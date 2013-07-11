//
//  LPPetQuiltVO.m
//  LovePetProject
//
//  Created by HyunJoon Park on 13. 7. 6..
//  Copyright (c) 2013년 HyunJoon Park. All rights reserved.
//

#import "LPPetVO.h"

@implementation LPPetVO
@synthesize thumbnailSrc = _thumbnailSrc;
@synthesize thumbnail = _thumbnail;
@synthesize imageSrc = _imageSrc;
@synthesize image = _image;
@synthesize linkSrc = _linkSrc;
@synthesize boardID = _boardID;
@synthesize date = _date;
@synthesize type = _type;
@synthesize sex = _sex;
@synthesize foundLocation = _foundLocation;
@synthesize detail = _detail;
@synthesize state = _state;

- (void)dealloc
{
    self.thumbnailSrc = nil;
    self.thumbnail = nil;
    self.imageSrc = nil;
    self.image = nil;
    self.linkSrc = nil;
    self.boardID = nil;
    self.date = nil;
    self.type = nil;
    self.sex = nil;
    self.foundLocation = nil;
    self.detail = nil;
    self.state = nil;
    
    [super dealloc];
}

@end
