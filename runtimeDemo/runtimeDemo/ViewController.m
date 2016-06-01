//
//  ViewController.m
//  runtimeDemo
//
//  Created by fanwenbo on 16/5/20.
//  Copyright © 2016年 fanwenbo. All rights reserved.
//

#import "ViewController.h"
#import "Cat.h"
#import <objc/message.h>
#import "EmptyClass.h"
#import "MesseageForwording.h"
#import "NSObject+Property.h"
#import "GitHubUser.h"
#import "NSObject+Model.h"
#import "Person.h"

@interface ViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageV;
@property (nonatomic, strong) Person * person;
@property (nonatomic, copy) NSString * path;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self runtimeMsg];
    
//    [self messageSwizzing];
    
//    [self dynamicLoadingMethod];
    
//    [self forwardMessageOne];
    
//    [self forwardMessageTwo];
    
//    [self associatedObject];

//    [self makeModel];
    
//    [self ObjectArchive];
//    
//    [self addNotifications];
    
}

/**
 *  添加通知
 */
-(void)addNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeContentViewPosition:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeContentViewPosition:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void) changeContentViewPosition:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyBoardEndY = value.CGRectValue.origin.y;
    
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    [UIView animateWithDuration:duration.doubleValue animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:[curve intValue]];
        self.view.center = CGPointMake(self.view.center.x, keyBoardEndY - self.view.bounds.size.height/2.0);
    }];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(Person *)person{
    if (!_person) {
        _person = [[Person alloc] init];
    }
    return _person;
}

/**
 *  对象解档、归档
 */
-(void)ObjectArchive{
    self.path = [NSString stringWithFormat:@"%@/person", NSHomeDirectory()];
    self.person = [NSKeyedUnarchiver unarchiveObjectWithFile:self.path];
    self.textField.delegate = self;
    self.textField.text = self.person.name;
}

- (IBAction)saveBtnClicked:(UIButton *)sender {
    [self.view endEditing:YES];
    self.person.name = self.textField.text;
    [NSKeyedArchiver archiveRootObject:self.person toFile:self.path];
}

/**
 *  字典转模型
 */
-(void)makeModel{
    // 从网络请求数据
    NSString *githubAPI = @"https://api.github.com/users/Joseph";
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:githubAPI]];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
     
                                                GitHubUser * Joseph = [GitHubUser modelWithDict:dict updateDict:@{@"ID":@"id"}];
                                                
                                                NSLog(@"%@",Joseph.name);
                                            }];
    [task resume];
}

/**
 *  动态关联属性
 */
-(void)associatedObject{
    NSObject * object = [NSObject new];
    object.associatedObject_copy = @"runtime_copy";
    object.associatedObject_assign = @"runtime_assign";
    object.associatedObject_retain = @"runtime_retain";
    NSLog(@"self.associatedObject_assign: %@ \n self.associatedObject_retain: %@ \n self.associatedObject_copy: %@", object.associatedObject_assign,object.associatedObject_retain,object.associatedObject_copy);
    
}

/**
 *  消息转发
 */
-(void)forwardMessageOne{
    MesseageForwording *instance = objc_msgSend(objc_msgSend(objc_getClass("MesseageForwording"), sel_registerName("alloc")), sel_registerName("init"));
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wundeclared-selector"
    NSLog(@"%@",[instance performSelector:@selector(uppercaseString)]);
#pragma clang diagnostic pop
    instance.identifier = @"guessMeWho";
}

-(void)forwardMessageTwo{
    [[Cat new] stoke];
    [Cat stoke];
}

/**
 *  动态加载方法
 */
-(void)dynamicLoadingMethod{
    EmptyClass * instance = objc_msgSend(objc_msgSend(objc_getClass("EmptyClass"), sel_registerName("alloc")), sel_registerName("init"));
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wundeclared-selector"
    [instance performSelector:@selector(say:) withObject:@"hello"];
#pragma clang diagnostic pop
    
}

/**
 *  方法交换
 */
-(void)messageSwizzing{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData * data = [NSData dataWithContentsOfFile:FWBAppImageFile(kImageUrl)];
        UIImage * image = [UIImage imageWithData:data];
        __weak typeof(self) appsVC = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (image) {
                appsVC.backgroundImageV.image = image;
            }
            else{
                UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"图像为空" preferredStyle:UIAlertControllerStyleAlert];
                [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
                [appsVC presentViewController:alertVC animated:YES completion:nil];
            }
        });
    });
    
}

/**
 *  消息机制
 */
-(void)runtimeMsg{
    //使用runtime创建一个对象
    Class catClass = objc_getClass("Cat");
    //通过类创建实例对象
    Cat *harlan = objc_msgSend(catClass, @selector(alloc));
    harlan = objc_msgSend(harlan, @selector(init));
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wundeclared-selector"
    objc_msgSend(harlan, @selector(eat));
#pragma clang diagnostic pop
    
    //objc_msgSend 可以传递参数
    Cat *alex = objc_msgSend(objc_msgSend(objc_getClass("Cat"), sel_registerName("alloc")), sel_registerName("init"));
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wundeclared-selector"
    objc_msgSend(alex, @selector(run:), 10);
#pragma clang diagnostic pop
    
    NSLog(@"%@--%@",harlan,alex);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
