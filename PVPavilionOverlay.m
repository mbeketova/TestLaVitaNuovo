//
//  PVPavilionOverlay.m
//  TestLaVitaNuovo
//
//  Created by Admin on 15.08.15.
//  Copyright (c) 2015 Mariya Beketova. All rights reserved.
//

#import "PVPavilionOverlay.h"
#import "PVPaviion.h"

@implementation PVPavilionOverlay

@synthesize coordinate;
@synthesize boundingMapRect;


- (instancetype)initWithPavilion:(PVPaviion *)park{
    self = [super init];
    if (self) {
        boundingMapRect = park.overlayBoundingMapRect;
        coordinate = park.midCoordinate;

    }
    
    return self;
}

@end
