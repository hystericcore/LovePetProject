//
//  LPPetDetailViewController.m
//  LovePetProject
//
//  Created by HyunJoon Park on 13. 7. 7..
//  Copyright (c) 2013년 HyunJoon Park. All rights reserved.
//

#import "LPPetDetailViewController.h"
#import "LPDetailViewDetailCell.h"
#import "LPDetailViewMapCell.h"
#import "LPClipPetDAO.h"
#import "LPPetVO.h"

#import "LPKeyDefines.h"
#import "UIBarButtonItem+Utils.h"
#import "UIView+Utils.h"
#import "UIViewController+Commons.h"
#import "UIImageViewModeScaleAspect.h"
#import "AFNetworking.h"
#import "DCKakaoActivity.h"
#import "DCLineActivity.h"

NSString * const kLPDaumLocalAPIaddr2coord = @"http://apis.daum.net/local/geo/addr2coord?apikey=%@&output=json&q=%@";

NSInteger const kLPDetailViewClipButtonHeight = 46;

static NSString *DetailCellIdentifer = @"DetailCell";
static NSString *MapCellIdentifer = @"MapCell";

@interface LPPetDetailViewController ()
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, strong) LPDetailViewMapCell *mapCell;
@property (nonatomic, strong) LPDetailViewDetailCell *detailCell;
@property (nonatomic, assign) CGPoint previousTableViewContentOffset;
@end

@implementation LPPetDetailViewController

- (id)initWithPetVO:(LPPetVO *)petVO
{
    self = [super init];
    if (self) {
        self.petVO = petVO;
        
        // create OperationQueue
        self.operationQueue = [[NSOperationQueue alloc] init];
        
        // set detail cell
        NSArray *texts = @[_petVO.sex, _petVO.year, _petVO.weight, _petVO.date, _petVO.foundLocation, _petVO.boardID, _petVO.centerName, _petVO.centerLocation, _petVO.centerTel];
        self.detailCell = [[LPDetailViewDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DetailCellIdentifer];
        [_detailCell setDetailContentLabelsText:texts];
        
        // set map cell
        self.mapCell = [[LPDetailViewMapCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MapCellIdentifer];
    }
    return self;
}

- (void)dealloc
{
    [_operationQueue cancelAllOperations];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:COLOR_GRAYWHITE];
    
    [self createTableView];
    [self createShareButton];
    [self createBackButton];
    [self createNavTitleView];
    
    [self loadPetImage];
    [self loadCenterLocation];
}

#pragma mark - Create Methods

- (void)createTableView
{
    CGRect tableViewFrame = self.view.bounds;
    tableViewFrame.size.height -= 44;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7"))
        tableViewFrame.size.height -= 22;
    
    self.tableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = COLOR_GRAYWHITE;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    // header view
    CGFloat headerViewSize = CGRectGetWidth(self.view.frame);
    CGFloat headerViewPadding = 15;
    CGFloat headerViewPetTypePoint = 26;
    CGFloat headerViewPetDetailPoint = 14;
    CGFloat headerViewLabelMargin = 2;

    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionPetImage:)];
    recognizer.delegate = self;
    
    self.headerView = [[UIImageViewModeScaleAspect alloc] initWithFrame:CGRectMake(0, 0, headerViewSize, headerViewSize)];
    [_headerView setClipsToBounds:YES];
    [_headerView setContentMode:UIViewContentModeScaleAspectFill];
    [_headerView setUserInteractionEnabled:NO];
    [_headerView addGestureRecognizer:recognizer];
    
    UILabel *petTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(headerViewPadding,
                                                                      headerViewSize -
                                                                      headerViewPadding -
                                                                      headerViewPetTypePoint -
                                                                      headerViewPetDetailPoint -
                                                                      headerViewLabelMargin,
                                                                      headerViewSize - headerViewPadding * 2,
                                                                      headerViewPetTypePoint)];
    [petTypeLabel setText:[_petVO getRemakePetType]];
    [petTypeLabel setTextColor:[UIColor whiteColor]];
    [petTypeLabel setFont:[UIFont boldSystemFontOfSize:headerViewPetTypePoint]];
    [petTypeLabel setBackgroundColor:[UIColor clearColor]];
    [petTypeLabel setUserInteractionEnabled:NO];
    [_headerView addSubview:petTypeLabel];
    
    UILabel *petDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(headerViewPadding,
                                                                        headerViewSize -
                                                                        headerViewPadding -
                                                                        headerViewPetDetailPoint,
                                                                        headerViewSize - headerViewPadding * 2,
                                                                        headerViewPetDetailPoint)];
    [petDetailLabel setText:[NSString stringWithFormat:@"%@, %@에서 보호중", _petVO.districtOffice, _petVO.centerName]];
    [petDetailLabel setTextColor:[UIColor whiteColor]];
    [petDetailLabel setFont:[UIFont italicSystemFontOfSize:headerViewPetDetailPoint]];
    [petDetailLabel setLineBreakMode:NSLineBreakByClipping];
    [petDetailLabel setBackgroundColor:[UIColor clearColor]];
    [petDetailLabel setUserInteractionEnabled:NO];
    [_headerView addSubview:petDetailLabel];
    
    [self.tableView addSubview:_headerView];
    
    UIView *fakeHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, headerViewSize, headerViewSize)];
    [fakeHeaderView setUserInteractionEnabled:NO];
    [_tableView setTableHeaderView:fakeHeaderView];
    
    // footer view
    CGFloat footerViewWidth = CGRectGetWidth(self.view.frame);
    CGFloat footerViewHeight = kLPDetailViewClipButtonHeight;
    
    UIButton *clipButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, footerViewWidth, footerViewHeight)];
    [clipButton addTarget:self action:@selector(actionClipButton:) forControlEvents:UIControlEventTouchUpInside];
    [clipButton setBackgroundColor:[UIColor clearColor]];
    [clipButton.titleLabel setClipsToBounds:NO];
    
    [clipButton drawLineFrom:CGPointMake(8, 0) to:CGPointMake(footerViewWidth - 8, 0) lineWidth:0.5f color:COLOR_SINGLE_LINE_ALPHA4 dotted:NO];
    
    [_tableView setTableFooterView:clipButton];
    
    [self resetClipButtonState];
}

