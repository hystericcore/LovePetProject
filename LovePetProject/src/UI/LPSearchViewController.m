//
//  LPSearchViewController.m
//  LovePetProject
//
//  Created by hyunjoon.park on 13. 7. 16..
//  Copyright (c) 2013년 HyunJoon Park. All rights reserved.
//

#import "LPSearchViewController.h"
#import "LPSearchOptionViewController.h"

#import "LPPetDAO.h"

NSString * const kLPNotificationSearchViewDismiss = @"searchView.dismiss";
NSInteger const kLPSearchViewCellHeight = 72;
NSInteger const kLPSearchViewHeight = 72 * 4;

@implementation LPSearchViewController

- (id)initWithPetDAO:(LPPetDAO *)petDAO
{
    self = [super init];
    if (self) {
        self.petDAO = petDAO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initializeDataSource];
    [self createSearchField];
    [self createTableView];
    [self createSearchButton];
}

- (void)initializeDataSource
{
    self.dataSource = @[@"동물종류", @"보호중인 위치"];
    /*
     self.dataSource = @[@"전체", @"서울특별시", @"부산광역시", @"대구광역시", @"인천광역시", @"세종특별자치시", @"대전광역시", @"울산광역시", @"경기도", @"강원도", @"충청북도", @"충청남도", @"전라북도", @"전라남도", @"경상북도", @"경상남도", @"제주특별자치도"];
     break;
     
     case LPSearchTypePetType:
     self.dataSource = @[@"전체", @"강아지", @"고양이", @"기타"];
     */
}

#pragma mark - SearchField

- (void)createSearchField
{
    self.searchField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), kLPSearchViewCellHeight)];
    [_searchField setBackgroundColor:RGB(241, 242, 242)];
    [_searchField setPlaceholder:@"공고번호"];
    [_searchField setFont:[UIFont systemFontOfSize:22]];
    [_searchField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [_searchField addTarget:self action:@selector(touchSearchField:) forControlEvents:UIControlEventEditingDidBegin];
    [_searchField addTarget:self action:@selector(dismissKeyboard) forControlEvents:UIControlEventEditingDidEndOnExit];
    [_searchField setReturnKeyType:UIReturnKeyDone];
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
    [_tableView setBackgroundColor:RGB(241, 242, 242)];
    [_tableView setContentInset:UIEdgeInsetsMake(1.0, 0.0, 0.0, 0.0)];
    [self.view addSubview:_tableView];
}

#pragma mark - SearchButton

- (void)createSearchButton
{
    self.searchButton = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_tableView.frame), CGRectGetWidth(self.view.frame), kLPSearchViewCellHeight)];
    [_searchButton addTarget:self action:@selector(actionSearchButton:) forControlEvents:UIControlEventTouchUpInside];
    [_searchButton setBackgroundColor:RGB(77, 98, 153)];
    [_searchButton setTitle:@"검색" forState:UIControlStateNormal];
    [_searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_searchButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    [_searchButton.titleLabel setFont:[UIFont systemFontOfSize:22]];
    [self.view addSubview:_searchButton];
}

- (void)actionSearchButton:(UIButton *)button
{
    [self postSearchViewDismiss];
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
        [cell.textLabel setTextColor:[UIColor darkGrayColor]];
    }
    
    [cell.textLabel setText:[_dataSource objectAtIndex:indexPath.row]];
    
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
    if (indexPath.row == 0) {
        viewController.dataSource = @[@"전체", @"강아지", @"고양이"];
        viewController.searchOption = kLPSearchOptionPetType;
    } else {
        viewController.dataSource = @[@"전체", @"서울특별시", @"부산광역시", @"대구광역시", @"인천광역시", @"세종특별자치시", @"대전광역시", @"울산광역시", @"경기도", @"강원도", @"충청북도", @"충청남도", @"전라북도", @"전라남도", @"경상북도", @"경상남도", @"제주특별자치도"];
        viewController.searchOption = kLPSearchOptionLocation;
    }
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
