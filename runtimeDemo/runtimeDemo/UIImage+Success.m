//
//  UIImage+Success.m
//  runtimeDemo
//
//  Created by fanwenbo on 16/5/20.
//  Copyright © 2016年 fanwenbo. All rights reserved.
//

#import "UIImage+Success.h"
#import <objc/message.h>

@implementation UIImage (Success)

+(void)load{
    // 获取到两个方法
    
    Method imageWithDataMethod = class_getClassMethod(self, @selector(imageWithData:));
    Method tuc_imageWithDataMethod = class_getClassMethod(self, @selector(tuc_imageWithData:));
    
    // 交换方法
    method_exchangeImplementations(imageWithDataMethod, tuc_imageWithDataMethod);
}

+(UIImage*)tuc_imageWithData:(NSData*)data{
    // 因为来到这里的时候方法实际上已经被交换过了
    // 这里要调用 imageNamedWithData: 就需要调换被交换过的 tuc_imageNamedWithData
    __block UIImage * image;
     image = [UIImage tuc_imageWithData:data];
    if (image) {
        NSLog(@"从沙盒读取图片资源成功!");
        return image;
    }else{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:kImageUrl]];
            image = [UIImage tuc_imageWithData:data];
            if (image) {
                //图片存到沙盒中
                [data writeToFile:FWBAppImageFile(kImageUrl) atomically:YES];
                NSLog(@"加载图片资源成功!");
            }
            else{
                NSLog(@"请求图片资源失败!");
            }
        });
    }
    return image;
}

@end
