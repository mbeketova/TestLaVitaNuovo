//
//  PVMapOverlay.m
//  MoscowZoo
//
//  Created by Admin on 13.08.15.
//  Copyright (c) 2015 Mariya Beketova. All rights reserved.
//

#import "PVMapOverlay.h"
#import "PVOldTerritory.h"



@implementation PVMapOverlay

@synthesize coordinate;
@synthesize boundingMapRect;

- (instancetype)initWithPark:(PVOldTerritory *)park {
    self = [super init];
    if (self) {
        boundingMapRect = park.overlayBoundingMapRect;
        coordinate = park.midCoordinate;
    }
    
    return self;
}



@end
