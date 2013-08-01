//
//  LPLeftListViewController.m
//  LovePetProject
//
//  Created by HyunJoon Park on 13. 7. 6..
//  Copyright (c) 2013년 HyunJoon Park. All rights reserved.
//

#import "LPLeftViewController.h"
#import "PKRevealController.h"

#import "LPPetListViewController.h"
#import "LPLoginViewController.h"

typedef enum {
    kLPListViewController = 0,
    kLPClipViewController,
    kLPLoginViewController,
} kLPViewControllerType;

@implementation LPLeftViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.revealController setMinimumWidth:250.0f maximumWidth:324.0f forViewController:self];
    
    [self.tableView setBackgroundColor:RGB(88, 89, 91)];
    [self.tableView setSeparatorColor:RGB(128, 128, 128)];
    [self.tableView setScrollsToTop:NO];
    
    self.controllerNames = @[@"유기동물 리스트", @"관심동물 리스트", @"설정"];
    self.controllerList = [[NSMutableDictionary alloc] initWithCapacity:0];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _controllerNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    [cell.textLabel setText:[_controllerNames objectAtIndex:indexPath.row]];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark - UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UINavigationController *frontViewController = (UINavigationController *)self.revealController.frontViewController;
    
    NSInteger oldIndex = [NSIndexPath indexPathForRow:_selectedIndex inSection:0].row;
    NSInteger index = indexPath.row;
    
    if (oldIndex == index) {
        [self.revealController showViewController:frontViewController];
        return indexPath;
    }
    
    self.selectedIndex = index;
    
    NSString *oldControllerKey = [_controllerNames objectAtIndex:oldIndex];
    UIViewController *oldController = [frontViewController.viewControllers objectAtIndex:0];
    [_controllerList setObject:oldController forKey:oldControllerKey];

    NSString *controllerKey = [_controllerNames objectAtIndex:index];
    UIViewController *rootViewController = [_controllerList objectForKey:controllerKey];
    
    if (rootViewController == nil) {
        switch (index) {
            case kLPListViewController:
                rootViewController = [[LPPetListViewController alloc] init];
                break;
                
            case kLPClipViewController:
                rootViewController = [[LPLoginViewController alloc] init];
                break;
                
            case kLPLoginViewController:
                rootViewController = [[LPLoginViewController alloc] init];
                break;
        }
    }
    
    [self.revealController enterPresentationModeAnimated:YES
                                              completion:^(BOOL finished) {
                                                  [frontViewController setViewControllers:@[rootViewController]];
                                                  [frontViewController popToRootViewControllerAnimated:NO];
                                                  [self.revealController showViewController:frontViewController];
                                              }];
    return indexPath;
}

/*
 - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 
 }
 */

@end
