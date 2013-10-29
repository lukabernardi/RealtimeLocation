//
//  LBRLocationSource.h
//  RealtimeLocation
//
//  Created by Luca Bernardi on 14/10/13.
//  Copyright (c) 2013 Luca Bernardi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


typedef void(^LBRLocationSourceLocationUpdateCallback)(CLLocation *location, NSError *error);


@interface LBRLocationSource : NSObject

@property (nonatomic, copy, readonly) LBRLocationSourceLocationUpdateCallback callbackBlock;

- (void)startUpdatingLocation;
- (void)stopUpdatingLocation;
- (void)registerLocationUpdateCallback:(LBRLocationSourceLocationUpdateCallback)callbackBlock;

@end
