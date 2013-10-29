//
//  LBRLocationBroker.m
//  RealtimeLocation
//
//  Created by Luca Bernardi on 24/10/13.
//  Copyright (c) 2013 Luca Bernardi. All rights reserved.
//

#import "LBRLocationBroker.h"

#import <AZSocketIO/AZSocketIO.h>
#import "LBRLocationSource.h"
#import "CLLocation+Helper.h"

static void * LBRLocationBrokerStateContext = &LBRLocationBrokerStateContext;
static NSString * const kStateKeyPath = @"state";

static NSString * const kLocationServerHost  = @"Lucas-MacBook-Pro-Retina.local";
static NSInteger  const kLocationServerPort  = 424242;

static NSString * const kEventLocationUpdate       = @"location_update";
static NSString * const kEventLocationNotification = @"location_notification";

static NSString * const kEventDataIDKey         = @"id";
static NSString * const kEventDataCoordinateKey = @"coordinate";


@interface LBRLocationBroker ()
@property (nonatomic, strong) AZSocketIO *socketIO;
@property (nonatomic, strong) LBRLocationSource *locationSource;
@end


@implementation LBRLocationBroker

#pragma mark - Init & Dealloc

- (instancetype)initWithLocationSource:(LBRLocationSource *)locationSource
                           updateBlock:(LBRLocationBrokerUpdateBlock)updateBlock;
{
    self = [self init];
    if (self) {
        self.locationSource = locationSource;
        
        __weak typeof(self) weakSelf = self;
        [self.locationSource registerLocationUpdateCallback:^(CLLocation *location, NSError *error) {
            if (location) {
                [weakSelf dispatchLocation:location];
            } else {
                DDLogError(@"[Location Broker] Error while retriving location: %@", error);
            }
        }];
        
        [self.socketIO addCallbackForEventName:kEventLocationNotification
                                      callback:^(NSString *eventName, id data) {
                                          NSString *sessionID = data[0][kEventDataIDKey];
                                          CLLocation *location = [CLLocation locationFromDictionaryRepresentation:data[0][kEventDataCoordinateKey]];
                                          if (updateBlock) {
                                              updateBlock(sessionID, location);
                                          }
                                      }];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.socketIO = [[AZSocketIO alloc] initWithHost:kLocationServerHost
                                                 andPort:[NSString stringWithFormat:@"%ld", (long)kLocationServerPort]
                                                  secure:NO];
        
        [self.socketIO addObserver:self
                        forKeyPath:kStateKeyPath
                           options:0
                           context:LBRLocationBrokerStateContext];
        
    }
    return self;
}

- (void)dealloc
{
    [self.socketIO removeObserver:self
                       forKeyPath:kStateKeyPath
                          context:LBRLocationBrokerStateContext];
}

#pragma mark - API

- (void)start
{
    __weak __block typeof(self) weakSelf = self;
    [self.socketIO connectWithSuccess:^{
        DDLogInfo(@"[Location Broker] Connected with sessionID: %@", _socketIO.sessionId);
        [weakSelf.locationSource startUpdatingLocation];
    } andFailure:^(NSError *error) {
        DDLogInfo(@"[Location Broker] Disconnected sesssionID: %@", _socketIO.sessionId);
    }];
}

- (void)stop
{
    [self.locationSource registerLocationUpdateCallback:nil];
    [self.locationSource stopUpdatingLocation];
    [self.socketIO disconnect];
}

#pragma mark - Private

- (void)dispatchLocation:(CLLocation *)location
{
    NSError *error = nil;
    NSDictionary *args = @{
                           kEventDataIDKey         : self.socketIO.sessionId ,
                           kEventDataCoordinateKey : [location dictionaryRepresentation]
                           };
    
    BOOL success = [self.socketIO emit:kEventLocationUpdate
                                  args:args
                                 error:&error];
    if (success == NO) {
        DDLogError(@"[Location Broker] Error while emitting `%@` event: %@", kEventLocationUpdate, error);
    }
}

- (BOOL)isRunning
{
    return (self.socketIO.state == AZSocketIOStateConnected);
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (context == LBRLocationBrokerStateContext) {
        if ([keyPath isEqualToString:kStateKeyPath]) {
            if (self.statusChangeBlock) {
                self.statusChangeBlock(self.isRunning);
            }
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
@end
