//
//  Button.h
//  Timer
//
//  Created by Arkadiy Grigoryanc on 27.07.16.
//  Copyright © 2016 Arkadiy Grigoryanc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    CountdownStart = 1,
    CountdownFinish = 2,
    CountdownPause = 3
} Countdown;

typedef enum {
    ButtonTypeStart = 1,
    ButtonTypeReset = 2,
    ButtonTypeSetting = 3
} ButtonType;

@interface Button : UIButton

@property (assign, nonatomic) BOOL theGameContinues;

+ (Button *)buttonWithType:(ButtonType)buttonType forButton:(Button *)button center:(CGPoint)center target:(UIViewController *)vc action:(SEL)selector;

@end
