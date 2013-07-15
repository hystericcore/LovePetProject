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
@property (nonatomic, strong) NSString *thumbnailSrc;
@property (nonatomic, strong) UIImage *thumbnail;
@property (nonatomic, strong) NSString *linkSrc;
@property (nonatomic, strong) NSString *boardID;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *leftDay;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *foundLocation;
@property (nonatomic, strong) NSString *detail;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *tel;
@property (nonatomic, strong) LPPetDetailVO *detailVO;
@end
