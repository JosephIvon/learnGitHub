//
//  FWBDownloadOperation.h
//  CellImageDownload
//
//  Created by fanwenbo on 16/5/16.
//  Copyright © 2016年 fanwenbo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class FWBDownloadOperation;

@protocol FWBDownloadOperationDelegate <NSObject>

@optional
-(void)downloadOperation:(FWBDownloadOperation*)operation didFinishDownload:(UIImage*)image;

@end
@interface FWBDownloadOperation : NSOperation

@property(nonatomic,copy) NSString * imageUrl;
@property(nonatomic,strong) NSIndexPath * indexPath;
@property(nonatomic,weak) id <FWBDownloadOperationDelegate> delegate;

@end
