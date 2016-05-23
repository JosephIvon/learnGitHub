//
//  ViewController.m
//  线程间通讯
//
//  Created by fanwenbo on 16/5/12.
//  Copyright © 2016年 fanwenbo. All rights reserved.
//

/*
  需要设置按钮的image和backgroundImage,按钮类型需要改为custom
  属性名称不能以new开头，否则系统会认为是构造函数方法，因返回类型不配报错
  只有init开头的构造函数，才允许对self进行赋值
 */

#import "ViewController.h"

#define  kMainQueue  dispatch_get_main_queue()
#define  kGlobalQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define  kURL  @"http://pic2.ooopic.com/01/00/13/66bOOOPICd7.jpg"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btn;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
//    [self asyncDownloadImage];
    [self dispatchApplyDemo];
}

//dispatch_apply
- (void)dispatchApplyDemo {
    //创建一个并行队列
//    dispatch_queue_t concurrentQueue = dispatch_queue_create("com.starming.gcddemo.concurrentqueue", DISPATCH_QUEUE_CONCURRENT);
    
//    系统给每一个应用程序提供了三个concurrent dispatch queues。这三个并发调度队列是全局的，它们只有优先级的不同。因为是全局的，我们不需要去创建。我们只需要通过使用函数dispath_get_global_queue去得到队列
    
    dispatch_async(dispatch_get_main_queue(), ^{
        __block int sum = 0;
        __block int pArray = 3;
        
//        dispatch_apply 重复运行一个代码片段N次
        dispatch_apply(10, kGlobalQueue, ^(size_t i) {
            sum += pArray;
            NSLog(@"---%@--->> Current Sum: %d",[NSThread currentThread],sum);
        });
        NSLog(@" >> sum: %d", sum);
    });
    NSLog(@"The end");
    //这里有个需要注意的是，dispatch_apply这个是会阻塞主线程的。这个log打印会在dispatch_apply都结束后才开始执行，但是使用dispatch_async包一下就不会阻塞了。
}

-(void)asyncDownloadImage{
    dispatch_async(kGlobalQueue, ^{
        NSLog(@"downloadImage-----%@",[NSThread currentThread]);
        //子线程下载图片
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:kURL]];
        UIImage * image = [UIImage imageWithData:data];
        
        //回主线程刷新UI
        dispatch_async(kMainQueue, ^{
            NSLog(@"setting-----%@",[NSThread currentThread]);
            [self.btn setBackgroundImage:image forState:UIControlStateNormal];
        });
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
