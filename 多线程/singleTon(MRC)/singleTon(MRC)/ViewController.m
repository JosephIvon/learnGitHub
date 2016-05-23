//
//  ViewController.m
//  singleTon(MRC)
//
//  Created by fanwenbo on 16/5/15.
//  Copyright © 2016年 fanwenbo. All rights reserved.
//

#import "ViewController.h"
#import "FWBDataTool.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    FWBDataTool * tool1 = [[FWBDataTool alloc] init];
    FWBDataTool * tool2 = [FWBDataTool sharedDataTool];
    NSLog(@"%@ %@",tool1,tool2);
    [tool1 release];
    
    FWBDataTool * tool4 = [FWBDataTool sharedDataTool];
    FWBDataTool * tool3 = [[FWBDataTool alloc] init];
    NSLog(@"%@ %@",tool3,tool4);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
