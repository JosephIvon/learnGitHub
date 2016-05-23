//
//  FWBAppsModel.m
//  CellImageDownload
//
//  Created by fanwenbo on 16/5/16.
//  Copyright © 2016年 fanwenbo. All rights reserved.
//

#import "FWBAppsModel.h"

@implementation FWBAppsModel

+(instancetype)appWithDict:(NSDictionary *)dict{
    FWBAppsModel * model = [[FWBAppsModel alloc] init];
    [model setValuesForKeysWithDictionary:dict];
    return model;
}

@end
