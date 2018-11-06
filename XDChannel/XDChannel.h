//
//  XDChannel.h
//  DN
//
//  Created by 谢兴达 on 2018/11/5.
//  Copyright © 2018 谢兴达. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 完成时的回调

 @param inUseTitles 可用标题组
 @param unUseTitles 不可用标题组
 @param endIndex 最终返回索引
 @param isInUseTitlesChanged 可用数组是否有变化
 */
typedef void(^finishBlock)(NSArray *inUseTitles, NSArray *unUseTitles, NSInteger endIndex, BOOL isInUseTitlesChanged);
@interface XDChannel : UIView
/**
 显示频道页

 @param inUseTitles 可选项
 @param unUseTitles 不可选项
 @param currentItem 当前项
 @param isFirstFixed 是否固定首项
 @param block 回调
 */
+ (void)showChannelWithInUseTitles:(NSArray *)inUseTitles
                       unUseTitles:(NSArray *)unUseTitles
                       currentItem:(NSString *)currentItem
                      isFirstFixed:(BOOL)isFirstFixed
                            finish:(finishBlock)block;
@end

