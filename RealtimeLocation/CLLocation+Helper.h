//
//  CLLocation+Helper.m
//  RealtimeLocation
//
//  Created by Luca Bernardi on 21/02/13.
//  Copyright (c) 2013 Luca Bernardi. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>


@interface CLLocation (Helper)

+ (instancetype)locationFromDictionaryRepresentation:(NSDictionary *)dictionaryRepresentation;
- (NSDictionary *)dictionaryRepresentation;

- (NSString *)latitudeString;
- (NSString *)longitudeString;
- (NSNumber *)latitudeNumber;
- (NSNumber *)longitudeNumber;

@end
