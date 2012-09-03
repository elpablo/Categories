//
//  NSDateFormatter+UTC.m
//  NSDateFormatter (Helper)
//
//  Created by Paolo Quadrani on 02/09/12.
//  Copyright (c) 2012 Paolo Quadrani. All rights reserved.
//

#import "NSDateFormatter+UTC.h"

@implementation NSDateFormatter (Helper)

- (NSDate *)dateFromStringUTC:(NSString *)dateStr utcFormat:(NSString *)format
{
    if ([dateStr length] < 19) {
        return nil;
    }
    
    [self setTimeZone:[self timezoneFromString:dateStr]];
    [self setDateFormat:(format == nil) ? @"yyyy-MM-dd'T'HH:mm:ss" : format];
//    return [self dateFromString:([dateStr length] == 19) ? dateStr : [dateStr substringToIndex:19]];
    return [self dateFromString:[[dateStr stringByReplacingOccurrencesOfString:@" " withString:@""] substringToIndex:19]];
}

- (NSTimeZone *)timezoneFromString:(NSString *)dateStr
{
    // length == 5                  => the passed string is considere the time-zone itself (eg. +0200)
    // length != 5 && length == 24  => the passed string is a full date with time-zone (eg. 2012-09-02T19:00:00-0700)
    // in all the other cases the passed string doesn't represent a UTC date or time-zome string so the system time-zone is returned as default.
    if ([dateStr length] != 5 && [dateStr length] < 24) {
        return [NSTimeZone systemTimeZone];
    }
    NSString *GMTString      = [dateStr substringFromIndex:[dateStr length]-5];
    NSInteger hoursFromGMT   = [[GMTString substringToIndex:3] intValue];
    NSInteger minutesFromGMT = [[GMTString substringFromIndex:3] intValue];
    NSInteger secondsFromGMT = (hoursFromGMT * 60 * 60) + (minutesFromGMT * 60);
    return [NSTimeZone timeZoneForSecondsFromGMT:secondsFromGMT];
}

@end
