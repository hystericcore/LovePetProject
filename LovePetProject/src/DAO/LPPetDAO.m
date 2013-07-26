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

NSString *const kLPNotificationPetListUpdateComplete = @"petDAO.listUpdateComplete";
NSString *const kLPNotificationPetListUpdateFail = @"petDAO.listUpdateFail";
NSString *const kLPNotificationPetListRequestFail = @"petDAO.listRequestFail";

NSString *const kLPPetKindCat = @"422400";
NSString *const kLPPetKindDog = @"417000";

NSString *const kLPPetQueryURL = @"https://api.baas.io/19afa818-e241-11e2-9011-06530c0000b4/3a653992-e241-11e2-9011-06530c0000b4/pets?ql=select * order by created desc";

NSString *const kLPPetQueryCursor = @"cursor";

NSString *const kLPPetListKey = @"entities";
NSString *const kLPPetCursorKey = @"cursor";

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
        self.operationQueue = [[NSOperationQueue alloc] init];
        [_operationQueue setMaxConcurrentOperationCount:3];
    }
    return self;
}

- (void)resetPetDataSource
{
    _currentQueryCursor = nil;
    _stopQuery = NO;
    self.petDataSource = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self requestPetList];
}

- (void)requestNextPetList
{
    [self requestPetList];
}

- (NSArray *)getPetDataSource
{
    return [NSArray arrayWithArray:_petDataSource];
}

#pragma mark - Private Methods

- (void)requestPetList
{
    if (_stopQuery) {
        return;
    }
    
    NSURL *url = [self createPetURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    void (^success)() = ^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSArray *petList = [JSON objectForKey:kLPPetListKey];
        _currentQueryCursor = [[JSON objectForKey:kLPPetCursorKey] copy];
        
        if (petList.count < 10) {
            _stopQuery = YES;
        }
        
        [self updatePetDataSource:petList];
    };
    void (^failure)() = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kLPNotificationPetListRequestFail object:self];
    };
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:success failure:failure];
    [_operationQueue addOperation:operation];
}

- (void)updatePetDataSource:(NSArray *)petList
{
    __block int requestCount = petList.count;
    
    for (NSDictionary *petDic in petList) {
        LPPetVO *vo = [[LPPetVO alloc] initWithProperties:petDic];
        [_petDataSource addObject:vo];
        
        NSURL *thumbnailURL = [NSURL URLWithString:vo.thumbnailSrc];
        NSURLRequest *request = [NSURLRequest requestWithURL:thumbnailURL];
        
        UIImage *(^imageProcessingBlock)() = ^UIImage *(UIImage *image) {
            return image;
        };
        void (^success)() = ^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            vo.thumbnail = image;
            
            if (--requestCount == 0)
                [[NSNotificationCenter defaultCenter] postNotificationName:kLPNotificationPetListUpdateComplete object:self];
        };
        void (^failure)() = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            [_petDataSource removeObject:vo];
            [[NSNotificationCenter defaultCenter] postNotificationName:kLPNotificationPetListUpdateFail object:self];
        };
        
        AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:request imageProcessingBlock:imageProcessingBlock success:success failure:failure];
        [_operationQueue addOperation:operation];
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

- (NSURL *)createPetURL
{
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:0];
    [string appendString:kLPPetQueryURL];
    
    if (_currentQueryCursor != nil) [string appendString:[NSString stringWithFormat:@"&%@=%@&", kLPPetQueryCursor, _currentQueryCursor]];
    
    return [NSURL URLWithString:[string stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
}

@end
