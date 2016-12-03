//
//  GameOptions.h
//  Timer
//
//  Created by Arkadiy Grigoryanc on 02.08.16.
//  Copyright © 2016 Arkadiy Grigoryanc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "SettingController.h"

//typedef enum {
//    GameTypeRapidity = 1,
//    GameTypeHourglass = 2,
//    GameTypeIncrementBefore = 3,
//    GameTypeIncrementAfter = 4,
//    GameTypeIncrementDelayedAfter = 5,
//    GameTypeSuddenDeath = 6
//} GameType;
//
//typedef enum {
//    GameTypeDelayNone = 0,
//    GameTypeDelayDefault = 1,
//    GameTypeDelayIncrementBefore = 2,
//    GameTypeDelayIncrementAfter = 3,
//    GameTypeDelayIncrementDelayedAfter = 4
//} GameTypeDelay;
//
//typedef enum {
//    GameTime1 = 60,
//    GameTime3 = 180,
//    GameTime5 = 300,
//    GameTime10 = 600,
//    GameTime15 = 900,
//    GameTime20 = 1200,
//    GameTime30 = 1800,
//    GameTime50 = 3000
//} GameTime;
//
//typedef int Overtime;
//
//struct GameOption {
//    GameType type;
//    GameTime time;
//    GameTypeDelay typeDelay;
//    Overtime overtime;
//};
//typedef struct GameOption GameOption;
//
//CG_INLINE GameOption
//GameOptionMake(GameType type, GameTime time, GameTypeDelay typeDelay, Overtime overtime)
//{
//    GameOption g; g.type = type; g.time = time; g.typeDelay = typeDelay; g.overtime = overtime; return g;
//}

@interface GameOptions : NSObject
@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) GameType gameType;
@property (assign, nonatomic) GameTypeDelay gameTypeDelay;
@property (assign, nonatomic) GameTime gameTime;
@property (assign, nonatomic) CGFloat overtime;
@property (strong, nonatomic) NSString *detail;

@end
