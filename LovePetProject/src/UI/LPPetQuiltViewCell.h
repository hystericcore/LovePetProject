//
//  LPPetQuiltViewCell.h
//  LovePetProject
//
//  Created by HyunJoon Park on 13. 7. 6..
//  Copyright (c) 2013년 HyunJoon Park. All rights reserved.
//

#import "TMQuiltViewCell.h"

const static CGFloat kLPPetQuiltViewTextPlaceHeight = 52;

@interface LPPetQuiltViewCell : TMQuiltViewCell
@property (nonatomic, retain) UIImageView *photoView;
@property (nonatomic, retain) UIImageView *typeView;
@property (nonatomic, retain) UILabel *typeLabel;
@property (nonatomic, retain) UILabel *dayLabel;
@property (nonatomic, retain) UILabel *detailLabel;
@end
