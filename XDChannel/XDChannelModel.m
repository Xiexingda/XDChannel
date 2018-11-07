//
//  XDChannelModel.m
//  DN
//
//  Created by 谢兴达 on 2018/11/5.
//  Copyright © 2018 谢兴达. All rights reserved.
//

#import "XDChannelModel.h"

@implementation XDChannelModel
- (instancetype)init {
    self = [super init];
    if (self) {
        _inUseTitles = @[].mutableCopy;
        _unUseTitles = @[].mutableCopy;
        _cancelTitles = @[].mutableCopy;
        _isEdit = NO;
        _staticIndex = -1;
    }
    return self;
}

- (NSString *)theEndCurrentItem {
    if ([self.inUseTitles containsObject:self.originalItem]) {
        return self.originalItem;
    }
    return self.currentItem;
}

- (NSInteger)theEndCurrentItemIndex {
    __weak typeof(self) weakSelf = self;
    __block NSInteger c_idx = 0;
    if ([self.inUseTitles containsObject:self.originalItem]) {
        //如果原始项还在可用数组中
        [self.inUseTitles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isEqualToString:weakSelf.originalItem]) {
                c_idx = idx;
                *stop = YES;
            }
        }];
        
    } else {
        //如果原始项不在可用数组中了
        [self.inUseTitles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isEqualToString:weakSelf.currentItem]) {
                c_idx = idx;
                *stop = YES;
            }
        }];
    }
    
    return c_idx;
}

- (BOOL)isInUseTitlesChanged {
    if (_originalInUseTitles.count == _inUseTitles.count) {
        __weak typeof(self) weakSelf = self;
        __block BOOL isChanged = NO;
        [_inUseTitles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![weakSelf.originalInUseTitles[idx] isEqualToString:obj]) {
                isChanged = YES;
                *stop = YES;
            }
        }];
        return isChanged;
    }
    return YES;
}

- (NSMutableArray *)allUnUseTitles {
    NSMutableArray *allUnUseTitles = [NSMutableArray arrayWithArray:self.cancelTitles];
    [allUnUseTitles addObjectsFromArray:self.unUseTitles];
    return allUnUseTitles;
}

- (id)copy {
    XDChannelModel *copyModel = [[XDChannelModel alloc]init];
    copyModel.originalInUseTitles = self.originalInUseTitles;
    copyModel.originalItem = self.originalItem;
    copyModel.inUseTitles = self.inUseTitles;
    copyModel.unUseTitles = self.unUseTitles;
    copyModel.cancelTitles = self.cancelTitles;
    copyModel.currentItem = self.currentItem;
    copyModel.staticIndex = self.staticIndex;
    copyModel.isEdit = self.isEdit;
    return copyModel;
}
@end
