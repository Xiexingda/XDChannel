//
//  NSArray+XDChannel.m
//  Demo
//
//  Created by 谢兴达 on 2018/11/7.
//  Copyright © 2018 谢兴达. All rights reserved.
//

#import "NSArray+XDChannel.h"

@implementation NSArray (XDChannel)
- (id)hasRepeatItemInArray {
    NSArray *arr = self;
    id repeatItem = nil;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    for (id obj in arr) {
        if ([dic objectForKey:obj]) {
            repeatItem = obj;
            break;
        } else {
            [dic setObject:obj forKey:obj];
        }
    }
    dic = nil;
    return repeatItem;
}

@end
