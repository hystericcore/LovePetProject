//
//  LPPetListCell.m
//  LovePetProject
//
//  Created by NTS Mobile on 13. 7. 27..
//  Copyright (c) 2013년 HyunJoon Park. All rights reserved.
//

#import "LPPetListCell.h"
#import <QuartzCore/QuartzCore.h>

#import "UIView+Utils.h"

const CGFloat kLPPetListCellMargin = 10;
const CGFloat kLPPetListCellTypePoint = 16;
const CGFloat kLPPetListCellDayPoint = 10;

@implementation LPPetListCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setBoxBorder:YES];
        
        [self createPhotoView];
        [self createTypeView];
        [self createTypeLabel];
        [self createDayLabel];
        [self createDetailLabel];
    }
    return self;
}

- (void)createPhotoView
{
    self.photoView = [[UIImageView alloc] init];
    _photoView.contentMode = UIViewContentModeScaleAspectFill;
    _photoView.clipsToBounds = YES;
    [self addSubview:_photoView];
}

- (void)createTypeView
{
    self.typeView = [[UIImageView alloc] init];
    _typeView.contentMode = UIViewContentModeScaleAspectFill;
    _typeView.clipsToBounds = YES;
    [self addSubview:_typeView];
}

- (void)createTypeLabel
{
    self.petTypeLabel = [[UILabel alloc] init];
    _petTypeLabel.backgroundColor = [UIColor clearColor];
    _petTypeLabel.textColor = COLOR_TEXT;
    _petTypeLabel.font = [UIFont boldSystemFontOfSize:kLPPetListCellTypePoint];
    [self addSubview:_petTypeLabel];
}

- (void)createDayLabel
{
    self.dayView = [[UIView alloc] init];
    _dayView.backgroundColor = COLOR_LOVEPET;
    _dayView.userInteractionEnabled = NO;
    
    UIImage *clock = [UIImage imageNamed:@"petlist_clock.png"];
    UIImageView *clockView = [[UIImageView alloc] initWithImage:clock];
    clockView.frame = CGRectMake(5, 6, 12, 12);
    clockView.userInteractionEnabled = NO;
    [_dayView addSubview:clockView];
    
    self.dayLabel = [[UILabel alloc] init];
    _dayLabel.backgroundColor = [UIColor clearColor];
    _dayLabel.textColor = [UIColor whiteColor];
    _dayLabel.textAlignment = NSTextAlignmentRight;
    _dayLabel.font = [UIFont boldSystemFontOfSize:10];
    _dayLabel.userInteractionEnabled = NO;
    [_dayView addSubview:_dayLabel];
    
    [self addSubview:_dayView];
}

- (void)createDetailLabel
{
    self.detailLabel = [[UILabel alloc] init];
    _detailLabel.backgroundColor = [UIColor clearColor];
    _detailLabel.textColor = COLOR_LIGHT_TEXT;
    _detailLabel.font = [UIFont italicSystemFontOfSize:kLPPetListCellDayPoint];
    [self addSubview:_detailLabel];
}

- (void)layoutSubviews
{
    _photoView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - kLPPetListCellTextPlaceHeight);
    _petTypeLabel.frame = CGRectMake(kLPPetListCellMargin, CGRectGetHeight(_photoView.frame) + kLPPetListCellMargin,
                                     self.bounds.size.width - 2 * kLPPetListCellMargin, 20);
    [_dayLabel sizeToFit];
    _dayLabel.frame = CGRectMake(10 + (5 * 2), 5, CGRectGetWidth(_dayLabel.frame), CGRectGetHeight(_dayLabel.frame));
    _dayView.frame = CGRectMake(CGRectGetWidth(self.bounds) - CGRectGetWidth(_dayLabel.frame) - (10 + (5 * 3)), 0, CGRectGetWidth(_dayLabel.frame) + (10 + (5 * 3)), CGRectGetHeight(_dayLabel.frame) + 10);
    
    _detailLabel.frame = CGRectMake(kLPPetListCellMargin, CGRectGetHeight(self.bounds) - kLPPetListCellMargin - kLPPetListCellDayPoint, CGRectGetWidth(_petTypeLabel.frame), kLPPetListCellDayPoint);
}

#pragma mark - Public Method

- (void)resetPhotoView:(UIImage *)image
{
    _photoView.alpha = 0;
    _photoView.image = image;
    [UIView animateWithDuration:0.5 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _photoView.alpha = 1.0f;
    } completion:nil];
}

@end
