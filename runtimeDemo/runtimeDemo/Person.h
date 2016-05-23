//
//  Person.h
//  runtimeDemo
//
//  Created by fanwenbo on 16/5/21.
//  Copyright © 2016年 fanwenbo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property (nonatomic, copy) NSString *name;

- (NSArray *)ignoredNames;
- (instancetype)initWithCoder:(NSCoder *)aDecoder;
- (void)encodeWithCoder:(NSCoder *)aCoder;

@end
