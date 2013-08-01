//
//  LPPetListViewController.m
//  LovePetProject
//
//  Created by NTS Mobile on 13. 7. 27..
//  Copyright (c) 2013년 HyunJoon Park. All rights reserved.
//

#import "LPPetListViewController.h"
#import "UIViewController+Commons.h"
#import "UIViewController+KNSemiModal.h"

#import "ISRefreshControl.h"
#import "PSCollectionView.h"

#import "LPPetVO.h"
#import "LPPetDAO.h"
#import "LPPetListCell.h"
#import "LPPetDetailViewController.h"

#import "LPSearchViewController.h"

@implementation LPPetListViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.petDAO = [LPPetDAO sharedInstance];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(petListReset:) name:kLPNotificationPetListReset object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(petListUpdateComplete:) name:kLPNotificationPetListUpdateComplete object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(petListReturnZero:) name:kLPNotificationPetListReturnZero object:nil];
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
    
    [self.view setBackgroundColor:COLOR_GRAYWHITE];
    
    [self createNavTitleView];
    [self createLeftViewButton];
    [self createPetSearchButton];
    
    [self createPetListView];
    [self createPullToRefresh];
    
    [_petDAO resetPetDataSource];
}

#pragma mark - Pet DAO Notification

- (void)petListReset:(NSNotificationCenter *)notification
{
    self.petShowed = [NSMutableArray arrayWithCapacity:0];
    [self showIndicator];
}

- (void)petListUpdateComplete:(NSNotification *)notification
{
    self.petDataSource = [_petDAO getPetDataSource];
    [self hideIndicator];
}

- (void)petListReturnZero:(NSNotification *)notification
{
    self.petDataSource = [_petDAO getPetDataSource];
    [self hideIndicator];
    
    if (_petDataSource.count == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"검색 결과가 없습니다." delegate:self cancelButtonTitle:@"닫기" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)petListUpdateFail:(NSNotification *)notification
{
    [self hideIndicator];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"데이터를 가져오는데 실패했습니다! 네트워크를 확인해 주세요." delegate:self cancelButtonTitle:@"닫기" otherButtonTitles:nil];
    [alert show];
}

- (void)petListRequestFail:(NSNotification *)notification
{
    [self hideIndicator];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"데이터를 가져오는데 실패했습니다! 네트워크를 확인해 주세요." delegate:self cancelButtonTitle:@"닫기" otherButtonTitles:nil];
    [alert show];
}

#pragma mark - Acitivity Indicator Methods

- (void)showIndicator
{
    _petListView.alpha = 0.5f;
    [_petListView setContentOffset:CGPointMake(0, 0)];
    
    if ([_refreshControl isRefreshing] != YES) {
        if (_indicator == nil) {
            self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            _indicator.center = _petListView.center;
            _indicator.hidesWhenStopped = YES;
            [self.view addSubview:_indicator];
        }
        
        _petListView.userInteractionEnabled = NO;
        [_indicator startAnimating];
    }
}

- (void)hideIndicator
{
    [_refreshControl endRefreshing];
    [_petListView reloadData];
    
    [_indicator stopAnimating];
    self.indicator = nil;
    
    _petListView.alpha = 1.0f;
    _petListView.userInteractionEnabled = YES;
}

#pragma mark PetSearchButton Methods

- (void)createPetSearchButton
{
    UIButton *listButton = [[UIButton alloc] init];
    [listButton setImage:[UIImage imageNamed:@"nav_button_search.png"] forState:UIControlStateNormal];
    [listButton addTarget:self action:@selector(actionSearchButton:) forControlEvents:UIControlEventTouchUpInside];
    [listButton sizeToFit];
    self.searchButton = [[UIBarButtonItem alloc] initWithCustomView:listButton];
    [self.navigationItem setRightBarButtonItem:_searchButton];
}

