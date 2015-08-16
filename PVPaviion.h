//
//  PVPaviion.h
//  TestLaVitaNuovo
//
//  Created by Admin on 15.08.15.
//  Copyright (c) 2015 Mariya Beketova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface PVPaviion : NSObject

@property (nonatomic, readonly) CLLocationCoordinate2D midCoordinate;
@property (nonatomic, readonly) CLLocationCoordinate2D centerLocation2D;
@property (nonatomic, readonly) CLLocationCoordinate2D overlayTopLeftCoordinate;
@property (nonatomic, readonly) CLLocationCoordinate2D overlayTopRightCoordinate;
@property (nonatomic, readonly) CLLocationCoordinate2D overlayBottomLeftCoordinate;
@property (nonatomic, readonly) CLLocationCoordinate2D overlayBottomRightCoordinate;
@property (nonatomic, readonly) NSMutableArray * arrayOverlay;

@property (nonatomic, readonly) MKMapRect overlayBoundingMapRect;


- (instancetype)initIndex:(int)index ;
@end
