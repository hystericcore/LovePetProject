//
//  LPPetDAO.h
//  LovePetProject
//
//  Created by HyunJoon Park on 13. 7. 14..
//  Copyright (c) 2013년 HyunJoon Park. All rights reserved.
//

#import <Foundation/Foundation.h>
extern NSString *const kLPNotificationPetListRequestFail;
extern NSString *const kLPNotificationPetListUpdateComplete;
extern NSString *const kLPNotificationPetListUpdateFail;

extern NSString *const kLPNotificationPetDetailRequestComplete;
extern NSString *const kLPNotificationPetDetailRequestFail;

extern NSString *const kLPPetKindCat;
extern NSString *const kLPPetKindDog;

@interface LPPetDAO : NSObject {
    NSUInteger _currentDateCountFromNow;
    NSUInteger _currentPageCount;
    BOOL _pageEnd;
}
- (void)resetPetDataSourceWithPetKind:(NSString *)petKind location:(NSString *)location;
- (void)requestNextPetList;
- (void)requestPetDetailDataAtIndex:(NSUInteger)index;
- (NSArray *)getPetDataSource;
- (id)getPetDetailDataAtIndex:(NSUInteger)index;
@end


