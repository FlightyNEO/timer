//
//  AppDelegate.m
//  Timer
//
//  Created by Arkadiy Grigoryanc on 25.07.16.
//  Copyright © 2016 Arkadiy Grigoryanc. All rights reserved.
//

#import "AppDelegate.h"
#import "TimeSettingController.h"
#import "SettingController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    /* Option time */
    extern GameOption gGameOption;
    
    NSString *path = [NSString stringWithFormat:@"%@/game.arch", NSTemporaryDirectory()];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path] == YES) {
        
        NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        NSLog(@"%@", dict);
        gGameOption = GameOptionMake([[dict objectForKey:@"GameType"] intValue] ,
                                     [[dict objectForKey:@"GameTime"] intValue],
                                     [[dict objectForKey:@"GameTypeDelay"] intValue],
                                     [[dict objectForKey:@"GameOvertime"] intValue]);
        
    } else {
        
        gGameOption = GameOptionMake(GameTypeHourglass,
                                     GameTime1,
                                     GameTypeDelayNone,
                                     0);
    }
    
    
    // Разархивируем массив с опциями (если его нету создаем новый)
    extern NSMutableDictionary *gOption;
    
    NSString *pathOptions = [NSString stringWithFormat:@"%@/options", NSTemporaryDirectory()];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:pathOptions] == YES) {      // если массив существует
        
        NSMutableDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithFile:pathOptions];
        NSLog(@"%@", dict);
        
        gOption = dict;
        
    } else {
        
        gOption = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                   @YES, @"volumeSwitch",
                   @100, @"volume",
                   @1, @"sound",
                   @NO, @"planeMode",
                   @NO, @"numberOfStep",
                   nil]; 
    }
    
    
    // Разархивируем массив с предупреждениями
    extern NSMutableArray <NSDictionary *> *gWarnings;
    
    NSString *pathWarnings = [NSString stringWithFormat:@"%@/warnings", NSTemporaryDirectory()];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:pathWarnings] == YES) {      // если массив существует
        
        NSMutableArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:pathWarnings];
        NSLog(@"%@", array);
        
        gWarnings = array;
        
    } else {
        
        gWarnings = [NSMutableArray array];
        
    }
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
