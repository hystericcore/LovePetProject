//
//  LPDottedLine.m
//  LovePetProject
//
//  Created by hyunjoon.park on 13. 7. 31..
//  Copyright (c) 2013년 HyunJoon Park. All rights reserved.
//

#import "LPDottedLine.h"

@implementation LPDottedLine

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        [shapeLayer setBounds:self.bounds];
        [shapeLayer setPosition:self.center];
        [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
        [shapeLayer setStrokeColor:[[UIColor blackColor] CGColor]];
        [shapeLayer setLineWidth:3.0f];
        [shapeLayer setLineJoin:kCALineJoinRound];
        [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:10], [NSNumber numberWithInt:5], nil]];
        
        // Setup the path
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, 10, 10);
        CGPathAddLineToPoint(path, NULL, 100,100);
        
        [shapeLayer setPath:path];
        CGPathRelease(path);
        
        [[self layer] addSublayer:shapeLayer];
    }
    return self;
}

@end
