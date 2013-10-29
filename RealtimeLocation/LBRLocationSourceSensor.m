//
//  LBRLocationSourceSensor.m
//  RealtimeLocation
//
//  Created by Luca Bernardi on 14/10/13.
//  Copyright (c) 2013 Luca Bernardi. All rights reserved.
//

#import "LBRLocationSourceSensor.h"

@interface LBRLocationSourceSensor () <CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *lastLocationSent;
@end


@implementation LBRLocationSourceSensor

#pragma mark - LBRLocationSource

- (void)startUpdatingLocation
{
    if (nil == self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
    }
    
    self.locationManager.delegate           = self;
    self.locationManager.desiredAccuracy    = kCLLocationAccuracyBest;
    self.lastLocationSent                   = nil;
    
    [self.locationManager startUpdatingLocation];
}

- (void)stopUpdatingLocation
{
    [self.locationManager stopUpdatingLocation];
    self.lastLocationSent = nil;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    CLLocation *lastLocation = [locations lastObject];
    [self handleNewLocation:lastLocation];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    DDLogError(@"[Location Source] Error: %@", error);
    
    if (self.callbackBlock) {
        self.callbackBlock(nil, error);
    }
}

#pragma mark - Private

/**
 Handle a new location and if necessary it will dispatch it
 
 @param location the new location received from the `CLLocationManager`
 
 @discussion The new location is sent according to the following logic:
 
 If it's the first location event the location is dispatched if
 it's not older than 5 minutes and at least 800 meters accurate.
 
 Otherwise if the new location:
 - is not older than 15 second (that means that is not from the cache)
 - is sufficient accurate
 In order to prevent a flood of checking I will send a new checkin
 if and only if the new location is more accurate or far enough in time
 comparing to the previously sent location
 
 */
- (void)handleNewLocation:(CLLocation *)location
{
    
    float kCutoffSeconds                = 5.0 * 60;
    float kMinimumDistanceInTime        = 3.0f;
    CLLocationAccuracy kCutoffAccurancy = 800;
    
    NSTimeInterval howOld = [location.timestamp timeIntervalSinceNow];
    
    BOOL isRecent        = (abs(howOld) < kCutoffSeconds);
    BOOL isAccurate      = (location.horizontalAccuracy <= kCutoffAccurancy);
    BOOL isMoreAccurate  = YES;
    BOOL isDistantInTime = YES;
    
    if (self.lastLocationSent) {
        isMoreAccurate = abs(location.horizontalAccuracy) < abs(self.lastLocationSent.horizontalAccuracy);
        NSTimeInterval timeDifference = [location.timestamp timeIntervalSinceDate:self.lastLocationSent.timestamp];
        isDistantInTime = (timeDifference > kMinimumDistanceInTime);
    }
    
    /*
     DDLogInfo(@"[LocationManager] R:%@ && A:%@ && (mA:%@ || DiT:%@)",
     isRecent          ? @"YES" : @"NO",
     isAccurate        ? @"YES" : @"NO",
     isMoreAccurate    ? @"YES" : @"NO",
     isDistantInTime   ? @"YES" : @"NO");
     */
    
    if (isRecent
        && isAccurate
        && (isMoreAccurate || isDistantInTime)) {
        
        self.lastLocationSent = location;
        if (self.callbackBlock) {
            self.callbackBlock(location, nil);
        }
    }
}

@end
