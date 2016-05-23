//
//  FWBMusicTool.m
//  singleTonDemo01
//
//  Created by fanwenbo on 16/5/15.
//  Copyright © 2016年 fanwenbo. All rights reserved.
//  懒汉式

/*
  单例模式：保证程序运行过程中，一个类只创建一个实例
  应用场景：在整个应用程序中，共享一份资源（这份资源只初始化一次）
 */

#import "FWBMusicTool.h"

@implementation FWBMusicTool

static id _musicTool;

/**
 *  alloc内部会实现这个方法来创建对象
 *
 *  @param zone 内存空间
 *
 *  @return 返回一个实例对象
 */
+(id)allocWithZone:(struct _NSZone *)zone{
    @synchronized (self) {
        if (!_musicTool) {
            _musicTool = [super allocWithZone:zone];
        }
    }
    return _musicTool;
}

-(instancetype)copyWithZone:(NSZone *)zone{
    return _musicTool;
}

+(instancetype)sharedMusicTool{
    if (!_musicTool) { //防止频繁加锁
        @synchronized (self) {
            if (!_musicTool) { //防止创建多次
                _musicTool = [[FWBMusicTool alloc] init];
            }
        }
    }
    return _musicTool;
}

@end
