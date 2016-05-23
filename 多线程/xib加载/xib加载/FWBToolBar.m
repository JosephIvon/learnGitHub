//
//  FWBToolBar.m
//  xib加载
//
//  Created by fanwenbo on 16/5/13.
//  Copyright © 2016年 fanwenbo. All rights reserved.
//

#import "FWBToolBar.h"

//[UITapGestureRecognizer superview]: unrecognized selector sent to instance 0x7ff438641b40'
//分析：
//方法属于哪个类：superview--》UIView
//结论：
//错误将UITapGestureRecognizer当做UIView

@implementation FWBToolBar
- (IBAction)tapToolBar:(UITapGestureRecognizer *)sender {
    NSLog(@"tapToolBar-----点击了工具条");
}

+(instancetype)toolBar{
    NSArray * objArr = [[NSBundle mainBundle] loadNibNamed:@"FWBToolBar" owner:nil options:nil];
    return [objArr firstObject];
    
}

@end
