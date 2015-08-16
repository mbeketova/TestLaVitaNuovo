//
//  PVMapOverlay.h
//  MoscowZoo
//
//  Created by Admin on 13.08.15.
//  Copyright (c) 2015 Mariya Beketova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class PVOldTerritory;


@interface PVMapOverlay : NSObject <MKOverlay>

- (instancetype)initWithPark:(PVOldTerritory *)park;


@end
