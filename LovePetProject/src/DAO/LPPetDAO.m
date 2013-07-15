//
//  LPPetDAO.m
//  LovePetProject
//
//  Created by HyunJoon Park on 13. 7. 14..
//  Copyright (c) 2013년 HyunJoon Park. All rights reserved.
//

#import "LPPetDAO.h"
#import "AFNetworking.h"
#import "LPPetVO.h"
#import "LPPetDetailVO.h"

NSString *const kLPNotificationPetListUpdateComplete = @"petDAO.listUpdateComplete";
NSString *const kLPNotificationPetListUpdateFail = @"petDAO.listUpdateFail";
NSString *const kLPNotificationPetListRequestFail = @"petDAO.listRequestFail";

NSString *const kLPNotificationPetDetailRequestComplete = @"petDAO.detailRequestComplete";
NSString *const kLPNotificationPetDetailRequestFail = @"petDAO.detailRequestFail";

NSString *const kLPPetKindCat = @"422400";
NSString *const kLPPetKindDog = @"417000";

NSString *const kLPPetQueryURL = @"http://lovepetproject.appspot.com/petList?";
NSString *const kLPPetQueryStartDate = @"startDate";
NSString *const kLPPetQueryEndDate = @"endDate";
NSString *const kLPPetQueryPetKind = @"petKind";
NSString *const kLPPetQueryPageCount = @"pageCount";
NSString *const kLPPetQueryLocation = @"location";

NSInteger const kLPPetQueryPageCountDefault = 1;
NSInteger const kLPPetQueryDateCountFromNowDefault = 0;

NSString *const kLPPetListJSONKey = @"petList";
NSInteger const kLPPetListCount = 10;

NSString *const kLPPetDetailQueryURL = @"http://lovepetproject.appspot.com/petDetail";

NSString *const kLPPetDetailJSONKey = @"petDetail";

@interface LPPetDAO ()
@property (nonatomic, strong) NSMutableArray *petDataSource;
@property (nonatomic, strong) NSString *currentPetKind;
@property (nonatomic, strong) NSString *currentLocation;
@end
@implementation LPPetDAO

- (id)init
{
    self = [super init];
    if (self) {
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    }
    return self;
}

- (void)resetPetDataSourceWithPetKind:(NSString *)petKind location:(NSString *)location
{
    self.petDataSource = [[NSMutableArray alloc] initWithCapacity:0];
    _currentPetKind = petKind;
#warning 위치를 서울로 고정.
    _currentLocation = @"6110000";
    _currentDateCountFromNow = kLPPetQueryDateCountFromNowDefault;
    _currentPageCount = kLPPetQueryPageCountDefault;
    _pageEnd = NO;
    
    [self requestPetList];
}

- (void)requestNextPetList
{
    if (_pageEnd) {
        _currentDateCountFromNow++;
        _currentPageCount = kLPPetQueryPageCountDefault;
    } else {
        _currentPageCount++;
    }
    
    _pageEnd = NO;
    
    [self requestPetList];
}

- (void)requestPetDetailDataAtIndex:(NSUInteger)index
{
    LPPetVO *petVO = [_petDataSource objectAtIndex:index];
    
    if (petVO.detailVO != nil) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kLPNotificationPetDetailRequestComplete object:self];
        return;
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kLPPetDetailQueryURL]];
    NSString *postString = [NSString stringWithFormat:@"linkSrc=%@", petVO.linkSrc];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    void (^success)(NSURLRequest *, NSHTTPURLResponse *, id) = ^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSDictionary *petDetailData = [JSON objectForKey:kLPPetDetailJSONKey];
        
        if (petDetailData != nil) {
            LPPetDetailVO *detailVO = [[LPPetDetailVO alloc] initWithProperties:petDetailData];
            [petVO setDetailVO:detailVO];
            
            NSURL *imageURL = [NSURL URLWithString:detailVO.imageSrc];
            NSURLRequest *request = [NSURLRequest requestWithURL:imageURL];
            
            UIImage *(^imageProcessingBlock)(UIImage *image) = ^UIImage *(UIImage *image) {
                return image;
            };
            void (^success)(NSURLRequest *, NSHTTPURLResponse *, UIImage *) = ^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                detailVO.image = image;
                [[NSNotificationCenter defaultCenter] postNotificationName:kLPNotificationPetDetailRequestComplete object:self];
            };
            void (^failure)(NSURLRequest *, NSHTTPURLResponse *, NSError *) = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                petVO.detailVO = nil;
                [[NSNotificationCenter defaultCenter] postNotificationName:kLPNotificationPetDetailRequestFail object:self];
            };
            
            [[AFImageRequestOperation imageRequestOperationWithRequest:request imageProcessingBlock:imageProcessingBlock success:success failure:failure] start];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:kLPNotificationPetDetailRequestFail object:self];
        }
    };
    void (^failure)(NSURLRequest *, NSHTTPURLResponse *, NSError *, id) = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kLPNotificationPetDetailRequestFail object:self];
    };
    
    [[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:success failure:failure] start];
}