- (void)createShareButton
{
    [self.navigationItem setRightBarButtonItem:[self createBarButtomItemToTarget:self
                                                                          action:@selector(actionShareButton:)
                                                                       imageName:@"nav_button_share.png"]];
}

- (void)actionShareButton:(id)sender
{
    if (_shortenLinkSrc != nil) {
        [self showActivityController:_shortenLinkSrc];
        return;
    }
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://tinyurl.com/api-create.php?url=%@", _petVO.linkSrc]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    void (^success)() = ^(AFHTTPRequestOperation *operation, id responseObject) {
        self.shortenLinkSrc = [operation.responseString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [self showActivityController:_shortenLinkSrc];
    };
    void (^failure)() = ^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showActivityController:_petVO.linkSrc];
    };
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:success failure:failure];
    [_operationQueue addOperation:operation];
}

- (void)showActivityController:(NSString *)urlString
{
    NSArray *activityItems = @[@"주인을 애타게 찾고 있는 아이들이 있어요!", [NSURL URLWithString:urlString], _petVO.image];
    
    DCKakaoActivity *kakao = [[DCKakaoActivity alloc] init];
    DCLineActivity *line = [[DCLineActivity alloc] init];
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems
                                                                                     applicationActivities:@[kakao, line]];
    activityController.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypePostToWeibo, UIActivityTypeSaveToCameraRoll];
    [self presentViewController:activityController animated:YES completion:nil];
}

#pragma mark - Action Methods

- (void)actionPetImage:(id)sender
{
    CGPoint currentContentOffset = _tableView.contentOffset;
    CGRect square = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetWidth(self.view.frame));
    CGRect full = self.view.bounds;
    CGFloat distanceY = CGRectGetHeight(full) - CGRectGetHeight(square);
    full.size.height += 44;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7"))
        full.size.height += 22;
    
    if (_headerView.contentMode == UIViewContentModeScaleAspectFit) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        CGRect tableFrame = _tableView.frame;
        tableFrame.size.height -= 44;
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7"))
            tableFrame.size.height -= 22;
        [_tableView setFrame:tableFrame];
        [_tableView setScrollEnabled:YES];
        
        [_headerView animateToScaleAspectFillToFrame:square WithDuration:0.5f afterDelay:0];
        
        [UIView animateWithDuration:0.4f animations:^{
            [_tableView setContentOffset:self.previousTableViewContentOffset];
            
            [UIView animateWithDuration:0.4f animations:^{
                for (UIView *view in _headerView.subviews) {
                    if (![view isKindOfClass:[UILabel class]])
                        continue;
                    CGRect viewFrame = view.frame;
                    viewFrame.origin.y -= distanceY;
                    [view setFrame:viewFrame];
                }
            }];
            
            [_headerView setBackgroundColor:[UIColor clearColor]];
        } completion:^(BOOL finished) {
            self.previousTableViewContentOffset = CGPointMake(0, 0);
        }];
    } else {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        CGRect tableFrame = _tableView.frame;
        tableFrame.size.height += 44;
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7"))
            tableFrame.size.height += 22;
        [_tableView setFrame:tableFrame];
        [_tableView setScrollEnabled:NO];
        
        [_headerView animateToScaleAspectFitToFrame:full WithDuration:0.5f afterDelay:0];
        
        [UIView animateWithDuration:0.4f animations:^{
            [_tableView setContentOffset:self.previousTableViewContentOffset];
            
            [UIView animateWithDuration:0.4f animations:^{
                for (UIView *view in _headerView.subviews) {
                    if (![view isKindOfClass:[UILabel class]])
                        continue;
                    CGRect viewFrame = view.frame;
                    viewFrame.origin.y += distanceY + 44;
                    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7"))
                        viewFrame.origin.y += 22;
                    [view setFrame:viewFrame];
                }
            }];
            
            [_headerView setBackgroundColor:[UIColor blackColor]];
        } completion:^(BOOL finished) {
            self.previousTableViewContentOffset = currentContentOffset;
        }];
    }
}

