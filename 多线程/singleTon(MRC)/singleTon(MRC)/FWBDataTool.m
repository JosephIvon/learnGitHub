//
//  FWBDataTool.m
//  singleTon(MRC)
//
//  Created by fanwenbo on 16/5/15.
//  Copyright © 2016年 fanwenbo. All rights reserved.
//

#import "FWBDataTool.h"

@implementation FWBDataTool
// 用来保存唯一的单例对象
static id _instance;

+ (id)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance
        = [super allocWithZone:zone];
    });
    return _instance;
}

+ (instancetype)sharedDataTool
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _instance;
}

- (oneway void)release { }
- (id)retain { return self; }
- (NSUInteger)retainCount { return 1;}
- (id)autorelease { return self;}


@end
