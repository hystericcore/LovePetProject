//
//  LPSearchViewController.m
//  LovePetProject
//
//  Created by hyunjoon.park on 13. 7. 16..
//  Copyright (c) 2013년 HyunJoon Park. All rights reserved.
//

#import "LPSearchViewController.h"

#import "LPPetDAO.h"

NSString * const kLPNotificationSearchViewDismiss = @"searchView.dismiss";
NSInteger const kLPSearchViewCellHeight = 72;
NSInteger const kLPSearchViewHeight = 72 * 4;

@implementation LPSearchViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.petDAO = [LPPetDAO sharedInstance];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initializeDataSource];
    [self loadSearchOptions];
    [self createSearchField];
    [self createTableView];
    [self createSearchButton];
}

- (void)initializeDataSource
{
    self.dataSource = @[@"동물종류", @"보호중인 위치"];
}

- (void)loadSearchOptions
{
    self.searchKeyword = [[NSUserDefaults standardUserDefaults] stringForKey:kLPSearchOptionKeyword];
    self.searchPetType = [[NSUserDefaults standardUserDefaults] stringForKey:kLPSearchOptionPetType];
    self.searchLocation = [[NSUserDefaults standardUserDefaults] stringForKey:kLPSearchOptionLocation];
}

#pragma mark - SearchField

- (void)createSearchField
{
    self.searchField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), kLPSearchViewCellHeight)];
    [_searchField setBackgroundColor:COLOR_GRAYWHITE];
    [_searchField setPlaceholder:@"키워드 검색"];
    [_searchField setFont:[UIFont systemFontOfSize:22]];
    [_searchField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [_searchField addTarget:self action:@selector(touchSearchField:) forControlEvents:UIControlEventEditingDidBegin];
    [_searchField addTarget:self action:@selector(dismissKeyboard) forControlEvents:UIControlEventEditingDidEndOnExit];
    [_searchField setReturnKeyType:UIReturnKeyDone];
    [_searchField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_searchField setText:_searchKeyword];
    
    UIView* leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    [_searchField setLeftViewMode:UITextFieldViewModeAlways];
    [_searchField setLeftView:leftView];
    [self.view addSubview:_searchField];
}

- (void)touchSearchField:(UITextField *)textField
{
    if (self.dismissKeyboardButton == nil) {
        self.dismissKeyboardButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_dismissKeyboardButton addTarget:self action:@selector(dismissKeyboard) forControlEvents:UIControlEventTouchUpInside];
        _dismissKeyboardButton.backgroundColor = [UIColor clearColor];
        _dismissKeyboardButton.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.window.frame) -CGRectGetHeight(self.view.frame));
    }
    [self.view.window addSubview:_dismissKeyboardButton];
}

- (void)dismissKeyboard
{
    [_searchField resignFirstResponder];
    [_dismissKeyboardButton removeFromSuperview];
}

#pragma mark - TableView

- (void)createTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_searchField.frame), CGRectGetWidth(self.view.frame), kLPSearchViewCellHeight * 2) style:UITableViewStylePlain];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [_tableView setScrollEnabled:NO];
    [_tableView setBackgroundColor:COLOR_GRAYWHITE];
    [_tableView setContentInset:UIEdgeInsetsMake(1.0, 0.0, 0.0, 0.0)];
    [self.view addSubview:_tableView];
}

#pragma mark - SearchButton

- (void)createSearchButton
{
    self.searchButton = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_tableView.frame), CGRectGetWidth(self.view.frame), kLPSearchViewCellHeight)];
    [_searchButton addTarget:self action:@selector(actionSearchButton:) forControlEvents:UIControlEventTouchUpInside];
    [_searchButton setBackgroundColor:COLOR_DEEP_BLUE];
    [_searchButton setTitle:@"검색" forState:UIControlStateNormal];
    [_searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_searchButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    [_searchButton.titleLabel setFont:[UIFont systemFontOfSize:22]];
    [self.view addSubview:_searchButton];
}

- (void)actionSearchButton:(id)sender
{
    [self postSearchViewDismiss];
    [self resetPetDataSource];
}

- (void)resetPetDataSource
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if (_searchField.text == nil)
        [userDefaults removeObjectForKey:kLPSearchOptionKeyword];
    else
        [userDefaults setObject:_searchField.text forKey:kLPSearchOptionKeyword];
    
    if (_searchPetType == nil)
        [userDefaults removeObjectForKey:kLPSearchOptionPetType];
    else
        [userDefaults setObject:_searchPetType forKey:kLPSearchOptionPetType];
    
    if (_searchLocation == nil)
        [userDefaults removeObjectForKey:kLPSearchOptionLocation];
    else
        [userDefaults setObject:_searchLocation forKey:kLPSearchOptionLocation];
    
    [userDefaults synchronize];
    
    [_petDAO resetRemotePetDataSource];
}

- (void)postSearchViewDismiss
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kLPNotificationSearchViewDismiss object:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [cell.textLabel setFont:[UIFont systemFontOfSize:22]];
        [cell.textLabel setTextColor:COLOR_TEXT];
        [cell.detailTextLabel setTextColor:COLOR_LIGHT_TEXT];
    }
    
    NSString *titleText = [_dataSource objectAtIndex:indexPath.row];
    NSString *detailText;
    
    if (indexPath.row == 1)
        detailText = _searchLocation;
    else
        detailText = _searchPetType;
    
    [cell.textLabel setText:titleText];
    [cell.detailTextLabel setText:detailText];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kLPSearchViewCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LPSearchOptionViewController *viewController = [[LPSearchOptionViewController alloc] init];
    viewController.delegate = self;
    if (indexPath.row == 0) {
        viewController.dataSource = [_petDAO getSearchOptionValues:kLPSearchOptionPetType];
        viewController.searchOption = kLPSearchOptionPetType;
        if (_searchPetType)
            viewController.selectedIndex = [viewController.dataSource indexOfObject:_searchPetType];
    } else {
        viewController.dataSource = [_petDAO getSearchOptionValues:kLPSearchOptionLocation];
        viewController.searchOption = kLPSearchOptionLocation;
        if (_searchLocation)
            viewController.selectedIndex = [viewController.dataSource indexOfObject:_searchLocation];
    }
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - LPSearchOptionViewControllerDelegate

- (void)searchOptionViewController:(LPSearchOptionViewController *)controller didSelectOption:(NSInteger)index
{
    NSString *value = [controller.dataSource objectAtIndex:index];
    if (index == 0)
        value = nil;
    
    if ([controller.searchOption isEqualToString:kLPSearchOptionPetType]) {
        self.searchPetType = value;
    } else if ([controller.searchOption isEqualToString:kLPSearchOptionLocation]) {
        self.searchLocation = value;
    }
    
    [_tableView reloadData];
}

@end
