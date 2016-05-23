//
//  ViewController.m
//  GCD
//
//  Created by fanwenbo on 16/5/12.
//  Copyright © 2016年 fanwenbo. All rights reserved.
//

/**
 GCD Grand Central Dispatch  中枢调度器  纯C语言
 优势：
 多核并行运算的解决方案
 自动利用更多的CPU内核
 自动管理线程的声明周期（创建线程、调度任务，销毁线程）
 只需告诉GCD要执行的任务，不必编写任何线程管理代码
 
 2个核心概念：
 任务（block）：执行什么操作
 队列（queue）：存放任务
 
 使用步骤：
 定制任务
 将任务添加到队列（GCD会自动将队列中的任务取出，放到对应线程中执行）
 遵循FIFO原则---- 先进先出，后进后出
 
 队列类型
 并发队列Concurrent Dispatch Queue,可以让多个任务并发（同时）执行（自动开启多个线程时同时执行任务），只在异步函数（dispatch_async）下有效
 串行队列Serial Dispatch Queue,一个任务执行完再执行下一个任务
 GCD默认已经提供了全局的并发队列dispatch_get_global_queue，供整个应用使用，不需要手动创建
 GCD获得串行的2中途径：使用dispatch_queue_create函数创建串行队列
 
 同步：在当前线程中执行任务，不具备开启新线程的能力
 异步：在新的线程中执行任务，具备开启新线程的能力
 
 */
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

//    [self asyncGlobalQueue];
//    [self asyncSerialQueue];
//    [self syncGlobalQueue];
//    [self syncSerialQueue];
    [self asyncMainQueue];
    
}

/**
 *  async---并发队列
 *  同时开多条线程，并发执行
 */
-(void)asyncGlobalQueue{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for (int i=0; i<6; i++) {
        dispatch_async(queue, ^{
            NSLog(@"----下载图片%d----%@",i,[NSThread currentThread]);
        });
    }
}

/**
 *  async---串行队列
 *  只开一条线程，串行执行
 */
-(void)asyncSerialQueue{
    //创建一个串行队列
    dispatch_queue_t queue = dispatch_queue_create("com.fanwenbo.GCD", NULL);
    for (int i=0; i<6; i++) {
        dispatch_async(queue, ^{
            NSLog(@"----下载图片%d----%@",i,[NSThread currentThread]);
        });
    }
    
    //非ARC，需要释放手动创建的队列
//    dispatch_release(queue);
    
//    Foundation OC,  Core Foundation C;
//    NSString * str1 = @"123";
//    CFStringRef * str2 = (__bridge CFStringRef)str1; //桥接转换数据类型
    
    // Core Foundation 中手动创建的数据类型（create/copy/retain/new），不论在ARC/MRC环境下，都需要手动释放
//    CFArrayRef array = CFArrayCreate(NULL, NULL, 10, NULL);
//    CFRelease(array);
//    
//    CGPathRef path = CGPathCreateMutable();
//    CGPathRelease(path);
}


-(void)asyncMainQueue{
    //添加到主队列中的任务，都会自动放到主线程中执行
    dispatch_queue_t queue = dispatch_get_main_queue();
    NSLog(@"asyncMainQueue----began----");
    dispatch_async(queue, ^{
        for (int i=0; i<6; i++) {
            dispatch_async(queue, ^{
                NSLog(@"----下载图片%d----%@",i,[NSThread currentThread]);
            });
        }
    });
    
    //错误写法，逻辑上互相等待，程序假死
//    dispatch_sync(queue, ^{
//        for (int i=0; i<6; i++) {
//            dispatch_async(queue, ^{
//                NSLog(@"----下载图片%d----%@",i,[NSThread currentThread]);
//            });
//        }
//    });
    NSLog(@"asyncMainQueue----end----");
}

/**
 *  sync---并发队列
 *  不会创建子线程，并发队列失去并发功能，串行执行
 */
-(void)syncGlobalQueue{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for (int i=0; i<6; i++) {
        dispatch_sync(queue, ^{
            NSLog(@"----下载图片%d----%@",i,[NSThread currentThread]);
        });
    }
}

/**
 *  sync---串行队列
 *  不会创建子线程，串行执行
 */
-(void)syncSerialQueue{
    //创建一个串行队列
    dispatch_queue_t queue = dispatch_queue_create("com.fanwenbo.GCD", NULL);
    for (int i=0; i<6; i++) {
        dispatch_sync(queue, ^{
            NSLog(@"----下载图片%d----%@",i,[NSThread currentThread]);
        });
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
