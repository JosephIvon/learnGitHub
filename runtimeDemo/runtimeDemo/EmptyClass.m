//
//  EmptyClass.m
//  runtimeDemo
//
//  Created by fanwenbo on 16/5/20.
//  Copyright © 2016年 fanwenbo. All rights reserved.
//

#import "EmptyClass.h"
#import <objc/message.h>

@implementation EmptyClass

void say(id self,SEL _cmd, NSString * word){
    NSLog(@"%@ say:%@",self,word);
}

// 当调用了一个未实现的方法会来到这里
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    if (sel == NSSelectorFromString(@"say:")) {
        // 动态添加 say: 方法
//        其中types参数为"i@:@“，按顺序分别表示：
//        i：返回值类型int，若是v则表示void
//        @：参数id(self)
//        :：SEL(_cmd)
//        @：id(str)
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wundeclared-selector"
        class_addMethod(self, @selector(say:), (IMP)say, "v@:@");
#pragma clang diagnostic pop
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}

@end
