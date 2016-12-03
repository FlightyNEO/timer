//
//  InfoController.h
//  Timer
//
//  Created by Arkadiy Grigoryanc on 17.08.16.
//  Copyright © 2016 Arkadiy Grigoryanc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OwnTimeSettingController;

typedef enum {
    InfoControllerButtonInfoHourglass = 0,
    InfoControllerButtonInfoDelay = 1,
    InfoControllerButtonInfoPlaneMode = 2
    
} InfoControllerButtonInfo;

@interface InfoController : UIViewController

@property (assign, nonatomic, readwrite) InfoControllerButtonInfo buttonInfo;
@property (assign, nonatomic, readwrite) CGSize contentSize;

//- (InfoController *)initWithButtonInfo:(InfoControllerButtonInfo)type;

@end
