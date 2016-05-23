//
//  NSObject+Property.h
//  runtimeDemo
//
//  Created by fanwenbo on 16/5/21.
//  Copyright © 2016年 fanwenbo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Property)

@property (assign, nonatomic) NSString *associatedObject_assign;
@property (strong, nonatomic) NSString *associatedObject_retain;
@property (copy,   nonatomic) NSString *associatedObject_copy;

@end
