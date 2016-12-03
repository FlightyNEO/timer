//
//  TimeSettingController.h
//  Timer
//
//  Created by Arkadiy Grigoryanc on 31.07.16.
//  Copyright © 2016 Arkadiy Grigoryanc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TimeSettingControllerDelegate;

@class OwnTimeSettingController;

@class SettingController;

@class GameOptions;

/************* Настройки **************/
#define kGameOption           @"gameOption"
////////////////////////////////////////

typedef enum {
    GameTypeRapidity = 1,
    GameTypeHourglass = 2
} GameType;

typedef enum {
    GameTypeDelayNone = 0,
    GameTypeDelayDefault = 1,
    GameTypeDelayIncrementBefore = 2,
    GameTypeDelayIncrementAfter = 3,
    GameTypeDelayIncrementDelayedAfter = 4
} GameTypeDelay;

typedef enum {
    GameTime1 = 60,
    GameTime3 = 180,
    GameTime5 = 300,
    GameTime10 = 600,
    GameTime15 = 900,
    GameTime20 = 1200,
    GameTime30 = 1800,
    GameTime50 = 3000
} GameTime;

typedef int Overtime;

struct GameOption {
    GameType type;
    GameTime time;
    GameTypeDelay typeDelay;
    Overtime overtime;
};
typedef struct GameOption GameOption;

CG_INLINE GameOption
GameOptionMake(GameType type, GameTime time, GameTypeDelay typeDelay, Overtime overtime)
{
    GameOption g; g.type = type; g.time = time; g.typeDelay = typeDelay; g.overtime = overtime; return g;
}


@interface TimeSettingController : UITableViewController

@property (strong, nonatomic, readonly) NSIndexPath *selectedIndexPath;

@property (strong, nonatomic, readonly) NSMutableDictionary *timeLimit;
@property (strong, nonatomic, readonly) NSArray *sections;

@property (strong, nonatomic, readonly) NSMutableArray <NSDictionary *> *ownGameOptions;     // свои настройки таймера

@property (weak, nonatomic, readwrite) SettingController *topNavigationController;

- (void)refresh;
- (void)archiveCurrentSetting;
- (void)archiveOwnSetting;
- (void)changeGameOptions:(NSIndexPath *)indexPath;


@end


//@protocol TimeSettingControllerDelegate
//@required
//- (IBAction)actionSaveAndBack:(UIBarButtonItem *)sender;
//@end
