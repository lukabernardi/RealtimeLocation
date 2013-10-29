//
//  LBRLocationSourceCanned.m
//  RealtimeLocation
//
//  Created by Luca Bernardi on 14/10/13.
//  Copyright (c) 2013 Luca Bernardi. All rights reserved.
//

#import "LBRLocationSourceCanned.h"
#import "LBRRandomWalker.h"

NSTimeInterval const kLocationEventPerSecondDefault = 1;

@interface LBRLocationSourceCanned ()
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) LBRRandomWalker *randomWalker;
@end


@implementation LBRLocationSourceCanned

- (instancetype)initWithInitialLocation:(CLLocation *)location
{
    self = [super init];
    if (self) {
        self.randomWalker = [[LBRRandomWalker alloc] initWithInitialLocation:location];
    }
    return self;
}

- (void)startUpdatingLocation
{
    [self startTimer];
}

- (void)stopUpdatingLocation
{
    [self stopTimer];
}

#pragma mark - Private

- (void)startTimer
{
    [self stopTimer];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:kLocationEventPerSecondDefault
                                                  target:self
                                                selector:@selector(handleTimerTick)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)stopTimer
{
    if ([self.timer isValid]) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)handleTimerTick
{
    CLLocation *randomLocation = [self.randomWalker step];
    if (self.callbackBlock) {
        self.callbackBlock(randomLocation, nil);
    }
}

@end
