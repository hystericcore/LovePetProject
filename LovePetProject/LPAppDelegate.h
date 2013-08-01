//
//  LPAppDelegate.h
//  LovePetProject
//
//  Created by HyunJoon Park on 13. 7. 6..
//  Copyright (c) 2013년 HyunJoon Park. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PKRevealController;

@interface LPAppDelegate : UIResponder <UIApplicationDelegate>
@property (nonatomic, strong, readwrite) PKRevealController *revealController;
@property (nonatomic, strong) UIWindow *window;
@end
