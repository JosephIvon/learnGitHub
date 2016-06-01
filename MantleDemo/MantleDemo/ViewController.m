//
//  ViewController.m
//  MantleDemo
//
//  Created by fanwenbo on 16/6/1.
//  Copyright © 2016年 fanwenbo. All rights reserved.
//

#import "ViewController.h"
#import "NoMantleViewController.h"
#import "MantleViewController.h"

@interface ViewController () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableV;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //关闭自动留白
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableV.delegate = self;
    self.tableV.dataSource = self;
    
}

#pragma mark -- tableView dataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * reuserID = @"reuseIdentifier";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuserID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuserID];
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"不使用Mantle";
        cell.detailTextLabel.text = @"不使用Mantle展示数据";
    }
    else{
        cell.textLabel.text = @"使用Mantle";
        cell.detailTextLabel.text = @"使用Mantle展示数据";
    }
    return cell;
}

#pragma mark -- tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        NoMantleViewController * noMantleViewController = [[NoMantleViewController alloc] init];
        [self.navigationController pushViewController:noMantleViewController animated:YES];
    }else{
        MantleViewController *mantleViewController = [[MantleViewController alloc] init];
        [self.navigationController pushViewController:mantleViewController animated:YES];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
