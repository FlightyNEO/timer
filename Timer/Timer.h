//
//  Timer.h
//  Timer
//
//  Created by Arkadiy Grigoryanc on 04.08.16.
//  Copyright © 2016 Arkadiy Grigoryanc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewController.h"

@class ViewController;
@protocol ViewControllerTimerDelegate;

@interface Timer : NSObject <ViewControllerTimerDelegate>

@property (weak, nonatomic, readonly) NSTimer *timer;
//@property (weak, nonatomic) NSTimer *delayTimer;

@property (assign, nonatomic, readwrite) NSTimeInterval whiteTimeInterval;
@property (assign, nonatomic, readwrite) NSTimeInterval blackTimeInterval;

@property (weak, nonatomic, readonly) NSTimer *overtimeTimer;
@property (assign, nonatomic, readwrite) NSTimeInterval overtimeTimeInterval;
//@property (assign, nonatomic, readonly) float progress;

@property (weak, nonatomic, readwrite) ViewController *delegate;

@end
