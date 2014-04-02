//
//  NSDateFormatter+UTC.m
//  NSDateFormatter (Helper)
//
//  Created by Paolo Quadrani on 02/09/12.
//  Copyright (c) 2014 Paolo Quadrani. All rights reserved.
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
    NSDate *d = [self dateFromString:[[dateStr stringByReplacingOccurrencesOfString:@" " withString:@""] substringToIndex:19]];
    return d;
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

- (NSDate *)dateFromString:(NSString *)dateStr withFormat:(NSString *)format
{
    NSString *oldFormat = self.dateFormat;
    self.dateFormat = format;
    NSDate *d = [self dateFromString:dateStr];
    if (oldFormat) {
        self.dateFormat = oldFormat;
    }
    return d;
}

static NSDateFormatter *sRFC3339DateFormatter = nil;

+ (NSString *)rfc3339DateFormatAsString:(NSDate *)date
{
    if (sRFC3339DateFormatter == nil) {
        sRFC3339DateFormatter = [[NSDateFormatter alloc] init];
        NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        
        [sRFC3339DateFormatter setLocale:enUSPOSIXLocale];
        [sRFC3339DateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
        [sRFC3339DateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    }
    return [sRFC3339DateFormatter stringFromDate:date];
}

@end
