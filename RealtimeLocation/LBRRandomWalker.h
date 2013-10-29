//
//  LBRRandomWalker.h
//  RealtimeLocation
//
//  Created by Luca Bernardi on 17/10/13.
//  Copyright (c) 2013 Luca Bernardi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLLocation;


@interface LBRRandomWalker : NSObject

- (instancetype)initWithInitialLocation:(CLLocation *)location;
- (CLLocation *)step;

@end
