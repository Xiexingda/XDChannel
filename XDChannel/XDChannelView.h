//
//  XDChannelView.h
//  DN
//
//  Created by 谢兴达 on 2018/11/5.
//  Copyright © 2018 谢兴达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XDChannelModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^channelChangedBlock)(XDChannelModel *model);
@interface XDChannelView : UIView
/**
 初始化

 @param frame frame
 @param model 数据模型
 @param changedBlock 一但变动就回调
 @param tapBlock 非编辑模式下点击后直接返回跳转
 @return self
 */
- (instancetype)initWithFrame:(CGRect)frame model:(XDChannelModel *)model itemsHasChanged:(channelChangedBlock)changedBlock itemTapToBack:(channelChangedBlock)tapBlock;
@end

NS_ASSUME_NONNULL_END
