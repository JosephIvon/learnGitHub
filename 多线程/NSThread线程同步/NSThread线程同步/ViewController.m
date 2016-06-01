//
//  ViewController.m
//  NSThread线程同步
//
//  Created by fanwenbo on 16/5/11.
//  Copyright © 2016年 fanwenbo. All rights reserved.
//

/*
 互斥锁优缺点：
 优点：有效防止因多线程抢夺资源造成的数据安全问题。
 缺点：需要消耗大量的CPU资源
 原理：利用线程同步技术
 */

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    tickets = 100;
    count = 0;
    theLock = [[NSLock alloc] init];
    
    // 锁对象
    ticketsCondition = [[NSCondition alloc] init];
    
    ticketsThreadone = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
    [ticketsThreadone setName:@"Thread-1"];
    [ticketsThreadone start];
    
    
    ticketsThreadtwo = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
    [ticketsThreadtwo setName:@"Thread-2"];
    [ticketsThreadtwo start];
    
//    NSThread *ticketsThreadthree = [[NSThread alloc] initWithTarget:self selector:@selector(run3) object:nil];
//    [ticketsThreadthree setName:@"Thread-3"];
//    [ticketsThreadthree start];
    
}

-(void)run3{
    while (YES) {
        [NSThread sleepForTimeInterval:3];
        
//        发送信号的方式，在一个线程唤醒另外一个线程的等待。
        [ticketsCondition signal];
    }
}

-(void)run{
    while (TRUE) {
        //上锁
//        [ticketsCondition lock];
        //线程等待
//        [ticketsCondition wait];
        
//        [theLock lock];
        
//        @synchronized关键字提供了互锁功能,括号内是锁对象
        @synchronized (self) {
            if (tickets > 0)
            {
                [NSThread sleepForTimeInterval:0.09];
                tickets--;
                count = 100 - tickets;
                NSLog(@"当前票数是:%d,售出:%d,线程名:%@",tickets,count,[[NSThread currentThread] name]);
                
            }else{
                break;
            }
        }
        
        //解锁
//        [theLock unlock];
//        [ticketsCondition unlock];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
