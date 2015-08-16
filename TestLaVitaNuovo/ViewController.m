//
//  ViewController.m
//  TestLaVitaNuovo
//
//  Created by Admin on 14.08.15.
//  Copyright (c) 2015 Mariya Beketova. All rights reserved.
//


#import "ViewController.h"
#import "PVOldTerritory.h"
#import "PVMapOverlay.h"
#import "PVMapOverlayView.h"
#import "ArrayPavilion.h"
#import "PVPaviion.h"
#import "PVPavilionOverlay.h"
#import "Animations.h"

#define DISTANSE_CAMERA 400
#define CHANGE_TAB 140


/*
 //-----------------
 Условие:
 В качестве тестового задания необходимо реализовать, карту павильонов на выставке.
 Таким образом, что бы на ней можно было показать расположение большого количества
 павильонов. Выбрать расположение определенного павильона на карте. По клику
 определить какой павильон находится в данной точке.
 Задание:
 Дано n - количество павильонов. У каждого павильона есть поля:
 - название
 - position x
 - position y
 - width
 - height
 Где x, y, width, height - определяют размеры и расположение прямоугольника на карте.
 Дано схематическое изображение карты павильонов в виде картинки (*.png).
 Необходимо:
 1. Масштабировать изображение в с картой свайпом двух пальцев.
 2. Показать расположение отдельно выбранного павильона.
 3. При клике на карту показывать располагающийся в данном месте павильон.
 
 //-----------------
 
 Реализация:
 Т.к. в задании не были даные конкретные координаты, картинка и размеры, поэтому я использовала ресурсы из своего проекта по Московскому Зоопарку. 
 (схема локации, граница локации и координаты всех объектов)
 Картинку для прямоугольника (павильона) - использовала обычный квадрат, который и вписывала по координате центра, ширине и высоте.
 Для реализации в классе: ArrayPavilion - оставила только 3 координаты для павильонов (для наглядности - установила у них разные размеры). В принципе, можно было как и в случае с координатами схемы использовать файл .plist.
 Кроме жеста longPress, добавила в проект таблицу и кнопку. По выбору объекта он размещается по центру карты. 
 Расчеты по координатам павильона реализован в классе: PVPavilion.
 
 На реализацию тестового задания ушло примерно 1,5 дня.
 
 //------------------
 
 */



@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *viewMap;
@property (weak, nonatomic) IBOutlet UIView *viewTable;
@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIButton *buttonShowMap;
@property (weak, nonatomic) IBOutlet UIButton *buttonHidenMap;
@property (nonatomic, strong) CLLocationManager * locationManager;
@property (strong, nonatomic) NSMutableArray * arrayPavilion;
@property (assign, nonatomic) NSInteger wight;
@property (assign, nonatomic) NSInteger height;
@property (nonatomic, strong) PVOldTerritory * parkZOO;
@property (nonatomic, strong) PVPaviion * pavilion;
@property (nonatomic, strong) NSMutableArray *selectedOptions;

- (IBAction)longPress:(UILongPressGestureRecognizer *)sender;
@property (nonatomic, strong) UILongPressGestureRecognizer* longPress;

@property (nonatomic, assign) BOOL isTable;
@end

@implementation ViewController{
    BOOL isCurrentLocation;
}

- (void) firstStart {
    //метод, который срабатывает один раз при первом запуске, если версия IOS = 8, или выше.
    NSString * ver = [[UIDevice currentDevice]systemVersion];
    
    if ([ver intValue] >=8) {
        [self.locationManager requestAlwaysAuthorization];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FirstStart"];
    }
    
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.isTable = NO;
    
    self.arrayPavilion = [[NSMutableArray alloc]init];
    self.arrayPavilion = [ArrayPavilion makeExpositionNewTerritory];
    
    [self.buttonShowMap addTarget:self action:@selector(action_ButtonShowTab) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonHidenMap addTarget:self action:@selector(action_ButtonHidenTab) forControlEvents:UIControlEventTouchUpInside];
    
    self.map.showsUserLocation = YES;
    self.locationManager = [[CLLocationManager alloc]init];
    [self.locationManager setDelegate:self];
    [self.locationManager startUpdatingLocation];
    
    //срабатывает только при первом запуске:
    BOOL isFirstStart = [[NSUserDefaults standardUserDefaults] boolForKey:@"FirstStart"];
    
    if (!isFirstStart) {
        [self firstStart];
    }
    

    isCurrentLocation = NO;
    [self setup_View];
    
}

