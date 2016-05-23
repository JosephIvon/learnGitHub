//
//  FWBWindow.h
//  UIWindowDemo
//
//  Created by fanwenbo on 16/5/18.
//  Copyright © 2016年 fanwenbo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    WMResizeLeft,
    WMResizeRight,
    WMResizeTop,
    WMResizeBottom
} WMResizeAxis;

@interface FWBWindow : UIWindow <UIGestureRecognizerDelegate>
{
    CGRect _savedFrame;
    BOOL _inWindowMove;
    BOOL _inWindowResize;
    CGPoint _originPoint;
    WMResizeAxis resizeAxis;
}

@property NSString *title;
@property NSMutableArray *windowButtons;
@property BOOL maximized;

@end
