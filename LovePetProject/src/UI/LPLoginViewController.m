//
//  LPLoginViewController.m
//  LovePetProject
//
//  Created by HyunJoon Park on 13. 7. 7..
//  Copyright (c) 2013년 HyunJoon Park. All rights reserved.
//

#import "LPLoginViewController.h"
#import "LPAppDelegate.h"

const CGFloat kLPLoginViewMargin = 20;

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
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self createFacebookLogin];
}

- (void)createFacebookLogin
{
    FBLoginView *loginView = [[FBLoginView alloc] init];
    loginView.delegate = self;
    
    CGRect frame = loginView.frame;
    frame = CGRectOffset(loginView.frame, (self.view.center.x - (loginView.frame.size.width / 2)), 5);
    frame.origin.y = CGRectGetHeight(self.view.bounds) - CGRectGetHeight(self.navigationController.navigationBar.frame) - CGRectGetHeight(frame) - kLPLoginViewMargin;
    [loginView setFrame:frame];
    [self.view addSubview:loginView];
}

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView
{
    
}

@end
