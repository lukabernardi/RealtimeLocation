//
//  CLLocationToNSDictionaryTransformer.m
//  RealtimeLocation
//
//  Created by Luca Bernardi on 17/05/13.
//  Copyright (c) 2013 Luca Bernardi. All rights reserved.
//

#import "CLLocationToNSDictionaryTransformer.h"
#import <CoreLocation/CoreLocation.h>
#import "CLLocation+Helper.h"

NSString * const CLLocationToNSDictionaryTransformerName = @"CLLocationToNSDictionaryTransformer";

@implementation CLLocationToNSDictionaryTransformer

+ (void)initialize
{
    [NSValueTransformer setValueTransformer:[[CLLocationToNSDictionaryTransformer alloc] init]
                                    forName:CLLocationToNSDictionaryTransformerName];
}

+ (Class)transformedValueClass
{
    return [NSDictionary class];
}

+ (BOOL)allowsReverseTransformation
{
    return YES;
}

- (id)transformedValue:(id)value
{
    if (value && [value isKindOfClass:[CLLocation class]]) {
        NSDictionary *coordinateDict = @{
                                         @"latitude"  : [(CLLocation *)value latitudeNumber],
                                         @"longitude" : [(CLLocation *)value longitudeNumber],
                                         };
        NSDictionary *locationDict = @{ @"coordinate" : coordinateDict};
        return locationDict;
    }
    return nil;
}

- (id)reverseTransformedValue:(id)value
{
    if (value && [value isKindOfClass:[NSDictionary class]]) {
        NSNumber *latitude  = [value valueForKeyPath:@"coordinate.latitude"];
        NSNumber *longitude = [value valueForKeyPath:@"coordinate.longitude"];
        
        if (latitude && longitude) {
            CLLocationDegrees latitudeDegree  = [latitude doubleValue];
            CLLocationDegrees longitudeDegree = [longitude doubleValue];
            
            CLLocation *location = [[CLLocation alloc] initWithLatitude:latitudeDegree longitude:longitudeDegree];
            return location;
        }
    }
    return nil;
}

@end
