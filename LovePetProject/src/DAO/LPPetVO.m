//
//  LPPetQuiltVO.m
//  LovePetProject
//
//  Created by HyunJoon Park on 13. 7. 6..
//  Copyright (c) 2013년 HyunJoon Park. All rights reserved.
//

#import "LPPetVO.h"

@implementation LPPetVO

- (id)initWithProperties:(NSDictionary *)properties
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:properties];
    }
    return self;
}

@end
