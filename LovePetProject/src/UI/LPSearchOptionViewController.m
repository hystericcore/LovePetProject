//
//  LPPetTypeViewController.m
//  LovePetProject
//
//  Created by hyunjoon.park on 13. 7. 24..
//  Copyright (c) 2013년 HyunJoon Park. All rights reserved.
//

#import "LPSearchOptionViewController.h"

NSString * const kLPSearchOptionPetType = @"searchOptionView.optionPetType";
NSString * const kLPSearchOptionLocation = @"searchOptionView.optionLocation";
NSInteger const kLPPetTypeCellHeight = 72;

@implementation LPSearchOptionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self createTableView];
    [self createBackButton];
    [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

#pragma mark - TableView

- (void)createTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), kLPPetTypeCellHeight * 3) style:UITableViewStylePlain];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [_tableView setBackgroundColor:RGB(241, 242, 242)];
    [_tableView setContentInset:UIEdgeInsetsMake(1.0, 0.0, 0.0, 0.0)];
    [self.view addSubview:_tableView];
}

- (void)createBackButton
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_tableView.frame), CGRectGetWidth(self.view.frame), kLPPetTypeCellHeight)];
    [button addTarget:self action:@selector(actionBackButton:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundColor:RGB(156, 158, 152)];
    [button setTitle:@"뒤로" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    [button.titleLabel setFont:[UIFont systemFontOfSize:22]];
    [self.view addSubview:button];
}

- (void)actionBackButton:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.textLabel setFont:[UIFont systemFontOfSize:22]];
        [cell.textLabel setTextColor:[UIColor darkGrayColor]];
    }
    
    NSIndexPath *selectedIndex = [tableView indexPathForSelectedRow];
    
    if (selectedIndex.row == indexPath.row) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    [cell.textLabel setText:[_dataSource objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kLPPetTypeCellHeight;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *oldIndex = [tableView indexPathForSelectedRow];
    [[tableView cellForRowAtIndexPath:oldIndex] setAccessoryType:UITableViewCellAccessoryNone];
    [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
    return indexPath;
}

@end
