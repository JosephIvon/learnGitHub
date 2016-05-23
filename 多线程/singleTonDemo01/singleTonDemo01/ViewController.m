//
//  ViewController.m
//  singleTonDemo01
//
//  Created by fanwenbo on 16/5/15.
//  Copyright © 2016年 fanwenbo. All rights reserved.
//

#import "ViewController.h"
#import "FWBMusicTool.h"
#import "FWBSoundTool.h"
#import "FWBPerson.h"
#import "FWBStudent.h"
#import "FWBGoodStudent.h"
#import "FWBDataTool.h"

@interface ViewController ()

@end

@implementation ViewController
/**
 static ：修饰变量
 1、修饰局部变量 
    保证局部变量只初始化1次，在程序运行过程中，永远只有一份内存。
    让局部变量声明周期和全局变量类似，但是作用域不变。
 2、修饰全局变量
    仅限于当前文件内部访问，其他文件不能引用（保证数据安全）
 */

-(void)test{
    static int a = 1;
    NSLog(@"%d",++a);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self test1];
    
//    [self test2];
    
//    [self test3];

//    [self test4];
    
//    [self test5];
    
    [self test6];
}

-(void)test1{
    FWBMusicTool * tool1 = [[FWBMusicTool alloc] init];
    FWBMusicTool * tool2 = [tool1 copy];
    FWBMusicTool * tool3 = [FWBMusicTool sharedMusicTool];
    FWBMusicTool * tool4 = [FWBMusicTool sharedMusicTool];
    NSLog(@"%@ -- %@ -- %@ -- %@",tool1,tool2,tool3,tool4);
}

-(void)test2{
    for (int i=0; i<5; i++) {
        [self test];
    }
}

-(void)test3{
    NSLog(@"begin---%@ --- %@",[FWBMusicTool sharedMusicTool],[FWBMusicTool sharedMusicTool]);

    //引用某个全局变量(并非定义)
//    extern id _musicTool;
//    _musicTool = nil;

    NSLog(@"end---%@ --- %@",[FWBMusicTool sharedMusicTool],[FWBMusicTool sharedMusicTool]);
    
}

-(void)test4{
    [FWBSoundTool run];
    FWBSoundTool * tool1 = [[FWBSoundTool alloc] init];
    FWBSoundTool * tool2 = [tool1 copy];
    FWBSoundTool * tool3 = [FWBSoundTool sharedSoundTool];
    FWBSoundTool * tool4 = [FWBSoundTool sharedSoundTool];
    NSLog(@"%@ -- %@ -- %@ -- %@",tool1,tool2,tool3,tool4);
}

-(void)test5{
    [[FWBPerson alloc] init];
    [[FWBStudent alloc] init];
    [[FWBGoodStudent alloc] init];
}

-(void)test6{
    FWBDataTool * tool1 = [[FWBDataTool alloc] init];
    FWBDataTool * tool2 = [[FWBDataTool alloc] init];
    FWBDataTool * tool3 = [FWBDataTool sharedDataTool];
    FWBDataTool * tool4 = [FWBDataTool sharedDataTool];
    FWBDataTool * tool5 = [tool4 copy];
    NSLog(@"%@ -- %@ -- %@ -- %@ -- %@",tool1,tool2,tool3,tool4,tool5);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
