//
//  UIView+Utils.m
//  LovePetProject
//
//  Created by hyunjoon.park on 13. 7. 31..
//  Copyright (c) 2013년 HyunJoon Park. All rights reserved.
//

#import "UIView+Utils.h"

@implementation UIView (Utils)

- (void)drawLineFrom:(CGPoint)startPoint to:(CGPoint)endPoint lineWidth:(CGFloat)lineWidth color:(UIColor *)color dotted:(BOOL)dotted
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    [shapeLayer setStrokeColor:color.CGColor];
    [shapeLayer setLineWidth:lineWidth];
    
    if (dotted) {
        [shapeLayer setLineJoin:kCALineJoinRound];
        [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:3], [NSNumber numberWithInt:1], nil]];
    }
    
    // Setup the path
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, startPoint.x, startPoint.y);
    CGPathAddLineToPoint(path, NULL, endPoint.x, endPoint.y);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    
    [self.layer addSublayer:shapeLayer];
}

- (void)setBoxShadow:(BOOL)state
{
    if (state) {
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = NO;
        self.layer.shadowOffset = CGSizeMake(0, 1.5f);
        self.layer.shadowRadius = 0.5f;
        self.layer.shadowOpacity = 0.2f;
    } else {
        self.layer.cornerRadius = 0;
        self.layer.masksToBounds = YES;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowRadius = 0;
        self.layer.shadowOpacity = 0;
    }
}

- (void)setBoxBorder:(BOOL)state
{
    if (state) {
        [self.layer setBorderColor:COLOR_GRAYWHITE.CGColor];
        [self.layer setBorderWidth:1.0f];
    } else {
        [self.layer setBorderColor:[UIColor clearColor].CGColor];
        [self.layer setBorderWidth:0];
    }
}

@end
