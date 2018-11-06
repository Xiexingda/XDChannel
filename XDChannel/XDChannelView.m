//
//  XDChannelView.m
//  DN
//
//  Created by 谢兴达 on 2018/11/5.
//  Copyright © 2018 谢兴达. All rights reserved.
//

#import "XDChannelView.h"
#import "XDChannelItem.h"
#import "XDChannelHeader.h"
#import "XDSectionHeader.h"

#define Column 4
#define Margin_X 15
#define Margin_Y 10
#define Section_Height 70
#define Item_Width ((self.bounds.size.width - (Column + 1) * Margin_X)/Column)
#define Item_Height (Item_Width/2.0)

#define CellID @"XDChannelItemID"
#define HeaderID @"XDChannelHeaderID"

@interface XDChannelView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) XDChannelHeader *header;
@property (nonatomic,   copy) channelChangedBlock hasChangedBlock;
@property (nonatomic,   copy) channelChangedBlock tapToBackBlock;
@property (nonatomic, strong) XDChannelModel *model;
@property (nonatomic, strong) XDChannelItem *moveItem;
@property (nonatomic, strong) NSIndexPath *dragingIndexPath;
@property (nonatomic, strong) NSIndexPath *targetIndexPath;
@end
@implementation XDChannelView
- (instancetype)initWithFrame:(CGRect)frame model:(XDChannelModel *)model itemsHasChanged:(channelChangedBlock)changedBlock itemTapToBack:(nonnull channelChangedBlock)tapBlock {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _hasChangedBlock = changedBlock;
        _tapToBackBlock = tapBlock;
        _model = model.copy;
        [self creatMainUI];
    }
    return self;
}

- (void)creatMainUI {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(Item_Width,Item_Height);
    flowLayout.sectionInset = UIEdgeInsetsMake(0, Margin_X, 0, Margin_X);
    flowLayout.minimumLineSpacing = Margin_Y;
    flowLayout.minimumInteritemSpacing = Margin_X;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    _collectionView.showsHorizontalScrollIndicator = false;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[XDChannelItem class] forCellWithReuseIdentifier:CellID];
    [_collectionView registerClass:[XDSectionHeader class]
        forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderID];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.contentInset = UIEdgeInsetsMake(Section_Height, 0, 0, 0);
    _collectionView.contentOffset = CGPointMake(0, Section_Height);
    [self addSubview:_collectionView];
    
    _header = [[XDChannelHeader alloc]initWithFrame:CGRectMake(0, -Section_Height, self.bounds.size.width, Section_Height)];
    [_collectionView addSubview:_header];
    _header.title = @"已选频道";
    _header.subTitle = @"点击进入频道";
    __weak typeof(self) weakSelf = self;
    [_header setEditBtnTapBlock:^(BOOL isEdit) {
        weakSelf.model.isEdit = isEdit;
        [weakSelf refreshCollection];
    }];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressMethod:)];
    longPress.minimumPressDuration = 0.4f;
    [_collectionView addGestureRecognizer:longPress];
    
    _moveItem = [[XDChannelItem alloc] initWithFrame:CGRectMake(0, 0, Item_Width, Item_Height)];
    _moveItem.hidden = true;
    [_collectionView addSubview:_moveItem];
}

