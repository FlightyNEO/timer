//
//  SettingController.h
//  Timer
//
//  Created by Arkadiy Grigoryanc on 27.07.16.
//  Copyright © 2016 Arkadiy Grigoryanc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface SettingController : UITableViewController <UIPopoverPresentationControllerDelegate>

@property (weak, nonatomic, readwrite) ViewController *delegate;

@property (assign, nonatomic, readwrite) BOOL isChangeSetting;

//@property (strong, nonatomic, readonly) NSMutableArray <NSDictionary *> *warnings;     // свои предупреждения
//@property (strong, nonatomic, readonly) NSMutableDictionary *options;


@property (weak, nonatomic, readonly) UIPopoverPresentationController *infoPopoverController;

//@property (weak, nonatomic, readonly) NSDictionary *nameGame;

- (void)archiveWarnings;

@end
