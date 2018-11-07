//
//  XDChannelModel.h
//  DN
//
//  Created by 谢兴达 on 2018/11/5.
//  Copyright © 2018 谢兴达. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XDChannelModel : NSObject
@property (nonatomic, strong) NSArray *originalInUseTitles;
@property (nonatomic, strong) NSString *originalItem;
@property (nonatomic, strong) NSMutableArray *inUseTitles;
@property (nonatomic, strong) NSMutableArray *unUseTitles;
@property (nonatomic, strong) NSMutableArray *cancelTitles;
@property (nonatomic, strong) NSString *currentItem;
@property (nonatomic, assign) NSInteger staticIndex;//固定项索引，只能是 0 或 -1
@property (nonatomic, assign) __block BOOL isEdit;

- (NSString *)theEndCurrentItem;     //返回最终当前项
- (NSInteger)theEndCurrentItemIndex; //返回最终索引
- (BOOL)isInUseTitlesChanged;        //可用数组是否发生了变化
- (NSMutableArray *)allUnUseTitles;  //返回所有不可用项
@end

NS_ASSUME_NONNULL_END
