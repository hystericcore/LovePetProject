//
//  LPClipPetDAO.m
//  LovePetProject
//
//  Created by hyunjoon.park on 13. 8. 29..
//  Copyright (c) 2013년 HyunJoon Park. All rights reserved.
//

#import "LPClipPetDAO.h"
#import "LPPetVO.h"

NSString *const kLPNotificationClipReset = @"petDAO.clipListReset";
NSString *const kLPNotificationClipUpdateComplete = @"petDAO.clipUpdateComplete";
NSString *const kLPNotificationClipReturnZero = @"petDAO.clipReturnZero";
NSString *const kLPNotificationClipUpdateFail = @"petDAO.clipUpdateFail";
NSString *const kLPNotificationClipRequestFail = @"petDAO.clipRequestFail";

NSString *const kLPLocalRootPath = @"lovepet";
NSString *const kLPLocalDomainClip = @"clip";

@implementation LPClipPetDAO

#pragma mark - LPPetDAO

+ (instancetype)sharedInstance
{
    static LPClipPetDAO *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}

- (NSString *)getNotiName:(kLPPetDAONoti)type
{
    NSString *name = nil;
    
    switch (type) {
        case kLPPetDAONotiReset:
            name = kLPNotificationClipReset;
            break;
            
        case kLPPetDAONotiUpdateComplete:
            name = kLPNotificationClipUpdateComplete;
            break;
        
        case kLPPetDAONotiUpdateFail:
            name = kLPNotificationClipUpdateFail;
            break;
        
        case kLPPetDAONotiReturnZero:
            name = kLPNotificationClipReturnZero;
            break;
            
        case kLPPetDAONotiRequestFail:
            name = kLPNotificationClipRequestFail;
            break;
    }
    
    return name;
}

- (void)resetPetDataSource
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kLPNotificationClipUpdateComplete object:self];
}

- (NSArray *)getPetDataSource
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

#pragma mark - LPLocalPetDAO

- (BOOL)isLocalPetDataExist:(LPPetVO *)petVO
{
    if ([self getLocalArchivedObject:petVO.uuid domain:kLPLocalDomainClip])
        return YES;
    
    return NO;
}

- (BOOL)setLocalPetData:(LPPetVO *)petVO
{
    BOOL result = [self setLocalArchivedObject:petVO toFile:petVO.uuid domain:kLPLocalDomainClip];
    [[NSNotificationCenter defaultCenter] postNotificationName:kLPNotificationClipUpdateComplete object:nil];
    return result;
}

- (void)removeLocalPetData:(LPPetVO *)petVO
{
    [self removeLocalArchivedObject:petVO.uuid domain:kLPLocalDomainClip];
    [[NSNotificationCenter defaultCenter] postNotificationName:kLPNotificationClipUpdateComplete object:nil];
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
