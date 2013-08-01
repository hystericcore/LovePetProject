//
//  LPPetQuiltVO.m
//  LovePetProject
//
//  Created by HyunJoon Park on 13. 7. 6..
//  Copyright (c) 2013년 HyunJoon Park. All rights reserved.
//

#import "LPPetVO.h"
#import <objc/runtime.h>

@implementation LPPetVO

- (id)initWithProperties:(NSDictionary *)properties
{
    self = [super init];
    if (self) {
        NSMutableArray *propertyNames = [self getPropertyNames];
        
        for (NSString *key in propertyNames) {
            id value = [properties objectForKey:key];
            
            if ([value isKindOfClass:[NSString class]]) {
                value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                value = [value stringByReplacingOccurrencesOfString:@"  " withString:@" "];
            }
            
            SEL keySetter = [self setterForPropertyName:key];
            
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self performSelector:keySetter withObject:value];
#pragma clang diagnostic pop
        }
    }
    return self;
}

#pragma mark - Key archived

- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super init];
    if (self)
    {
        NSMutableArray *propertyNames = [self getPropertyNames];
        
        for (NSString *key in propertyNames) {
            NSString *value = [aCoder decodeObjectForKey:key];
            
            SEL keySetter = [self setterForPropertyName:key];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self performSelector:keySetter withObject:value];
#pragma clang diagnostic pop
        }
    }
    
    return self;
}


- (void)encodeWithCoder:(NSCoder *)aCoder
{
    NSMutableArray *propertyNames = [self getPropertyNames];
    
    for (NSString *key in propertyNames) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        id object = [self performSelector:NSSelectorFromString(key)];
#pragma clang diagnostic pop
        [aCoder encodeObject:object forKey:key];
    };
}

#pragma mark - Public Methods

- (void)resetLeftDay
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *nowDate = [[NSDate alloc] init];
    NSDate *dayDate = [dateFormat dateFromString:self.date];
    
    if (nowDate == nil || dayDate == nil) {
        NSLog(@"date nil");
        return;
    }
    
    NSInteger leftDay = 10 - [self daysBetweenDate:dayDate andDate:nowDate];
    
    if (leftDay < 0 || leftDay > 10) {
        leftDay = 0;
    }
    
    self.leftDay = [NSString stringWithFormat:@"%d일", leftDay];
}

- (NSString *)getRemakePetType
{
    NSString *petType = [NSString stringWithString:self.petType];
    petType = [petType stringByReplacingOccurrencesOfString:@"[개]" withString:@""];
    petType = [petType stringByReplacingOccurrencesOfString:@"[고양이]" withString:@"고양이"];
    petType = [petType stringByReplacingOccurrencesOfString:@"[기타축종]" withString:@""];
    petType = [petType stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return petType;
}

#pragma mark - private methods

- (NSMutableArray *)getPropertyNames
{
    unsigned int propertyCount = 0;
    objc_property_t * properties = class_copyPropertyList([self class], &propertyCount);
    
    NSMutableArray * propertyNames = [NSMutableArray array];
    for (unsigned int i = 0; i < propertyCount; ++i) {
        objc_property_t property = properties[i];
        const char * name = property_getName(property);
        [propertyNames addObject:[NSString stringWithUTF8String:name]];
    }
    free(properties);
    
    return propertyNames;
}

- (SEL)setterForPropertyName:(NSString *)property
{
    NSMutableString *name = [property mutableCopy];
    NSString *firstChar = [name substringToIndex:1];
    [name replaceCharactersInRange:NSMakeRange(0, 1) withString:[firstChar uppercaseString]];
    [name insertString:@"set" atIndex:0];
    [name appendString:@":"];
    return NSSelectorFromString(name);
}

- (NSInteger)daysBetweenDate:(NSDate *)firstDate andDate:(NSDate *)secondDate
{
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [currentCalendar components:NSDayCalendarUnit fromDate:firstDate
                                                        toDate:secondDate options:0];
    NSInteger days = [components day];
    return days;
}

/*
 self.thumbnailSrc = [properties objectForKey:@"thumbnailSrc"];
 self.linkSrc = [properties objectForKey:@"linkSrc"];
 
 self.boardID = [properties objectForKey:@"boardID"];
 self.petType = [properties objectForKey:@"petType"];
 self.sex = [properties objectForKey:@"sex"];
 self.foundLocation = [properties objectForKey:@"foundLocation"];
 self.date = [properties objectForKey:@"date"];
 self.detail = [properties objectForKey:@"detail"];
 self.state = [properties objectForKey:@"state"];
 self.imageSrc = [properties objectForKey:@"imageSrc"];
 self.color = [properties objectForKey:@"color"];
 self.year = [properties objectForKey:@"year"];
 self.weight = [properties objectForKey:@"weight"];
 self.districtOffice = [properties objectForKey:@"districtOffice"];
 self.centerName = [properties objectForKey:@"centerName"];
 self.centerTel = [properties objectForKey:@"centerTel"];
 self.centerLocation = [properties objectForKey:@"centerLocation"];
 */

@end
