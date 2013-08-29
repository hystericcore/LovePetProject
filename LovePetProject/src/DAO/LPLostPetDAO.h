//
//  LPPetDAO.h
//  LovePetProject
//
//  Created by HyunJoon Park on 13. 7. 14..
//  Copyright (c) 2013년 HyunJoon Park. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LPPetDAO.h"
@class LPPetVO;
@interface LPLostPetDAO : NSObject <LPPetDAO>
@property (nonatomic, strong) NSString *currentQueryCursor;
@property (nonatomic, assign) BOOL stopQuery;
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@end
