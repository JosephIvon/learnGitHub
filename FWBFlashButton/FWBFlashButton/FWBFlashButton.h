//
//  FWBFlashButton.h
//  FWBFlashButton
//
//  Created by fanwenbo on 16/5/19.
//  Copyright © 2016年 fanwenbo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,FWBFlashButtonType) {
    FWBFlashButtonTypeInner = 0,
    FWBFlashButtonTypeOuter = 1
};

typedef void(^FWBFlashButtonDidClickBlock)(void);

@interface FWBFlashButton : UIView

@property (nonatomic, strong) UILabel *textLabel;

/**
 *  超出父视图部分是否切除
 */
@property (nonatomic, assign) FWBFlashButtonType buttonType;

/**
 *  动画颜色
 */
@property (nonatomic, strong) UIColor *flashColor;

/**
 *  点击回调
 */
@property (nonatomic, copy) FWBFlashButtonDidClickBlock clickBlock;

- (void)setText:(NSString *)text;
- (void)setTextColor:(UIColor *)textColor;
- (void)setText:(NSString *)text withTextColor:(UIColor *)textColor;

@end
