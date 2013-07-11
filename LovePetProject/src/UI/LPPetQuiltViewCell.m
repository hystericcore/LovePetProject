//
//  LPPetQuiltViewCell.m
//  LovePetProject
//
//  Created by HyunJoon Park on 13. 7. 6..
//  Copyright (c) 2013년 HyunJoon Park. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import "LPPetQuiltViewCell.h"

const CGFloat kLPPetQuiltViewMargin = 10;
const CGFloat kLPPetQuiltViewTypePoint = 16;
const CGFloat kLPPetQuiltViewDayPoint = 10;

@implementation LPPetQuiltViewCell
@synthesize photoView = _photoView;
@synthesize typeView = _typeView;
@synthesize typeLabel = _typeLabel;
@synthesize dayLabel = _dayLabel;
@synthesize detailLabel = _detailLabel;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self.layer setBorderColor:RGB(233, 233, 233).CGColor];
        [self.layer setBorderWidth:1.0f];
        
        [self createPhotoView];
        [self createTypeView];
        [self createTypeLabel];
        [self createDayLabel];
        [self createDetailLabel];
        
    }
    return self;
}

- (void)dealloc
{
    self.photoView = nil;
    self.typeView = nil;
    self.typeLabel = nil;
    self.dayLabel = nil;
    self.detailLabel = nil;
    
    [super dealloc];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [self.photoView setAlpha:0.0];
}

- (void)didMoveToSuperview
{
    [UIView animateWithDuration:0.5f animations:^{
        [self.photoView setAlpha:1.0f];
    }];
}

- (void)createPhotoView
{
    self.photoView = [[[UIImageView alloc] init] autorelease];
    _photoView.contentMode = UIViewContentModeScaleAspectFill;
    _photoView.clipsToBounds = YES;
    [self addSubview:_photoView];
}

- (void)createTypeView
{
    self.typeView = [[[UIImageView alloc] init] autorelease];
    _typeView.contentMode = UIViewContentModeScaleAspectFill;
    _typeView.clipsToBounds = YES;
    [self addSubview:_typeView];
}

- (void)createTypeLabel
{
    self.typeLabel = [[[UILabel alloc] init] autorelease];
    _typeLabel.backgroundColor = [UIColor clearColor];
    _typeLabel.textColor = RGB(23, 23, 23);
    _typeLabel.font = [UIFont boldSystemFontOfSize:kLPPetQuiltViewTypePoint];
    [self addSubview:_typeLabel];
}

- (void)createDayLabel
{
    self.dayLabel = [[[UILabel alloc] init] autorelease];
    _dayLabel.backgroundColor = [UIColor clearColor];
    _dayLabel.textColor = RGB(23, 23, 23);
    _dayLabel.textAlignment = NSTextAlignmentRight;
    _dayLabel.font = [UIFont fontWithName:@"Kite One" size:kLPPetQuiltViewDayPoint];
    [self addSubview:_dayLabel];
}

- (void)createDetailLabel
{
    self.detailLabel = [[[UILabel alloc] init] autorelease];
    _detailLabel.backgroundColor = [UIColor clearColor];
    _detailLabel.textColor = RGB(23, 23, 23);
    _detailLabel.font = [UIFont systemFontOfSize:kLPPetQuiltViewDayPoint];
    [self addSubview:_detailLabel];
}

- (void)layoutSubviews
{
    _photoView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - kLPPetQuiltViewTextPlaceHeight);
    _typeLabel.frame = CGRectMake(kLPPetQuiltViewMargin, CGRectGetHeight(_photoView.frame) + kLPPetQuiltViewMargin,
                                       self.bounds.size.width - 2 * kLPPetQuiltViewMargin, 20);
    _dayLabel.frame = _typeLabel.frame;
    _detailLabel.frame = CGRectMake(kLPPetQuiltViewMargin, CGRectGetHeight(self.bounds) - kLPPetQuiltViewMargin - kLPPetQuiltViewDayPoint, CGRectGetWidth(_typeLabel.frame), kLPPetQuiltViewDayPoint);
}

@end
