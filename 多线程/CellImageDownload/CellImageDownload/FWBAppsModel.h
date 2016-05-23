//
//  FWBAppsModel.h
//  CellImageDownload
//
//  Created by fanwenbo on 16/5/16.
//  Copyright © 2016年 fanwenbo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FWBAppsModel : NSObject
/**
 *  应用名称
 */
@property (nonatomic, copy) NSString *name;

/**
 *  应用下载量
 */
@property (nonatomic, copy) NSString *download;

/**
 *  应用图标的URL
 */
@property (nonatomic, copy) NSString *icon;

+ (instancetype)appWithDict:(NSDictionary *)dict;

@end
