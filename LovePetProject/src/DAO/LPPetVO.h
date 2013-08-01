//
//  LPPetQuiltVO.h
//  LovePetProject
//
//  Created by HyunJoon Park on 13. 7. 6..
//  Copyright (c) 2013년 HyunJoon Park. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LPPetDetailVO;
@interface LPPetVO : NSObject
- (id)initWithProperties:(NSDictionary *)properties;
- (void)resetLeftDay;
- (NSString *)getRemakePetType;
// baas entity id
@property (nonatomic, strong) NSString *uuid;

// list view
@property (nonatomic, strong) NSString *thumbnailSrc;
@property (nonatomic, strong) UIImage *thumbnail;
@property (nonatomic, strong) NSString *linkSrc;
@property (nonatomic, strong) NSString *leftDay;

// detail view
@property (nonatomic, strong) NSString *boardID;
@property (nonatomic, strong) NSString *petType;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *foundLocation;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *detail;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *imageSrc;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *color;
@property (nonatomic, strong) NSString *year;
@property (nonatomic, strong) NSString *weight;
@property (nonatomic, strong) NSString *neutralize;
@property (nonatomic, strong) NSString *districtOffice;
@property (nonatomic, strong) NSString *centerName;
@property (nonatomic, strong) NSString *centerTel;
@property (nonatomic, strong) NSString *centerLocation;

@property (nonatomic, strong) NSDictionary *geoInfo;
@end
