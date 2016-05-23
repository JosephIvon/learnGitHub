//
//  FWBSoundTool.m
//  singleTonDemo01
//
//  Created by fanwenbo on 16/5/15.
//  Copyright © 2016年 fanwenbo. All rights reserved.
//  饿汉式

#import "FWBSoundTool.h"

@implementation FWBSoundTool

static id _instance;

/**
 *  当类加载到OC运行时环境中(内存)，就会调用一次（一个类只会加载1次）
 */
+(void)load{
//    NSLog(@"load --- before --- %@",_instance);
    _instance = [[self alloc] init];
//    NSLog(@"load--- after --- %@",_instance);
}

/**
 *  当第一次使用这个类的时候调用
 */
+(void)initialize{
//     NSLog(@"initialize---");
}

+(id)allocWithZone:(struct _NSZone *)zone{
    if (!_instance) {
            _instance = [super allocWithZone:zone];
        }
    return _instance;
}


-(instancetype)copyWithZone:(NSZone *)zone{
    return _instance;
}


+(instancetype)sharedSoundTool{
    return _instance;
}

+(void)run{
    NSLog(@"run----");
}

@end
