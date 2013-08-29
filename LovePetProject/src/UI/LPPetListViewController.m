//
//  LPPetListViewController.m
//  LovePetProject
//
//  Created by NTS Mobile on 13. 7. 27..
//  Copyright (c) 2013년 HyunJoon Park. All rights reserved.
//

#import "LPPetListViewController.h"
#import "LPPetDAO.h"
#import "LPLocalPetDAO.h"
#import "LPPetVO.h"
#import "LPPetListCell.h"
#import "LPPetDetailViewController.h"
#import "LPSearchViewController.h"

#import "UIBarButtonItem+Utils.h"
#import "UIViewController+Commons.h"
#import "UIViewController+KNSemiModal.h"
#import "ISRefreshControl.h"
#import "PSCollectionView.h"

@interface LPPetListViewController ()
@property (nonatomic, strong) UIImageView *emptyBackground;
@end

@implementation LPPetListViewController

- (id)initWithDAO:(id<LPPetDAO>)dao
{
    self = [super init];
    if (self) {
        self.petDAO = dao;
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadPetDataSource
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(petListReset:)
                                                 name:[_petDAO getNotiName:kLPPetDAONotiReset]
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(petListUpdateComplete:)
                                                 name:[_petDAO getNotiName:kLPPetDAONotiUpdateComplete]
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(petListUpdateFail:)
                                                 name:[_petDAO getNotiName:kLPPetDAONotiUpdateFail]
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(petListReturnZero:)
                                                 name:[_petDAO getNotiName:kLPPetDAONotiReturnZero]
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(petListRequestFail:)
                                                 name:[_petDAO getNotiName:kLPPetDAONotiRequestFail]
                                               object:nil];
    
    [_petDAO resetPetDataSource];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self createNavTitleView];
    [self createLeftViewButton];
    [self createPetSearchButton];
    
    [self createPetListView];
    [self createPullToRefresh];
    
    [self loadPetDataSource];
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
    
    if (_emptyBackground == nil) {
        UIImage *image = [UIImage imageNamed:@"default_background.png"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(0, 0, image.size.width / 2, image.size.height / 2);
        imageView.center = _petListView.center;
        imageView.userInteractionEnabled = NO;
        [self.view addSubview:imageView];
        
        self.emptyBackground = imageView;
    }
    
    _emptyBackground.alpha = (_petDataSource == nil || _petDataSource.count == 0) ? 1 : 0;
}

#pragma mark PetSearchButton Methods

- (void)createPetSearchButton
{
    if ([_petDAO respondsToSelector:@selector(getSearchOptionName:)]) {
        self.searchButton = [self createBarButtomItemToTarget:self action:@selector(actionSearchButton:) imageName:@"nav_button_search.png"];
        [self.navigationItem setRightBarButtonItem:_searchButton];
    }
}

- (void)actionSearchButton:(id)sender
{
    LPSearchViewController *viewController = [[LPSearchViewController alloc] initWithDAO:_petDAO];
    [viewController.view setBackgroundColor:[UIColor whiteColor]];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [navController.view setFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), kLPSearchViewHeight)];
    [navController setNavigationBarHidden:YES];
    [self presentSemiViewController:navController
                        withOptions:@{KNSemiModalOptionKeys.pushParentBack    : @(NO),
                                      KNSemiModalOptionKeys.animationDuration : @(0.3),
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
    CGRect frame = self.view.bounds;
    frame.size.height -= 44;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7"))
        frame.size.height -= 22;
    
    self.petListView = [[PSCollectionView alloc] initWithFrame:frame];
    _petListView.delegate = self;
    _petListView.collectionViewDataSource = self;
    _petListView.collectionViewDelegate = self;
    _petListView.backgroundColor = [UIColor whiteColor];
    _petListView.numColsPortrait = 2;
    [self.view addSubview:_petListView];
}

#pragma mark - Pull To Refresh Methods

- (void)createPullToRefresh
{
    if ([_petDAO conformsToProtocol:@protocol(LPLocalPetDAO)])
        return;
    
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
    if ([_petDAO respondsToSelector:@selector(requestNextPetList)] &&
        _petDataSource.count > 20 && _petDataSource.count - 15 < index)
        [_petDAO requestNextPetList];
    
    LPPetListCell *cell = (LPPetListCell *)[collectionView dequeueReusableViewForClass:[LPPetListCell class]];
    
    if (cell == nil)
        cell = [[LPPetListCell alloc] init];
    
    LPPetVO *vo = [_petDataSource objectAtIndex:index];
    [vo resetLeftDay];
    [cell.dayLabel setText:vo.leftDay];
    [cell.detailLabel setText:vo.centerName];
    
    NSNumber *cellIndex = [NSNumber numberWithInteger:index];
    
    if ([_petDAO conformsToProtocol:@protocol(LPLocalPetDAO)] || [_petShowed containsObject:cellIndex]) {
        [cell.photoView setImage:vo.thumbnail];
    } else {
        [_petShowed addObject:cellIndex];
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

@end