- (void) setup_View {
    self.navigationController.navigationBar.hidden = YES;
    
    [Animations moveViewDown:self.viewTable Alpha:0 OriginY:CHANGE_TAB];
    
    //кнопка показать таблицу:
    
    self.buttonShowMap.layer.borderColor = [UIColor blueColor].CGColor;
    self.buttonShowMap.layer.borderWidth = 1.0;
    self.buttonShowMap.layer.cornerRadius = 3.0;
    self.buttonShowMap.backgroundColor = [UIColor lightGrayColor];
    
    //кнопка скрыть таблицу:
    self.buttonHidenMap.layer.borderColor = [UIColor blueColor].CGColor;
    self.buttonHidenMap.layer.borderWidth = 1.0;
    self.buttonHidenMap.layer.cornerRadius = 3.0;
    self.buttonHidenMap.backgroundColor = [UIColor darkGrayColor];
       
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    
    if (!isCurrentLocation) {
        isCurrentLocation = YES;
       newLocation = [[CLLocation alloc] initWithLatitude:55.762452 longitude:37.582119];
        //центр локации
        //указываем к каким координатом необходимо обратиться (из какого файла):
        self.selectedOptions = [NSMutableArray array];
        self.parkZOO = [[PVOldTerritory alloc] initWithFilename:@"MagicNewTerritory"];
        [self setupMapView:newLocation.coordinate];

    }
    
}

#pragma mark - MKMapViewDelegate protocol implementation


- (void) setupMapView: (CLLocationCoordinate2D) coord {
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, DISTANSE_CAMERA, DISTANSE_CAMERA);
    [self.map setRegion:region animated:YES];
    
    [self addOverlay];//добавление к карте картинки схемы
    [self addBoundary]; // добавление к карте границы (парка, выставки и т.д.)
    [self addOverlayPavilion]; //добавляем к карте Павильоны
    [self annotation_Plan]; //добавление к карте аннотаций

}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    //устанавливаем маркер на карту
    if (![annotation isKindOfClass:MKUserLocation.class]) {
        MKAnnotationView*annView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Annotation"];
        annView.canShowCallout = NO;
        [annView addSubview:[self get_CalloutView:annotation.title]];
        
        return annView;
        
    }
    
    return nil;
}

- (UIView*) get_CalloutView: (NSString*)title { // метод, который подписывает данные над маркером
  
    
    //создаем вью для вывода адреса:
    UIView * callView = [[UIView alloc]initWithFrame:CGRectMake(-120, -80, 120, 80)];
   
    callView.layer.borderColor = [UIColor whiteColor].CGColor;
    callView.layer.borderWidth = 1.0;
    callView.backgroundColor = [UIColor blackColor];
    callView.layer.cornerRadius = 5;
    callView.tag = 1000;

    
    //создаем лейбл для вывода адреса
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 80)];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter; //выравнивание по центру
    label.textColor = [UIColor whiteColor];
    label.text = title;
    label.font = [UIFont fontWithName: @"Arial" size: 10.0];
    [callView addSubview:label];
    
    
    [callView addSubview:label];
    if (!self.isTable) {
         callView.alpha = 0;
    }
   
    
    return callView;
    
    
}

