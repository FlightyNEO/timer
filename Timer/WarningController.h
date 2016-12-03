//
//  WarningController.h
//  Timer
//
//  Created by Arkadiy Grigoryanc on 22.08.16.
//  Copyright © 2016 Arkadiy Grigoryanc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingController.h"

typedef enum {
    TypeWarningAlarm = 0,
    TypeWarningBeep = 1,
    TypeWarningSpeech = 2,
    TypeWarningBlink = 3
} TypeWarning;

@interface WarningController : UITableViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic, readwrite) SettingController *topNavigationController;

@property (assign, nonatomic, readwrite) NSInteger row;

@end
