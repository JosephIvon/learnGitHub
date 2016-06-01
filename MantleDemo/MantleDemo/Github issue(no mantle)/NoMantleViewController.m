//
//  NoMantleViewController.m
//  MantleDemo
//
//  Created by fanwenbo on 16/6/1.
//  Copyright © 2016年 fanwenbo. All rights reserved.
//

#import "NoMantleViewController.h"
#import "GHIssue.h"

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

@interface NoMantleViewController () <UITableViewDataSource,UITableViewDelegate,NSURLConnectionDataDelegate,NSURLConnectionDataDelegate>

@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation NoMantleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBar];
    
    [self initViews];
    
    [self refreshDataSource];
}

#pragma mark - dataSource
- (void)refreshDataSource{
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.github.com/repos/mantle/mantle/issues"]];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
    //状态栏显示活动
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

#pragma mark - NSURLConnection delegate
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    dispatch_async(dispatch_get_main_queue(), ^{
        //状态栏隐藏活动
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    });
    //数据处理
    //issue字典转换为模型
    NSArray * issueArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    for (int i=0; i<issueArray.count; i++) {
        GHIssue * issue = [[GHIssue alloc] initWithDictionary:issueArray[i]];
        [self.dataSource addObject:issue];
    }
    __weak __typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.tableView reloadData];
    });
}

#pragma mark - init views
- (void)setNavigationBar{
    self.navigationItem.title = @"不使用Mantle";
}

-(void)initViews{
    [self.view addSubview:self.tableView];
}

#pragma mark - getter
- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

-(UITableView*)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

#pragma mark - UITableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellIndentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    GHIssue *issue = [self.dataSource objectAtIndex:indexPath.row];
    cell.textLabel.text = issue.title;
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
