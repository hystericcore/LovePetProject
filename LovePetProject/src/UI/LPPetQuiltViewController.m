//
//  LPPetListViewController.m
//  LovePetProject
//
//  Created by HyunJoon Park on 13. 7. 6..
//  Copyright (c) 2013년 HyunJoon Park. All rights reserved.
//

#import "LPPetQuiltViewController.h"
#import "HTMLParser.h"
#import "WebImageOperations.h"
#import "TMQuiltView.h"

#import "LPPetVO.h"
#import "LPPetQuiltViewCell.h"

#import "LPPetDetailViewController.h"

const NSString *kLPPetQueryURL = @"/portal_rnl/abandonment/protection_list.jsp";
//const NSString *kLPPetQueryStartDate = @"s_date";
//const NSString *kLPPetQueryEndDate = @"e_date";
//const NSString *kLPPetQueryPageCnt = @"pagecnt";

@implementation LPPetQuiltViewController
@synthesize prePetQuilts = _prePetQuilts;
@synthesize petQuilts = _petQuilts;

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)dealloc
{
    self.prePetQuilts = nil;
    self.petQuilts = nil;
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self createPetSearchButton];
    [self createPetDataArray];
}

- (void)createPetSearchButton
{
    UIButton *listButton = [[UIButton alloc] init];
    [listButton setImage:[UIImage imageNamed:@"nav_button_search.png"] forState:UIControlStateNormal];
    [listButton addTarget:self action:@selector(actionSearchButton:) forControlEvents:UIControlEventTouchUpInside];
    [listButton sizeToFit];
    
    self.searchButton = [[[UIBarButtonItem alloc] initWithCustomView:listButton] autorelease];
    [listButton release];
    
    [self.navigationItem setRightBarButtonItem:_searchButton];
}

- (void)actionSearchButton:(UIBarButtonItem *)button
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"검색 옵션을 선택하세요." delegate:self cancelButtonTitle:@"취소" destructiveButtonTitle:nil otherButtonTitles:@"서울특별시", nil];
    [actionSheet showInView:self.view];
}

- (NSURL *)createPetURLStringWithStartDate:(NSString *)startDate withEndDate:(NSString *)endDate withPetKind:(NSString *)petKind withPage:(NSString *)page
{
    NSString *string = [NSString stringWithFormat:@"%@%@?s_date=%@&e_date=%@&s_up_kind_cd=%@&pagecnt=%@", kLPPetDataDomain, kLPPetQueryURL, startDate, endDate, petKind, page];
    return [NSURL URLWithString:string];
}

