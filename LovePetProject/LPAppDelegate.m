//
//  LPAppDelegate.m
//  LovePetProject
//
//  Created by HyunJoon Park on 13. 7. 6..
//  Copyright (c) 2013년 HyunJoon Park. All rights reserved.
//

#import "LPAppDelegate.h"
#import <baas.io/Baas.h>
#import "LPRootViewController.h"

@implementation LPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    
    // Override point for customization after application launch.
    self.viewController = [[[LPRootViewController alloc] init] autorelease];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
//    NSLog(@"Available fonts : %@", [UIFont familyNames]);
    
    return YES;
}

- (void)dealloc
{
    self.viewController = nil;
    self.window = nil;
    
    [super dealloc];
}

@end
