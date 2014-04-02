//
//  CLLocation+Extras.h
//  CLLocation (Helper)
//
//  Created by Paolo Quadrani on 02/03/14.
//  Copyright (c) 2014 Paolo Quadrani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface CLLocation (Helper)

/// Returns the latitude formatted as string using 6 decimal digits
- (NSString *)latitudeAsString;

/// Returns the longitude formatted as string using 6 decimal digits
- (NSString *)longitudeAsString;

/// Returns the altitude formatted as string using 2 decimal digits
- (NSString *)altitudeAsString;

@end
