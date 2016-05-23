//
//  Cat.m
//  runtimeDemo
//
//  Created by fanwenbo on 16/5/20.
//  Copyright © 2016年 fanwenbo. All rights reserved.
//

#import "Cat.h"

@implementation Cat

- (void)eat {
    NSLog(@"burbur~");
}

- (void)run:(NSUInteger)metre
{
    NSLog(@"跑了 %ld 米", metre);
}

#pragma mark - 实例方法
//  第一步
//  在没有找到方法时，会先调用此方法，可用于动态添加方法
//  返回 YES 表示相应 selector 的实现已经被找到并添加到了类中，否则返回 NO
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    return YES;
}

//  第二步
//  如果第一步的返回 NO 或者直接返回了 YES 而没有添加方法，该方法被调用
//  在这个方法中，我们可以指定一个可以返回一个可以响应该方法的对象
//  如果返回 self 就会死循环
- (id)forwardingTargetForSelector:(SEL)aSelector {
    return nil;
}

//  第三步
//  如果 `forwardingTargetForSelector:` 返回了 nil，则该方法会被调用，系统会询问我们要一个合法的『类型编码(Type Encoding)』
//  若返回 nil，则不会进入下一步，而是无法处理消息
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    return [NSMethodSignature signatureWithObjCTypes:"v@:"];
}

// 当实现了此方法后，-doesNotRecognizeSelector: 将不会被调用
// 如果要测试找不到方法，可以注释掉这一个方法
// 在这里进行消息转发
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    // 我们还可以改变方法选择器
    [anInvocation setSelector:@selector(touch)];
    // 改变方法选择器后，还需要指定是哪个对象的方法
    [anInvocation invokeWithTarget:self];
}

- (void)touch{
    NSLog(@"the instance of Cat do not perform '-stoke' method，and transform to '-touch' method successfully");
}

- (void)doesNotRecognizeSelector:(SEL)aSelector {
    NSLog(@"deal with message fail：%@", NSStringFromSelector(aSelector));
}

#pragma mark - 类方法

//  类方法也会直接消息转发机制
//  不过有些东西可能会比较有趣：
//  下述方法中：
//  forwardingTargetForSelector
//  methodSignatureForSelector
//  forwardInvocation
//  doesNotRecognizeSelector
//  我们将前面的修饰符由 "-" 替换为了 "+"，
//  但当我们在上述各个方法中的实现用调用 [super method] 时，method 的定义还是 NSObject 的实例方法
//  这可能就和元类(MetaClass)相关了
//  与 resolveInstanceMethod 相对应
+ (BOOL)resolveClassMethod:(SEL)sel {
    return NO;
}

+ (id)forwardingTargetForSelector:(SEL)aSelector {
    return nil;
}

+ (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    return [NSMethodSignature signatureWithObjCTypes:"v@:"];
}

+ (void)forwardInvocation:(NSInvocation *)anInvocation {
    [anInvocation setSelector:@selector(touch)];
    [anInvocation invokeWithTarget:self];
}

+ (void)touch {
     NSLog(@"the Class of Cat do not perform '+stoke' method，and transform to '+touch' method successfully");
}

+ (void)doesNotRecognizeSelector:(SEL)aSelector {
    NSLog(@"deal with msg fail：%@", NSStringFromSelector(aSelector));
}

@end
