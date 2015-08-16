
//
//  PVPaviion.m
//  TestLaVitaNuovo
//
//  Created by Admin on 15.08.15.
//  Copyright (c) 2015 Mariya Beketova. All rights reserved.
//

#import "PVPaviion.h"
#import "ArrayPavilion.h"


@implementation PVPaviion

- (instancetype)initIndex:(int)index {
    self = [super init];
    if (self) {
        
            //добавление оверлея каждого павильона
            NSMutableArray * arrayPavilion = [ArrayPavilion makeExpositionNewTerritory];

            NSDictionary * dict = [arrayPavilion objectAtIndex:index];
            CLLocation * newLocation = [[CLLocation alloc] init];
            newLocation = [dict objectForKey:@"coord"];
            NSInteger wightPavilion = [[dict objectForKey:@"wight"]integerValue];
            NSInteger heightPavilion = [[dict objectForKey:@"height"]integerValue];
        
            //в дальнейшем для привязки углов каждого прямоугольника используем две координаты: центр прямоугольника и центр локации
            //основные расчеты в методе: scaleMeterPerPoint
            _midCoordinate = CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude);
            MKMapPoint midPoint = MKMapPointForCoordinate(_midCoordinate);
            //---------------------
            double scaleMeterPerPoint = [self scaleMeterPerPoint:newLocation MapPoint:midPoint];
            
            NSInteger wight = wightPavilion*scaleMeterPerPoint;
            NSInteger height = heightPavilion*scaleMeterPerPoint;
        
            //Расчет координат трех углов прямоугольника - на плоскости (экрана)
            double pointXTopLeft = (midPoint.x - height/2);
            double pointYTopLeft= (midPoint.y - wight/2);
            
            double pointXTopRight = (midPoint.x + height/2);
            double pointYTopRight = (midPoint.y - wight/2);
            
            double pointXBottomLeft = (midPoint.x - height/2);
            double pointYBottomLeft = (midPoint.y + wight/2);
            
            _overlayTopLeftCoordinate = CLLocationCoordinate2DMake([self makePointPerCoordinate:pointXTopLeft PointY:pointYTopLeft].latitude, [self makePointPerCoordinate:pointXTopLeft PointY:pointYTopLeft].longitude);
            
            _overlayTopRightCoordinate = CLLocationCoordinate2DMake([self makePointPerCoordinate:pointXTopRight PointY:pointYTopRight].latitude, [self makePointPerCoordinate:pointXTopRight PointY:pointYTopRight].longitude);
            
            _overlayBottomLeftCoordinate = CLLocationCoordinate2DMake([self makePointPerCoordinate:pointXBottomLeft PointY:pointYBottomLeft].latitude, [self makePointPerCoordinate:pointXBottomLeft PointY:pointYBottomLeft].longitude);
            
   
     }
    
   return self;
}


- (CLLocationCoordinate2D)overlayBottomRightCoordinate {
    //определение координат четвертого угла по трем уже известным
    return CLLocationCoordinate2DMake(self.overlayBottomLeftCoordinate.latitude, self.overlayTopRightCoordinate.longitude);
}

- (MKMapRect)overlayBoundingMapRect {
    
    MKMapPoint topLeft = MKMapPointForCoordinate(self.overlayTopLeftCoordinate);
    MKMapPoint topRight = MKMapPointForCoordinate(self.overlayTopRightCoordinate);
    MKMapPoint bottomLeft = MKMapPointForCoordinate(self.overlayBottomLeftCoordinate);
    
    return MKMapRectMake(topLeft.x,
                         topLeft.y,
                         fabs(topLeft.x - topRight.x),
                         fabs(topLeft.y - bottomLeft.y));
}

- (float) scaleMeterPerPoint:(CLLocation*)newLocation MapPoint:(MKMapPoint) midPoint{
    //в данном методе расчитываем сколько метров в точке экрана
    //для расчета использовала точки: центра локации и любой точки из массива
    CLLocation * centerLocation = [[CLLocation alloc] initWithLatitude:55.762452 longitude:37.582119];
    //переводим обе точки в плоскую систему координат (на экране)
    _centerLocation2D = CLLocationCoordinate2DMake(centerLocation.coordinate.latitude, centerLocation.coordinate.longitude);
    MKMapPoint centLocationPoin = MKMapPointForCoordinate(_centerLocation2D);
    //расчитываем расстояние между точками в метрах (какое между ними расстояние в мире, а не на карте/экране):
    float betweenDistance2=[newLocation distanceFromLocation:centerLocation];
    //далее, используя теорему Пифагора - находим расстояние между точками на плоскости:
    double x = ((midPoint.x - centLocationPoin.x)*(midPoint.x - centLocationPoin.x) + (midPoint.y - centLocationPoin.y)*(midPoint.y - centLocationPoin.y) );
    double  distancePoint = sqrt(x);
    //получаем: сколько метров в точке экрана:
    float scaleMeterPerPoint = distancePoint/betweenDistance2;
    return scaleMeterPerPoint;
}

- (CLLocationCoordinate2D) makePointPerCoordinate: (double)pointX PointY:(double)pointY{
    //конвертируем координаты обратно в гегорафические широту и долготу
    MKMapPoint point= MKMapPointMake(pointX, pointY);
    CLLocationCoordinate2D pointCoordinate = MKCoordinateForMapPoint (point);
    return pointCoordinate;
}


@end
