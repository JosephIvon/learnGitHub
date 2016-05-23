//
//  ViewController.m
//  GCD一次性代码
//
//  Created by fanwenbo on 16/5/13.
//  Copyright © 2016年 fanwenbo. All rights reserved.
//

#import "ViewController.h"
#import "FWBDownloadImageManager.h"

@interface ViewController ()

@property(nonatomic,assign) BOOL hasExecuted;

@property(nonatomic,strong) FWBDownloadImageManager * manager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.manager = [[FWBDownloadImageManager alloc] init];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"-----touchBegan----");
//    [self download0];
//    [self download1];
    
//    FWBDownloadImageManager * manager = [[FWBDownloadImageManager alloc] init];
//    [manager downLoad2];
   
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"-----onceToken----");
        FWBDownloadImageManager * manager = [[FWBDownloadImageManager alloc] init];
        [manager downLoad3];
    });
    
}
-(void)download1{
    [self.manager downLoad1];
}

-(void)download0{
    if (self.hasExecuted) {
        return;
    }
    NSLog(@"-----下载图片----");
    self.hasExecuted = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
