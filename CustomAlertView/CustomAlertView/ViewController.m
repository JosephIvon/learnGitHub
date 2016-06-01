//
//  ViewController.m
//  CustomAlertView
//
//  Created by fanwenbo on 16/4/14.
//  Copyright © 2016年 fanwenbo. All rights reserved.
//

#import "ViewController.h"
#import "FWBAlertView.h"

@interface ViewController ()<FWBAlertviewdelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(50, 50, 100, 100)];
    button.backgroundColor = [UIColor greenColor];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}

-(void)buttonAction:(UIButton*)button{
    FWBAlertView *alertView = [[FWBAlertView alloc] initWithTitle:@"提示"
                                                          message:@"dylan_lwb_"
                                                         delegate:self
                                                cancelButtonTitle:@"确定"
                                                otherButtonTitles: nil];
    //    [alertView addCustomerSubview:myView];
    
    [alertView show];

}

#pragma mark --- 代理方法
-(void)alertView:(FWBAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"点击了%ld个按钮",buttonIndex);
}

-(void)alertViewClosed:(FWBAlertView *)alertView
{
     NSLog(@"关闭了%@",alertView);
}

-(void)willPresentCustomAlertView:(UIView *)alertView
{
    
    NSLog(@"弹出了%@",alertView);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
