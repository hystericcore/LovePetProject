//
//  LPPetDetailView.m
//  LovePetProject
//
//  Created by HyunJoon Park on 13. 7. 7..
//  Copyright (c) 2013년 HyunJoon Park. All rights reserved.
//

#import "LPPetDetailView.h"

const CGFloat kLPPetDetailViewMargin = 10;
const CGFloat kLPPetDatailViewBigPoint = 24;
const CGFloat kLPPetDatailViewSmallPoint = 14;
const CGFloat kLPPetDetailViewBottomHeight = 60;

@implementation LPPetDetailView
@synthesize photoView = _photoView;
@synthesize typeLabel = _typeLabel;
@synthesize dayLabel = _dayLabel;
@synthesize boardIDLabel = _boardIDLabel;
@synthesize detailLabel = _detailLabel;
@synthesize telLabel = _telLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createPhotoView];
        [self createTypeLabel];
        [self createDayLabel];
        [self createBoardIDLabel];
        [self createDetailLabel];
        [self createTelLabel];
    }
    return self;
}

- (void)createPhotoView
{
    self.photoView = [[[UIImageView alloc] init] autorelease];
    _photoView.contentMode = UIViewContentModeScaleAspectFit;
    _photoView.clipsToBounds = YES;
    [self addSubview:_photoView];
}

- (void)createTypeLabel
{
    self.typeLabel = [[[UILabel alloc] init] autorelease];
    _typeLabel.backgroundColor = [UIColor clearColor];
    _typeLabel.textColor = RGB(23, 23, 23);
    _typeLabel.font = [UIFont boldSystemFontOfSize:kLPPetDatailViewBigPoint];
    [self addSubview:_typeLabel];
}

- (void)createDayLabel
{
    self.dayLabel = [[[UILabel alloc] init] autorelease];
    _dayLabel.backgroundColor = [UIColor clearColor];
    _dayLabel.textColor = RGB(23, 23, 23);
    _dayLabel.textAlignment = NSTextAlignmentRight;
    _dayLabel.font = [UIFont fontWithName:@"Kite One" size:kLPPetDatailViewSmallPoint];
    [self addSubview:_dayLabel];
}

- (void)createBoardIDLabel
{
    self.boardIDLabel = [[[UILabel alloc] init] autorelease];
    _boardIDLabel.backgroundColor = [UIColor clearColor];
    _boardIDLabel.textColor = RGB(23, 23, 23);
    _boardIDLabel.font = [UIFont boldSystemFontOfSize:kLPPetDatailViewBigPoint];
    [self addSubview:_boardIDLabel];
}

- (void)createDetailLabel
{
    self.detailLabel = [[[UILabel alloc] init] autorelease];
    _detailLabel.backgroundColor = [UIColor clearColor];
    _detailLabel.textColor = RGB(23, 23, 23);
    _detailLabel.font = [UIFont systemFontOfSize:kLPPetDatailViewSmallPoint];
    [self addSubview:_detailLabel];
}

- (void)createTelLabel
{
    self.telLabel = [[[UILabel alloc] init] autorelease];
    _telLabel.backgroundColor = [UIColor clearColor];
    _telLabel.textColor = RGB(23, 23, 23);
    _telLabel.font = [UIFont systemFontOfSize:kLPPetDatailViewSmallPoint];
    [self addSubview:_telLabel];
}

- (void)layoutSubviews
{
    CGRect bounds = self.bounds;
    CGRect photoViewFrame = bounds;
    photoViewFrame.size.height -= kLPPetDetailViewBottomHeight;
    [self.photoView setFrame:photoViewFrame];
    [self.typeLabel setFrame:CGRectMake(kLPPetDetailViewMargin, CGRectGetMaxY(photoViewFrame), CGRectGetWidth(bounds) - kLPPetDetailViewMargin * 2, kLPPetDatailViewBigPoint)];
    [self.dayLabel setFrame:CGRectMake(kLPPetDetailViewMargin, CGRectGetMinY(_typeLabel.frame), CGRectGetWidth(_typeLabel.frame), kLPPetDatailViewBigPoint)];
    [self.detailLabel setFrame:CGRectMake(kLPPetDetailViewMargin, CGRectGetMaxY(_typeLabel.frame) + kLPPetDetailViewMargin / 2, CGRectGetWidth(_typeLabel.frame), kLPPetDatailViewSmallPoint)];
}

@end
