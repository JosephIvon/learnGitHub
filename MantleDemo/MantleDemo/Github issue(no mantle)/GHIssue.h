//
//  GHIssue.h
//  MantleDemo
//
//  Created by fanwenbo on 16/6/1.
//  Copyright © 2016年 fanwenbo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger,GHIssueState) {
    GHIssueStateOpen,
    GHIssueStateClosed
};

@class GHUser;

@interface GHIssue : NSObject <NSCopying,NSCoding>

@property (nonatomic, copy, readonly) NSURL *URL;
@property (nonatomic, copy, readonly) NSURL *HTMLURL;
@property (nonatomic, copy, readonly) NSNumber *number;
@property (nonatomic, assign, readonly) GHIssueState state;
@property (nonatomic, copy, readonly) NSString *reporterLogin;
@property (nonatomic, copy, readonly) NSDate *updatedAt;
@property (nonatomic, strong, readonly) GHUser *assignee;
@property (nonatomic, copy, readonly) NSDate *retrievedAt;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *body;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
