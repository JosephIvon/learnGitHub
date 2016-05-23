//
//  AppDelegate.m
//  UIWindowDemo
//
//  Created by fanwenbo on 16/5/18.
//  Copyright © 2016年 fanwenbo. All rights reserved.
//

/**
 *  Resources:
 *  http://www.jianshu.com/p/2d4dcf7d97eb
 *  https://github.com/steventroughtonsmith/WindowManager.git
 */
#import "AppDelegate.h"
#import "FWBWindow.h"
#import "FWBTableViewController.h"

@import MapKit;
@import ObjectiveC.runtime;

@interface AppDelegate () <UITextFieldDelegate>
{
    FWBWindow *windowOne;
    FWBWindow *windowTwo;
    FWBWindow *windowThree;
}

@property (strong, nonatomic) UIWindow *window0;
@property (strong, nonatomic) UIWindow *window1;
@property (strong, nonatomic) UIWindow *window2;

@end

@implementation UINavigationBar (FWBNavigationBar)

/*	Overly simplistic. You'd want to rewrite this */
-(void)layoutSubviews_FWB
{
    [self layoutSubviews_FWB];
    
    for (UIView *view in self.subviews)
    {
        if (![[view class] isSubclassOfClass:NSClassFromString(@"_UINavigationBarBackground")] && [view class] != NSClassFromString(@"UINavigationItemView"))
        {
            CGRect f = view.frame;
            f.origin.x += 75;
            view.frame = f;
        }
    }
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self addNotifications];
//    [self testWindow1];
    [self testWindow2];

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
#pragma clang diagnostic pop
    
    return YES;
}

-(void)addNotifications{
    /*
     * 1 监测window
     */
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(windowDidBecomeVisible:) name:UIWindowDidBecomeVisibleNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(windowDidBecomeHidden:) name:UIWindowDidBecomeHiddenNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(windowDidBecomeKey:) name:UIWindowDidBecomeKeyNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(windowDidResignKey:) name:UIWindowDidResignKeyNotification object:nil];
    
    /*
     * 2 监测keyboard
     */
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidShowNotification:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidHideNotification:) name:UIKeyboardDidHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillChangeFrameNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidChangeFrameNotification:) name:UIKeyboardDidChangeFrameNotification object:nil];
}

-(void)testWindow2{
    Class class = [UINavigationBar class];
    
    Method originalMethod = class_getInstanceMethod(class, @selector(layoutSubviews));
    Method categoryMethod = class_getInstanceMethod(class, @selector(layoutSubviews_FWB));
    method_exchangeImplementations(originalMethod, categoryMethod);
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[UIViewController alloc] init];
    self.window.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"wallpapers"]];
    [self.window makeKeyAndVisible];
    
    {
        windowOne = [[FWBWindow alloc] initWithFrame:CGRectMake(0, 20, 300, 300)];
        windowOne.title = @"Map";
        
        UIViewController *vc1 = [[UIViewController alloc] init];
        vc1.title = @"Root";
        
        UIViewController *vc = [[UIViewController alloc] init];
        vc.title = @"Map";
        
        vc.view = [[MKMapView alloc] init];
        
        windowOne.rootViewController = [[UINavigationController alloc] initWithRootViewController:vc1];
        vc.navigationItem.hidesBackButton = NO;
        
        [((UINavigationController *)windowOne.rootViewController) pushViewController:vc animated:YES]; // testing nav bar behavior
        
        [windowOne makeKeyAndVisible];
    }
    
    {
        windowTwo = [[FWBWindow alloc] initWithFrame:CGRectMake(100, 100, 300, 300)];
        windowTwo.title = @"Table";
        
        FWBTableViewController *vc = [[FWBTableViewController alloc] init];
        vc.title = @"Table";
        
        windowTwo.rootViewController = [[UINavigationController alloc] initWithRootViewController:vc];
        
        [windowTwo makeKeyAndVisible];
    }
    
    {
        windowThree = [[FWBWindow alloc] initWithFrame:CGRectMake(200, 200, 300, 300)];
        windowThree.title = @"Text";
        
        UIViewController *vc = [[UIViewController alloc] init];
        vc.view = [[UITextView alloc] init];
        
        vc.title = @"Text";
        
        UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:vc];
        
        ((UITextView *)vc.view).text = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";
        windowThree.rootViewController = navC;
        
        [windowThree makeKeyAndVisible];
    }
}

