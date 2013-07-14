//
//  LPAppDelegate.m
//  LovePetProject
//
//  Created by HyunJoon Park on 13. 7. 6..
//  Copyright (c) 2013년 HyunJoon Park. All rights reserved.
//

#import "LPAppDelegate.h"
#import "LPPetDAO.h"
#import "LPRootViewController.h"

@implementation LPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    
    // Override point for customization after application launch.
    self.viewController = [[LPRootViewController alloc] init];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

#pragma mark - Temporary Methods

- (void)printAvailableFont
{
    NSLog(@"Available fonts : %@", [UIFont familyNames]);
}

@end
