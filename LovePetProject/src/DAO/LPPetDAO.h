//
//  LPPetDAO.h
//  LovePetProject
//
//  Created by HyunJoon Park on 13. 7. 14..
//  Copyright (c) 2013년 HyunJoon Park. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LPPetVO;

extern NSString *const kLPNotificationPetListRequestFail;
extern NSString *const kLPNotificationPetListUpdateComplete;
extern NSString *const kLPNotificationPetListUpdateFail;

extern NSString *const kLPPetKindCat;
extern NSString *const kLPPetKindDog;

@interface LPPetDAO : NSObject {
    NSUInteger _currentDateCountFromNow;
    NSUInteger _currentPageCount;
    BOOL _pageEnd;
}
- (void)resetPetDataSourceWithPetKind:(NSString *)petKind location:(NSString *)location;
- (void)requestNextPetList;
- (NSArray *)getPetDataSource;
@end


