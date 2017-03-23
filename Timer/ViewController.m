//
//  ViewController.m
//  Timer
//
//  Created by Arkadiy Grigoryanc on 25.07.16.
//  Copyright © 2016 Arkadiy Grigoryanc. All rights reserved.
//

#import "ViewController.h"
#import "SettingController.h"
#import "Timer.h"

@import AVFoundation;

@interface ViewController ()

@property (weak, nonatomic) Button *reset;              // Reset button
@property (weak, nonatomic) Button *setting;            // Setting button

@property (strong, nonatomic) AVAudioPlayer *soundID;   // звук нажатия
@property (assign, nonatomic) CGFloat volume;           // уровень громкости нажатия

// иконки режима самолета
@property (weak, nonatomic) UIImageView *airplainModeBlackIcon;
@property (weak, nonatomic) UIImageView *airplainModeWhiteIcon;

@end

@implementation ViewController

@synthesize soundID;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    /* create Timer */
    _timer = [[Timer alloc] init];
    self.timer.delegate = self;
    
    /* Create sound */
    [self changeSound];
    [self changeVolume];
    
    /* Option time */
    extern GameOption gGameOption;
    
    self.timer.whiteTimeInterval = gGameOption.time;
    self.timer.blackTimeInterval = gGameOption.time;
    self.timer.overtimeTimeInterval = gGameOption.overtime;
    
    self.gameOption = gGameOption;
    
    /* DRAWING */
    [self drawing];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self changeAirplainMode];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientation) preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

#pragma mark - Drawing Methods

- (void)drawing {
    /* Create black and white descks */
    [self drawDesks];
    
    /* Create black and white timers */
    [self drawTimers];
    
    /* Create buttons */
    [self createButton:ButtonTypeStart];
    [self createButton:ButtonTypeSetting];
    
    /* Create overtime timers */
    if (self.gameOption.typeDelay == GameTypeDelayDefault) {
        [self drawOvertimeTimers];
    }
    
    [self.timer refreshTimers];
}

- (void)drawDesks {
    
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat height = (CGRectGetHeight(self.view.bounds) / 4) * 3;
    
    // white view
    UIButton *whiteView = [[UIButton alloc] initWithFrame:CGRectMake(0, -height / 3, width, height)];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.tag = TurnAnyone;
    [whiteView addTarget:self
                  action:@selector(actionTurnChangeForWhite)
        forControlEvents:UIControlEventTouchUpInside];
    
    // black view
    UIButton *blackView = [[UIButton alloc] initWithFrame:CGRectMake(0, (height / 3) * 2, width, height)];
    blackView.backgroundColor = [UIColor blackColor];
    blackView.tag = TurnAnyone;
    [blackView addTarget:self
                  action:@selector(actionTurnChangeForBlack)
        forControlEvents:UIControlEventTouchUpInside];
    
    _whiteView = whiteView;
    _blackView = blackView;
    
    [self.view addSubview:self.whiteView];
    [self.view addSubview:self.blackView];
}

- (void)drawTimers {
    
    CGFloat width = CGRectGetWidth(self.view.bounds);
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:50];
    
    UILabel *whiteTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (CGRectGetHeight(self.view.bounds) / 2) - 25, width, 50)];
    whiteTimeLabel.textColor = [UIColor blackColor];
    whiteTimeLabel.textAlignment = NSTextAlignmentCenter;
    whiteTimeLabel.font = font;
    whiteTimeLabel.transform = CGAffineTransformMakeRotation(M_PI);
    
    UILabel *blackTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (CGRectGetHeight(self.view.bounds) / 4) - 25, width, 50)];
    blackTimeLabel.textColor = [UIColor whiteColor];
    blackTimeLabel.textAlignment = NSTextAlignmentCenter;
    blackTimeLabel.font = font;
    
    _timeLabelWhite = whiteTimeLabel;
    _timeLabelBlack = blackTimeLabel;
    
    [self.whiteView addSubview:self.timeLabelWhite];
    [self.blackView addSubview:self.timeLabelBlack];
}

