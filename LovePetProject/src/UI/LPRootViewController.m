//
//  LPRootViewController.m
//  LovePetProject
//
//  Created by HyunJoon Park on 13. 7. 6..
//  Copyright (c) 2013년 HyunJoon Park. All rights reserved.
//

#import "LPRootViewController.h"
#import "LPPetQuiltViewController.h"
#import "LPLoginViewController.h"

@implementation LPRootViewController

- (void)dealloc
{
    self.leftListViewController = nil;
    self.navController = nil;
    self.leftListButton = nil;
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createLeftListView];
    [self createMainNavController];
    [self createLeftListButton];
    
    [self changeNavRootViewController:[self createPetListController]];
}

#pragma mark - Create Subviews

- (void)createLeftListView
{
    // Left List View create
    self.leftListViewController = [[LPLeftListViewController alloc] init];
    [_leftListViewController.view setFrame:CGRectInset(self.view.bounds, 5, 10)];
    _leftListViewController.delegate = self;
    [self.view addSubview:_leftListViewController.view];
}

- (void)createMainNavController
{
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navbar_background.png"]
                                       forBarMetrics:UIBarMetricsDefault];
    
    self.navController = [[[UINavigationController alloc] init] autorelease];
    [_navController.view setFrame:self.view.bounds];
    [_navController.view.layer setMasksToBounds:NO];
    [_navController.view.layer setShadowRadius:5];
    [_navController.view.layer setShadowOpacity:0.5];
    
    [self.view addSubview:_navController.view];
}

- (void)createLeftListButton
{
    UIButton *listButton = [[UIButton alloc] init];
    [listButton setImage:[UIImage imageNamed:@"nav_button_list.png"] forState:UIControlStateNormal];
    [listButton addTarget:self action:@selector(actionListButton:) forControlEvents:UIControlEventTouchUpInside];
    [listButton sizeToFit];
    
    self.leftListButton = [[[UIBarButtonItem alloc] initWithCustomView:listButton] autorelease];
    [listButton release];
}

- (void)actionListButton:(UIBarButtonItem *)button
{
    if (CGRectGetMinX(_navController.view.frame) == 0) {
        [self showLeftList:YES];
    } else {
        [self showLeftList:NO];
    }
}

- (UIViewController *)createPetListController
{
    // Pet List Controller create
    LPPetQuiltViewController *petListController = [[LPPetQuiltViewController alloc] init];
    [petListController.navigationItem setLeftBarButtonItem:_leftListButton];
    
    UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navbar_lovepet.png"]];
    [petListController.navigationItem setTitleView:titleView];
    [titleView release];
    
    return petListController;
}

- (UIViewController *)createLoginViewController
{
    LPLoginViewController *loginViewController = [[LPLoginViewController alloc] init];
    [loginViewController.navigationItem setLeftBarButtonItem:_leftListButton];
    
    UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navbar_lovepet.png"]];
    [loginViewController.navigationItem setTitleView:titleView];
    [titleView release];
    
    return loginViewController;
}

- (void)changeNavRootViewController:(UIViewController *)viewController
{
    [_navController setViewControllers:@[viewController]];
}

- (void)showLeftList:(BOOL)show
{
    UIViewController *viewController = [_navController.viewControllers objectAtIndex:0];
    [viewController.view setUserInteractionEnabled:!show];
    
    CGRect navControllerFrame = _navController.view.frame;
    
    if (show) {
        navControllerFrame.origin = CGPointMake(250, 0);
    } else {
        navControllerFrame.origin = CGPointZero;
    }
    
    [UIView animateWithDuration:0.3f animations:^{
        if (show) {
            [_leftListViewController.view setFrame:self.view.bounds];
        } else {
            [_leftListViewController.view setFrame:CGRectInset(self.view.bounds, 5, 10)];
        }
        
        [_navController.view setFrame:navControllerFrame];
    }];
}

#pragma mark - LPLeftListViewControllerDelegate

- (void)leftListViewController:(LPLeftListViewController *)viewController didSelectListAtIndex:(NSInteger)index
{
    UIViewController *rootViewController;
    
    switch (index) {
        case 0:
            rootViewController = [self createPetListController];
            break;
            
        case 2:
            rootViewController = [self createLoginViewController];
            break;
    }
    
    if (rootViewController == nil) {
        return;
    }
    
    [self changeNavRootViewController:rootViewController];
    [self showLeftList:NO];
}

@end
