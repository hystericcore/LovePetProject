//
//  LPClipPetDAO.h
//  LovePetProject
//
//  Created by hyunjoon.park on 13. 8. 29..
//  Copyright (c) 2013년 HyunJoon Park. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LPPetDAO.h"
#import "LPLocalPetDAO.h"
@interface LPClipPetDAO : NSObject <LPPetDAO, LPLocalPetDAO>
@end
