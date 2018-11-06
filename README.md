# XDChannel
仿天天快报频道管理器
使用方法
引入头文件
```
#import "XDChannel.h"
```

然后调用方法
```
_inUseTitles = @[@"item_0",@"item_1",@"item_2",@"item_3",@"item_4",@"item_5"];
_unUseTitles = @[@"item_6",@"item_7",@"item_8",@"item_9",@"item_10",@"item_11",@"item_12"];
_currentItem = @"item_0";

__weak typeof(self) weakSelf = self;
[XDChannel showChannelWithInUseTitles:_inUseTitles unUseTitles:_unUseTitles currentItem:_currentItem isFirstFixed:YES finish:^(NSArray * _Nonnull inUseTitles, NSArray * _Nonnull unUseTitles, NSInteger endIndex, BOOL isInUseTitlesChanged) {
weakSelf.inUseTitles = inUseTitles;
weakSelf.unUseTitles = unUseTitles;
weakSelf.currentItem = inUseTitles[endIndex];
}];
```
# 效果

![image](https://github.com/Xiexingda/XDChannel/blob/master/show.png)
