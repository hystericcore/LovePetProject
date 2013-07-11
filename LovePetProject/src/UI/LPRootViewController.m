//
//  LPRootViewController.m
//  LovePetProject
//
//  Created by HyunJoon Park on 13. 7. 6..
//  Copyright (c) 2013년 HyunJoon Park. All rights reserved.
//

#import "LPRootViewController.h"
#import "LPLeftListViewController.h"
#import "LPPetQuiltViewController.h"
#import "LPLoginViewController.h"

@implementation LPRootViewController

- (id)init
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        
    }
    return self;
}

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

- (void)actionListButton:(UIBarButtonItem *)button
{
    if (CGRectGetMinX(_navController.view.frame) == 0) {
        [self showLeftList:YES];
    } else {
        [self showLeftList:NO];
    }
}

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
    UIImage *i1 = [[UIImage imageNamed:@"back_button_background.png"]
                   resizableImageWithCapInsets:UIEdgeInsetsMake(0, 18, 0, 6)];
    UIImage *i2 = [[UIImage imageNamed:@"back_button_landscape_background.png"]
                   resizableImageWithCapInsets:UIEdgeInsetsMake(0, 18, 0, 6)];
    UIImage *i3 = [[UIImage imageNamed:@"back_button_selected_background.png"]
                   resizableImageWithCapInsets:UIEdgeInsetsMake(0, 18, 0, 6)];
    UIImage *i4 = [[UIImage imageNamed:@"back_button_landscape_selected_background.png"]
                   resizableImageWithCapInsets:UIEdgeInsetsMake(0, 18, 0, 6)];
    
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:i1
                                                      forState:UIControlStateNormal
                                                    barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setTintColor:RGB(64, 64, 64)];
    
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:i2
                                                      forState:UIControlStateNormal
                                                    barMetrics:UIBarMetricsLandscapePhone];
    
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:i3
                                                      forState:UIControlStateHighlighted
                                                    barMetrics:UIBarMetricsDefault];
    
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:i4
                                                      forState:UIControlStateHighlighted
                                                    barMetrics:UIBarMetricsLandscapePhone];
    [[UIBarButtonItem appearance]
     setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                             RGB(64, 64, 64), UITextAttributeTextColor,
                             RGB(250, 250, 250), UITextAttributeTextShadowColor,
                             [NSValue valueWithUIOffset:UIOffsetMake(0, -1)], UITextAttributeTextShadowOffset,
                             nil]
     forState:UIControlStateNormal];
    [[UIBarButtonItem appearance]
     setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                             RGB(240, 240, 240), UITextAttributeTextColor,
                             RGB(32, 32, 32), UITextAttributeTextShadowColor,
                             [NSValue valueWithUIOffset:UIOffsetMake(0, -1)], UITextAttributeTextShadowOffset,
                             nil]
     forState:UIControlStateSelected];
    [[UIBarButtonItem appearance]
     setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                             RGB(240, 240, 240), UITextAttributeTextColor,
                             RGB(32, 32, 32), UITextAttributeTextShadowColor,
                             [NSValue valueWithUIOffset:UIOffsetMake(0, -1)], UITextAttributeTextShadowOffset,
                             nil]
     forState:UIControlStateHighlighted];
    [[UIBarButtonItem appearance]
     setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                             RGB(176, 176, 176), UITextAttributeTextColor,
                             RGB(250, 250, 250), UITextAttributeTextShadowColor,
                             [NSValue valueWithUIOffset:UIOffsetMake(0, -1)], UITextAttributeTextShadowOffset,
                             nil]
     forState:UIControlStateDisabled];
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navbar_background.png"]
                                       forBarMetrics:UIBarMetricsDefault];
    
    self.navController = [[UINavigationController alloc] init];
    [_navController.view setFrame:self.view.bounds];
    [_navController.view.layer setMasksToBounds:NO];
    [_navController.view.layer setShadowRadius:5];
    [_navController.view.layer setShadowOpacity:0.5];
    
    [self.view addSubview:_navController.view];
}

- (void)createLeftListButton
{
    UIButton *listButton = [[UIButton alloc] init];
    [listButton setImage:[UIImage imageNamed:@"nav_button_list@2x"] forState:UIControlStateNormal];
    [listButton addTarget:self action:@selector(actionListButton:) forControlEvents:UIControlEventTouchUpInside];
    [listButton sizeToFit];
    
    self.leftListButton = [[[UIBarButtonItem alloc] initWithCustomView:listButton] autorelease];
    [listButton release];
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
