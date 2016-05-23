//
//  FWBDataTool.m
//  singleTonDemo01
//
//  Created by fanwenbo on 16/5/15.
//  Copyright © 2016年 fanwenbo. All rights reserved.
//

#import "FWBDataTool.h"

@implementation FWBDataTool
//用来保存唯一的单例对象
static id _instance;

+(instancetype)sharedDataTool{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

+(id)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

-(instancetype)copyWithZone:(NSZone *)zone{
    return _instance;
}

@end
