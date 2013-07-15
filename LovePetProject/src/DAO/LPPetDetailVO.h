//
//  LPPetDetailVO.h
//  LovePetProject
//
//  Created by HyunJoon Park on 13. 7. 14..
//  Copyright (c) 2013년 HyunJoon Park. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPPetDetailVO : NSObject
- (id)initWithProperties:(NSDictionary *)properties;
@property (nonatomic, strong) NSString *boardID;
@property (nonatomic, strong) NSString *imageSrc;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *color;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *year;
@property (nonatomic, strong) NSString *weight;
@property (nonatomic, strong) NSString *foundLocation;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *leftDay;
@property (nonatomic, strong) NSString *neutralize;
@property (nonatomic, strong) NSString *detail;
@property (nonatomic, strong) NSString *districtOffice;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *centerName;
@property (nonatomic, strong) NSString *centerTel;
@property (nonatomic, strong) NSString *centerLocation;
@end
