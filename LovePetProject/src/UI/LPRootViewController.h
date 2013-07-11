//
//  LPRootViewController.h
//  LovePetProject
//
//  Created by HyunJoon Park on 13. 7. 6..
//  Copyright (c) 2013년 HyunJoon Park. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPLeftListViewController.h"

@interface LPRootViewController : UIViewController <LPLeftListViewControllerDelegate>
// Left list
@property (nonatomic, strong) LPLeftListViewController *leftListViewController;

// Main navigation controller
@property (nonatomic, strong) UINavigationController *navController;
@property (nonatomic, strong) UIBarButtonItem *leftListButton;
@end
