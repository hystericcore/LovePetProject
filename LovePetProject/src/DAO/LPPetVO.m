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
            NSString *value = [properties objectForKey:key];
            [self performSelector:[self setterForPropertyName:key] withObject:value];
        }
    }
    return self;
}

- (void)resetLeftDay
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *nowDate = [[NSDate alloc] init];
    NSDate *dayDate = [dateFormat dateFromString:self.date];
    
    NSInteger leftDay = 10 - [self daysBetweenDate:dayDate andDate:nowDate];
    
    self.leftDay = [NSString stringWithFormat:@"day-%d", leftDay];
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
    [name replaceCharactersInRange:NSMakeRange(0, 1)
                        withString:[firstChar uppercaseString]];
    [name insertString:@"set" atIndex:0];
    [name appendString:@":"];
    return NSSelectorFromString(name);
}

- (NSInteger)daysBetweenDate:(NSDate *)firstDate andDate:(NSDate *)secondDate
{
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [currentCalendar components: NSDayCalendarUnit fromDate: firstDate toDate: secondDate options: 0];
    NSInteger days = [components day];
    return days;
}

@end
