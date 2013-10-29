//
//  CLLocation+Helper.m
//  RealtimeLocation
//
//  Created by Luca Bernardi on 21/02/13.
//  Copyright (c) 2013 Luca Bernardi. All rights reserved.
//

#import "CLLocation+Helper.h"
#import "CLLocationToNSDictionaryTransformer.h"

@implementation CLLocation (Helper)

+ (instancetype)locationFromDictionaryRepresentation:(NSDictionary *)dictionaryRepresentation
{
    NSValueTransformer *locationTransformer = [NSValueTransformer valueTransformerForName:CLLocationToNSDictionaryTransformerName];
    CLLocation *location = [locationTransformer reverseTransformedValue:dictionaryRepresentation];
    return location;
}

- (NSDictionary *)dictionaryRepresentation
{
    NSValueTransformer *locationTransformer = [NSValueTransformer valueTransformerForName:CLLocationToNSDictionaryTransformerName];
    NSDictionary *dict = [locationTransformer transformedValue:self];
    return dict;
}

- (NSString *)latitudeString
{
    return [NSString stringWithFormat:@"%lf", self.coordinate.latitude];
}

- (NSNumber *)latitudeNumber
{
    return [NSNumber numberWithDouble:self.coordinate.latitude];
}

- (NSString *)longitudeString
{
    return [NSString stringWithFormat:@"%lf", self.coordinate.longitude];    
}

- (NSNumber *)longitudeNumber
{
    return [NSNumber numberWithDouble:self.coordinate.longitude];
}

@end
