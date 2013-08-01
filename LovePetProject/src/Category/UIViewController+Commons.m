//
//  UIViewController+Commons.m
//  LovePetProject
//
//  Created by hyunjoon.park on 13. 8. 1..
//  Copyright (c) 2013년 HyunJoon Park. All rights reserved.
//

#import "UIViewController+Commons.h"
#import "PKRevealController.h"

@implementation UIViewController (Commons)

#pragma mark - Navigation Controller Methods

- (void)createNavTitleView
{
    UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navbar_lovepet.png"]];
    [self.navigationItem setTitleView:titleView];
}

#pragma mark LeftListButton Methods

- (void)createLeftViewButton
{
    UIButton *listButton = [[UIButton alloc] init];
    [listButton setImage:[UIImage imageNamed:@"nav_button_list.png"] forState:UIControlStateNormal];
    [listButton addTarget:self action:@selector(actionLeftViewButton:) forControlEvents:UIControlEventTouchUpInside];
    [listButton sizeToFit];
    
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:listButton]];
}

- (void)actionLeftViewButton:(id)sender
{
    UIViewController *showViewController;
    PKRevealController *revealController =self.navigationController.revealController;
    
    if (revealController.focusedController == revealController.leftViewController) {
        showViewController = revealController.frontViewController;
    } else {
        showViewController = revealController.leftViewController;
    }
    
    [self.navigationController.revealController showViewController:showViewController];
}

@end
