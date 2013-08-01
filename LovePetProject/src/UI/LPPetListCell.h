//
//  LPPetListCell.h
//  LovePetProject
//
//  Created by NTS Mobile on 13. 7. 27..
//  Copyright (c) 2013년 HyunJoon Park. All rights reserved.
//

#import "PSCollectionViewCell.h"

const static CGFloat kLPPetListCellTextPlaceHeight = 52;

@interface LPPetListCell : PSCollectionViewCell
@property (nonatomic, strong) UIImageView *photoView;
@property (nonatomic, strong) UIImageView *typeView;
@property (nonatomic, strong) UILabel *petTypeLabel;
@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UIView *dayView;
@property (nonatomic, strong) UILabel *detailLabel;
- (void)resetPhotoView:(UIImage *)image;
@end
