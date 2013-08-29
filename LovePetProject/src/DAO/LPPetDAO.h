//
//  LPPetDAO.h
//  LovePetProject
//
//  Created by hyunjoon.park on 13. 8. 29..
//  Copyright (c) 2013년 HyunJoon Park. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    kLPPetDAONotiReset,
    kLPPetDAONotiUpdateComplete,
    kLPPetDAONotiUpdateFail,
    kLPPetDAONotiReturnZero,
    kLPPetDAONotiRequestFail,
} kLPPetDAONoti;

typedef enum {
    kLPSearchOptionKeyword,
    kLPSearchOptionPetType,
    kLPSearchOptionLocation,
} kLPSearchOption;

@protocol LPPetDAO <NSObject>
+ (instancetype)sharedInstance;
- (NSString *)getNotiName:(kLPPetDAONoti)type;
- (void)resetPetDataSource;
- (NSArray *)getPetDataSource;
@optional
- (void)requestNextPetList;
- (NSString *)getSearchOptionName:(kLPSearchOption)option;
- (NSArray *)getSearchOptionValues:(kLPSearchOption)option;
@end
