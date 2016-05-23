//
//  ViewController.m
//  Pthread
//
//  Created by fanwenbo on 16/5/11.
//  Copyright © 2016年 fanwenbo. All rights reserved.
//

#import "ViewController.h"
#import "pthread.h"

@interface ViewController ()

@end

@implementation ViewController

void *run (void * const t){
    for (int i=0; i<10000; i++) {
        NSLog(@"run---%d-----%@",i,[NSThread currentThread]);
    }
    return NULL;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"viewDidLoad----%@",[NSThread currentThread]);
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
     NSLog(@"touchbegan--------%@",[NSThread currentThread]);
    //创建线程
    pthread_t myRestrict;
    pthread_create(&myRestrict, NULL, run, NULL);
}


@end
