//
//  FWBTableViewController.h
//  UIWindow
//
//  Created by fanwenbo on 16/5/18.
//  Copyright © 2016年 fanwenbo. All rights reserved.
//


#import "FWBTableViewController.h"

@interface FWBTableViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView * tableView;

@end

@implementation FWBTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"UITableView详解";
    self.view.backgroundColor = [UIColor whiteColor];
    
    //tableView分两种样式,Plain样式，区头不随着区一起滑动，直到整个区滑动出tableView后才消失。Grouped样式，区头随着区一起滑动。
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        _tableView.separatorInset = UIEdgeInsetsMake(0,10, 0, 10);
    }
    [self.view addSubview:_tableView];
    
}

#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     return 5*(section+1);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static  NSString * cellIdentifier = @"Cell";
    
    UITableViewCell * cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier  ];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"第%ld区第%ld行------->%@",(long)indexPath.section,(long)indexPath.row,@"假数据"];
    return cell;
}

#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return indexPath.section == 0?50:indexPath.section == 1?60:70;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"第%lu区",section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

@end
