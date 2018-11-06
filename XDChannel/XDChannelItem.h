//
//  XDChannelItem.h
//  DN
//
//  Created by 谢兴达 on 2018/11/5.
//  Copyright © 2018 谢兴达. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, itemStatus) {
    Edit_Default,
    Edit_Add,
    Edit_Cancel
};

@interface XDChannelItem : UICollectionViewCell
@property (nonatomic,   copy) NSString *title;  //标题
@property (nonatomic, assign) BOOL isMoving;    //移动状态
@property (nonatomic, assign) BOOL isFixed;     //固定

@property (nonatomic, assign) itemStatus itemStatus;//状态
@end

NS_ASSUME_NONNULL_END
