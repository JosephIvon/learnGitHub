//
//  ViewController.m
//  GCD队列组
//
//  Created by fanwenbo on 16/5/13.
//  Copyright © 2016年 fanwenbo. All rights reserved.
//

// 1.分别下载2张图片：大图片、LOGO
// 2.合并2张图片
// 3.显示到一个imageView身上

#define kURL1  @"http://g.hiphotos.baidu.com/image/pic/item/f2deb48f8c5494ee460de6182ff5e0fe99257e80.jpg"
#define kURL2  @"http://su.bdimg.com/static/superplus/img/logo_white_ee663702.png"

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
//@property (strong, nonatomic) UIImage *image1;
//@property (strong, nonatomic) UIImage *image2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"----touchBegan----");
//   [self test1];
//   [self test2];
    [self test3];
    
}

-(void)test3{
    // 1.队列组
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // 2.下载图片1
    __block UIImage *image1 = nil;
    dispatch_group_async(group, queue, ^{
        image1 = [self downloadImage:kURL1];
    });
    
    // 3.下载图片2
    __block UIImage *image2 = nil;
    dispatch_group_async(group, queue, ^{
        image2 = [self downloadImage:kURL2];
    });
    
    // 4.合并图片 (保证执行完组里面的所有任务之后，再执行notify函数里面的block)
    dispatch_group_notify(group, queue, ^{
        // 开启一个位图上下文
        UIGraphicsBeginImageContextWithOptions(image1.size, NO, 0.0);
        
        // 绘制第1张图片
        CGFloat image1W = image1.size.width;
        CGFloat image1H = image1.size.height;
        [image1 drawInRect:CGRectMake(0, 0, image1W, image1H)];
        
        // 绘制第2张图片
        CGFloat image2W = image2.size.width * 0.5;
        CGFloat image2H = image2.size.height * 0.5;
        CGFloat image2Y = image1H - image2H;
        [image2 drawInRect:CGRectMake(0, image2Y, image2W, image2H)];
        
        // 得到上下文中的图片
        UIImage *fullImage = UIGraphicsGetImageFromCurrentImageContext();
        
        // 结束上下文
        UIGraphicsEndImageContext();
        
        // 5.回到主线程显示图片
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = fullImage;
        });
    });
}

/*
-(void)test1{
    //异步下载
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //下载图片1和2
        self.image1 = [self downloadImage:kURL1];
        self.image2 = [self downloadImage:kURL2];
        [self bindImages];
    });
}

- (void)test2
{
    // 异步下载
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 1.下载第1张
        self.image1 = [self downloadImage:kURL1];
        [self bindImages];
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 2.下载第2张
        self.image2 = [self downloadImage:kURL2];
        [self bindImages];
    });
}

- (void)bindImages
{
    if (self.image1 == nil || self.image2 == nil) return;
    // 3.合并图片
    // 开启一个位图上下文
    UIGraphicsBeginImageContextWithOptions(self.image1.size, NO, 0.0);
    
    // 绘制第1张图片
    CGFloat image1W = self.image1.size.width;
    CGFloat image1H = self.image1.size.height;
    [self.image1 drawInRect:CGRectMake(0, 0, image1W, image1H)];
    
    // 绘制第2张图片
    CGFloat image2W = self.image2.size.width * 0.5;
    CGFloat image2H = self.image2.size.height * 0.5;
    CGFloat image2Y = image1H - image2H;
    [self.image2 drawInRect:CGRectMake(0, image2Y, image2W, image2H)];
    
    // 得到上下文中的图片
    UIImage *fullImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 结束上下文
    UIGraphicsEndImageContext();
    
    // 4.回到主线程显示图片
    dispatch_async(dispatch_get_main_queue(), ^{
        self.imageView.image = fullImage;
        NSLog(@"----downloadEnd----");
    });
}
*/

-(UIImage*)downloadImage:(NSString*)url{
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    return [UIImage imageWithData:data];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
