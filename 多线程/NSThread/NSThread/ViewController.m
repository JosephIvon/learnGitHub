//
//  ViewController.m
//  NSThread
//
//  Created by fanwenbo on 16/5/11.
//  Copyright © 2016年 fanwenbo. All rights reserved.
//

#import "ViewController.h"

#define kURL @"http://avatar.csdn.net/2/C/D/1_totogo2010.jpg"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

-(void)downloadImage:(NSString *) url{
    NSLog(@"download---began---%@----%@",url,[NSThread currentThread]);
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
    NSLog(@"download---end");
    
    UIImage *image = [[UIImage alloc] initWithData:data];
    if(image == nil){
        
    }else{
        //调用主线程刷新显示UI界面（主线程的另一任务，处理UI控件交互事件）
        //YES 表示等待这一条语句执行完再继续下面的操作
//        [self performSelectorOnMainThread:@selector(updateUI:) withObject:image waitUntilDone:NO];
//        [self performSelector:@selector(updateUI:) onThread:[NSThread mainThread] withObject:image waitUntilDone:YES];
        
        //优化代码
        [self.imageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:YES];
        
        NSLog(@"------done------");
    }
    
}

-(void)updateUI:(UIImage*) image{
    self.imageView.image = image;
    NSLog(@"updateUI---%@",[NSThread currentThread]);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%d",[NSThread isMainThread]);
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchbegan----%@",[NSThread currentThread]);
    //不要同时开多条线程（1~3条即可，最多不超过5条）
    [self createThread1];
    [self createThread2];
    [self createThread3];
}

-(void)createThread3{
    //调用的还是当前线程
//    [self performSelector:@selector(download:) withObject:@"https://www.qq.com"];
    
    //隐式创建并启动线程
    [self performSelectorInBackground:@selector(downloadImage:) withObject:kURL];
}

-(void)createThread2{
    //创建线程
    [NSThread detachNewThreadSelector:@selector(download:) toTarget:self withObject:@"https://www.sina.com"];
    
}

-(void)createThread1{
    //创建线程
    NSThread * thread = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
    thread.name = @"下载";
    [thread start];
}

-(void)download:(NSString*)url{
    // 暂停2s
//    [NSThread sleepForTimeInterval:2];
    
    // 或者
    NSDate *date = [NSDate dateWithTimeInterval:2 sinceDate:[NSDate date]];
    [NSThread sleepUntilDate:date];
    
    NSLog(@"download---%@----%@",url,[NSThread currentThread]);
    
}

-(void)run{
    NSLog(@"run-----%@----began",[NSThread currentThread]);
    
    for (int i=0; i<100; i++) {
        NSLog(@"-----%d",i);
        if (i==49) {
            //退出线程
            [NSThread exit];
        }
    }

    NSLog(@"run-----%@----end",[NSThread currentThread]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
