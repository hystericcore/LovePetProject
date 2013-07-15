//
//  LPPetDetailVO.m
//  LovePetProject
//
//  Created by HyunJoon Park on 13. 7. 14..
//  Copyright (c) 2013년 HyunJoon Park. All rights reserved.
//

#import "LPPetDetailVO.h"

@implementation LPPetDetailVO

- (id)initWithProperties:(NSDictionary *)properties
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:properties];
    }
    return self;
}

@end
