//
//  FWBDownloadImageManager.m
//  GCD一次性代码
//
//  Created by fanwenbo on 16/5/13.
//  Copyright © 2016年 fanwenbo. All rights reserved.
//

#import "FWBDownloadImageManager.h"

@interface FWBDownloadImageManager()

@property(nonatomic,assign) BOOL hasExecuted;

@end

@implementation FWBDownloadImageManager

-(void)downLoad1{
    if (self.hasExecuted) {
        return;
    }
    NSLog(@"-----下载图片----");
    self.hasExecuted = YES;
}

-(void)downLoad2{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"-----下载图片----");
    });
}

-(void)downLoad3{
    NSLog(@"-----下载图片----");
}

@end
