//
//  OwnTimeSettingController.h
//  Timer
//
//  Created by Arkadiy Grigoryanc on 05.08.16.
//  Copyright © 2016 Arkadiy Grigoryanc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeSettingController.h"

@interface OwnTimeSettingController : UITableViewController <UIPickerViewDelegate,
                                                             UIPickerViewDataSource,
                                                             UITextFieldDelegate,
                                                             UIPopoverPresentationControllerDelegate>

@property (strong, nonatomic) NSDictionary *ownGameOptions;     // Own Game Options

@property (weak, nonatomic, readonly) NSString *name;
@property (weak, nonatomic, readonly) NSString *detail;

// Time
@property (assign, nonatomic, readonly) NSInteger timePickerHours;
@property (assign, nonatomic, readonly) NSInteger timePickerMinutes;
@property (assign, nonatomic, readonly) NSInteger timePickerSeconds;

// Overtime
@property (assign, nonatomic, readonly) NSInteger overtimePickerHours;
@property (assign, nonatomic, readonly) NSInteger overtimePickerMinutes;
@property (assign, nonatomic, readonly) NSInteger overtimePickerSeconds;

@property (assign, nonatomic, readonly) GameType type;        // game type
@property (assign, nonatomic, readonly) GameTypeDelay typeDelay;  // game type delay

//@property (assign, nonatomic) BOOL isSelected;  // if current game options

@property (weak, nonatomic, readwrite) TimeSettingController *timeSettingController;

@property (weak, nonatomic, readwrite) NSIndexPath *editIndexPath;

@property (weak, nonatomic, readonly) UIPopoverPresentationController *infoPopoverController;

@end
