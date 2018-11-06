//
//  XDSectionHeader.m
//  DN
//
//  Created by 谢兴达 on 2018/11/6.
//  Copyright © 2018 谢兴达. All rights reserved.
//

#import "XDSectionHeader.h"

@interface XDSectionHeader()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *secondTitleLabel;
@end
@implementation XDSectionHeader
-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self creatMainUI];
    }
    return self;
}

- (void)creatMainUI {
    CGFloat marginX = 15.0f;
    CGFloat labelWidth = 85;
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 20, labelWidth, self.bounds.size.height-20)];
    _titleLabel.font = [UIFont fontWithName:@"Medium" size:16];
    [self addSubview:_titleLabel];
    
    _secondTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_titleLabel.frame), 20, self.bounds.size.width-marginX*2-labelWidth, self.bounds.size.height-20)];
    _secondTitleLabel.textColor = [UIColor lightGrayColor];
    _secondTitleLabel.font = [UIFont systemFontOfSize:13.0f];
    [self addSubview:_secondTitleLabel];
}

#pragma mark -
#pragma mark - set
- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = title;
}

- (void)setSubTitle:(NSString *)subTitle {
    _subTitle = subTitle;
    _secondTitleLabel.text = subTitle;
}
@end
