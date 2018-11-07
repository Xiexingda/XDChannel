//
//  XDChannelHeader.m
//  DN
//
//  Created by 谢兴达 on 2018/11/6.
//  Copyright © 2018 谢兴达. All rights reserved.
//

#import "XDChannelHeader.h"

@interface XDChannelHeader()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *secondTitleLabel;
@property (nonatomic, strong) UIButton *editBtn;
@end

@implementation XDChannelHeader
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self creatMainUI];
    }
    return self;
}

- (void)creatMainUI {
    CGFloat marginX = 15.0f;
    CGFloat labelWidth = 85;
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginX, 20, labelWidth, self.bounds.size.height-20)];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.font = [UIFont fontWithName:@"Medium" size:16];
    [self addSubview:_titleLabel];
    
    _secondTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_titleLabel.frame), 20, self.bounds.size.width-marginX*2-labelWidth-70, self.bounds.size.height-20)];
    _secondTitleLabel.textColor = [UIColor lightGrayColor];
    _secondTitleLabel.font = [UIFont systemFontOfSize:13.0f];
    _secondTitleLabel.text = @"点击进入频道";
    [self addSubview:_secondTitleLabel];
    
    _editBtn = [[UIButton alloc]init];
    [_editBtn setFrame:CGRectMake(self.bounds.size.width-marginX-60, (self.bounds.size.height-46)/2 + 20, 60, 26)];
    _editBtn.layer.masksToBounds = YES;
    _editBtn.layer.cornerRadius = 13;
    _editBtn.layer.borderWidth = 0.6;
    _editBtn.layer.borderColor = [UIColor grayColor].CGColor;
    [_editBtn addTarget:self action:@selector(editTapMethord:) forControlEvents:UIControlEventTouchUpInside];
    [_editBtn setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
    [_editBtn setTitleColor:[UIColor grayColor] forState:(UIControlStateSelected)];
    [_editBtn setTitle:@"编辑" forState:(UIControlStateNormal)];
    [_editBtn setTitle:@"完成" forState:(UIControlStateSelected)];
    _editBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    
    [self addSubview:_editBtn];
}

- (void)editTapMethord:(UIButton *)btn {
    if (self.editBtnTapBlock) {
        self.editBtnTapBlock(!btn.selected);
    }
}

#pragma mark -
#pragma mark - set
- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = title;
}

- (void)setIsEdit:(BOOL)isEdit {
    _isEdit = isEdit;
    _secondTitleLabel.text = isEdit ? @"长按拖动调整排序" : @"点击进入频道";
    _editBtn.selected = isEdit;
}
@end
