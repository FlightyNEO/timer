//
//  Timer.m
//  Timer
//
//  Created by Arkadiy Grigoryanc on 04.08.16.
//  Copyright © 2016 Arkadiy Grigoryanc. All rights reserved.
//

#import "Timer.h"
#import "WarningController.h"
#import <string.h>
@import AVFoundation;

// Warnings
typedef enum {
    WarningColorForWhite = 1,   // warning for white
    WarningColorForBlack = 2,   // warning for black
    WarningColorForBoth = 3     // warning for both
} WarningColor;

@interface Timer ()

@property (strong, nonatomic, readonly) AVAudioPlayer *soundID;   // warning's sound

@end

@implementation Timer {
    BOOL isFlash;   // воспроизвести вспышку
}

@synthesize soundID;

#pragma mark - Initialisation methods

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        isFlash = NO;
    }
    
    return self;
}

#pragma mark - Timer methods

// started timer
- (void)startTimer {
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.1f
                                                      target:self
                                                    selector:@selector(tick)
                                                    userInfo:nil
                                                     repeats:YES];
    
    // create Timer
    _timer = timer;
    
    // create Overtime Timer
    if (self.delegate.gameOption.typeDelay == GameTypeDelayDefault) {   // if type dalay: Default
        _overtimeTimer = timer;
    }
}

// stoped timer
- (void)stopTimer {
    if ([self.timer isValid] || [self.overtimeTimer isValid]) {
        
        [self.timer invalidate];
        
        if (self.delegate.gameOption.typeDelay == GameTypeDelayDefault) {   // if type dalay: Default
            [self.overtimeTimer invalidate];
        }
    }
}

// step timing
- (void)tick {
    
    [self refreshTimers];
    
    // Warning sound
    dispatch_queue_t queueWarning = dispatch_queue_create("com.agrigoryanc.queue_warning", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queueWarning, ^{
        
        [self verificationWarning];
    });
    
    dispatch_queue_t queueTick = dispatch_queue_create("com.agrigoryanc.queue_tick_timer", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queueTick, ^{
        
        NSLog(@"Time tick");
        
        if ((self.overtimeTimer != nil) && (self.overtimeTimeInterval > 0)) {
            
            self.overtimeTimeInterval -= self.overtimeTimer.timeInterval;
            
        }
        
        if ((((self.overtimeTimeInterval <= 0) && (self.whiteTimeInterval > 0) && (self.blackTimeInterval > 0)) ||
              (self.delegate.gameOption.typeDelay != GameTypeDelayDefault)) && (self.whiteTimeInterval >= 0) && (self.blackTimeInterval >= 0)) {
            
            if (self.delegate.gameOption.type == GameTypeRapidity) {
                
                if (self.delegate.whiteView.tag == TurnRight) {
                    self.whiteTimeInterval -= self.timer.timeInterval;
                } else {
                    self.blackTimeInterval -= self.timer.timeInterval;
                }
                
            } else if (self.delegate.gameOption.type == GameTypeHourglass) {    // if type: Hourglass
                
                if (self.delegate.whiteView.tag == TurnRight) {
                    self.whiteTimeInterval -= self.timer.timeInterval;
                    self.blackTimeInterval += self.timer.timeInterval;
                } else {
                    self.whiteTimeInterval += self.timer.timeInterval;
                    self.blackTimeInterval -= self.timer.timeInterval;
                }
            }
        }
    });
    
    // If ran out of time
    if (((self.whiteTimeInterval <= 0) && (self.delegate.whiteView.tag == TurnRight)) ||
        ((self.blackTimeInterval <= 0) && (self.delegate.blackView.tag == TurnRight))) {
        
        //extern GameOption gGameOption;
        
        switch (self.delegate.gameOption.typeDelay) {
            case GameTypeDelayDefault: {
                if (self.overtimeTimeInterval < 0) {
                    [self.delegate actionStopTimer];
                    NSLog(@"Stop timer");
                }
            }
                break;
                
            case GameTypeDelayIncrementBefore: {
                [self.delegate actionStopTimer];
                NSLog(@"Stop timer");
            }
                break;
                
            case GameTypeDelayNone: {
                [self.delegate actionStopTimer];
                NSLog(@"Stop timer");
            }
                break;
                
            default:
                break;
        }
    }
}

