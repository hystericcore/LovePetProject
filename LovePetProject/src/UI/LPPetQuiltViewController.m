//
//  LPPetListViewController.m
//  LovePetProject
//
//  Created by HyunJoon Park on 13. 7. 6..
//  Copyright (c) 2013년 HyunJoon Park. All rights reserved.
//

#import "LPPetQuiltViewController.h"
#import "UIViewController+KNSemiModal.h"

#import "ISRefreshControl.h"
#import "TMQuiltView.h"

#import "LPPetVO.h"
#import "LPPetDAO.h"
#import "LPPetQuiltViewCell.h"
#import "LPPetDetailViewController.h"

@implementation LPPetQuiltViewController

- (id)initWithPetDAO:(LPPetDAO *)petDAO
{
    self = [super init];
    if (self) {
        self.petDAO = petDAO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(petListUpdateComplete:) name:kLPNotificationPetListUpdateComplete object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(petListUpdateFail:) name:kLPNotificationPetListUpdateFail object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(petListRequestFail:) name:kLPNotificationPetListRequestFail object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self createPetSearchButton];
    [self createPullToRefresh];
    
    [_petDAO resetPetDataSourceWithPetKind:nil location:nil];
}

#pragma mark - Pet DAO Notification

- (void)petListUpdateComplete:(NSNotification *)notification
{
    [self.quiltView beginUpdates];
    self.petDataSource = [_petDAO getPetDataSource];
    [self.quiltView endUpdates];
    [_refreshControl endRefreshing];
}

- (void)petListUpdateFail:(NSNotification *)notification
{
    [self.quiltView beginUpdates];
    self.petDataSource = [_petDAO getPetDataSource];
    [self.quiltView endUpdates];
    [_refreshControl endRefreshing];
}

- (void)petListRequestFail:(NSNotification *)notification
{
    [_refreshControl endRefreshing];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"데이터를 가져오는데 실패했습니다!" delegate:self cancelButtonTitle:@"닫기" otherButtonTitles:nil];
    [alert show];
}

#pragma mark - Pet Search Button Methods

- (void)createPetSearchButton
{
    UIButton *listButton = [[UIButton alloc] init];
    [listButton setImage:[UIImage imageNamed:@"nav_button_search.png"] forState:UIControlStateNormal];
    [listButton addTarget:self action:@selector(actionSearchButton:) forControlEvents:UIControlEventTouchUpInside];
    [listButton sizeToFit];
    self.searchButton = [[UIBarButtonItem alloc] initWithCustomView:listButton];
    [self.navigationItem setRightBarButtonItem:_searchButton];
}

- (void)actionSearchButton:(UIBarButtonItem *)button
{
    UIViewController *viewController = [[UIViewController alloc] init];
    [viewController.view setFrame:CGRectMake(0, 0, 320, CGRectGetHeight(self.view.bounds) / 4 * 3)];
    [viewController.view setBackgroundColor:[UIColor whiteColor]];
    [self presentSemiViewController:viewController
                        withOptions:@{KNSemiModalOptionKeys.pushParentBack    : @(YES),
                                      KNSemiModalOptionKeys.animationDuration : @(0.5),
                                      KNSemiModalOptionKeys.shadowOpacity     : @(0.3),
                                      }];
}

#pragma mark - Pull To Refresh Methods

- (void)createPullToRefresh
{
    self.refreshControl = [[ISRefreshControl alloc] init];
    [self.quiltView addSubview:_refreshControl];
    [_refreshControl addTarget:self action:@selector(pullToRefresh:) forControlEvents:UIControlEventValueChanged];
}

- (void)pullToRefresh:(ISRefreshControl *)refreshControl
{
    [self.quiltView beginUpdates];
    [_petDAO resetPetDataSourceWithPetKind:nil location:nil];
}

#pragma mark - QuiltViewControllerDataSource

- (NSInteger)quiltViewNumberOfCells:(TMQuiltView *)TMQuiltView
{
    return _petDataSource.count;
}

- (TMQuiltViewCell *)quiltView:(TMQuiltView *)quiltView cellAtIndexPath:(NSIndexPath *)indexPath
{
    if (_petDataSource.count == indexPath.row + 1) {
        [_petDAO requestNextPetList];
    }
    
    static NSString *petIdentifier = @"PetIdentifier";
    LPPetQuiltViewCell *cell = (LPPetQuiltViewCell *)[quiltView dequeueReusableCellWithReuseIdentifier:petIdentifier];
    
    if (cell == nil) {
        cell = [[LPPetQuiltViewCell alloc] initWithReuseIdentifier:petIdentifier];
    }
    
    LPPetVO *vo = [_petDataSource objectAtIndex:indexPath.row];
    cell.photoView.image = vo.thumbnail;
    cell.typeLabel.text = vo.type;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *nowDate = [[NSDate alloc] init];
    NSDate *dayDate = [dateFormat dateFromString:vo.date];
    
    NSInteger leftDay = 10 - [self daysBetweenDate:dayDate andDate:nowDate];
    
    vo.leftDay = [NSString stringWithFormat:@"day-%d", leftDay];
    
    cell.dayLabel.text = vo.leftDay;
    cell.detailLabel.text = vo.detail;
    
    return cell;
}

- (NSInteger)daysBetweenDate:(NSDate *)firstDate andDate:(NSDate *)secondDate
{
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [currentCalendar components: NSDayCalendarUnit fromDate: firstDate toDate: secondDate options: 0];
    NSInteger days = [components day];
    return days;
}

#pragma mark - TMQuiltViewDelegate

- (void)quiltView:(TMQuiltView *)quiltView didSelectCellAtIndexPath:(NSIndexPath *)indexPath
{
    LPPetDetailViewController *viewController = [[LPPetDetailViewController alloc] initWithPetDAO:_petDAO];
    [viewController loadPetDataAtIndex:indexPath.row];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (NSInteger)quiltViewNumberOfColumns:(TMQuiltView *)quiltView
{
    return 2;
}

- (CGFloat)quiltViewMargin:(TMQuiltView *)quilView marginType:(TMQuiltViewMarginType)marginType
{
    return 8;
}

- (CGFloat)quiltView:(TMQuiltView *)quiltView heightForCellAtIndexPath:(NSIndexPath *)indexPath
{
    LPPetVO *vo = [_petDataSource objectAtIndex:indexPath.row];
    CGFloat ratio = vo.thumbnail.size.width / vo.thumbnail.size.height;
    return [quiltView cellWidth] / ratio + kLPPetQuiltViewTextPlaceHeight;
}

@end
