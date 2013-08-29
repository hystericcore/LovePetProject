//
//  LPLocalPetDAO.h
//  LovePetProject
//
//  Created by hyunjoon.park on 13. 8. 29..
//  Copyright (c) 2013년 HyunJoon Park. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LPPetVO;
@protocol LPLocalPetDAO <NSObject>
- (BOOL)isLocalPetDataExist:(LPPetVO *)petVO;
- (BOOL)setLocalPetData:(LPPetVO *)petVO;
- (void)removeLocalPetData:(LPPetVO *)petVO;
@end
