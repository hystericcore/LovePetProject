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

#import "LPPetDAOFactory.h"

#import "UIView+Utils.h"

typedef enum {
    kLPListViewController = 0,
    kLPClipViewController,
} kLPViewControllerType;

NSInteger const kLPLeftViewCellHeight = 46;

@implementation LPLeftViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.revealController setMinimumWidth:250.0f maximumWidth:324.0f forViewController:self];
    
    [self.tableView setBackgroundColor:[UIColor colorWithWhite:0.2f alpha:1.0f]];
    [self.tableView setSeparatorColor:RGB(128, 128, 128)];
    [self.tableView setScrollsToTop:NO];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 44)];
    [headerView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setTableHeaderView:headerView];
    
    self.controllerNames = @[@"보호중인 동물", @"나의 관심목록"];
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
        
        CGFloat cellHeight = kLPLeftViewCellHeight - 1;
        CGFloat cellWidth = CGRectGetWidth(tableView.bounds);
        [cell setBackgroundColor:[UIColor colorWithWhite:0.2f alpha:1.0f]];
        [cell drawLineFrom:CGPointMake(0, cellHeight - 1) to:CGPointMake(cellWidth, cellHeight - 1) lineWidth:1 color:[UIColor colorWithWhite:0.1f alpha:1.0f] dotted:NO];
        [cell drawLineFrom:CGPointMake(0, cellHeight) to:CGPointMake(cellWidth, cellHeight) lineWidth:1 color:[UIColor colorWithWhite:0.3f alpha:1.0f] dotted:NO];
        
        CGRect textLabelFrame = cell.textLabel.frame;
        textLabelFrame.origin.x += 20;
        [cell.textLabel setFrame:textLabelFrame];
        [cell.textLabel setTextColor:COLOR_GRAYWHITE];
    }
    
    [cell.textLabel setText:[_controllerNames objectAtIndex:indexPath.row]];
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
                rootViewController = [[LPPetListViewController alloc] initWithDAO:[LPPetDAOFactory petDAO:kLPPetDAOTypeLost]];
                break;
                
            case kLPClipViewController:
                rootViewController = [[LPPetListViewController alloc] initWithDAO:[LPPetDAOFactory petDAO:kLPPetDAOTypeClip]];
                break;
        }
    }
    
    [self.revealController enterPresentationModeAnimated:YES
                                              completion:^(BOOL finished) {
                                                  [frontViewController setNavigationBarHidden:NO];
                                                  [frontViewController setViewControllers:@[rootViewController]];
                                                  [frontViewController popToRootViewControllerAnimated:NO];
                                                  [self.revealController showViewController:frontViewController];
                                              }];
    return indexPath;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kLPLeftViewCellHeight;
}

@end
