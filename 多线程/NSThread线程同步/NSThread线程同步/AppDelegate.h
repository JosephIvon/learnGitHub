//
//  AppDelegate.h
//  NSThread线程同步
//
//  Created by fanwenbo on 16/5/11.
//  Copyright © 2016年 fanwenbo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
/*
  nonatomic 和 atomic 对比
  nonatomic：非线程安全，适合内存小的移动设备
  atomic:线程安全，需要消耗大量的资源，实际是对变量的setter方法加锁
   
 iOS开发建议：
 所有属性声明为nonatomic
 尽量避免多线程抢夺同一块资源
 尽量将加锁、资源抢夺的逻辑交给服务器端处理，减少移动客户端的压力。
 */