- (void)drawOvertimeTimers {
    
    CGFloat width = CGRectGetWidth(self.view.bounds);
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:20];
    
    UILabel *whiteOvertimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (CGRectGetHeight(self.view.bounds) / 2) - 75, width, 50)];
    whiteOvertimeLabel.textColor = [UIColor blackColor];
    whiteOvertimeLabel.textAlignment = NSTextAlignmentCenter;
    whiteOvertimeLabel.font = font;
    whiteOvertimeLabel.transform = CGAffineTransformMakeRotation(M_PI);
    
    UILabel *blackOvertimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (CGRectGetHeight(self.view.bounds) / 4) + 25, width, 50)];
    blackOvertimeLabel.textColor = [UIColor whiteColor];
    blackOvertimeLabel.textAlignment = NSTextAlignmentCenter;
    blackOvertimeLabel.font = font;
    
    _overtimeLabelWhite = whiteOvertimeLabel;
    _overtimeLabelBlack = blackOvertimeLabel;
    
    [self.whiteView addSubview:self.overtimeLabelWhite];
    [self.blackView addSubview:self.overtimeLabelBlack];
}

- (void)redrawing {
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         CGAffineTransform  translation,
                                            translation2,
                                            translation3;
                         
                         CGPoint    center,
                                    center2;
                         
                         if (self.whiteView.tag == TurnRight) {
                             
                             translation = CGAffineTransformMakeTranslation(0, (CGRectGetHeight(self.whiteView.frame) / 3));
                             
                             translation2 = CGAffineTransformMakeTranslation(0, -((CGRectGetHeight(self.whiteView.frame) / 3) / 2));
                             
                             translation3 = CGAffineTransformMakeTranslation(CGRectGetWidth(self.view.bounds) / 8,
                                                                             (CGRectGetHeight(self.whiteView.frame) / 3));
                             
                             center = CGPointMake(CGRectGetWidth(self.view.bounds) / 2,
                                                  (CGRectGetHeight(self.whiteView.frame) / 2));
                             
                             center2 = CGPointMake(CGRectGetWidth(self.view.bounds) / 2,
                                                  ((CGRectGetHeight(self.whiteView.frame) / 2) - 50));
                             
                         } else {
                             
                             translation = CGAffineTransformMakeTranslation(0, -(CGRectGetHeight(self.whiteView.frame) / 3));
                             
                             translation2 = CGAffineTransformMakeTranslation(0, ((CGRectGetHeight(self.whiteView.frame) / 3) / 2));
                             
                             translation3 = CGAffineTransformMakeTranslation(CGRectGetWidth(self.view.bounds) / 8,
                                                                             -(CGRectGetHeight(self.whiteView.frame) / 3));
                             
                             center = CGPointMake(CGRectGetWidth(self.view.bounds) / 2,
                                                  CGRectGetHeight(self.whiteView.frame) - ((CGRectGetHeight(self.whiteView.frame) / 3) / 2));
                             
                             center2 = CGPointMake(CGRectGetWidth(self.view.bounds) / 2,
                                                  (CGRectGetHeight(self.whiteView.frame) - ((CGRectGetHeight(self.whiteView.frame) / 3) / 2)) - 50);
                         }
                         
                         self.whiteView.transform = translation;
                         self.blackView.transform = translation;
                         self.start.transform = translation3;
                         
                         // если setting button существует
                         if (self.setting != nil) {
                             
                             CGAffineTransform scale = CGAffineTransformMakeScale(0.1, 0.1);
                             CGAffineTransform translation4 = CGAffineTransformConcat(scale, translation3);
                             self.setting.transform = translation4;
                         }
                         
                         self.timeLabelWhite.center = center;
                         self.timeLabelBlack.transform = translation2;
                         
                         self.overtimeLabelWhite.center = center2;
                         self.overtimeLabelBlack.transform = translation2;
                         
                     }
                     completion:^(BOOL finished) {
                         
                         // если setting button существует
                         if (self.setting != nil) {
                             
                             [self.setting removeFromSuperview];    // удаляем setting button
                             _setting = nil;
                         }
                     }];
}