- (void) annotation_Plan {
    //по координатам из массива устанавливаем аннотации
    for (int i = 0; i < self.arrayPavilion.count; i++) {
        NSDictionary * dict = [self.arrayPavilion objectAtIndex:i];
        CLLocation * newLocation = [[CLLocation alloc] init];
        newLocation = [dict objectForKey:@"coord"];
        self.wight = [[[self.arrayPavilion objectAtIndex:i]objectForKey:@"wight"] integerValue];
        self.height = [[[self.arrayPavilion objectAtIndex:i]objectForKey:@"height"] integerValue];
        
        CLGeocoder * geocoder = [[CLGeocoder alloc]init];
        [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            CLPlacemark * place = [placemarks objectAtIndex:0];
            //записываем адрес с индексом в NSString
            NSString * adressString = [[NSString alloc] initWithFormat:@"%@\n%@\nИндекс - %@", [place.addressDictionary valueForKey:@"City"], [place.addressDictionary valueForKey:@"Street"], [place.addressDictionary valueForKey:@"ZIP"]];
            
            MKPointAnnotation * annotation = [[MKPointAnnotation alloc]init];
            annotation.title = adressString;
            //
            annotation.coordinate = newLocation.coordinate;
            //по координатам и индексу показываем аннотацию на карте:
            [self.map addAnnotation:annotation]; //добавляем на карту аннотацию
        }];
    }
    
}

//--------------------------------------------------------------------------------------------------------------------------

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    //данный метод делает видимой вью с адресом при нажатии на маркер
    if (![view.annotation isKindOfClass:MKUserLocation.class]) {
        for (UIView * subView in view.subviews) {
            if (subView.tag == 1000) {
                subView.alpha = 1;
            }
        }
    }
    
}


- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    //данный метод делает невидимой вью с адресом при нажатии на другой элемент
    for (UIView * subView in view.subviews) {
        if (subView.tag == 1000) {
            subView.alpha = 0;
        }
    }
    
}

//--------------------------------------------------------------------------------------------------------------------------
#pragma mark - MKOverlay

- (void)addOverlay {
    [self.map removeAnnotations:self.map.annotations];
    [self.map removeOverlays:self.map.overlays];
    PVMapOverlay *overlay = [[PVMapOverlay alloc] initWithPark:self.parkZOO];
    [self.map addOverlay:overlay];
    
  
}

- (void)addOverlayPavilion {
    for (int i = 0; i < self.arrayPavilion.count; i++) {
        self.pavilion = [[PVPaviion alloc]initIndex:i];
        PVPavilionOverlay * overlay = [[PVPavilionOverlay alloc] initWithPavilion:self.pavilion];
        [self.map addOverlay:overlay];
    }

    
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    if ([overlay isKindOfClass:PVMapOverlay.class]) {
        //схема общая
        UIImage *magicZOOImage = [UIImage imageNamed:@"Skin_NewZOO"];
            PVMapOverlayView *overlayView = [[PVMapOverlayView alloc] initWithOverlay:overlay overlayImage:magicZOOImage];

        return overlayView;

    }
    
    else if ([overlay isKindOfClass:MKPolygon.class]) {
        //граница схемы
        MKPolygonRenderer *polygonView = [[MKPolygonRenderer alloc] initWithOverlay:overlay];
        polygonView.strokeColor = [UIColor blackColor];
        polygonView.lineWidth = 3;
        return polygonView;
    }
    
    else  if ([overlay isKindOfClass:PVPavilionOverlay.class]) {
        //картинка павильона
        UIImage *magicPavilion = [UIImage imageNamed:@"black (1).jpg"];
        PVMapOverlayView *overlayViewPavilion = [[PVMapOverlayView alloc] initWithOverlay:overlay overlayImage:magicPavilion];
        return overlayViewPavilion;
        
    }

    return nil;
}

#pragma mark - MKPoligon

