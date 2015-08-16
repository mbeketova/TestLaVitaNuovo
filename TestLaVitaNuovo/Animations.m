//
//  Animations.m
//  TestLaVitaNuovo
//
//  Created by Admin on 16.08.15.
//  Copyright (c) 2015 Mariya Beketova. All rights reserved.
//

#import "Animations.h"

@implementation Animations

+ (void) change_CH_View:(UIView*)view Color:(UIColor*)color {
    //анимация при нажатии кнопки
    CATransition * animation = [CATransition animation];
    animation.type = kCATransitionFade; // вид анимации
    animation.duration = 0.35; //интервал анимации
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [animation setFillMode:kCAFillModeBoth]; //как длится анимация
    
    [view.layer addAnimation:animation forKey:@"Fade"];
    view.backgroundColor = color;
    
}

+ (void)moveViewTop: (UIView*)view Alpha:(int)alfa OriginY:(int)originY {
    
    [UIView animateWithDuration:0.35 delay:0.00 usingSpringWithDamping:0.8 initialSpringVelocity:0.3 options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState animations:^{
        //устанавливаем положение - внизу, за пределами экрана и делаем вью видимой/невидимой
        CGRect frame_view = [view frame];
        frame_view.origin.y = frame_view.origin.y + originY;
        view.frame = frame_view;
        view.alpha = alfa;
        
    } completion:^(BOOL finished) {
        
    }];
    
}

+ (void)moveViewDown: (UIView*)view Alpha:(int)alfa OriginY:(int)originY{
    
    [UIView animateWithDuration:0.35 delay:0.00 usingSpringWithDamping:0.8 initialSpringVelocity:0.3 options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState animations:^{
        //устанавливаем положение контента слева и делаем его видимым/невидимым
        CGRect frame_view = [view frame];
        frame_view.origin.y = frame_view.origin.y - originY;
        view.frame = frame_view;
        view.alpha = alfa;
        
    } completion:^(BOOL finished) {
        
    }];
    
}

@end