// add overtime
- (void)addOvertime {
    
    switch (self.delegate.gameOption.typeDelay) {
            
        case GameTypeDelayIncrementBefore: {        // if type dalay: Фишер до
            if (self.delegate.start.theGameContinues) {
                if (self.delegate.whiteView.tag == TurnRight) {
                    self.blackTimeInterval += self.delegate.gameOption.overtime;
                } else {
                    self.whiteTimeInterval += self.delegate.gameOption.overtime;
                }
            } else {
                self.whiteTimeInterval += self.delegate.gameOption.overtime;
            }
        }
            break;
            
        case GameTypeDelayIncrementAfter: {         // if type dalay: Фишер после
            if (self.delegate.whiteView.tag == TurnRight) {
                self.whiteTimeInterval += self.delegate.gameOption.overtime;
            } else {
                self.blackTimeInterval += self.delegate.gameOption.overtime;
            }
        }
            break;
            
        case GameTypeDelayIncrementDelayedAfter: {  // if type dalay: Бронштейна
            if (self.delegate.whiteView.tag == TurnRight) {
                if ((self.whiteTimeInterval += self.delegate.gameOption.overtime) > self.delegate.gameOption.time) {
                    self.whiteTimeInterval = self.delegate.gameOption.time;
                }
            } else {
                if ((self.blackTimeInterval += self.delegate.gameOption.overtime) > self.delegate.gameOption.time) {
                    self.blackTimeInterval = self.delegate.gameOption.time;
                }
            }
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - draw methods

- (void)refreshTimers {
    
    // если Warning = мигание
    if (isFlash) {
        [self flash];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    NSDateFormatter *(^format)(NSTimeInterval) = ^(NSTimeInterval timeInterval) {
        if (timeInterval > 3600) {
            formatter.dateFormat = @"HH:mm:ss";
        } else if (timeInterval >= 600) {
            formatter.dateFormat = @"mm:ss";
        } else if (timeInterval >= 60) {
            formatter.dateFormat = @"m:ss";
        } else if (timeInterval >= 10) {
            formatter.dateFormat = @"ss";
        } else {
            formatter.dateFormat = @"s:S";
        }
        
        NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        [formatter setTimeZone:gmt];
        
        return formatter;
    };
    
//    NSDate *(^createTimer)(NSTimeInterval) = ^(NSTimeInterval time) {
//        
//        NSInteger hours = time / 3600;
//        NSInteger seconds = time - (hours * 3600);
//        NSInteger minutes = seconds / 60;
//        seconds = seconds - (minutes * 60);
//        NSInteger nanoseconds = (time - (float)(hours * 3600) - (float)(minutes * 60) - (float)seconds) * 10.0;
//        
//        NSDateComponents *comps = [[NSDateComponents alloc] init];
//        
//        [comps setHour:hours];
//        [comps setMinute:minutes];
//        [comps setSecond:seconds];
//        [comps setNanosecond:nanoseconds];
//        
//        NSLog(@"nano: %ld", nanoseconds);
//        
//        return [[NSCalendar currentCalendar] dateFromComponents:comps];
//        
//    };
    
//    NSDate *timeWhite = createTimer(self.whiteTimeInterval);
//    NSDate *timeBlack = createTimer(self.blackTimeInterval);
    
    NSDate *timeWhite = [NSDate dateWithTimeIntervalSinceReferenceDate:self.whiteTimeInterval];    // минус 3 часа???
    NSDate *timeBlack = [NSDate dateWithTimeIntervalSinceReferenceDate:self.blackTimeInterval];    // минус 3 часа???
    
    NSString *stringFromDateWhite = [format(self.whiteTimeInterval) stringFromDate:timeWhite];
    NSString *stringFromDateBlack = [format(self.blackTimeInterval) stringFromDate:timeBlack];
    
    self.delegate.timeLabelWhite.text = [NSString stringWithFormat:@"%@", stringFromDateWhite];
    self.delegate.timeLabelBlack.text = [NSString stringWithFormat:@"%@", stringFromDateBlack];
    
    if ((self.delegate.gameOption.typeDelay == GameTypeDelayDefault) && (self.delegate.start.theGameContinues)) {
        
        NSDate *overtime = [NSDate dateWithTimeIntervalSinceReferenceDate:self.overtimeTimeInterval];    // минус 3 часа???
        
        NSString *stringFromDateOvertime;
        if (self.overtimeTimeInterval <= 0) {
            stringFromDateOvertime = @"";
        } else {
            stringFromDateOvertime = [format(self.overtimeTimeInterval) stringFromDate:overtime];
        }
        
        
        if (self.delegate.whiteView.tag == CountdownStart) {
            self.delegate.overtimeLabelBlack.text = [NSString stringWithFormat:@"%@", stringFromDateOvertime];
        } else {
            self.delegate.overtimeLabelWhite.text = [NSString stringWithFormat:@"%@", stringFromDateOvertime];
        }
    }
}

#pragma mark - Warning Methods

- (void)verificationWarning {
    
    extern NSMutableArray <NSDictionary *> *gWarnings;
    
    if ([gWarnings count] > 0) {
        
        void(^inspection)(NSDictionary *, NSInteger) = ^(NSDictionary *warning, NSInteger timeWarning) {
            if (self.delegate.gameOption.typeDelay == GameTypeDelayDefault) {
                if ((timeWarning == 0) && (self.overtimeTimeInterval <= 0)) {
                    [self launchWarning:warning];
                } else if ((timeWarning != 0) && (self.overtimeTimeInterval < 0.1)) {
                    [self launchWarning:warning];
                }
            } else {
                [self launchWarning:warning];
            }
        };
        
        for (NSDictionary *warning in gWarnings) {
            
            BOOL onForWhite = [[warning objectForKey:@"OnForWhite"] boolValue];     // звук включен для белых
            BOOL onForBlack = [[warning objectForKey:@"OnForBlack"] boolValue];     // звук включен для черных
            
            NSInteger timeWarning = [[warning objectForKey:@"TimeWarning"] intValue];   // время сигнала
            
            if (onForWhite && onForBlack) {     // если включено для белых и черных
                
                if (((self.delegate.whiteView.tag == TurnRight) &&  // если ход белых
                     (self.whiteTimeInterval >= timeWarning - 0.00001) &&
                     (self.whiteTimeInterval <= timeWarning + 0.00001)) ||
                    ((self.delegate.blackView.tag == TurnRight) &&  // если ход черных
                     (self.blackTimeInterval >= timeWarning - 0.00001) &&
                     (self.blackTimeInterval <= timeWarning + 0.00001))) {
                    
                    inspection(warning, timeWarning);
                        
                }
                
            } else if (onForWhite) {            // если включено для белых
                
                if ((self.delegate.blackView.tag == TurnRight) &&   // если ход черных
                    (self.blackTimeInterval >= timeWarning - 0.00001) &&
                    (self.blackTimeInterval <= timeWarning + 0.00001)) {
                    
                    inspection(warning, timeWarning);
                    
                }
                
            } else if (onForBlack) {            // если включено для черных
                
                if ((self.delegate.whiteView.tag == TurnRight) &&   // если ход белых
                    (self.whiteTimeInterval >= timeWarning - 0.00001) &&
                    (self.whiteTimeInterval <= timeWarning + 0.00001)) {
                    
                    inspection(warning, timeWarning);
                    
                }
            }
        }
    }
}

- (void)launchWarning:(NSDictionary *)warning {
    
    //NSInteger typeWarning = [[warning objectForKey:@"TypeWarning"] intValue];
    
    CGFloat volume = [[warning objectForKey:@"Volume"] floatValue];
    
    switch ([[warning objectForKey:@"TypeWarning"] intValue]) {
        case TypeWarningAlarm:  // сигнал тревоги
            [self playSound:[[NSBundle mainBundle] pathForResource:@"alarm" ofType:@"mp3"]
                 withVolume:volume];
            break;
        case TypeWarningBeep:   // гудок
            [self playSound:[[NSBundle mainBundle] pathForResource:@"beep" ofType:@"mp3"]
                 withVolume:volume];
            break;
        case TypeWarningSpeech: // речь
            [self playSpeech:[[warning objectForKey:@"TimeWarning"] intValue]
                  withVolume:volume];
            break;
        case TypeWarningBlink:  // мигание
            isFlash = YES;
            break;
    }
}

- (void)playSound:(NSString *)path withVolume:(CGFloat)volume {
    
    NSURL *soundURL = [NSURL fileURLWithPath:path];
    NSError *error;
    
    soundID = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:&error];
    
    //[soundID prepareToPlay];
    //[soundID setNumberOfLoops:0];
    //[soundID setCurrentTime:3];
    [soundID setVolume:volume];
    [soundID play];
    
}

- (void)playSpeech:(NSInteger)time withVolume:(CGFloat)volume {
    
    NSInteger hours = time / 3600;
    NSInteger seconds = time - (hours * 3600);
    NSInteger minutes = seconds / 60;
    seconds = seconds - (minutes * 60);
    
    NSMutableString *text = [NSMutableString string];
    
    if (hours == 1) {
        [text appendFormat:@"%ld час,", hours];
    } else if (hours > 1 && hours <= 4) {
        [text appendFormat:@"%ld часа,", hours];
    } else if (hours > 4) {
        [text appendFormat:@"%ld часов,", hours];
    }
    
    if (minutes == 1 || minutes == 21 || minutes == 31 || minutes == 41 || minutes == 51) {
        [text appendFormat:@"%ld минута,", minutes];
    } else if ((minutes > 1 && minutes <= 4) || (minutes > 21 && minutes <= 24) || (minutes > 31 && minutes <= 34) ||
               (minutes > 41 && minutes <= 44) || (minutes > 51 && minutes <= 54)) {
        [text appendFormat:@"%ld минуты,", minutes];
    } else if ((minutes > 4 && minutes <= 20) || (minutes > 24 && minutes <= 30) || (minutes > 34 && minutes <= 40) ||
               (minutes > 44 && minutes <= 50) || (minutes > 54 && minutes <= 60)) {
        [text appendFormat:@"%ld минут,", minutes];
    }
    
    if (seconds == 1 || seconds == 21 || seconds == 31 || seconds == 41 || seconds == 51) {
        [text appendFormat:@"%ld секунда,", seconds];
    } else if ((seconds > 1 && seconds <= 4) || (seconds > 21 && seconds <= 24) || (seconds > 31 && seconds <= 34) ||
               (seconds > 41 && seconds <= 44) || (seconds > 51 && seconds <= 54)) {
        [text appendFormat:@"%ld секунды,", seconds];
    } else if ((seconds > 4 && seconds <= 20) || (seconds > 24 && seconds <= 30) || (seconds > 34 && seconds <= 40) ||
               (seconds > 44 && seconds <= 50) || (seconds > 54 && seconds <= 60)) {
        [text appendFormat:@"%ld секунд,", seconds];
    }
    
    if (seconds == 0 && minutes == 0 && hours == 0) {
        [text appendFormat:@"Время вышло"];
    }
    
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:text];
    [utterance setVolume:volume];
    [utterance setVoice:[AVSpeechSynthesisVoice voiceWithLanguage:@"ru-RU"]];
    AVSpeechSynthesizer *syn = [[AVSpeechSynthesizer alloc] init];
    [syn speakUtterance:utterance];
    
}

- (void)flash {
    
    UIView *flash = [[UIView alloc] initWithFrame:CGRectMake(0, 0,
                                                             CGRectGetWidth(self.delegate.view.frame),
                                                             CGRectGetHeight(self.delegate.view.frame))];
    if (self.delegate.whiteView.tag == TurnRight) {
        flash.backgroundColor = [UIColor blackColor];
    } else {
        flash.backgroundColor = [UIColor whiteColor];
    }
    
    [self.delegate.view addSubview:flash];
    
    [UIView animateWithDuration:0.3f
                          delay:0.f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         flash.alpha = 0.f;
                     }
                     completion:^(BOOL finished) {
                         [flash removeFromSuperview];
                     }];
    
    isFlash = NO;
}

@end





