//
//  LPPetDAOFactory.h
//  LovePetProject
//
//  Created by hyunjoon.park on 13. 8. 29..
//  Copyright (c) 2013년 HyunJoon Park. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    kLPPetDAOTypeLost,
    kLPPetDAOTypeClip,
} kLPPetDAOType;
@protocol LPPetDAO;
@interface LPPetDAOFactory : NSObject
+ (id<LPPetDAO>)petDAO:(kLPPetDAOType)type;
@end