- (void)actionClipButton:(id)sender
{
    NSString *message;
    
    if ([[LPClipPetDAO sharedInstance] isLocalPetDataExist:_petVO]) {
        [[LPClipPetDAO sharedInstance] removeLocalPetData:_petVO];
        message = @"관심목록에서 삭제하였습니다";
    } else {
        [[LPClipPetDAO sharedInstance] setLocalPetData:_petVO];
        message = @"관심목록에 추가하였습니다.";
    }
    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:message delegate:self cancelButtonTitle:@"닫기" otherButtonTitles:nil];
//    [alert show];
    
    [self resetClipButtonState];
}

- (void)resetClipButtonState
{
    UIButton *clipButton = (UIButton *)_tableView.tableFooterView;
    
    if ([[LPClipPetDAO sharedInstance] isLocalPetDataExist:_petVO]) {
        [clipButton setTitle:@"관심목록에서 삭제하기" forState:UIControlStateNormal];
        [UIView animateWithDuration:0.5f
                         animations:^{
                             [clipButton setTitleColor:COLOR_RED forState:UIControlStateNormal];
                             [clipButton setTitleColor:COLOR_BROWN forState:UIControlStateHighlighted];
                             [clipButton.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
                         }];
    } else {
        [clipButton setTitle:@"관심목록에 추가하기" forState:UIControlStateNormal];
        [UIView animateWithDuration:0.5f
                         animations:^{
                             [clipButton setTitleColor:COLOR_LIGHT_TEXT forState:UIControlStateNormal];
                             [clipButton setTitleColor:COLOR_TEXT forState:UIControlStateHighlighted];
                             [clipButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
                         }];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 1;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    UITableViewCell *cell;
    
    if (section == 0) {
        cell = _detailCell;
    } else if (section == 1) {
        cell = _mapCell;
        [self loadCenterLocationComplete];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    
    if (section == 0) {
        return LPDetailViewDetailCellHeight;
    } else if (section == 1) {
        return LPDetailViewMapCellHeight;
    }
    
    return 0;
}

#pragma mark - Load Content Methods

- (void)loadPetImage
{
    if (_petVO.image) {
        [self loadPetImageComplete];
        return;
    }
    
    NSURL *imageURL = [NSURL URLWithString:_petVO.imageSrc];
    NSURLRequest *request = [NSURLRequest requestWithURL:imageURL];
    
    UIImage *(^imageProcessingBlock)() = ^UIImage *(UIImage *image) {
        return image;
    };
    void (^success)() = ^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        _petVO.image = image;
        [self loadPetImageComplete];
    };
    void (^failure)() = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        [self loadFail];
    };
    
    AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:request imageProcessingBlock:imageProcessingBlock success:success failure:failure];
    [_operationQueue addOperation:operation];
}

- (void)loadPetImageComplete
{
    [_headerView setImage:_petVO.image];
    [_headerView setUserInteractionEnabled:YES];
}

- (void)loadFail
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"데이터를 가져오는데 실패했습니다!" delegate:self cancelButtonTitle:@"닫기" otherButtonTitles:nil];
    [alert show];
}

- (void)loadCenterLocation
{
    if (_petVO.geoInfo) {
        [self loadCenterLocationComplete];
        return;
    }
    
    NSURL *url = [self createCenterLocationQueryURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    void (^success)() = ^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSDictionary *searchResult = [NSDictionary dictionaryWithDictionary:[JSON objectForKey:@"channel"]];
        NSArray *items = [searchResult objectForKey:@"item"];
        
        if (items == nil || items.count == 0) {
            return;
        }
        
        _petVO.geoInfo = [items objectAtIndex:0];
        [self loadCenterLocationComplete];
    };
    void (^failure)() = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [self loadFail];
    };
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:success failure:failure];
    [_operationQueue addOperation:operation];
}

- (void)loadCenterLocationComplete
{
    [_mapCell setCenterLocation:_petVO.centerName
                       latitude:[_petVO.geoInfo objectForKey:@"lat"]
                      longitude:[_petVO.geoInfo objectForKey:@"lng"]];
}

- (NSURL *)createCenterLocationQueryURL
{
    NSString *query= [NSString stringWithFormat:kLPDaumLocalAPIaddr2coord, kLPDaumLocalAPIKey, _petVO.centerLocation];
    return [NSURL URLWithString:[query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

@end
