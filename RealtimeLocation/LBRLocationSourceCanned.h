//
//  LBRLocationSourceCanned.h
//  RealtimeLocation
//
//  Created by Luca Bernardi on 14/10/13.
//  Copyright (c) 2013 Luca Bernardi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LBRLocationSource.h"

@interface LBRLocationSourceCanned : LBRLocationSource
- (instancetype)initWithInitialLocation:(CLLocation *)location;
@end
