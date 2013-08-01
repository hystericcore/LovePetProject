//
//  LPLoginViewController.m
//  LovePetProject
//
//  Created by HyunJoon Park on 13. 7. 7..
//  Copyright (c) 2013년 HyunJoon Park. All rights reserved.
//

#import "LPLoginViewController.h"
#import "UIViewController+Commons.h"

@implementation LPLoginViewController

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:COLOR_GRAYWHITE];
    
    [self createLeftViewButton];
    [self createNavTitleView];
}

@end
