//
//  XDChannelHeader.h
//  DN
//
//  Created by 谢兴达 on 2018/11/6.
//  Copyright © 2018 谢兴达. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XDChannelHeader : UIView
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic,   copy) void(^editBtnTapBlock)(BOOL isEdit);
@end

NS_ASSUME_NONNULL_END
