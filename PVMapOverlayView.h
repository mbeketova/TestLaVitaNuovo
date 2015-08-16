//
//  PVMapOverlayView.h
//  MoscowZoo
//
//  Created by Admin on 13.08.15.
//  Copyright (c) 2015 Mariya Beketova. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface PVMapOverlayView : MKOverlayRenderer

- (instancetype)initWithOverlay:(id<MKOverlay>)overlay overlayImage:(UIImage *)overlayImage;

@end
