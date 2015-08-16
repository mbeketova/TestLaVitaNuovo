//
//  PVOldTerritory.h
//  MoscowZoo
//
//  Created by Admin on 13.08.15.
//  Copyright (c) 2015 Mariya Beketova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface PVOldTerritory : NSObject

@property (nonatomic, readonly) CLLocationCoordinate2D *boundary;
@property (nonatomic, readonly) NSInteger boundaryPointsCount;

@property (nonatomic, readonly) CLLocationCoordinate2D midCoordinate;
@property (nonatomic, readonly) CLLocationCoordinate2D overlayTopLeftCoordinate;
@property (nonatomic, readonly) CLLocationCoordinate2D overlayTopRightCoordinate;
@property (nonatomic, readonly) CLLocationCoordinate2D overlayBottomLeftCoordinate;
@property (nonatomic, readonly) CLLocationCoordinate2D overlayBottomRightCoordinate;

@property (nonatomic, readonly) MKMapRect overlayBoundingMapRect;

@property (nonatomic, strong) NSString *name;

- (instancetype)initWithFilename:(NSString *)filename;

@end
