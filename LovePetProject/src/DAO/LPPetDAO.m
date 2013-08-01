//
//  LPPetDAO.m
//  LovePetProject
//
//  Created by HyunJoon Park on 13. 7. 14..
//  Copyright (c) 2013년 HyunJoon Park. All rights reserved.
//

#import "LPPetDAO.h"
#import "LPPetVO.h"

#import "AFNetworking.h"

NSString *const kLPNotificationPetListReset = @"petDAO.listReset";
NSString *const kLPNotificationPetListUpdateComplete = @"petDAO.listUpdateComplete";
NSString *const kLPNotificationPetListReturnZero = @"petDAO.listReturnZero";
NSString *const kLPNotificationPetListUpdateFail = @"petDAO.listUpdateFail";
NSString *const kLPNotificationPetListRequestFail = @"petDAO.listRequestFail";

NSString *const kLPNotificationClipPetListReset = @"petDAO.clipListReset";

NSString *const kLPPetKindCat = @"422400";
NSString *const kLPPetKindDog = @"417000";

NSString *const kLPSearchOptionKeyword = @"searchOption.keyword";
NSString *const kLPSearchOptionPetType = @"searchOption.petType";
NSString *const kLPSearchOptionLocation = @"searchOption.location";

NSString *const kLPPetQueryURL = @"https://api.baas.io/19afa818-e241-11e2-9011-06530c0000b4/3a653992-e241-11e2-9011-06530c0000b4/pets?ql=select * ";

NSString *const kLPPetQueryKeyword = @"petType contains '%@*' ";
NSString *const kLPPetQueryPetType = @"petType contains '%@' ";
NSString *const kLPPetQueryLocation = @"boardID contains '%@*' ";
NSString *const kLPPetQueryLimit = @"limit=30";
NSString *const kLPPetQueryOrder = @"order by created desc";

NSString *const kLPPetQueryCursor = @"cursor";

NSString *const kLPPetListKey = @"entities";
NSString *const kLPPetCursorKey = @"cursor";

NSString *const kLPLocalRootPath = @"lovepet";
NSString *const kLPLocalDomainClip = @"clip";

@interface LPPetDAO ()
@property (nonatomic, strong) NSMutableArray *petDataSource;
@property (nonatomic, strong) NSString *currentPetKind;
@property (nonatomic, strong) NSString *currentLocation;
@end
@implementation LPPetDAO

+ (instancetype)sharedInstance
{
    static LPPetDAO *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
        self.operationQueue = [[NSOperationQueue alloc] init];
    }
    return self;
}

- (void)resetRemotePetDataSource
{
    self.currentQueryCursor = nil;
    self.stopQuery = NO;
    self.petDataSource = [[NSMutableArray alloc] initWithCapacity:0];
    [[NSNotificationCenter defaultCenter] postNotificationName:kLPNotificationPetListReset object:self];
    
    [self requestPetList];
}

- (void)requestNextPetList
{
    [self requestPetList];
}

- (NSArray *)getRemotePetDataSource
{
    return [NSArray arrayWithArray:self.petDataSource];
}

- (NSArray *)getSearchOptionValues:(NSString *)optionType
{
    NSArray *values;
    
    if ([optionType isEqualToString:kLPSearchOptionLocation]) {
        values = @[@"전체", @"서울특별시", @"부산광역시", @"대구광역시", @"인천광역시", @"세종특별자치시", @"대전광역시", @"울산광역시", @"경기도", @"강원도", @"충청북도", @"충청남도", @"전라북도", @"전라남도", @"경상북도", @"경상남도", @"제주특별자치도"];
    } else if ([optionType isEqualToString:kLPSearchOptionPetType]) {
        values = @[@"전체", @"개", @"고양이"];
    }
    
    return values;
}

#pragma mark - Private Methods

