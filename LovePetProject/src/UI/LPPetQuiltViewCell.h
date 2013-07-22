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
@property (nonatomic, strong) UIImageView *photoView;
@property (nonatomic, strong) UIImageView *typeView;
@property (nonatomic, strong) UILabel *petTypeLabel;
@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@end
