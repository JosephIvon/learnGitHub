//
//  FWBAlertView.h
//  CustomAlertView
//
//  Created by fanwenbo on 16/4/14.
//  Copyright © 2016年 fanwenbo. All rights reserved.
//

#import <UIKit/UIKit.h>

#if defined(__APPLE_CC__) && (__APPLE_CC__ >= 5549)
#define NS_REQUIRES_NIL_TERMINATION __attribute__((sentinel(0,1)))
#else
#define NS_REQUIRES_NIL_TERMINATION __attribute__((sentinel))
#endif

#define SCREEN_WIDTH    [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT   [[UIScreen mainScreen] bounds].size.height
#define RGBA_COLOR(r, g, b, a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define kBCAlertViewPresentNotify   @"kBCAlertViewPresentNotify"  //alertview present notify

@class FWBAlertView;

@protocol FWBAlertviewdelegate <NSObject>

-(void)alertView:(FWBAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

-(void)alertViewClosed:(FWBAlertView *)alertView;

-(void)willPresentCustomAlertView:(UIView *)alertView;

// - 隐藏实用类弹出键盘
- (void)hideCurrentKeyBoard;

@end
@interface FWBAlertView : UIView

@property (nonatomic, assign) id <FWBAlertviewdelegate> delegate;

// - 左上角带叉叉按钮
@property (nonatomic, assign) BOOL isNeedCloseBtn;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * message;
@property (nonatomic, strong) UIView * backView;
@property (nonatomic, strong) UIView * titleBackgroundView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIImageView * titleIcon;
@property (nonatomic, strong) NSMutableArray * customerViewsToBeAdd;

- (instancetype)initWithTitle:(NSString*)title message:(NSString*)message delegate:(id)delegate cancelButtonTitle:(NSString*)cancelButtonTitle otherButtonTitles:(NSString*)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

-(void)initTitle:(NSString*)title message:(NSString*)message delegate:(id)del cancelButtonTitle:(NSString*)cancelBtnTitle otherButtonTitles:(NSString*)otherBtnTitles, ...NS_REQUIRES_NIL_TERMINATION;

- (void)show;

// - 在alertview中添加自定义控件
- (void)addCustomerSubview:(UIView *)view;

+ (void)exChangeOut:(UIView *)changeOutView dur:(CFTimeInterval)dur;

+ (FWBAlertView *)defaultAlert;

@end
