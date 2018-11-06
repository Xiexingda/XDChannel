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
@property (nonatomic, assign) NSInteger staticIndex;
@property (nonatomic, assign) __block BOOL isEdit;

- (NSInteger)theEndIndexHandle;      //返回最终索引
- (BOOL)isInUseTitlesChanged;        //可用数组是否发生了变化
- (NSMutableArray *)allUnUseTitles;  //返回所有不可用项
@end

NS_ASSUME_NONNULL_END
