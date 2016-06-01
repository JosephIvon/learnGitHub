//
//  RWViewController.m
//  RWReactivePlayground
//
//  Created by Colin Eberhardt on 18/12/2013.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

/*
 作为一个iOS开发者，你写的每一行代码几乎都是在响应某个事件，例如按钮的点击，收到网络消息，属性的变化（通过KVO）或者用户位置的变化（通过CoreLocation）。但是这些事件都用不同的方式来处理，比如action、delegate、KVO、callback等。ReactiveCocoa为事件定义了一个标准接口，从而可以使用一些基本工具来更容易的连接、过滤和组合。
 */

#import "RWViewController.h"
#import "RWDummySignInService.h"
#import "ReactiveCocoa.h"

@interface RWViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UILabel *signInFailureText;

//@property (nonatomic) BOOL passwordIsValid;
//@property (nonatomic) BOOL usernameIsValid;
@property (strong, nonatomic) RWDummySignInService *signInService;

@end

@implementation RWViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
//  [self updateUIState];
  
  self.signInService = [RWDummySignInService new];
  
  // handle text changes for both text fields
//  [self.usernameTextField addTarget:self action:@selector(usernameTextFieldChanged) forControlEvents:UIControlEventEditingChanged];
//  [self.passwordTextField addTarget:self action:@selector(passwordTextFieldChanged) forControlEvents:UIControlEventEditingChanged];
  
  // initially hide the failure message
  self.signInFailureText.hidden = YES;
    
//    ReactiveCocoa signal（RACSignal）发送事件流给它的subscriber。目前总共有三种类型的事件：next、error、completed。一个signal在因error终止或者完成前，可以发送任意数量的next事件。
    RACSignal *validUsernameSignal =
    [self.usernameTextField.rac_textSignal
     map:^id(NSString *text) {
         return @([self isValidUsername:text]);
     }];
    
//    RAC宏允许直接把信号的输出应用到对象的属性上。RAC宏有两个参数，第一个是需要设置属性值的对象，第二个是属性名。每次信号产生一个next事件，传递过来的值都会应用到该属性上。
    RAC(self.usernameTextField, backgroundColor) =
    [validUsernameSignal
     map:^id(NSNumber *usernameValid){
         return[usernameValid boolValue] ? [UIColor clearColor]:[UIColor yellowColor];
     }];

    RACSignal *validPasswordSignal =
    [self.passwordTextField.rac_textSignal
     map:^id(NSString *text) {
         return @([self isValidPassword:text]);
     }];
    
    RAC(self.passwordTextField, backgroundColor) =
    [validPasswordSignal
     map:^id(NSNumber *passwordValid){
         return[passwordValid boolValue] ? [UIColor clearColor]:[UIColor yellowColor];
     }];
//    用响应式编程的一个关键区别，你不需要使用实例变量来追踪瞬时状态。
    
//    RACsignal的这个方法可以聚合任意数量的信号，reduce block的参数和每个源信号相关。ReactiveCocoa有一个工具类RACBlockTrampoline，它在内部处理reduce block的可变参数。
    RACSignal *signUpActiveSignal =
    [RACSignal combineLatest:@[validUsernameSignal, validPasswordSignal]
                      reduce:^id(NSNumber*usernameValid, NSNumber *passwordValid){
                          return @([usernameValid boolValue]&&[passwordValid boolValue]);
                      }];
    [signUpActiveSignal subscribeNext:^(NSNumber*signupActive){
        self.signInButton.enabled =[signupActive boolValue];
    }];
    
    [[[[self.signInButton
        rac_signalForControlEvents:UIControlEventTouchUpInside]
//      doNext: 附加操作，并不改变事件本身。
       doNext:^(id x){
           self.signInButton.enabled =NO;
           self.signInFailureText.hidden =YES;
       }]
      
//      flattenMap:把按钮点击事件转换为登录信号，同时还从内部信号发送事件到外部信号。
      flattenMap:^id(id x){
          return[self signInSignal];
      }]
     subscribeNext:^(NSNumber*signedIn){
         self.signInButton.enabled =YES;
         BOOL success =[signedIn boolValue];
         self.signInFailureText.hidden = success;
         if(success){
             [self performSegueWithIdentifier:@"signInSuccess" sender:self];
         }
     }];
    
//    [[[self.usernameTextField.rac_textSignal
//       map:^id(NSString*text){
//           return @(text.length);
//       }]
//      filter:^BOOL(NSNumber*length){
//          return[length integerValue] > 3;
//      }]
//     subscribeNext:^(id x){
//         NSLog(@"%@", x);
//     }];
}

- (BOOL)isValidUsername:(NSString *)username {
  return username.length > 3;
}

- (BOOL)isValidPassword:(NSString *)password {
  return password.length > 3;
}

//使用RACSignal的createSignal:方法来创建信号。方法的入参是一个block，这个block描述了这个信号。当这个信号有subscriber时，block里的代码就会执行。
//block的入参是一个subscriber实例，它遵循RACSubscriber协议，协议里有一些方法来产生事件，你可以发送任意数量的next事件，或者用error\complete事件来终止。本例中，信号发送了一个next事件来表示登录是否成功，随后是一个complete事件。
//这个block的返回值是一个RACDisposable对象，它允许你在一个订阅被取消时执行一些清理工作。当前的信号不需要执行清理操作，所以返回nil就可以了。
- (RACSignal *)signInSignal {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber){
        [self.signInService
         signInWithUsername:self.usernameTextField.text
         password:self.passwordTextField.text
         complete:^(BOOL success){
             [subscriber sendNext:@(success)];
             [subscriber sendCompleted];
         }];
        return nil;
    }];
}

- (IBAction)signInButtonTouched:(id)sender {
  // disable all UI controls
  self.signInButton.enabled = NO;
  self.signInFailureText.hidden = YES;
  
  // sign in
  [self.signInService signInWithUsername:self.usernameTextField.text
                            password:self.passwordTextField.text
                            complete:^(BOOL success) {
                              self.signInButton.enabled = YES;
                              self.signInFailureText.hidden = success;
                              if (success) {
                                [self performSegueWithIdentifier:@"signInSuccess" sender:self];
                              }
                            }];
}


// updates the enabled state and style of the text fields based on whether the current username
// and password combo is valid
//- (void)updateUIState {
//  self.usernameTextField.backgroundColor = self.usernameIsValid ? [UIColor clearColor] : [UIColor yellowColor];
//  self.passwordTextField.backgroundColor = self.passwordIsValid ? [UIColor clearColor] : [UIColor yellowColor];
//  self.signInButton.enabled = self.usernameIsValid && self.passwordIsValid;
//}

//- (void)usernameTextFieldChanged {
//  self.usernameIsValid = [self isValidUsername:self.usernameTextField.text];
//  [self updateUIState];
//}

//- (void)passwordTextFieldChanged {
//  self.passwordIsValid = [self isValidPassword:self.passwordTextField.text];
//  [self updateUIState];
//}

@end