-(void)testWindow1{
    
    self.window0 = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window0.backgroundColor = [UIColor greenColor];
    self.window0.windowLevel = UIWindowLevelNormal;
    self.window0.rootViewController = [[UIViewController alloc] init];
    [self.window0 makeKeyAndVisible];
    
    UITextField *tf0 = [[UITextField alloc]initWithFrame:CGRectMake(0, 20, 100, 30)];
    tf0.layer.borderColor = [UIColor blueColor].CGColor;
    tf0.layer.borderWidth = 1;
    tf0.delegate = self;
    [self.window0 addSubview:tf0];
    UILabel *lab0 = [[UILabel alloc]initWithFrame:CGRectMake(0, 60, 100, 30)];
    lab0.text = @"视图一";
    lab0.font = [UIFont boldSystemFontOfSize:18];
    [self.window0 addSubview:lab0];
    
    self.window1 = [[UIWindow alloc]initWithFrame:CGRectMake(100, 100, [UIScreen mainScreen].bounds.size.width - 100, [UIScreen mainScreen].bounds.size.height- 100)];
    self.window1.backgroundColor = [UIColor brownColor];
    self.window1.windowLevel = UIWindowLevelStatusBar;
    self.window1.rootViewController = [[UIViewController alloc] init];
    [self.window1 makeKeyAndVisible];
    
    UITextField *tf1 = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    tf1.layer.borderColor = [UIColor blueColor].CGColor;
    tf1.layer.borderWidth = 1;
    tf1.delegate = self;
    [self.window1 addSubview:tf1];
    UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, 100, 30)];
    lab1.text = @"视图二";
    lab1.font = [UIFont boldSystemFontOfSize:18];
    [self.window1 addSubview:lab1];
    
    // window2
    self.window2 = [[UIWindow alloc] initWithFrame:CGRectMake(200, 200, [UIScreen mainScreen].bounds.size.width - 200, [UIScreen mainScreen].bounds.size.height- 200)];
    self.window2.windowLevel = UIWindowLevelAlert;
    self.window2.backgroundColor = [UIColor redColor];
    self.window2.rootViewController = [[UIViewController alloc] init];
    [self.window2 makeKeyAndVisible];
    
    UITextField *tf2 = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    tf2.layer.borderColor = [UIColor blueColor].CGColor;
    tf2.layer.borderWidth = 1;
    tf2.delegate = self;
    [self.window2 addSubview:tf2];
    UILabel *lab2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, 100, 30)];
    lab2.text = @"视图三";
    lab2.font = [UIFont boldSystemFontOfSize:18];
    [self.window2 addSubview:lab2];
    
    CGPoint p = [self.window1 convertPoint:CGPointMake(0, 0) toWindow:self.window0];
    NSLog(@"%@",NSStringFromCGPoint(p));
    NSLog(@"-------------%@",[UIApplication sharedApplication].keyWindow);
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)windowDidBecomeVisible:(NSNotification *)notification {
    NSLog(@"windowDidBecomeVisible----%@",notification.object);
}

- (void)windowDidBecomeHidden:(NSNotification *)notification {
    NSLog(@"windowDidBecomeHidden----%@",notification.object);
}

- (void)windowDidBecomeKey:(NSNotification *)notification {
    NSLog(@"windowDidBecomeKey----%@",notification.object);
}

- (void)windowDidResignKey:(NSNotification *)notification {
    NSLog(@"windowDidResignKey----%@",notification.object);
}

- (void)keyboardWillShowNotification:(NSNotification *)notification {
    NSLog(@"keyboardWillShowNotification----%@",notification.userInfo);
}

- (void)keyboardDidShowNotification:(NSNotification *)notification {
    NSLog(@"keyboardDidShowNotification----%@",notification.userInfo);
}

- (void)keyboardWillHideNotification:(NSNotification *)notification {
    NSLog(@"keyboardWillHideNotification----%@",notification.userInfo);
}

- (void)keyboardDidHideNotification:(NSNotification *)notification {
    NSLog(@"keyboardDidHideNotification----%@",notification.userInfo);
}

- (void)keyboardWillChangeFrameNotification:(NSNotification *)notification {
    NSLog(@"keyboardWillChangeFrameNotification----%@",notification.userInfo);
}

- (void)keyboardDidChangeFrameNotification:(NSNotification *)notification {
    NSLog(@"keyboardDidChangeFrameNotification----%@",notification.userInfo);
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
