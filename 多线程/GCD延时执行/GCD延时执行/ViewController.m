//
//  ViewController.m
//  GCD延时执行
//
//  Created by fanwenbo on 16/5/13.
//  Copyright © 2016年 fanwenbo. All rights reserved.
//

#import "ViewController.h"

#define kImageUrl @"http://e.hiphotos.baidu.com/image/h%3D200/sign=2b02fe8a7e310a55db24d9f487454387/503d269759ee3d6d89cfe3b244166d224f4adeba.jpg"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageV;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"----touchBegan1----");
   
    [self delay3];
    
    NSLog(@"----touchBegan2----");
}

-(void)delay1{
    //延迟执行会阻塞主线程，一般不用
    [NSThread sleepForTimeInterval:3.0];
    [self download:kImageUrl];
}

-(void)delay2{
    //一旦定制好延迟任务，不会卡主当前线程
    [self performSelector:@selector(download:) withObject:kImageUrl afterDelay:3.0];
}

-(void)delay3{
    //3秒后回到主线程，执行block中的代码
//    dispatch_queue_t queue = dispatch_get_main_queue();
    
    //3秒后开启新线程，执行block中的代码
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), queue, ^{
        [self download:kImageUrl];
    });
    
}

-(void)download:(NSString*)url{
    NSLog(@"--%@---%@",url,[NSThread currentThread]);
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    UIImage * image = [UIImage imageWithData:data];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.backgroundImageV.image = image;
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
