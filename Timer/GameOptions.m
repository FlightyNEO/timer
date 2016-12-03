//
//  GameOptions.m
//  Timer
//
//  Created by Arkadiy Grigoryanc on 02.08.16.
//  Copyright © 2016 Arkadiy Grigoryanc. All rights reserved.
//

#import "GameOptions.h"

@implementation GameOptions

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.gameTime = 0;
        self.gameType = GameTypeRapidity;
        self.gameTypeDelay = GameTypeDelayNone;
        self.overtime = 0;
        self.name = @"Default";
        self.detail = @"Default";
        
    }
    return self;
}

@end
