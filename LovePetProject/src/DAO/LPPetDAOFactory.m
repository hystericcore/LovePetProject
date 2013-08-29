//
//  LPPetDAOFactory.m
//  LovePetProject
//
//  Created by hyunjoon.park on 13. 8. 29..
//  Copyright (c) 2013년 HyunJoon Park. All rights reserved.
//

#import "LPPetDAOFactory.h"

#import "LPLostPetDAO.h"
#import "LPClipPetDAO.h"

@implementation LPPetDAOFactory

+ (id<LPPetDAO>)petDAO:(kLPPetDAOType)type
{
    id dao = nil;
    
    switch (type) {
        case kLPPetDAOTypeLost:
            dao = [LPLostPetDAO sharedInstance];
            break;
            
        case kLPPetDAOTypeClip:
            dao = [LPClipPetDAO sharedInstance];
            break;
    }
    
    return dao;
}

@end