- (void)addBoundary {
    //граница для схемы
    MKPolygon *polygon = [MKPolygon polygonWithCoordinates:self.parkZOO.boundary
                                                     count:self.parkZOO.boundaryPointsCount];
    [self.map addOverlay:polygon];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayPavilion.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }

    cell.textLabel.text = [[self.arrayPavilion objectAtIndex:indexPath.row]objectForKey:@"value"];

    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //по индексу ячейки находим координаты в массиве
    NSDictionary * dict = [self.arrayPavilion objectAtIndex:indexPath.row];
    CLLocation * newLocation = [[CLLocation alloc] init];
    newLocation = [dict objectForKey:@"coord"];
    [self setupMapView:newLocation.coordinate];
    //по полученным координатам устанавливаем центр карты:
    CLGeocoder * geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark * place = [placemarks objectAtIndex:0];
        NSString * adressString = [[NSString alloc] initWithFormat:@"%@\n%@\nИндекс - %@", [place.addressDictionary valueForKey:@"City"], [place.addressDictionary valueForKey:@"Street"], [place.addressDictionary valueForKey:@"ZIP"]];

        MKPointAnnotation * annotation = [[MKPointAnnotation alloc]init];
        annotation.coordinate = newLocation.coordinate;
        annotation.title = adressString;
    
        [self.map addAnnotation:annotation];
        
    }];
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.map removeAnnotations:self.map.annotations];
}


#pragma mark UIButton


- (void) action_ButtonShowTab {
    [self.map removeAnnotations:self.map.annotations];
    if (!self.isTable){
    self.isTable = YES;
    [self action_ChangeViewFrame];
    [self action_ChangeColorView:self.buttonShowMap ViewGray:self.buttonHidenMap];
    
    }
}

- (void) action_ButtonHidenTab {
    [self.map removeAnnotations:self.map.annotations];
    if (self.isTable) {
        self.isTable = NO;
        [self action_ChangeViewFrame];
        [self action_ChangeColorView:self.buttonHidenMap ViewGray:self.buttonShowMap];
  
        
    }

    
}

#pragma mark Animations

- (void) action_ChangeColorView:(UIView*)viewLightGray ViewGray:(UIView*)viewDarkGray{
    [Animations change_CH_View:viewLightGray Color:[UIColor darkGrayColor]];
    [Animations change_CH_View:viewDarkGray Color:[UIColor lightGrayColor]];
}

- (void) action_ChangeViewFrame {
    if (self.isTable) {
        //[Animations moveViewDown:self.viewMap Alpha:1 OriginY:CHANGE_TAB/2];
        [Animations moveViewTop:self.viewTable Alpha:1 OriginY:CHANGE_TAB];
    }
    
    else {
        
        [Animations moveViewDown:self.viewTable Alpha:0 OriginY:CHANGE_TAB];
      //  [Animations moveViewTop:self.viewMap Alpha:1 OriginY:CHANGE_TAB/2]; // поднимаем центр карты
    }
}

#pragma mark UIGestureRecognizerDelegate

- (IBAction)longPress:(UILongPressGestureRecognizer *)sender {

    
    if (sender.state == UIGestureRecognizerStateBegan) {

        CLLocationCoordinate2D coordScreenPoint = [self.map convertPoint:[sender locationInView:self.map] toCoordinateFromView:self.map];
        CLGeocoder * geocoder = [[CLGeocoder alloc]init];

        CLLocation * tapLocation = [[CLLocation alloc] initWithLatitude:coordScreenPoint.latitude longitude:coordScreenPoint.longitude];
        [geocoder reverseGeocodeLocation:tapLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            
            CLPlacemark * place = [placemarks objectAtIndex:0];

            NSString * adressString = [[NSString alloc] initWithFormat:@"%@\n%@\nИндекс - %@", [place.addressDictionary valueForKey:@"City"], [place.addressDictionary valueForKey:@"Street"], [place.addressDictionary valueForKey:@"ZIP"]];
            
            MKPointAnnotation * annotation = [[MKPointAnnotation alloc]init];
            annotation.title = adressString;
            annotation.coordinate = coordScreenPoint;
            [self.map addAnnotation:annotation];
            
            
        }];
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
