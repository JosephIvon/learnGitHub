//
//  ViewController.m
//  xib加载
//
//  Created by fanwenbo on 16/5/13.
//  Copyright © 2016年 fanwenbo. All rights reserved.
//

#import "ViewController.h"
#import "FWBToolBar.h"
#import "FWBHomeViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    FWBToolBar * toolBar = [FWBToolBar toolBar];
    [toolBar setFrame:CGRectMake(0, 64, 480, 44)];
    [self.view addSubview:toolBar];
    
}

- (IBAction)tapGreenView:(UITapGestureRecognizer *)sender {
    NSLog(@"tapGreenView----点击了GreenView");
    FWBHomeViewController * homeVC = [[FWBHomeViewController alloc] init];
    homeVC.title = @"首页";
    homeVC.view.backgroundColor = [UIColor yellowColor];
    [self.navigationController pushViewController:homeVC animated:YES];
}

//[UIViewController _loadViewFromNibNamed:bundle:] loaded the "FWBHomeView" nib but the view outlet was not set.'
//控制器默认会自动找对用的xib来创建view
// 1、去掉controller单词后同名的xib:FWBHomeView.xib
// 2、完全同名的xib：FWBHomeViewController.xib



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
