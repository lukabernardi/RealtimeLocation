//
//  LBRRandomWalker.m
//  RealtimeLocation
//
//  Created by Luca Bernardi on 17/10/13.
//  Copyright (c) 2013 Luca Bernardi. All rights reserved.
//

#import "LBRRandomWalker.h"
#import <CoreLocation/CoreLocation.h>

/** 
 The defaul step size is around 300m
 
 this is an aproximation since the real degree-to-meter depends
 on the actual latitude/longitude, 
 for our purpose we can aproximate given that, on avarage, 1˚ ~= 111Km
 */
CLLocationDegrees const kRandomWalkerStepSizeDefault = 0.0027;


@interface LBRRandomWalker ()
@property (nonatomic, strong) CLLocation *currentLocation;
@end


@implementation LBRRandomWalker

- (instancetype)initWithInitialLocation:(CLLocation *)initialLocation
{
    self = [super init];
    if (self) {
        self.currentLocation = initialLocation;
    }
    return self;
}

- (CLLocation *)step
{
    CLLocationCoordinate2D coordinate = self.currentLocation.coordinate;
    NSInteger stepX = ((NSInteger) arc4random_uniform(3)) - 1;
    NSInteger stepY = ((NSInteger) arc4random_uniform(3)) - 1;
    CLLocationDegrees newLatitude  = coordinate.latitude  + (stepX * kRandomWalkerStepSizeDefault);
    CLLocationDegrees newLongitude = coordinate.longitude + (stepY * kRandomWalkerStepSizeDefault);
    CLLocation *step = [[CLLocation alloc] initWithLatitude:newLatitude
                                                  longitude:newLongitude];
    self.currentLocation = step;
    return step;
}

@end
