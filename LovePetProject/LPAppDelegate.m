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
#import "LPGuideViewController.h"

#import "PKRevealController.h"

@implementation LPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    
    [self setUIAppearanceToWhite];
    
    LPPetListViewController *petListController = [[LPPetListViewController alloc] initWithViewMode:kLPPetListViewModeRemote];
    UINavigationController *frontViewController = [[UINavigationController alloc] initWithRootViewController:petListController];
    UIViewController *leftViewController = [[LPLeftViewController alloc] init];
    
    self.revealController = [PKRevealController revealControllerWithFrontViewController:frontViewController
                                                                     leftViewController:leftViewController
                                                                                options:nil];
    self.window.rootViewController = self.revealController;
    [self.window makeKeyAndVisible];
    
    [self showGuideView];
    
    return YES;
}

- (void)showGuideView
{
    NSString *appVer = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *currentVer = [[NSUserDefaults standardUserDefaults] objectForKey:kLPCurrentVersion];
    
    NSLog(@"%@ %@", appVer, currentVer);
    
    if (currentVer == nil || [appVer isEqualToString:currentVer] != YES) {
        LPGuideViewController *viewController = [[LPGuideViewController alloc] init];
        [self.revealController presentViewController:viewController
                                            animated:NO
                                          completion:^{
                                              
                                          }];
    }
    
//    [[NSUserDefaults standardUserDefaults] setObject:appVer forKey:kLPCurrentVersion];
}

- (void)setUIAppearanceToWhite
{
    [[UINavigationBar appearanceWhenContainedIn:[PKRevealController class], nil] setBackgroundImage:[UIImage imageNamed:@"navbar_background.png"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearanceWhenContainedIn:[PKRevealController class], nil]
     setTitleTextAttributes:@{UITextAttributeTextColor:COLOR_TEXT,
                              UITextAttributeTextShadowColor:[UIColor whiteColor],
                              UITextAttributeTextShadowOffset:[NSValue valueWithUIOffset:UIOffsetMake(0.0f, 1.0f)]}];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[PKRevealController class], nil] setTintColor:COLOR_GRAYWHITE];
    [[UIBarButtonItem appearanceWhenContainedIn:[PKRevealController class], nil]
     setTitleTextAttributes:@{UITextAttributeTextColor:COLOR_TEXT,
                              UITextAttributeTextShadowColor:[UIColor whiteColor],
                              UITextAttributeTextShadowOffset:[NSValue valueWithUIOffset:UIOffsetMake(0.0f, 1.0f)]}
     forState:UIControlStateNormal];
    [[UIBarButtonItem appearanceWhenContainedIn:[PKRevealController class], nil]
     setTitleTextAttributes:@{UITextAttributeTextColor:COLOR_TEXT,
                              UITextAttributeTextShadowColor:[UIColor whiteColor],
                              UITextAttributeTextShadowOffset:[NSValue valueWithUIOffset:UIOffsetMake(0.0f, 1.0f)]}
     forState:UIControlStateHighlighted];
    [[UIBarButtonItem appearanceWhenContainedIn:[PKRevealController class], nil]
     setTitleTextAttributes:@{UITextAttributeTextColor:COLOR_LIGHT_TEXT,
                              UITextAttributeTextShadowColor:[UIColor whiteColor],
                              UITextAttributeTextShadowOffset:[NSValue valueWithUIOffset:UIOffsetMake(0.0f, 1.0f)]}
     forState:UIControlStateDisabled];
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