- (void)resetDraw {
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         CGAffineTransform translation = CGAffineTransformMakeTranslation(0, 0);
                         
                         CGPoint centerForTimeLabelWhite = CGPointMake(CGRectGetWidth(self.view.bounds) / 2,
                                                                       (CGRectGetHeight(self.whiteView.frame) / 3 * 2));
                         
                         CGPoint centerForOvertimeLabelWhite = CGPointMake(CGRectGetWidth(self.view.bounds) / 2,
                                                                       ((CGRectGetHeight(self.whiteView.frame) / 3 * 2)) - 50);
                         
                         CGPoint centerForSettingButton = CGPointMake((CGRectGetWidth(self.view.bounds) / 8) * 5,
                                                                      CGRectGetMidY(self.view.bounds));
                         
                         self.whiteView.transform = translation;
                         self.blackView.transform = translation;
                         self.start.transform = translation;
                         self.setting.center = centerForSettingButton;
                         self.timeLabelWhite.center = centerForTimeLabelWhite;
                         self.timeLabelBlack.transform = translation;
                         
                         self.overtimeLabelWhite.center = centerForOvertimeLabelWhite;
                         self.overtimeLabelBlack.transform = translation;
                         
                     }
                     completion:^(BOOL finished) {}];
    
    // перезаписываем параметры таймера
    extern GameOption gGameOption;

    self.timer.whiteTimeInterval = gGameOption.time;
    self.timer.blackTimeInterval = gGameOption.time;
    self.timer.overtimeTimeInterval = gGameOption.overtime;
    
    self.gameOption = gGameOption;
    
    [self.timer refreshTimers];
    
    if (self.gameOption.typeDelay == GameTypeDelayDefault) {
        
        if (self.overtimeLabelBlack == nil) {
            [self drawOvertimeTimers];
        }
        
        self.overtimeLabelBlack.text = @"";
        self.overtimeLabelWhite.text = @"";
        
    } else if (self.overtimeLabelBlack != nil) {
        
        [self.overtimeLabelBlack removeFromSuperview];
        [self.overtimeLabelWhite removeFromSuperview];
        
        _overtimeLabelBlack = nil;
        _overtimeLabelWhite = nil;
    }
}

- (void)removeButton:(UIButton *)button {
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         CGAffineTransform scale = CGAffineTransformMakeScale(0.1, 0.1);
                         
                         button.transform = scale;
                     }
                     completion:^(BOOL finished) {
                         [button removeFromSuperview];
                     }];
}

#pragma mark - Create Buttons

// create buttons
- (void)createButton:(ButtonType)buttonType {
    
    Button *newButton;
    
    switch (buttonType) {
        case ButtonTypeStart:
            newButton = [self drawStartButton];
            _start = newButton;
            break;
        case ButtonTypeReset:
            newButton = [self drawResetButton];
            _reset = newButton;
            break;
        case ButtonTypeSetting:
            newButton = [self drawSettingButton];
            _setting = newButton;
            break;
            
        default:
            break;
    }
    
    [self.view addSubview:newButton];
}

// create start button
- (Button *)drawStartButton {
    Button *startButton = [Button buttonWithType:ButtonTypeStart
                                       forButton:nil
                                          center:CGPointMake((CGRectGetWidth(self.view.bounds) / 8) * 3,
                                                             CGRectGetMidY(self.view.bounds))
                                          target:self
                                          action:@selector(actionStartTimer)];
    return startButton;
}

// create setting button
- (Button *)drawSettingButton {
    
    Button *settingButton;
    CGPoint center;
    
    if (self.start.theGameContinues) {
        center = CGPointMake((CGRectGetWidth(self.view.bounds) / 4) * 3,
                             CGRectGetMidY(self.start.frame));
    } else {
        center = CGPointMake((CGRectGetWidth(self.view.bounds) / 8) * 5,
                             CGRectGetMidY(self.start.frame));
    }
    
    settingButton = [Button buttonWithType:ButtonTypeSetting
                                 forButton:self.setting
                                    center:center
                                    target:self
                                    action:@selector(actionSetting)];
    
    return settingButton;
}

// create reset button
- (Button *)drawResetButton {
    Button *resetButton = [Button buttonWithType:ButtonTypeReset
                                       forButton:nil
                                          center:CGPointMake(CGRectGetWidth(self.view.bounds) / 4,
                                                             CGRectGetMidY(self.start.frame))
                                          target:self
                                          action:@selector(actionResetTimer)];
    return resetButton;
}

