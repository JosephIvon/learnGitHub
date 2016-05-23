//
//  Person.m
//  runtimeDemo
//
//  Created by fanwenbo on 16/5/21.
//  Copyright © 2016年 fanwenbo. All rights reserved.
//

#import "Person.h"
#import "NSObject+Archive.m"

@implementation Person

- (NSArray *)ignoredNames {
    return @[];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        [self tuc_initWithCoder:aDecoder];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self tuc_encodeWithCoder:aCoder];
}

@end
