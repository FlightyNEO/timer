//
//  ViewController.h
//  Timer
//
//  Created by Arkadiy Grigoryanc on 25.07.16.
//  Copyright © 2016 Arkadiy Grigoryanc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeSettingController.h"
#import "Button.h"

//@protocol ViewControllerDelegate;
@protocol ViewControllerTimerDelegate;

//@class SettingController;
@class Timer;

typedef enum {
    TurnAnyone = 1,
    TurnRight = 2
} Turn;

@interface ViewController : UIViewController

@property (weak, nonatomic, readonly) UIView *whiteView;
@property (weak, nonatomic, readonly) UIView *blackView;

// Timers
@property (weak, nonatomic, readonly) UILabel *timeLabelBlack;
@property (weak, nonatomic, readonly) UILabel *timeLabelWhite;
@property (weak, nonatomic, readonly) UILabel *overtimeLabelBlack;
@property (weak, nonatomic, readonly) UILabel *overtimeLabelWhite;

@property (assign, nonatomic, readwrite) GameOption gameOption;    // Setting game

@property (weak, nonatomic, readonly) Button *start;              // Start button

@property (strong, nonatomic, readonly) Timer *timer;

- (void)resetTimer;
- (void)actionStopTimer;
- (void)drawOvertimeTimers;
- (void)applySettingAndResetTimer;

// Изменение настроек
- (void)changeSound;                // сменить звук нажатия
- (void)changeVolume;               // сменить уровень громкости нажатия
- (void)changeAirplainMode;         // сменить уровень громкости нажатия

@end
//
//
//@protocol ViewControllerDelegate
//@required
////- (IBAction)actionBack:(UIBarButtonItem *)sender;
//@end


@protocol ViewControllerTimerDelegate
@required
- (void)startTimer;
- (void)stopTimer;
- (void)addOvertime;
- (void)refreshTimers;
@end