#pragma mark - Methods

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)applySettingAndResetTimer {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Параметры изменены"
                                                                   message:@"Применить новые параметры немедленно?\nЭто приведет к сбросу таймера"
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *actionDestructive = [UIAlertAction actionWithTitle:@"Применить"
                                                                style:UIAlertActionStyleDestructive
                                                              handler:^(UIAlertAction *action) {
                                                                  
                                                                  [self resetTimer];
                                                              }];
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Применить позже"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    
    [alert addAction:actionDestructive];
    [alert addAction:actionCancel];
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)resetTimer {
    
    [self.reset removeFromSuperview];
    _reset = nil;
    
    if (!self.start) {      // если закончилось время
        [self createButton:ButtonTypeStart];
        
        if (self.whiteView.tag == TurnRight) {
            
            self.start.transform = CGAffineTransformMakeTranslation(CGRectGetWidth(self.view.bounds) / 8,
                                                                    (CGRectGetHeight(self.whiteView.frame) / 3));
        } else {
            
            self.start.transform = CGAffineTransformMakeTranslation(CGRectGetWidth(self.view.bounds) / 8,
                                                                    -(CGRectGetHeight(self.whiteView.frame) / 3));
        }
    }
    
    self.start.theGameContinues = NO;
    
    if (self.blackView.tag == TurnRight) {
        
        self.blackView.tag = TurnAnyone;
        self.whiteView.tag = TurnRight;
    }
    
    [self resetDraw];
}

#pragma mark - Change settings

- (void)changeSound {
    
    extern NSMutableDictionary *gOption;
    
    NSString *path;
    
    if ([[gOption objectForKey:@"sound"] intValue] == 0) {
        path = [[NSBundle mainBundle] pathForResource:@"click" ofType:@"caf"];
    } else if ([[gOption objectForKey:@"sound"] intValue] == 1) {
        path = [[NSBundle mainBundle] pathForResource:@"chirp" ofType:@"caf"];
    }
    
    NSURL *soundURL = [NSURL fileURLWithPath:path];
    NSError *error;
    
    soundID = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:&error];
}

- (void)changeVolume {
    
    extern NSMutableDictionary *gOption;
    
    _volume = [[gOption objectForKey:@"volume"] floatValue];
}

- (void)changeAirplainMode {
    
    extern NSMutableDictionary *gOption;
    
    if ([[gOption objectForKey:@"planeMode"] boolValue]) {
        
        UIImageView *blackPlain = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"airplainModeBlack"]];
        UIImageView *whitePlain = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"airplainModeWhite"]];
        
        blackPlain.center = CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMinY(self.view.bounds) + CGRectGetHeight(blackPlain.frame));
        whitePlain.center = CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMaxY(self.view.bounds) - CGRectGetHeight(whitePlain.frame));
        
        _airplainModeBlackIcon = blackPlain;
        _airplainModeWhiteIcon = whitePlain;
        
        [self.view addSubview:self.airplainModeBlackIcon];
        [self.view addSubview:self.airplainModeWhiteIcon];
        
    } else {
        [self.airplainModeBlackIcon removeFromSuperview];
        [self.airplainModeWhiteIcon removeFromSuperview];
    }
}

#pragma mark - Play sound

- (void)playSound {
    
    //[soundID prepareToPlay];
    [soundID setVolume:self.volume];
    //[soundID setNumberOfLoops:0];
    [soundID setCurrentTime:1];
    [soundID play];
}

#pragma mark - Actions

- (void)addTime {
    
    if ((self.gameOption.typeDelay == GameTypeDelayIncrementAfter) ||
        (self.gameOption.typeDelay == GameTypeDelayIncrementBefore) ||
        (self.gameOption.typeDelay == GameTypeDelayIncrementDelayedAfter)) {
        
        [self.timer addOvertime];
        
    } else if (self.gameOption.typeDelay == GameTypeDelayDefault) {
        self.timer.overtimeTimeInterval = self.gameOption.overtime;
    }
}

