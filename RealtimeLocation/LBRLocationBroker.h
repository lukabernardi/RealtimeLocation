//
//  LBRLocationBroker.h
//  RealtimeLocation
//
//  Created by Luca Bernardi on 24/10/13.
//  Copyright (c) 2013 Luca Bernardi. All rights reserved.
//

#import <Foundation/Foundation.h>


@class LBRLocationSource;
@class CLLocation;

typedef void(^LBRLocationBrokerUpdateBlock)(NSString *sessionID, CLLocation *location);
typedef void(^LBRLocationBrokerStatusChangeBlock)(BOOL running);


@interface LBRLocationBroker : NSObject

@property (nonatomic, assign, readonly) BOOL isRunning;
@property (nonatomic, copy) LBRLocationBrokerStatusChangeBlock statusChangeBlock;

- (instancetype)initWithLocationSource:(LBRLocationSource *)locationSource
                           updateBlock:(LBRLocationBrokerUpdateBlock)updateBlock;
- (void)start;
- (void)stop;

@end
