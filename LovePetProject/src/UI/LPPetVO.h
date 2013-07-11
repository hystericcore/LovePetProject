//
//  LPPetQuiltVO.h
//  LovePetProject
//
//  Created by HyunJoon Park on 13. 7. 6..
//  Copyright (c) 2013년 HyunJoon Park. All rights reserved.
//

#import <Foundation/Foundation.h>

const static NSString *kLPPetDataDomain = @"http://animal.go.kr";

@interface LPPetVO : NSObject
@property (nonatomic, retain) NSString *thumbnailSrc;
@property (nonatomic, retain) UIImage *thumbnail;
@property (nonatomic, retain) NSString *imageSrc;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) NSString *linkSrc;
@property (nonatomic, retain) NSString *boardID;
@property (nonatomic, retain) NSString *date;
@property (nonatomic, retain) NSString *leftDay;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *sex;
@property (nonatomic, retain) NSString *foundLocation;
@property (nonatomic, retain) NSString *detail;
@property (nonatomic, retain) NSString *state;

@property (nonatomic, retain) NSString *tel;
@end
