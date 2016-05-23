//
//  NSObject+Archive.h
//  runtimeDemo
//
//  Created by fanwenbo on 16/5/21.
//  Copyright © 2016年 fanwenbo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Archive)

- (NSArray *)ignoredProperty;

- (void)tuc_encodeWithCoder:(NSCoder *)aCoder;
- (void)tuc_initWithCoder:(NSCoder *)aDecoder;

@end
