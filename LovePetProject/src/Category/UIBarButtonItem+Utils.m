//
//  UIBarButtonItem+Utils.m
//  LovePetProject
//
//  Created by hyunjoon.park on 13. 8. 15..
//  Copyright (c) 2013년 HyunJoon Park. All rights reserved.
//

#import "UIBarButtonItem+Utils.h"

@implementation UIBarButtonItem (Utils)

- (void)setWhiteAppearance
{
    [self setTintColor:COLOR_GRAYWHITE];
    [self setTitleTextAttributes:@{UITextAttributeTextColor:COLOR_TEXT,
                                   UITextAttributeTextShadowColor:[UIColor whiteColor],
                                   UITextAttributeTextShadowOffset:[NSValue valueWithUIOffset:UIOffsetMake(0.0f, 1.0f)]}
                        forState:UIControlStateNormal];
    [self setTitleTextAttributes:@{UITextAttributeTextColor:COLOR_TEXT,
                                   UITextAttributeTextShadowColor:[UIColor whiteColor],
                                   UITextAttributeTextShadowOffset:[NSValue valueWithUIOffset:UIOffsetMake(0.0f, 1.0f)]}
                        forState:UIControlStateHighlighted];
}

- (void)setBlueAppearance
{
    [self setTintColor:COLOR_LIGHT_BLUE];
}

@end