// change step to black
- (void)actionTurnChangeForWhite {
    
    [self addTime];
    
    if (self.start.tag == CountdownStart &&
        self.whiteView.tag == TurnRight) {
        
        extern NSMutableDictionary *gOption;
        
        if ([[gOption objectForKey:@"volumeSwitch"] boolValue]) {
            __weak id weakSelf = self;
            //dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_queue_t queue = dispatch_queue_create("com.agrigoryanc.queue_sound_white", DISPATCH_QUEUE_SERIAL);
            dispatch_async(queue, ^{
                [weakSelf playSound];
            });
        }
        
        if (self.gameOption.typeDelay == GameTypeDelayDefault) {
            self.overtimeLabelWhite.text = @"";
        }
        
        self.whiteView.tag = TurnAnyone;
        self.blackView.tag = TurnRight;
        NSLog(@"white");
        [self redrawing];
    }
}

// change step to white
- (void)actionTurnChangeForBlack {
    
    [self addTime];
    
    if (self.start.tag == CountdownStart &&
        self.blackView.tag == TurnRight) {
        
        extern NSMutableDictionary *gOption;
        
        if ([[gOption objectForKey:@"volumeSwitch"] boolValue]) {
            __weak id weakSelf = self;
            //dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_queue_t queue = dispatch_queue_create("com.agrigoryanc.queue_sound_black", DISPATCH_QUEUE_SERIAL);
            dispatch_async(queue, ^{
                [weakSelf playSound];
            });
        }
        
        if (self.gameOption.typeDelay == GameTypeDelayDefault) {
            self.overtimeLabelBlack.text = @"";
        }
        
        self.blackView.tag = TurnAnyone;
        self.whiteView.tag = TurnRight;
        NSLog(@"black");
        [self redrawing];
    }
}

- (void)actionStopTimer {
    
    self.start.tag = CountdownFinish;
    
    [self createButton:ButtonTypeReset];
    [self createButton:ButtonTypeSetting];
    
    [self.timer stopTimer];
    
    // Удаляем start button
    [self.start removeFromSuperview];
    _start = nil;
}

// start/pause button
// start timer
- (void)actionStartTimer {
    
    if (self.start.tag == CountdownFinish) {
        
        self.start.tag = CountdownStart;
        
        // Удаляем reset button
        if (self.reset != nil) {        // проверка на существование reset button
            [self removeButton:self.reset];
            _reset = nil;
        }
        
        // Удаляем setting button
        if (self.start.theGameContinues) {  // если игра не начата
            [self removeButton:self.setting];
            _setting = nil;
        }
        
        UIImage *image = [UIImage imageNamed:@"pause"];
        [self.start setBackgroundImage:image forState:UIControlStateNormal];
        
        if (self.whiteView.tag == TurnAnyone &&
            self.blackView.tag == TurnAnyone) {
            self.whiteView.tag = TurnRight;
        }
        
        [self.timer startTimer];
        
        [self redrawing];
        
    } else {
        
        self.start.tag = CountdownFinish;
        UIImage *image = [UIImage imageNamed:@"start"];
        [self.start setBackgroundImage:image forState:UIControlStateNormal];
        [self createButton:ButtonTypeReset];
        [self createButton:ButtonTypeSetting];
        
        [self.timer stopTimer];
    }
    
    if (self.start.theGameContinues == NO) {
        
        if (self.gameOption.typeDelay == GameTypeDelayIncrementBefore) {
            
            [self.timer addOvertime];
            
        }
        
        self.start.theGameContinues = YES;
    }
}

- (void)actionResetTimer {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Сброс таймера"
                                                                   message:@"Подтвердите сброс таймера или нажмите \"Отмена\""
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *actionDestructive = [UIAlertAction actionWithTitle:@"Подтвердить"
                                                                style:UIAlertActionStyleDestructive
                                                              handler:^(UIAlertAction *action) {
                                                                  [self resetTimer];
                                                              }];
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Отмена"
                                                                style:UIAlertActionStyleCancel
                                                              handler:^(UIAlertAction *action) {}];
    
    [alert addAction:actionDestructive];
    [alert addAction:actionCancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)actionSetting {
    [self performSegueWithIdentifier:@"showSetting" sender:self.setting];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"showSetting"]) {
        
        UINavigationController *navigationController = segue.destinationViewController;
        
        if ([navigationController.topViewController isKindOfClass:[SettingController class]]) {
            SettingController *selectViewController = (SettingController *)navigationController.topViewController;
            selectViewController.delegate = self;
        }
    }
}

@end
