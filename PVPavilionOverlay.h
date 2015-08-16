//
//  PVPavilionOverlay.h
//  TestLaVitaNuovo
//
//  Created by Admin on 15.08.15.
//  Copyright (c) 2015 Mariya Beketova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class PVPaviion;

@interface PVPavilionOverlay : NSObject <MKOverlay>

- (instancetype)initWithPavilion:(PVPaviion *)park;

@end