- (NSArray *)getPetDataSource
{
    return [NSArray arrayWithArray:_petDataSource];
}

- (id)getPetDetailDataAtIndex:(NSUInteger)index
{
    if (index >= _petDataSource.count) {
        return nil;
    }
    
    return [_petDataSource objectAtIndex:index];
}

#pragma mark - Private Methods

- (void)requestPetList
{
    NSDate *nowDate = [self createQueryDate:_currentDateCountFromNow];
    NSURL *url = [self createPetURLStringWithStartDate:[self convertDateToQueryString:nowDate]
                                               endDate:[self convertDateToQueryString:nowDate]
                                               petKind:_currentPetKind
                                             pageCount:[NSNumber numberWithInteger:_currentPageCount]
                                              location:_currentLocation];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    void (^success)(NSURLRequest *, NSHTTPURLResponse *, id) = ^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSArray *petList = [JSON objectForKey:kLPPetListJSONKey];
        
        if (petList.count > 0) {
            [self updatePetDataSource:petList];
        } else {
            _currentDateCountFromNow++;
            [self requestPetList];
        }
    };
    void (^failure)(NSURLRequest *, NSHTTPURLResponse *, NSError *, id) = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kLPNotificationPetListRequestFail object:self];
    };
    
    [[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:success failure:failure] start];
}

- (void)updatePetDataSource:(NSArray *)petList
{
    if (petList.count < kLPPetListCount) {
        _pageEnd = YES;
    }
    
    __block int requestCount = petList.count;
    
    for (NSDictionary *petDic in petList) {
        LPPetVO *vo = [[LPPetVO alloc] initWithProperties:petDic];
        [_petDataSource addObject:vo];
        
        NSURL *thumbnailURL = [NSURL URLWithString:vo.thumbnailSrc];
        NSURLRequest *request = [NSURLRequest requestWithURL:thumbnailURL];
        
        UIImage *(^imageProcessingBlock)(UIImage *image) = ^UIImage *(UIImage *image) {
            return image;
        };
        void (^success)(NSURLRequest *, NSHTTPURLResponse *, UIImage *) = ^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            vo.thumbnail = image;
            
            if (--requestCount == 0)
                [[NSNotificationCenter defaultCenter] postNotificationName:kLPNotificationPetListUpdateComplete object:self];
        };
        void (^failure)(NSURLRequest *, NSHTTPURLResponse *, NSError *) = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            [_petDataSource removeObject:vo];
            [[NSNotificationCenter defaultCenter] postNotificationName:kLPNotificationPetListUpdateFail object:self];
        };
        
        [[AFImageRequestOperation imageRequestOperationWithRequest:request imageProcessingBlock:imageProcessingBlock success:success failure:failure] start];
    }
}

#pragma mark - Private Methods

- (NSDate *)createQueryDate:(NSUInteger)countingFromNow
{
    NSDate *nowDate = [[NSDate alloc] init];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit)
                                          fromDate:nowDate];
    [components setHour:-[components hour]];
    [components setMinute:-[components minute]];
    [components setSecond:-[components second]];
    NSDate *today = [cal dateByAddingComponents:components toDate:nowDate options:0];
    
    // Query Date
    [components setHour:-24 * countingFromNow];
    [components setMinute:0];
    [components setSecond:0];
    return [cal dateByAddingComponents:components toDate:today options:0];
}

- (NSString *)convertDateToQueryString:(NSDate *)date
{
    // NSDateToString
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    return [dateFormat stringFromDate:date];
}

- (NSURL *)createPetURLStringWithStartDate:(NSString *)startDate endDate:(NSString *)endDate petKind:(NSString *)petKind pageCount:(NSNumber *)pageCount location:(NSString *)location
{
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:0];
    [string appendString:kLPPetQueryURL];
    
    if (startDate != nil) [string appendString:[NSString stringWithFormat:@"%@=%@&", kLPPetQueryStartDate, startDate]];
    if (endDate != nil) [string appendString:[NSString stringWithFormat:@"%@=%@&", kLPPetQueryEndDate, endDate]];
    if (petKind != nil) [string appendString:[NSString stringWithFormat:@"%@=%@&", kLPPetQueryPetKind, petKind]];
    if (pageCount != nil) [string appendString:[NSString stringWithFormat:@"%@=%@&", kLPPetQueryPageCount, pageCount]];
    if (location != nil) [string appendString:[NSString stringWithFormat:@"%@=%@", kLPPetQueryLocation, location]];
    
    return [NSURL URLWithString:string];
}

@end