- (void)actionSearchButton:(id)sender
{
    LPSearchViewController *viewController = [[LPSearchViewController alloc] init];
    [viewController.view setBackgroundColor:[UIColor whiteColor]];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [navController.view setFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), kLPSearchViewHeight)];
    [navController setNavigationBarHidden:YES];
    [self presentSemiViewController:navController
                        withOptions:@{KNSemiModalOptionKeys.pushParentBack    : @(NO),
                                      KNSemiModalOptionKeys.animationDuration : @(0.5),
                                      KNSemiModalOptionKeys.shadowOpacity     : @(0.3),
                                      }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissSearchView:) name:kLPNotificationSearchViewDismiss object:nil];
}

- (void)dismissSearchView:(NSNotification *)notification
{
    [self dismissSemiModalView];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLPNotificationSearchViewDismiss object:nil];
}

#pragma mark - Pet List View Methods

- (void)createPetListView
{
    self.petListView = [[PSCollectionView alloc] initWithFrame:self.view.bounds];
    _petListView.delegate = self;
    _petListView.collectionViewDataSource = self;
    _petListView.collectionViewDelegate = self;
    _petListView.backgroundColor = COLOR_GRAYWHITE;
    _petListView.autoresizingMask = ~UIViewAutoresizingNone;
    _petListView.numColsPortrait = 2;
    [self.view addSubview:_petListView];
}

#pragma mark - Pull To Refresh Methods

- (void)createPullToRefresh
{
    self.refreshControl = [[ISRefreshControl alloc] init];
    [_petListView addSubview:_refreshControl];
    [_refreshControl addTarget:self action:@selector(pullToRefresh:) forControlEvents:UIControlEventValueChanged];
}

- (void)pullToRefresh:(ISRefreshControl *)refreshControl
{
    [_petDAO resetPetDataSource];
}

#pragma mark - PSCollectionViewDataSource

- (NSInteger)numberOfRowsInCollectionView:(PSCollectionView *)collectionView
{
    return _petDataSource.count;
}

- (PSCollectionViewCell *)collectionView:(PSCollectionView *)collectionView cellForRowAtIndex:(NSInteger)index
{
    if (_petDataSource.count > 20 && _petDataSource.count - 15 < index)
        [_petDAO requestNextPetList];
    
    LPPetListCell *cell = (LPPetListCell *)[collectionView dequeueReusableViewForClass:[LPPetListCell class]];
    
    if (cell == nil)
        cell = [[LPPetListCell alloc] init];
    
    LPPetVO *vo = [_petDataSource objectAtIndex:index];
    [vo resetLeftDay];
    [cell.dayLabel setText:vo.leftDay];
    [cell.detailLabel setText:vo.centerName];
    
    if ([_petShowed containsObject:vo]) {
        [cell.photoView setImage:vo.thumbnail];
    } else {
        [_petShowed addObject:vo];
        [cell resetPhotoView:vo.thumbnail];
    }
    
    [cell.petTypeLabel setText:[vo getRemakePetType]];
    
    return cell;
}

- (CGFloat)collectionView:(PSCollectionView *)collectionView heightForRowAtIndex:(NSInteger)index
{
    LPPetVO *vo = [_petDataSource objectAtIndex:index];
    CGFloat ratio = vo.thumbnail.size.width / vo.thumbnail.size.height;
    return [collectionView colWidth] / ratio + kLPPetListCellTextPlaceHeight;
}

#pragma mark - PSCollectionViewDelegate

- (void)collectionView:(PSCollectionView *)collectionView didSelectCell:(PSCollectionViewCell *)cell atIndex:(NSInteger)index
{
    LPPetVO *petVO = [_petDataSource objectAtIndex:index];
    LPPetDetailViewController *viewController = [[LPPetDetailViewController alloc] initWithPetVO:petVO];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (Class)collectionView:(PSCollectionView *)collectionView cellClassForRowAtIndex:(NSInteger)index
{
    return [LPPetListCell class];
}

#pragma mark - ScrollViewDelegate

// called when scroll view grinds to a halt
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int bottomEdge = floorf(scrollView.contentOffset.y + scrollView.frame.size.height);
    int contentHeight = floorf(scrollView.contentSize.height) - 30;
    if (bottomEdge >= contentHeight)
        [_petDAO requestNextPetList];
}

@end
