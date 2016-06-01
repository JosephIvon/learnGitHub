//
//  main.m
//  runtimeDemo
//
//  Created by fanwenbo on 16/5/20.
//  Copyright © 2016年 fanwenbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <objc/runtime.h>

int main(int argc, char * argv[]) {
    @autoreleasepool {
        
        /*Seciton 0. 关联数据的Key和Value*/
        static char overviewKey;
        static const char *myOwnKey = "VideoProperty\0";
        static const char intValueKey = 'i';
        
        NSArray *array = [[NSArray alloc]
                          initWithObjects:@ "One", @"Two", @"Three", nil];
        
        // For the purposes of illustration, use initWithFormat: to ensure
        // we get a deallocatable string
        NSString *overview = [[NSString alloc]
                              initWithFormat:@"%@", @"First three numbers"];
        NSString *videoKeyValue = @"This is a video";
        NSNumber * intValue = [[NSNumber alloc] initWithInt:5];
        
        /*Section 1. 关联数据设置部分*/
        objc_setAssociatedObject (
                                  array,
                                  &overviewKey,
                                  overview,
                                  OBJC_ASSOCIATION_RETAIN
                                  );
        
        objc_setAssociatedObject (
                                  array,
                                  myOwnKey,
                                  videoKeyValue,
                                  OBJC_ASSOCIATION_COPY
                                  );
        
        objc_setAssociatedObject (
                                  array,
                                  &intValueKey,
                                  intValue,
                                  OBJC_ASSOCIATION_ASSIGN
                                  );
        
        /*Section 3. 关联数据查询部分*/
        NSString *associatedObject =  (NSString *) objc_getAssociatedObject (array, &overviewKey);
        NSLog(@"associatedObject: %@", associatedObject);
        
        NSString *associatedObject2 = (NSString *) objc_getAssociatedObject(array, myOwnKey);
        NSLog(@"Video Key value is %@", associatedObject2);
        
        NSString *assObject3 = (NSString *) objc_getAssociatedObject(array, &myOwnKey);
        
        if( assObject3 )
        {
            NSLog(@"不会进入这里! assObject3 应当为nil!");
        }
        else
        {
            NSLog(@"OK. 通过myOwnKey的地址是得不到数据的!");
        }
        
        NSNumber *assKeyValue = (NSNumber *) objc_getAssociatedObject(array, &intValueKey);
        NSLog(@"Int value is %d",[assKeyValue intValue]);
        
        /*Section 3. 关联数据清理部分*/
        objc_setAssociatedObject (
                                  array,
                                  &overviewKey,
                                  nil,
                                  OBJC_ASSOCIATION_ASSIGN
                                  );
        
        objc_setAssociatedObject (
                                  array,
                                  myOwnKey,
                                  nil,
                                  OBJC_ASSOCIATION_ASSIGN
                                  );
        
        objc_setAssociatedObject (
                                  array,
                                  &intValueKey,
                                  nil,
                                  OBJC_ASSOCIATION_ASSIGN
                                  );
        
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
