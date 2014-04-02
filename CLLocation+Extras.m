//
//  CLLocation+Extras.m
//  CLLocation (Helper)
//
//  Created by Paolo Quadrani on 02/03/14.
//  Copyright (c) 2014 Paolo Quadrani. All rights reserved.
//

#import "CLLocation+Extras.h"

@implementation CLLocation (Helper)

- (NSString *)latitudeAsString
{
    return [NSString stringWithFormat:@"%.6f", self.coordinate.latitude];
}

- (NSString *)longitudeAsString
{
    return [NSString stringWithFormat:@"%.6f", self.coordinate.longitude];
}

- (NSString *)altitudeAsString
{
    return [NSString stringWithFormat:@"%.2f", self.altitude];
}

@end
