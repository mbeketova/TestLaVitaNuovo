//
//  Animations.h
//  TestLaVitaNuovo
//
//  Created by Admin on 16.08.15.
//  Copyright (c) 2015 Mariya Beketova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Animations : NSObject

+ (void) change_CH_View:(UIView*)view Color:(UIColor*)color;
+ (void) moveViewTop: (UIView*)view Alpha:(int)alfa OriginY:(int)originY;
+ (void) moveViewDown: (UIView*)view Alpha:(int)alfa OriginY:(int)originY;

@end
