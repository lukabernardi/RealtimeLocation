//
//  LBRLocationSource.m
//  RealtimeLocation
//
//  Created by Luca Bernardi on 14/10/13.
//  Copyright (c) 2013 Luca Bernardi. All rights reserved.
//

#import "LBRLocationSource.h"

@interface LBRLocationSource ()
@property (nonatomic, copy) LBRLocationSourceLocationUpdateCallback callbackBlock;
@end

@implementation LBRLocationSource

- (void)startUpdatingLocation {}

- (void)stopUpdatingLocation {}

- (void)registerLocationUpdateCallback:(LBRLocationSourceLocationUpdateCallback)callbackBlock
{
    self.callbackBlock = callbackBlock;
}

@end