- (void)createPetDataArray
{
    // 임시 날짜 생성
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[[NSDate alloc] init]];
    
    [components setHour:-[components hour]];
    [components setMinute:-[components minute]];
    [components setSecond:-[components second]];
    NSDate *today = [cal dateByAddingComponents:components toDate:[[NSDate alloc] init] options:0]; //This variable should now be pointing at a date object that is the start of today (midnight);
    
    [components setHour:-24 * 2];
    [components setMinute:0];
    [components setSecond:0];
    NSDate *startday = [cal dateByAddingComponents:components toDate:today options:0];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    NSString *startdayString = [dateFormat stringFromDate:startday];
    NSString *enddayString = [dateFormat stringFromDate:today];
    
    NSMutableArray *petQuilts = [[NSMutableArray alloc] initWithCapacity:0];
    NSString *html = [[NSString alloc] initWithContentsOfURL:[self createPetURLStringWithStartDate:startdayString
                                                                                       withEndDate:enddayString
                                                                                       withPetKind:@""
                                                                                          withPage:@""]
                                                    encoding:NSEUCKRStringEncoding
                                                       error:nil];
    
    HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:nil];
    HTMLNode *bodyNode = [parser body];
    
    NSArray *thumbnailImgNodes = [bodyNode findChildrenOfClass:@"thumbnail_img01"];
    NSArray *linkButtonNodes = [bodyNode findChildrenOfClass:@"thumbnail_btn01"];
    NSArray *tableNodes = [bodyNode findChildrenOfClass:@"thumbnail_table01"];

    for (int i = 0; i < thumbnailImgNodes.count; i++) {
        LPPetVO *vo = [[LPPetVO alloc] init];
        
        // thumbnail
        HTMLNode *thumbnailImgNode = [thumbnailImgNodes objectAtIndex:i];
        HTMLNode *thumbnailNode = [thumbnailImgNode findChildTag:@"img"];
        vo.thumbnailSrc = [NSString stringWithFormat:@"%@%@", kLPPetDataDomain, [thumbnailNode getAttributeNamed:@"src"]];
        
        // link
        HTMLNode *linkButtonNode = [linkButtonNodes objectAtIndex:i];
        HTMLNode *linkNode = [linkButtonNode findChildTag:@"a"];
        vo.linkSrc = [NSString stringWithFormat:@"%@%@", kLPPetDataDomain, [linkNode getAttributeNamed:@"href"]];
        
        // text
        HTMLNode *tableNode = [tableNodes objectAtIndex:i];
        NSArray *tdNodes = [tableNode findChildTags:@"td"];
        
        vo.boardID = [(HTMLNode *)[tdNodes objectAtIndex:0] contents];
        vo.date = [(HTMLNode *)[tdNodes objectAtIndex:1] contents];
        vo.type = [(HTMLNode *)[tdNodes objectAtIndex:2] contents];
        vo.sex = [(HTMLNode *)[tdNodes objectAtIndex:3] contents];
        vo.foundLocation = [(HTMLNode *)[tdNodes objectAtIndex:4] contents];
        vo.detail = [(HTMLNode *)[tdNodes objectAtIndex:5] contents];
        vo.state = [(HTMLNode *)[tdNodes objectAtIndex:6] contents];
        
        [petQuilts addObject:vo];
        [vo release];
    }
    
    self.prePetQuilts = petQuilts;
    [petQuilts release];
    
    [self loadThumbnailImages];
}

- (void)loadThumbnailImages
{
    for (LPPetVO *vo in _prePetQuilts) {
        if (vo.thumbnail != nil) {
            continue;
        }
        
        [WebImageOperations processImageDataWithURLString:vo.thumbnailSrc andBlock:^(NSData *imageData) {
            if (self.view.window) {
                UIImage *image = [UIImage imageWithData:imageData];
                vo.thumbnail = image;
                
                [self loadComplete];
            }
        }];
    }
}

- (void)loadComplete
{
    for (LPPetVO *vo in _prePetQuilts) {
        if (vo.thumbnail == nil) {
            return;
        }
    }
    
    self.petQuilts = _prePetQuilts;
    [self.quiltView reloadData];
}

#pragma mark - QuiltViewControllerDataSource

- (NSInteger)quiltViewNumberOfCells:(TMQuiltView *)TMQuiltView
{
    return [_petQuilts count];
}

- (TMQuiltViewCell *)quiltView:(TMQuiltView *)quiltView cellAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *petIdentifier = @"PetIdentifier";
    LPPetQuiltViewCell *cell = (LPPetQuiltViewCell *)[quiltView dequeueReusableCellWithReuseIdentifier:petIdentifier];
    
    if (cell == nil) {
        cell = [[[LPPetQuiltViewCell alloc] initWithReuseIdentifier:petIdentifier] autorelease];
    }
    
    LPPetVO *vo = [_petQuilts objectAtIndex:indexPath.row];
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

- (NSInteger)quiltViewNumberOfColumns:(TMQuiltView *)quiltView
{
    return 3;
}

- (CGFloat)quiltView:(TMQuiltView *)quiltView heightForCellAtIndexPath:(NSIndexPath *)indexPath
{
    LPPetVO *vo = [_petQuilts objectAtIndex:indexPath.row];
    CGFloat ratio = vo.thumbnail.size.width / vo.thumbnail.size.height;
    return [quiltView cellWidth] / ratio + kLPPetQuiltViewTextPlaceHeight;
}

- (void)quiltView:(TMQuiltView *)quiltView didSelectCellAtIndexPath:(NSIndexPath *)indexPath
{
    LPPetVO *vo = [_petQuilts objectAtIndex:indexPath.row];
    NSLog(@"%@", vo.linkSrc);
    
    LPPetDetailViewController *viewController = [[LPPetDetailViewController alloc] init];
    [viewController createPetDetailData:vo];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

@end