- (void)requestPetList
{
    if (_operationQueue.operationCount > 0 || _stopQuery)
        return;
    
    NSURL *url = [self createPetURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    void (^success)() = ^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSArray *petList = [[NSArray alloc] initWithArray:[JSON objectForKey:kLPPetListKey]];
        NSString *cursorKey = [JSON objectForKey:kLPPetCursorKey];
        
        if (petList.count == 0) {
            self.currentQueryCursor = nil;
            self.stopQuery = YES;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kLPNotificationPetListReturnZero object:self];
        } else {
            self.currentQueryCursor = cursorKey;
            
            if (self.currentQueryCursor == nil)
                self.stopQuery = YES;
            
            [self updatePetDataSource:petList];
        }
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
        
        void (^success)() = ^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            vo.thumbnail = image;
            
            if (--requestCount == 0)
                [[NSNotificationCenter defaultCenter] postNotificationName:kLPNotificationPetListUpdateComplete object:self];
        };
        void (^failure)() = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            [_petDataSource removeObject:vo];
            [[NSNotificationCenter defaultCenter] postNotificationName:kLPNotificationPetListUpdateFail object:self];
        };
        
        AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:request imageProcessingBlock:nil success:[success copy] failure:[failure copy]];
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
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSString *keyword = [[NSUserDefaults standardUserDefaults] stringForKey:kLPSearchOptionKeyword];
    NSString *petType = [[NSUserDefaults standardUserDefaults] stringForKey:kLPSearchOptionPetType];
    NSString *location = [[NSUserDefaults standardUserDefaults] stringForKey:kLPSearchOptionLocation];
    BOOL append = NO;
    
    NSMutableString *query = [[NSMutableString alloc] initWithCapacity:0];
    [query appendString:kLPPetQueryURL];
    
    if (keyword) {
        append = YES;
        [query appendString:@"where "];
        [query appendString:[NSString stringWithFormat:kLPPetQueryKeyword, keyword]];
    }
    
    if (petType) {
        if (append != YES)
            [query appendString:@"where "];
        else
            [query appendString:@"and "];
        
        append = YES;
        [query appendString:[NSString stringWithFormat:kLPPetQueryPetType, petType]];
    }
    
    if (location) {
        if (append != YES)
            [query appendString:@"where "];
        else
            [query appendString:@"and "];
        
        if (location.length > 2)
            location = [location substringWithRange:NSMakeRange(0, 2)];
        
        append = YES;
        [query appendString:[NSString stringWithFormat:kLPPetQueryLocation, location]];
    }
    
    [query appendString:kLPPetQueryOrder];
    [query appendFormat:@"&%@", kLPPetQueryLimit];
    
    if (_currentQueryCursor != nil)
        [query appendFormat:@"&%@=%@", kLPPetQueryCursor, _currentQueryCursor];
    
    return [NSURL URLWithString:[query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

#pragma mark - Pet Clip Methods

- (NSArray *)getClipPetDataSource
{
    NSArray *archivedObjects = [self loadAllObjectInDomain:kLPLocalDomainClip];
    
    if (!archivedObjects)
        return nil;
    
    NSMutableArray *clipPetDataSouce = [NSMutableArray arrayWithCapacity:0];
    
    for (NSString *fileName in archivedObjects) {
        [clipPetDataSouce addObject:[NSKeyedUnarchiver unarchiveObjectWithFile:[self makePathForFile:fileName domain:kLPLocalDomainClip]]];
    }
    
    NSArray *sortedArray = [clipPetDataSouce sortedArrayUsingComparator:^(LPPetVO *firstVO, LPPetVO *secondVO) {
        if ([firstVO.created doubleValue] > [secondVO.created doubleValue])
            return (NSComparisonResult)NSOrderedAscending;
        else if ([firstVO.created doubleValue] < [secondVO.created doubleValue])
            return (NSComparisonResult)NSOrderedDescending;
        else
            return (NSComparisonResult)NSOrderedSame;
    }];
    
    return sortedArray;
}

- (BOOL)isClipPetDataExist:(LPPetVO *)petVO
{
    if ([self getLocalArchivedObject:petVO.uuid domain:kLPLocalDomainClip])
        return YES;
    
    return NO;
}

- (BOOL)setClipPetData:(LPPetVO *)petVO
{
    BOOL result = [self setLocalArchivedObject:petVO toFile:petVO.uuid domain:kLPLocalDomainClip];
    [[NSNotificationCenter defaultCenter] postNotificationName:kLPNotificationClipPetListReset object:nil];
    return result;
}

- (void)removeClipPetData:(LPPetVO *)petVO
{
    [self removeLocalArchivedObject:petVO.uuid domain:kLPLocalDomainClip];
    [[NSNotificationCenter defaultCenter] postNotificationName:kLPNotificationClipPetListReset object:nil];
}

#pragma mark - NSKeyedArchiver Methods

- (NSArray *)loadAllObjectInDomain:(NSString *)domain
{
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *docDirectory = [pathArray objectAtIndex:0];
    NSString *objectsPath = [NSString stringWithFormat:@"%@/%@/%@", docDirectory, kLPLocalRootPath, domain];
    
    NSError *error;
    NSArray *objects = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:objectsPath error:&error];
    
    if (error) {
        NSLog(@"%@", error);
        return nil;
    }
    
    return objects;
}

- (id)getLocalArchivedObject:(NSString *)fileName domain:(NSString *)domain
{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[self makePathForFile:fileName domain:domain]];
}

- (BOOL)setLocalArchivedObject:(id)object toFile:(NSString *)fileName domain:(NSString *)domain
{
    return [NSKeyedArchiver archiveRootObject:object toFile:[self makePathForFile:fileName domain:domain]];
}

- (void)removeLocalArchivedObject:(NSString *)fileName domain:(NSString *)domain
{
    [[NSFileManager defaultManager] removeItemAtPath:[self makePathForFile:fileName domain:domain] error:nil];
}

- (NSString *)makePathForFile:(NSString *)fileName domain:(NSString *)domain
{
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *docDirectory = [pathArray objectAtIndex:0];
    NSString *path = [NSString stringWithFormat:@"%@/%@/%@/%@", docDirectory, kLPLocalRootPath, domain, fileName];
    [self makeDirectory:[path stringByDeletingLastPathComponent]];
    return path;
}

- (void)makeDirectory:(NSString *)path
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
        return;
    
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:NULL];
}

@end
