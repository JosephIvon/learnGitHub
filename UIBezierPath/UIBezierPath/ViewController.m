//
//  ViewController.m
//  UIBezierPath
//
//  Created by fanwenbo on 16/4/25.
//  Copyright © 2016年 fanwenbo. All rights reserved.
//

#import "ViewController.h"
#import "BezierPathView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    BezierPathView * view = [[BezierPathView alloc] initWithFrame:self.view.bounds];
    view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
