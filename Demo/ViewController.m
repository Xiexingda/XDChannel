//
//  ViewController.m
//  Demo
//
//  Created by 谢兴达 on 2018/11/6.
//  Copyright © 2018 谢兴达. All rights reserved.
//

#import "ViewController.h"
#import "XDChannel.h"

@interface ViewController ()
@property (nonatomic, strong) __block NSArray *inUseTitles;
@property (nonatomic, strong) __block NSArray *unUseTitles;
@property (nonatomic, strong) __block NSString *currentItem;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _inUseTitles = @[@"item_0",@"item_1",@"item_2",@"item_3",@"item_4",@"item_5"];
    _unUseTitles = @[@"item_6",@"item_7",@"item_8",@"item_9",@"item_10",@"item_11",@"item_12"];
    _currentItem = @"item_0";
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn addTarget:self action:@selector(btnTap) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"频道管理" forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(0, 0, 80, 30)];
    btn.clipsToBounds = YES;
    btn.layer.cornerRadius = 5;
    btn.layer.borderWidth = 0.6;
    btn.layer.borderColor = [UIColor grayColor].CGColor;
    btn.center = self.view.center;
    
    [self.view addSubview:btn];
}

- (void)btnTap {
    __weak typeof(self) weakSelf = self;
    [XDChannel showChannelWithInUseTitles:_inUseTitles unUseTitles:_unUseTitles currentItem:_currentItem isFirstFixed:YES finish:^(NSArray * _Nonnull inUseTitles, NSArray * _Nonnull unUseTitles, NSInteger endIndex, BOOL isInUseTitlesChanged) {
        weakSelf.inUseTitles = inUseTitles;
        weakSelf.unUseTitles = unUseTitles;
        weakSelf.currentItem = inUseTitles[endIndex];
    }];
}
@end
