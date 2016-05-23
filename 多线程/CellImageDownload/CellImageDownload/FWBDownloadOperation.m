//
//  FWBDownloadOperation.m
//  CellImageDownload
//
//  Created by fanwenbo on 16/5/16.
//  Copyright © 2016年 fanwenbo. All rights reserved.
//

#import "FWBDownloadOperation.h"

@implementation FWBDownloadOperation

/**
 *  只要添加到队列，就会自动调用main方法
 *  如果是异步操作，由于无法访问主线程的自动释放池，需要手动创建自动释放池
 *  经常通过-(BOOL)isCancelled方法检测操作是否被取消，对取消做出响应。
 */
-(void)main{
    @autoreleasepool {
        if(self.isCancelled) return;
        NSURL * url = [NSURL URLWithString:self.imageUrl]; // 从模型中取出url
        NSData * data = [NSData dataWithContentsOfURL:url]; // 转化为data
        UIImage * image = [UIImage imageWithData:data]; //NSData -> image
        
        if (self.isCancelled) return;
        
        //回到主线程
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if ([self.delegate respondsToSelector:@selector(downloadOperation:didFinishDownload:)]) {
                [self.delegate downloadOperation:self didFinishDownload:image];
            }
        }];
    }
}

@end
