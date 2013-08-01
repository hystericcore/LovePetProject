//
//  LPPetDAO.h
//  LovePetProject
//
//  Created by HyunJoon Park on 13. 7. 14..
//  Copyright (c) 2013년 HyunJoon Park. All rights reserved.
//

#import <Foundation/Foundation.h>
extern NSString *const kLPNotificationPetListReset;
extern NSString *const kLPNotificationPetListUpdateComplete;
extern NSString *const kLPNotificationPetListReturnZero;
extern NSString *const kLPNotificationPetListUpdateFail;
extern NSString *const kLPNotificationPetListRequestFail;

extern NSString *const kLPNotificationClipPetListReset;

extern NSString *const kLPPetKindCat;
extern NSString *const kLPPetKindDog;

extern NSString *const kLPSearchOptionKeyword;
extern NSString *const kLPSearchOptionPetType;
extern NSString *const kLPSearchOptionLocation;
@class LPPetVO;
@interface LPPetDAO : NSObject
+ (instancetype)sharedInstance;
@property (nonatomic, strong) NSString *currentQueryCursor;
@property (nonatomic, assign) BOOL stopQuery;
@property (nonatomic, strong) NSOperationQueue *operationQueue;
- (void)resetRemotePetDataSource;
- (void)requestNextPetList;
- (NSArray *)getRemotePetDataSource;
- (NSArray *)getSearchOptionValues:(NSString *)optionType;
- (NSArray *)getClipPetDataSource;
- (BOOL)isClipPetDataExist:(LPPetVO *)petVO;
- (BOOL)setClipPetData:(LPPetVO *)petVO;
- (void)removeClipPetData:(LPPetVO *)petVO;
@end
