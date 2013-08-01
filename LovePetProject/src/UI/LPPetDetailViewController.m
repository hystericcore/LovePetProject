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
#import "LPPetDAO.h"
#import "LPPetVO.h"

#import "UIView+Utils.h"
#import "UIViewController+Commons.h"
#import "AFNetworking.h"

NSString * const kLPDaumLocalAPIaddr2coord = @"http://apis.daum.net/local/geo/addr2coord?apikey=fcc4121ab324059bf37e6dccc20932b4adfd053a&output=json&q=";

NSInteger const kLPDetailViewClipButtonHeight = 46;

static NSString *DetailCellIdentifer = @"DetailCell";
static NSString *MapCellIdentifer = @"MapCell";

@interface LPPetDetailViewController ()
@property (nonatomic, strong) LPDetailViewMapCell *mapCell;
@property (nonatomic, strong) LPDetailViewDetailCell *detailCell;
@end

@implementation LPPetDetailViewController

- (id)initWithPetVO:(LPPetVO *)petVO
{
    self = [super init];
    if (self) {
        self.petVO = petVO;
        
        // set detail cell
        NSArray *texts = @[_petVO.sex, _petVO.year, _petVO.weight, _petVO.date, _petVO.foundLocation, _petVO.boardID, _petVO.centerName, _petVO.centerLocation, _petVO.centerTel];
        self.detailCell = [[LPDetailViewDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DetailCellIdentifer];
        [_detailCell setDetailContentLabelsText:texts];
        
        // set map cell
        self.mapCell = [[LPDetailViewMapCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MapCellIdentifer];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_GRAYWHITE;
    
    [self createTableView];
    [self createShareButton];
    [self createNavTitleView];
    
    [self loadPetImage];
    [self loadCenterLocation];
}

#pragma mark - Create Methods

- (void)createTableView
{
    CGRect tableViewFrame = self.view.bounds;
    tableViewFrame.size.height -= 44;
    
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
    
    UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, headerViewSize, headerViewSize)];
    [headerView setContentMode:UIViewContentModeScaleAspectFill];
    [headerView setUserInteractionEnabled:YES];
    [headerView setClipsToBounds:YES];
    
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
    [headerView addSubview:petTypeLabel];
    
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
//    [petDetailLabel setShadowColor:COLOR_LIGHT_TEXT];
//    [petDetailLabel setShadowOffset:CGSizeMake(0.0, 0.0)];
//    [petDetailLabel.layer setShadowRadius:3.0];
//    [petDetailLabel.layer setShadowOpacity:0.7];
//    [petDetailLabel setClipsToBounds:NO];
    [headerView addSubview:petDetailLabel];
    
    [_tableView setTableHeaderView:headerView];
    
    // footer view
    CGFloat footerViewWidth = CGRectGetWidth(self.view.frame);
    CGFloat footerViewHeight = kLPDetailViewClipButtonHeight;
    
    UIButton *clipButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, footerViewWidth, footerViewHeight)];
    [clipButton addTarget:self action:@selector(actionClipButton:) forControlEvents:UIControlEventTouchUpInside];
    [clipButton setBackgroundColor:[UIColor clearColor]];
    
    [clipButton drawLineFrom:CGPointMake(8, 0) to:CGPointMake(footerViewWidth - 8, 0) lineWidth:0.5f color:COLOR_SINGLE_LINE_ALPHA4 dotted:NO];
    
    [_tableView setTableFooterView:clipButton];
    
    [self resetClipButtonState];
}

- (void)createShareButton
{
    UIBarButtonItem *shareButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionShareButton:)];
    [self.navigationItem setRightBarButtonItem:shareButtonItem];
}

- (void)actionShareButton:(id)sender
{
    NSArray *activityItems = @[@"주인을 애타게 찾고있는 아이들이 있어요! 러브팻에서 작성되었습니다.", _petVO.image];
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems
                                                                                     applicationActivities:nil];
    activityController.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypePrint, UIActivityTypePostToWeibo, UIActivityTypeSaveToCameraRoll];
    [self presentViewController:activityController animated:YES completion:nil];
}

#pragma mark - Action Methods

- (void)actionClipButton:(id)sender
{
    NSString *message;
    
    if ([[LPPetDAO sharedInstance] isClipPetDataExist:_petVO]) {
        [[LPPetDAO sharedInstance] removeClipPetData:_petVO];
        message = @"관심목록에서 삭제하였습니다";
    } else {
        [[LPPetDAO sharedInstance] setClipPetData:_petVO];
        message = @"관심목록에 추가하였습니다.";
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:message delegate:self cancelButtonTitle:@"닫기" otherButtonTitles:nil];
    [alert show];
    
    [self resetClipButtonState];
}

- (void)resetClipButtonState
{
    UIButton *clipButton = (UIButton *)_tableView.tableFooterView;
    
    if ([[LPPetDAO sharedInstance] isClipPetDataExist:_petVO]) {
        [UIView animateWithDuration:0.5f
                         animations:^{
                             [clipButton setTitle:@"관심목록에서 삭제하기" forState:UIControlStateNormal];
                             [clipButton setTitleColor:COLOR_RED forState:UIControlStateNormal];
                             [clipButton setTitleColor:COLOR_BROWN forState:UIControlStateHighlighted];
                             [clipButton.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
                         }];
    } else {
        [UIView animateWithDuration:0.5f
                         animations:^{
                             [clipButton setTitle:@"관심목록에 추가하기" forState:UIControlStateNormal];
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
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    [operationQueue addOperation:operation];
}

- (void)loadPetImageComplete
{
    UIImageView *headerView = (UIImageView *)_tableView.tableHeaderView;
    [headerView setImage:_petVO.image];
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
    
    [[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:success failure:failure] start];
}

- (void)loadCenterLocationComplete
{
    [_mapCell setCenterLocation:_petVO.centerName
                       latitude:[_petVO.geoInfo objectForKey:@"lat"]
                      longitude:[_petVO.geoInfo objectForKey:@"lng"]];
}

- (NSURL *)createCenterLocationQueryURL
{
    NSString *query = [NSString stringWithFormat:@"%@%@", kLPDaumLocalAPIaddr2coord, _petVO.centerLocation];
    return [NSURL URLWithString:[query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

@end
