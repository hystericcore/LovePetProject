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
    [self.navigationItem setLeftBarButtonItem:[self createBarButtomItemToTarget:self
                                                                         action:@selector(actionLeftViewButton:)
                                                                      imageName:@"nav_button_list.png"]];
}

- (void)createBackButton
{
    [self.navigationItem setLeftBarButtonItem:[self createBarButtomItemToTarget:self
                                                                         action:@selector(actionBackButton:)
                                                                      imageName:@"nav_button_back.png"]];
}

- (UIBarButtonItem *)createBarButtomItemToTarget:(id)target action:(SEL)selector imageName:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    UIButton *button = [[UIButton alloc] init];
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, image.size.width * 0.8, image.size.height * 0.8)];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

#pragma mark - Action methods

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

- (void)actionBackButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
