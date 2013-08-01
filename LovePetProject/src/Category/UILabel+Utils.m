//
//  UILabel+Utils.m
//  LovePetProject
//
//  Created by hyunjoon.park on 13. 8. 1..
//  Copyright (c) 2013년 HyunJoon Park. All rights reserved.
//

#import "UILabel+Utils.h"

@implementation UILabel (Utils)

- (void)resizeToStretch
{
    float width = [self expectedWidth];
    CGRect newFrame = [self frame];
    newFrame.size.width = width;
    [self setFrame:newFrame];
}

- (float)expectedWidth
{
    [self setNumberOfLines:1];
    
    CGSize maximumLabelSize = CGSizeMake(9999,self.frame.size.height);
    CGSize expectedLabelSize = [[self text] sizeWithFont:[self font]
                                       constrainedToSize:maximumLabelSize
                                           lineBreakMode:[self lineBreakMode]];
    return expectedLabelSize.width;
}

@end
