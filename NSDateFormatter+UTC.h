//
//  NSDateFormatter+UTC.h
//  NSDateFormatter (Helper)
//
//  Created by Paolo Quadrani on 02/09/12.
//  Copyright (c) 2012 Paolo Quadrani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (Helper)

/** 
 Return a NSDate instance from the string representation formatted as UTC date (containing the time-zone). 
 It assign also a date format to process the UTC date.
 */
- (NSDate *)dateFromStringUTC:(NSString *)dateStr utcFormat:(NSString *)format;

/// Pass a full date as string containing the time-zone information or the time-zone string.
- (NSTimeZone *)timezoneFromString:(NSString *)dateStr;

/// Return a NSDate instance starting from a date represented as string and given format.
- (NSDate *)dateFromString:(NSString *)dateStr withFormat:(NSString *)format;

@end
