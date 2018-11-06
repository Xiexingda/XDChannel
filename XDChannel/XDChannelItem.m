//
//  XDChannelItem.m
//  DN
//
//  Created by 谢兴达 on 2018/11/5.
//  Copyright © 2018 谢兴达. All rights reserved.
//

#import "XDChannelItem.h"

@interface XDChannelItem()
@property (nonatomic, strong) UILabel *titleLabel;      //标题
@property (nonatomic, strong) UIImageView *iconMark;    //右上角图标
@property (nonatomic, strong) CAShapeLayer *maskLayer;  //底部虚线
@end
@implementation XDChannelItem

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self creatMainUI];
    }
    return self;
}

- (void)creatMainUI {
    CGFloat c_width = self.bounds.size.width;
    CGFloat c_height = self.bounds.size.height;
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 3, c_width-3, c_height-3)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.clipsToBounds = YES;
    _titleLabel.font = [UIFont systemFontOfSize:14.f];
    _titleLabel.backgroundColor = [self backGrayColor];
    _titleLabel.textColor = [self textDurkColor];
    _titleLabel.layer.cornerRadius = 5;
    _iconMark = [[UIImageView alloc]initWithFrame:CGRectMake(c_width-16, 0, 16, 16)];
    _iconMark.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_titleLabel];
    [self.contentView addSubview:_iconMark];
    _iconMark.hidden = YES;
    
    _maskLayer = [CAShapeLayer layer];
    _maskLayer.bounds = _titleLabel.bounds;
    _maskLayer.position = CGPointMake(CGRectGetMidX(_titleLabel.bounds), CGRectGetMidY(_titleLabel.bounds));
    _maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:_maskLayer.bounds cornerRadius:_titleLabel.layer.cornerRadius].CGPath;
    _maskLayer.lineWidth = 1;
    _maskLayer.lineDashPattern = @[@5, @3];
    _maskLayer.fillColor = [UIColor clearColor].CGColor;
    _maskLayer.strokeColor = [self textGrayColor].CGColor;
    [self.titleLabel.layer addSublayer:_maskLayer];
    _maskLayer.hidden = YES;
}

#pragma mark -
#pragma mark -- Setter
- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = title;
}

-(void)setIsMoving:(BOOL)isMoving {
    _isMoving = isMoving;
    if (_isMoving) {
        _titleLabel.backgroundColor = [self backWhiteColor];
        _titleLabel.textColor = [self textGrayColor];
        _maskLayer.hidden = NO;
        _iconMark.hidden = YES;
    }else{
        _titleLabel.backgroundColor = [self backGrayColor];
        _titleLabel.textColor = [self textDurkColor];
        _maskLayer.hidden = YES;
        _iconMark.hidden = NO;
    }
}

-(void)setIsFixed:(BOOL)isFixed{
    _isFixed = isFixed;
    if (isFixed) {
        _iconMark.hidden = YES;
        _titleLabel.backgroundColor = [self backWhiteColor];
        _titleLabel.textColor = [self textGrayColor];
        _titleLabel.layer.borderWidth = 0.6;
        _titleLabel.layer.borderColor = [self textGrayColor].CGColor;
    }else{
        _titleLabel.backgroundColor = [self backGrayColor];
        _titleLabel.textColor = [self textDurkColor];
        _titleLabel.layer.borderWidth = 0;
    }
}

- (UIColor *)textGrayColor {
    return [UIColor colorWithRed:180/255.0f green:180/255.0f blue:180/255.0f alpha:1];
}

- (UIColor *)textDurkColor {
    return [UIColor colorWithRed:40/255.0f green:40/255.0f blue:40/255.0f alpha:1];
}

- (UIColor *)backGrayColor {
    return [UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
}

- (UIColor *)backWhiteColor {
    return [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1];
}

- (void)setItemStatus:(itemStatus)itemStatus {
    _itemStatus = itemStatus;
    if (_isFixed) {return;}
    switch (itemStatus) {
        case Edit_Default:
            [self defaultStatus];
            break;
            
        case Edit_Add:
            [self addStatus];
            break;
            
        case Edit_Cancel:
            [self cancelStatus];
            break;
            
        default:
            break;
    }
}

- (void)defaultStatus {
    _iconMark.hidden = YES;
}

- (void)addStatus {
    _iconMark.hidden = NO;
    _iconMark.image = [UIImage imageNamed:@"xdchannel_add" inBundle:[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"XDChannelResource" ofType:@"bundle"]] compatibleWithTraitCollection:nil];
}

- (void)cancelStatus {
    _iconMark.hidden = NO;
    _iconMark.image = [UIImage imageNamed:@"xdchannel_cancel" inBundle:[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"XDChannelResource" ofType:@"bundle"]] compatibleWithTraitCollection:nil];
}
@end
