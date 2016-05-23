//
//  MesseageForwording.m
//  runtimeDemo
//
//  Created by fanwenbo on 16/5/21.
//  Copyright © 2016年 fanwenbo. All rights reserved.
//

#import "MesseageForwording.h"
#import <objc/message.h>

@implementation MesseageForwording

//表明不让系统给我们创建setter、getter方法
@dynamic identifier;

//  第一步
//  在没有找到方法时，会先调用此方法，可用于动态添加方法
//  返回 YES 表示相应 selector 的实现已经被找到并添加到了类中，否则返回 NO
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    NSLog(@"resolveInstanceMethod:---%@",[self class]);
    return YES;
}

//  第二步
//  如果第一步的返回 NO 或者直接返回了 YES 而没有添加方法，该方法被调用
//  在这个方法中，我们可以指定一个可以返回一个可以响应该方法的对象
//  如果返回 self 就会死循环
- (id)forwardingTargetForSelector:(SEL)aSelector
{
    NSLog(@"forwardingTargetForSelector:---%@",[self class]);
    if (aSelector == @selector(uppercaseString))
    {
        return@"hello world";
    }
    return nil;
}

//  第三步
//  如果 `forwardingTargetForSelector:` 返回了 nil，则该方法会被调用，系统会询问我们要一个合法的『类型编码(Type Encoding)』
//  若返回 nil，则不会进入下一步，而是无法处理消息
//  这个方法是根据SEL去生成一个方法签名，然后系统用这个方法签名去生成NSInvocation对象,NSInvocation对象封装了最原始的消息和参数，然后执行forwardInvocation方法
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSLog(@"methodSignatureForSelector:---%@",[self class]);
    if (aSelector == @selector(setIdentifier:)) {
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
    return nil;
}

//这个方法就会将消息传递给消息接收对象，我们在类实现文件里面添加了一个setIdentifier:方法,这样-doesNotRecognizeSelector: 将不会被调用
//当一个类无法响应某个消息的时候，runtime会通过forwardInvocation通知该对象。每个对象都继承了NSObject的forwardInvocation方法，但是NSObject并没有实现，所以需要我们手动的实现。forwardInvocation就像是一个消息分发中心或者是一个中转站，能将消息分发给不同的对象。它还可以将某些消息更改，或者是'吃掉'，不响应这些消息也不会出错。
- (void)forwardInvocation:(NSInvocation *)anInvocation{
    MesseageForwording * object = [MesseageForwording new];
    if ([object respondsToSelector:[anInvocation selector]]) {
        
        [anInvocation invokeWithTarget:object];
    }
    else{
        [super forwardInvocation:anInvocation];
    }
}

- (void)setIdentifier:(NSString*)str
{
    NSLog(@"This is a forward method:%@",str);
}

@end
