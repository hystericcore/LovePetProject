//
//  UIView+Utils.h
//  LovePetProject
//
//  Created by hyunjoon.park on 13. 7. 31..
//  Copyright (c) 2013년 HyunJoon Park. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Utils)
- (void)drawLineFrom:(CGPoint)startPoint to:(CGPoint)endPoint lineWidth:(CGFloat)lineWidth color:(UIColor *)color dotted:(BOOL)dotted;
- (void)setBoxShadow:(BOOL)state;
- (void)setBoxBorder:(BOOL)state;
@end