#pragma mark -
#pragma mark LongPressMethod
- (void)longPressMethod:(UILongPressGestureRecognizer*)gesture{
    CGPoint point = [gesture locationInView:_collectionView];
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            [self dragBegin:point];
            break;
        case UIGestureRecognizerStateChanged:
            [self dragChanged:point];
            break;
        case UIGestureRecognizerStateEnded:
            [self dragEnd];
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark - 相关方法
//拖拽开始 找到被拖拽的item
- (void)dragBegin:(CGPoint)point{
    [self dragingBeginHandle];
    _dragingIndexPath = [self getDragingIndexPathWithPoint:point];
    if (!_dragingIndexPath) {return;}
    [_collectionView bringSubviewToFront:_moveItem];
    XDChannelItem *item = (XDChannelItem*)[_collectionView cellForItemAtIndexPath:_dragingIndexPath];
    item.isMoving = YES;
    //更新被拖拽的item
    _moveItem.frame = item.frame;
    _moveItem.title = item.title;
    [_moveItem setTransform:CGAffineTransformMakeScale(1.1, 1.1)];
    _moveItem.hidden = NO;
}

- (void)dragChanged:(CGPoint)point{
    if (!_dragingIndexPath) {return;}
    _moveItem.center = point;
    _targetIndexPath = [self getTargetIndexPathWithPoint:point];
    //交换位置 如果没有找到targetIndexPath则不交换位置
    if (_dragingIndexPath && _targetIndexPath) {
        //更新数据源
        [self refreshData];
        //更新item位置
        [_collectionView moveItemAtIndexPath:_dragingIndexPath toIndexPath:_targetIndexPath];
        _dragingIndexPath = _targetIndexPath;
    }
}

- (void)dragEnd{
    if (!_dragingIndexPath) {return;}
    CGRect endFrame = [_collectionView cellForItemAtIndexPath:_dragingIndexPath].frame;
    [_moveItem setTransform: CGAffineTransformIdentity];
    [UIView animateWithDuration:0.4 animations:^{
        self.moveItem.frame = endFrame;
    }completion:^(BOOL finished) {
        self.moveItem.hidden = true;
        XDChannelItem *item = (XDChannelItem*)[self.collectionView cellForItemAtIndexPath:self.dragingIndexPath];
        item.isMoving = false;
    }];
}

//获取被拖动IndexPath的方法
- (NSIndexPath*)getDragingIndexPathWithPoint:(CGPoint)point{
    NSIndexPath* dragIndexPath = nil;
    //最后剩一个怎不可以排序
    if ([_collectionView numberOfItemsInSection:0] == 1) {return dragIndexPath;}
    for (NSIndexPath *indexPath in _collectionView.indexPathsForVisibleItems) {
        //下半部分不需要排序
        if (indexPath.section > 0) {continue;}
        //在上半部分中找出相对应的Item
        if (CGRectContainsPoint([_collectionView cellForItemAtIndexPath:indexPath].frame, point)) {
            if (indexPath.row != _model.staticIndex) {
                dragIndexPath = indexPath;
            }
            break;
        }
    }
    return dragIndexPath;
}

//获取目标IndexPath的方法
- (NSIndexPath*)getTargetIndexPathWithPoint:(CGPoint)point {
    NSIndexPath *targetIndexPath = nil;
    for (NSIndexPath *indexPath in _collectionView.indexPathsForVisibleItems) {
        if ([indexPath isEqual:_dragingIndexPath]) {continue;}
        if (indexPath.section > 0) {continue;}
        //在第一组中找出将被替换位置的Item
        if (CGRectContainsPoint([_collectionView cellForItemAtIndexPath:indexPath].frame, point)) {
            if (indexPath.row != _model.staticIndex) {
                targetIndexPath = indexPath;
            }
        }
    }
    return targetIndexPath;
}

//拖拽排序后需要重新排序数据源
- (void)refreshData {
    id obj = [_model.inUseTitles objectAtIndex:_dragingIndexPath.row];
    [_model.inUseTitles removeObject:obj];
    [_model.inUseTitles insertObject:obj atIndex:_targetIndexPath.row];
    _model.currentItem = obj;
    [self changedBackBlock];
}

- (void)dragingBeginHandle {
    _model.isEdit = YES;
    _header.isEdit = YES;
    [self refreshCollection];
}

//变化回调
- (void)changedBackBlock {
    if (_hasChangedBlock) {
        _hasChangedBlock(_model);
    }
}

//选择频道返回
- (void)tapBackBlock {
    if (_tapToBackBlock) {
        _tapToBackBlock(_model);
    }
}

#pragma mark -
#pragma mark CollectionViewDelegate&DataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return section == 0 ? _model.inUseTitles.count : section == 1 ? _model.cancelTitles.count : _model.unUseTitles.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(self.frame.size.width, 0);
    } else if (section == 1) {
        return _model.cancelTitles.count > 0 ? CGSizeMake(self.frame.size.width, Section_Height) : CGSizeMake(self.frame.size.width, 0);
    }
    return CGSizeMake(self.frame.size.width, Section_Height);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(self.frame.size.width, 0);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    XDSectionHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderID forIndexPath:indexPath];
    if (indexPath.section == 0) {
        return nil;
        
    } else if (indexPath.section == 1) {
        header.title = @"最近删除";
        header.subTitle = @"点击添加更多";
        header.hidden = _model.cancelTitles.count > 0 ? NO : YES;
        
    } else if (indexPath.section == 2) {
        header.title = @"推荐频道";
        header.subTitle = @"点击添加更多";
        header.hidden = NO;
    }
    
    return header;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XDChannelItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:CellID forIndexPath:indexPath];
    item.isFixed = indexPath.section == 0 && indexPath.row == _model.staticIndex;
    item.title = indexPath.section == 0 ? _model.inUseTitles[indexPath.row] : indexPath.section == 1 ? _model.cancelTitles[indexPath.row] : _model.unUseTitles[indexPath.row];
    if (indexPath.section == 0) {
        if (_model.isEdit) {
            item.itemStatus = Edit_Cancel;
        } else {
            item.itemStatus = Edit_Default;
        }
        
    } else {
        item.itemStatus = Edit_Add;
    }
    
    return  item;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (!_model.isEdit) {
            _model.currentItem = _model.inUseTitles[indexPath.row];
            _model.originalItem = _model.inUseTitles[indexPath.row];
            [self tapBackBlock];
            return;
        }
        
        //只剩一个的时候不可删除
        if ([_collectionView numberOfItemsInSection:0] == 1) {return;}
        //第一个不可删除
        if (indexPath.row  == _model.staticIndex) {return;}
        id obj = [_model.inUseTitles objectAtIndex:indexPath.row];
        [_model.inUseTitles removeObject:obj];
        [_model.cancelTitles insertObject:obj atIndex:0];
        [_collectionView moveItemAtIndexPath:indexPath toIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
        //处理当前项，如果当前位置还有item，则直接用该item做为当前项，如果没有，则向前一位
        if (_model.inUseTitles.count - 1 >= indexPath.row) {
            _model.currentItem = _model.inUseTitles[indexPath.row];
        } else {
            _model.currentItem = _model.inUseTitles.lastObject;
        }
        
    } else if (indexPath.section == 1) {
        id obj = [_model.cancelTitles objectAtIndex:indexPath.row];
        [_model.cancelTitles removeObject:obj];
        [_model.inUseTitles addObject:obj];
        XDSectionHeader *cHeader = ((XDSectionHeader *)[_collectionView supplementaryViewForElementKind:UICollectionElementKindSectionHeader atIndexPath:indexPath]);
        cHeader.hidden = _model.cancelTitles.count > 0 ? NO : YES;
        [_collectionView moveItemAtIndexPath:indexPath toIndexPath:[NSIndexPath indexPathForRow:_model.inUseTitles.count - 1 inSection:0]];
        _model.currentItem = obj;
        
    } else {
        id obj = [_model.unUseTitles objectAtIndex:indexPath.row];
        [_model.unUseTitles removeObject:obj];
        [_model.inUseTitles addObject:obj];
        [_collectionView moveItemAtIndexPath:indexPath toIndexPath:[NSIndexPath indexPathForRow:_model.inUseTitles.count - 1 inSection:0]];
        _model.currentItem = obj;
    }
    
    [self changedBackBlock];
    [self refreshCollection];
}

- (void)refreshCollection {
    NSMutableIndexSet *indexset = [[NSMutableIndexSet alloc]init];
    [indexset addIndex:0];
    [indexset addIndex:1];
    [indexset addIndex:2];
    [self.collectionView reloadSections:indexset];
    [self.collectionView reloadItemsAtIndexPaths:[self.collectionView indexPathsForVisibleItems]];
}
@end
