//
//  XDChannel.m
//  DN
//
//  Created by 谢兴达 on 2018/11/5.
//  Copyright © 2018 谢兴达. All rights reserved.
//

#import "XDChannel.h"
#import "XDChannelModel.h"
#import "XDChannelView.h"
#import "NSArray+XDChannel.h"

@interface XDChannel()
@property (nonatomic, strong) UINavigationController *naVC;
@property (nonatomic, strong) XDChannelView *channelView;
@property (nonatomic, strong) XDChannelModel *model;
@property (nonatomic,   copy) finishBlock privateFinishBlock;
@end

@implementation XDChannel
- (void)dealloc {
    NSLog(@"释放XDChannel");
}

+ (void)showChannelWithInUseTitles:(NSArray *)inUseTitles unUseTitles:(NSArray *)unUseTitles currentItem:(NSString *)currentItem isFirstFixed:(BOOL)isFirstFixed finish:(finishBlock)block {
    [[[self alloc] initChannelViewWithInUseTitles:inUseTitles unUseTitles:unUseTitles currentItem:currentItem isFirstFixed:isFirstFixed finish:block] showChannel];
}

- (instancetype)initChannelViewWithInUseTitles:(NSArray *)inUseTitles unUseTitles:(NSArray *)unUseTitles currentItem:(NSString *)currentItem isFirstFixed:(BOOL)isFirstFixed finish:(finishBlock)block {
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        [self checkInUseTitles:inUseTitles unUseTitles:unUseTitles];
        self.model = [[XDChannelModel alloc]init];
        self.model.originalInUseTitles = inUseTitles;
        self.model.originalItem = currentItem;
        [self.model.inUseTitles addObjectsFromArray:inUseTitles];
        [self.model.unUseTitles addObjectsFromArray:unUseTitles];
        self.model.currentItem = currentItem;
        self.model.staticIndex = isFirstFixed ? 0 : -1;
        self.privateFinishBlock = block;
        [self creatMainUI];
    }
    return self;
}

- (void)showChannel {
    CGRect frame = self.frame;
    frame.origin.y = - self.bounds.size.height;
    self.frame = frame;
    self.alpha = 0;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
        self.frame = [UIScreen mainScreen].bounds;
    }];
}

- (void)creatMainUI {
    __weak typeof(self) weakSelf = self;
    _channelView = [[XDChannelView alloc] initWithFrame:[UIScreen mainScreen].bounds model:_model itemsHasChanged:^(XDChannelModel * _Nonnull model) {
        weakSelf.model = model.copy;
        
    } itemTapToBack:^(XDChannelModel * _Nonnull model) {
        weakSelf.model = model.copy;
        [weakSelf backMethod];
    }];
    
    _naVC = [[UINavigationController alloc] initWithRootViewController:[UIViewController new]];
    _naVC.navigationBar.tintColor = [UIColor blackColor];
    _naVC.topViewController.title = @"频道管理";
    _naVC.topViewController.view = _channelView;
    _naVC.topViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(cancelMethod)];
    [self addSubview:_naVC.view];
}

- (void)cancelMethod {
    [self backMethod];
}

//返回
- (void)backMethod {
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = self.frame;
        frame.origin.y = - self.bounds.size.height;
        self.frame = frame;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
    if (self.privateFinishBlock) {
        self.privateFinishBlock(self.model.inUseTitles, [self.model allUnUseTitles], [self.model theEndCurrentItem], [self.model theEndCurrentItemIndex], [self.model isInUseTitlesChanged]);
    }
}

//数组检测
- (void)checkInUseTitles:(NSArray *)inUseTitles unUseTitles:(NSArray *)unUseTitles {
    NSMutableArray *allTitles = [NSMutableArray arrayWithArray:inUseTitles];
    [allTitles addObjectsFromArray:unUseTitles];
    
    if ([[allTitles hasRepeatItemInArray] length] > 0) {
        NSLog(@"XDChannel_出现重复标题：%@", [allTitles hasRepeatItemInArray]);
        __assert(0, "XDChannel_标题重复", __LINE__);
    }
}
@end
