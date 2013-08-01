//
//  LPAppDelegate.m
//  LovePetProject
//
//  Created by HyunJoon Park on 13. 7. 6..
//  Copyright (c) 2013년 HyunJoon Park. All rights reserved.
//

#import "LPAppDelegate.h"
#import "LPPetDAO.h"
#import "LPPetListViewController.h"
#import "LPLeftViewController.h"

#import "PKRevealController.h"

@implementation LPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    
    LPPetListViewController *petListController = [[LPPetListViewController alloc] init];
    UINavigationController *frontViewController = [[UINavigationController alloc] initWithRootViewController:petListController];
    [frontViewController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar_background.png"] forBarMetrics:UIBarMetricsDefault];
    UIViewController *leftViewController = [[LPLeftViewController alloc] init];
    
    self.revealController = [PKRevealController revealControllerWithFrontViewController:frontViewController
                                                                     leftViewController:leftViewController
                                                                                options:nil];
    self.window.rootViewController = self.revealController;
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark - Temporary Methods

- (void)printAvailableFont
{
    NSLog(@"Available fonts : %@", [UIFont familyNames]);
    
    NSArray *fontNames = [UIFont fontNamesForFamilyName:@"Apple SD Gothic Neo"];
    
    for (NSString* aFontName in fontNames) {
        NSLog(@"Font name: %@", aFontName);
    }
}

/*
 NSDictionary *options = @{
 PKRevealControllerAllowsOverdrawKey : [NSNumber numberWithBool:YES],
 PKRevealControllerDisablesFrontViewInteractionKey : [NSNumber numberWithBool:YES]
 };
 */

@end
