//
//  BezierPathView.m
//  UIBezierPath
//
//  Created by fanwenbo on 16/4/25.
//  Copyright © 2016年 fanwenbo. All rights reserved.
//

#import "BezierPathView.h"

#define   kDegreesToRadians(degrees)  ((pi * degrees)/ 180)

@implementation BezierPathView

-(void)drawRect:(CGRect)rect
{
//    [self drawRectPath];
//    [self drawTrianglePath];
//    [self drawCiclePath];
//    [self drawOvalPath];
//    [self drawRoundedRectPath];
//    [self drawOneRoundedRectPath];
    [self drawARCPath];
//    [self drawSecondBezierPath];
//    [self drawThirdBezierPath];
}

// 画三角形
- (void)drawTrianglePath {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(40, 40)];
    [path addLineToPoint:CGPointMake(self.frame.size.width - 40, 40)];
    [path addLineToPoint:CGPointMake(self.frame.size.width / 2, self.frame.size.height - 40)];
    
    // 最后的闭合线是可以通过调用closePath方法来自动生成的，也可以调用-addLineToPoint:方法来添加
    //  [path addLineToPoint:CGPointMake(20, 20)];

    [path closePath];
    
    // 设置线宽
    path.lineWidth = 1.5;
    
    // 设置填充颜色
    [[UIColor redColor] set];
    [path fill];
    
    // 设置画笔颜色
    [[UIColor yellowColor] set];
    
    // 根据我们设置的各个点连线
    [path stroke];
}

// 画矩形
- (void)drawRectPath {
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(20, 20, self.frame.size.width - 40, self.frame.size.height - 40)];
    
    path.lineWidth = 1.5;
    path.lineCapStyle = kCGLineCapRound;
//    kCGLineCapButt,  //默认
//    kCGLineCapRound, //轻微圆角
//    kCGLineCapSquare //正方形
    path.lineJoinStyle = kCGLineJoinBevel;
//    kCGLineJoinMiter,  //斜接
//    kCGLineJoinRound,  //圆滑衔接
//    kCGLineJoinBevel   //斜角链接
    
    
//    我们需要在设置画笔颜色之前先设置填充颜色，否则画笔颜色就被填充颜色替代.
    // 设置填充颜色
    [[UIColor redColor] set];
    [path fill];
    
    // 设置画笔颜色
    [[UIColor yellowColor] set];
    
    // 根据我们设置的各个点连线
    [path stroke];
}

//画正方形
- (void)drawCiclePath {
    // 传的是正方形，因此就可以绘制出圆了
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(20, 20, self.frame.size.width - 40, self.frame.size.width - 40)];
    
    // 设置填充颜色
    UIColor *fillColor = [UIColor greenColor];
    [fillColor set];
    [path fill];
    
    // 设置画笔颜色
    UIColor *strokeColor = [UIColor blueColor];
    [strokeColor set];
    
    // 根据我们设置的各个点连线
    [path stroke];
}

// 画椭圆
- (void)drawOvalPath {
    // 传的是不是正方形，因此就可以绘制出椭圆圆了
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(20, 20, self.frame.size.width - 80, self.frame.size.height - 40)];
    
    // 设置填充颜色
    UIColor *fillColor = [UIColor greenColor];
    [fillColor set];
    [path fill];
    
    // 设置画笔颜色
    UIColor *strokeColor = [UIColor blueColor];
    [strokeColor set];
    
    // 根据我们设置的各个点连线
    [path stroke];
}

//画带圆角的矩形
- (void)drawRoundedRectPath {
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(20, 20, self.frame.size.width - 40, self.frame.size.height - 40) cornerRadius:30];
    
    // 设置填充颜色
    UIColor *fillColor = [UIColor greenColor];
    [fillColor set];
    [path fill];
    
    // 设置画笔颜色
    UIColor *strokeColor = [UIColor blueColor];
    [strokeColor set];
    
    // 根据我们设置的各个点连线
    [path stroke];
}

//画指定角切圆角的矩形
- (void)drawOneRoundedRectPath {
   UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(20, 20, self.frame.size.width - 40, self.frame.size.height - 40) byRoundingCorners:UIRectCornerTopRight cornerRadii:CGSizeMake(20, 20)];
    
    // 设置填充颜色
    UIColor *fillColor = [UIColor greenColor];
    [fillColor set];
    [path fill];
    
    // 设置画笔颜色
    UIColor *strokeColor = [UIColor blueColor];
    [strokeColor set];
    
    // 根据我们设置的各个点连线
    [path stroke];
}

//画圆弧
- (void)drawARCPath {
    const CGFloat pi = 3.14159265359;
    
    CGPoint center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center
                                                        radius:100
                                                    startAngle:0
                                                      endAngle:kDegreesToRadians(135)
                                                     clockwise:YES];
    
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineJoinRound;
    path.lineWidth = 5.0;
    
    UIColor *strokeColor = [UIColor redColor];
    [strokeColor set];
    
    [path stroke];
}

//画二次贝塞尔曲线
- (void)drawSecondBezierPath {
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    // 首先设置一个起始点
    [path moveToPoint:CGPointMake(20, self.frame.size.height - 100)];
    
    // 添加二次曲线
    [path addQuadCurveToPoint:CGPointMake(self.frame.size.width - 20, self.frame.size.height - 100)
                 controlPoint:CGPointMake(self.frame.size.width / 2, 0)];
    
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineJoinRound;
    path.lineWidth = 5.0;
    
    UIColor *strokeColor = [UIColor redColor];
    [strokeColor set];
    
    [path stroke];
}

//画三次贝塞尔曲线
- (void)drawThirdBezierPath {
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    // 设置起始端点
    [path moveToPoint:CGPointMake(20, 150)];
    
    [path addCurveToPoint:CGPointMake(300, 150)
            controlPoint1:CGPointMake(160, 0)
            controlPoint2:CGPointMake(160, 250)];
    
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineJoinRound;
    path.lineWidth = 5.0;
    
    UIColor *strokeColor = [UIColor redColor];
    [strokeColor set];
    
    [path stroke];
}
@end
