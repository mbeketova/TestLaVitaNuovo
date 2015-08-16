//
//  ArrayPavilion.m
//  TestLaVitaNuovo
//
//  Created by Admin on 14.08.15.
//  Copyright (c) 2015 Mariya Beketova. All rights reserved.
//

#import "ArrayPavilion.h"

@implementation ArrayPavilion

+ (NSMutableArray*) makeExpositionNewTerritory {
    
    NSMutableArray * arrayNew = [[NSMutableArray alloc]init];
    
    NSString*stringNew= @"Турья горка, Остров Зверей, Детский Зоопарк";
    NSArray * arrayWight = @[@"40", @"50", @"115"];
    NSArray * arayHeight = @[@"100", @"50", @"130"];
    NSArray* arrayValueNew = [stringNew componentsSeparatedByString:@", "];
   
    CLLocation * coord1 = [[CLLocation alloc]initWithLatitude:55.7633379289713 longitude:37.58201837539673];
    CLLocation * coord2 = [[CLLocation alloc]initWithLatitude:55.764182984617634 longitude:37.5840139389038];
    CLLocation * coord3 = [[CLLocation alloc]initWithLatitude:55.76097771226809 longitude:37.58250653743744];
    
    
    
    NSArray * arrayCoord = [[NSArray alloc] initWithObjects: coord1, coord2, coord3, nil];
    
    
    for (int i = 0; i < arrayValueNew.count; i++) {
        NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
        
        [dict setObject:[arrayCoord objectAtIndex:i] forKey:@"coord"];
        [dict setObject:[arrayValueNew objectAtIndex:i] forKey:@"value"];
        [dict setObject:[arrayWight objectAtIndex:i] forKey:@"wight"];
        [dict setObject:[arayHeight objectAtIndex:i] forKey:@"height"];
        
        [arrayNew addObject:dict];
    }
    
    NSSortDescriptor * sorter = [[NSSortDescriptor alloc] initWithKey:@"value" ascending:YES];
    NSArray * descriptors = [NSArray arrayWithObjects:sorter, nil];
    [arrayNew sortUsingDescriptors:descriptors];
    
    return arrayNew;
}



@end
