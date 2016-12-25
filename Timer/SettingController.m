//
//  SettingController.m
//  Timer
//
//  Created by Arkadiy Grigoryanc on 27.07.16.
//  Copyright © 2016 Arkadiy Grigoryanc. All rights reserved.
//

#import "SettingController.h"
#import "Timer.h"
#import "InfoController.h"
#import "WarningController.h"

NSDictionary *gGameName;
NSMutableDictionary *gOption;
NSMutableArray <NSDictionary *> *gWarnings;
GameOption gGameOption;

@implementation SettingController {
    NSInteger row;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isChangeSetting = NO;
    
    // Разархивируем массив с названием выбранного таймера (если его нету создаем новый)
    NSString *pathNameGame = [NSString stringWithFormat:@"%@/nameGame", NSTemporaryDirectory()];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:pathNameGame] == YES) {      // если массив существует
        
        gGameName = [NSKeyedUnarchiver unarchiveObjectWithFile:pathNameGame];
        NSLog(@"%@", gGameName);
        
    } else {
        
        gGameName = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                     @"1 минута", @"Title",
                     @"1 мин, песочные часы", @"Detail",
                     nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger numberOfRows;
    
    switch (section) {
        case 0:
            numberOfRows = 1;
            break;
            
        case 1:
            numberOfRows = [gWarnings count] + 1;
            break;
            
        case 2: {
            if ([[gOption objectForKey:@"volumeSwitch"] boolValue]) {
                numberOfRows = 3;
            } else {
                numberOfRows = 1;
            }
        }
            break;
            
        case 3:
            numberOfRows = 1;
            break;
            
        default:
            break;
    }
    
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    // Configure the cell...
    switch (indexPath.section) {
        case 0: {
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"TimeLimitCell" forIndexPath:indexPath];
            cell.textLabel.text = [gGameName objectForKey:@"Title"];
            cell.detailTextLabel.text = [gGameName objectForKey:@"Detail"];
        }
            break;
            
        case 1: {
            
            if (indexPath.row != [gWarnings count]) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"WarningCell" forIndexPath:indexPath];
                cell.textLabel.text = [[gWarnings objectAtIndex:indexPath.row] objectForKey:@"Name"];
                cell.detailTextLabel.text = [[gWarnings objectAtIndex:indexPath.row] objectForKey:@"Detail"];
            } else {
                cell = [tableView dequeueReusableCellWithIdentifier:@"AddWarningCell" forIndexPath:indexPath];
            }
        }
            break;
            
        case 2: {
            
            switch (indexPath.row) {
                case 0:
                    cell = [tableView dequeueReusableCellWithIdentifier:@"SwichVolumeCell" forIndexPath:indexPath];
                    
                    for (UISwitch *obj in cell.contentView.subviews) {
                        if ([obj class] == [UISwitch class]) {
                            obj.on = [[gOption objectForKey:@"volumeSwitch"] boolValue];
                        }
                    }
                    
                    break;
                case 1:
                    cell = [tableView dequeueReusableCellWithIdentifier:@"VolumeCell" forIndexPath:indexPath];
                    
                    for (UISlider *obj in cell.contentView.subviews) {
                        if ([obj class] == [UISlider class]) {
                            obj.value = [[gOption objectForKey:@"volume"] floatValue];
                        }
                    }
                    
                    break;
                case 2:
                    cell = [tableView dequeueReusableCellWithIdentifier:@"SoundCell" forIndexPath:indexPath];
                    
                    for (UISegmentedControl *obj in cell.contentView.subviews) {
                        if ([obj class] == [UISegmentedControl class]) {
                            obj.selectedSegmentIndex = [[gOption objectForKey:@"sound"] intValue];
                        }
                    }
                    
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        case 3: {
            
            switch (indexPath.row) {
//                case 0:
//                    cell = [tableView dequeueReusableCellWithIdentifier:@"PlaneModeCell" forIndexPath:indexPath];
//
//                    for (UISwitch *obj in cell.contentView.subviews) {
//                        if ([obj class] == [UISwitch class]) {
//                            obj.on = [[gOption objectForKey:@"planeMode"] boolValue];
//                        }
//                    }
//
//                    break;
//                case 1:
//                    cell = [tableView dequeueReusableCellWithIdentifier:@"NumberOfStepCell" forIndexPath:indexPath];
//                    
//                    for (UISwitch *obj in cell.contentView.subviews) {
//                        if ([obj class] == [UISwitch class]) {
//                            obj.on = [[gOption objectForKey:@"numberOfStep"] boolValue];
//                        }
//                    }
                    
                    break;
                case 0:
                    cell = [tableView dequeueReusableCellWithIdentifier:@"AboutMeCell" forIndexPath:indexPath];
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Ограничения времени";
            break;
        case 1:
            return @"Предупреждения о приближении к нулевой отметке таймера";
            break;
        case 2:
            return @"Звук";
            break;
        case 3:
            return @"Другие параметры";
            break;
        default:
            return @"Другое";
            break;
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell.reuseIdentifier isEqualToString: @"WarningCell"]) {
        row = indexPath.row;
    }
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell.reuseIdentifier isEqualToString: @"AddWarningCell"]) {
        
        NSDictionary *warning = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"Сигнал тревоги, 0 сек", @"Name",
                                 @"", @"Detail",
                                 @0, @"TimeWarning",
                                 @0, @"TypeWarning",
                                 @1, @"Volume",
                                 @YES, @"OnForWhite",
                                 @YES, @"OnForBlack",
                                 nil];
        
        [gWarnings addObject:warning];
        
        [self archiveWarnings];     // Архивируем предупреждения
        
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
    }
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell.reuseIdentifier isEqualToString:@"WarningCell"]) {
        return YES;
    }
    
    return NO;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        [gWarnings removeObjectAtIndex:indexPath.row];
        [self archiveWarnings];     // Архивируем предупреждения
        //[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        CGFloat width = CGRectGetWidth(self.tableView.frame);
        
        UIFont *fontThin = [UIFont systemFontOfSize:16 weight:UIFontWeightThin];
        UIFont *fontLight = [UIFont systemFontOfSize:11 weight:UIFontWeightLight];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        
        NSMutableAttributedString *nameAttributeString = [[NSMutableAttributedString alloc] initWithString:[gGameName objectForKey:@"Title"]];
        [nameAttributeString addAttribute:NSFontAttributeName
                                    value:fontThin
                                    range:NSMakeRange(0, nameAttributeString.length)];
        [nameAttributeString addAttribute:NSParagraphStyleAttributeName
                                    value:paragraphStyle
                                    range:NSMakeRange(0, nameAttributeString.length)];
        
        NSMutableAttributedString *detailAttributeString = [[NSMutableAttributedString alloc] initWithString:[gGameName objectForKey:@"Detail"]];
        [detailAttributeString addAttribute:NSFontAttributeName
                                      value:fontLight
                                      range:NSMakeRange(0, detailAttributeString.length)];
        [detailAttributeString addAttribute:NSParagraphStyleAttributeName
                                      value:paragraphStyle
                                      range:NSMakeRange(0, detailAttributeString.length)];
        
        CGSize nameLabel = [nameAttributeString boundingRectWithSize:CGSizeMake(width - 15 * 2, CGFLOAT_MAX)
                                                             options:NSStringDrawingUsesFontLeading
                                                             context:nil].size;
        
        CGSize detailLabel = [detailAttributeString boundingRectWithSize:CGSizeMake(width - 15 * 2, CGFLOAT_MAX)
                                                                 options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                                                 context:nil].size;
        
        
        return 5 + ceilf(nameLabel.height) + 5 + ceilf(detailLabel.height) + 5;
    } else {
        return 44;
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    
    NSString *title = [self tableView:self.tableView titleForHeaderInSection:indexPath.section];
    
    if ([segue.identifier isEqualToString:@"TimeLimit"]) {
        
        [segue.destinationViewController navigationItem].title = title;
        
        TimeSettingController *navigationController = segue.destinationViewController;
        navigationController.topNavigationController = self;
        
    } else if ([segue.identifier isEqualToString:@"Warning"]) {
        
        [segue.destinationViewController navigationItem].title = title;
        
        WarningController *navigationController = segue.destinationViewController;
        navigationController.topNavigationController = self;
        navigationController.row = row;
    }
}

#pragma mark - UIAdaptivePresentationControllerDelegate

- (UIModalPresentationStyle) adaptivePresentationStyleForPresentationController:(UIPresentationController * )controller {
    return UIModalPresentationNone;
}

#pragma mark - Archiving

- (void)archiveNameGame {
    NSString *pathNameGame = [NSString stringWithFormat:@"%@/nameGame", NSTemporaryDirectory()];
    [NSKeyedArchiver archiveRootObject:gGameName toFile:pathNameGame];    // архивируем название выбранного таймера
}

- (void)archiveOptions {
    NSString *pathOptions = [NSString stringWithFormat:@"%@/options", NSTemporaryDirectory()];
    [NSKeyedArchiver archiveRootObject:gOption toFile:pathOptions];    // архивируем опции
}

- (void)archiveWarnings {
    NSString *pathOptions = [NSString stringWithFormat:@"%@/warnings", NSTemporaryDirectory()];
    [NSKeyedArchiver archiveRootObject:gWarnings toFile:pathOptions];    // архивируем предупреждения
}

#pragma mark - Methods

-(BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - Actions

- (IBAction)toggleInfoPopover:(UIButton *)sender {
    
    InfoController *infoController = [[InfoController alloc] init];
    CGSize contentSize = CGSizeMake(280,200);
    UINavigationController *destNav = [[UINavigationController alloc] initWithRootViewController:infoController];
    infoController.preferredContentSize = contentSize;
    destNav.modalPresentationStyle = UIModalPresentationPopover;
    destNav.navigationBarHidden = YES;
    _infoPopoverController = destNav.popoverPresentationController;
    self.infoPopoverController.delegate = self;
    self.infoPopoverController.sourceView = sender;
    self.infoPopoverController.sourceRect = sender.bounds;
    
    if (sender.tag == InfoControllerButtonInfoPlaneMode) {
        infoController.buttonInfo = InfoControllerButtonInfoPlaneMode;
    }
    
    infoController.contentSize = contentSize;
    
    [self presentViewController:destNav animated:YES completion:nil];
    
}

- (IBAction)actionVolumeSwitch:(UISwitch *)sender {
    [gOption setValue:[NSNumber numberWithBool:sender.on] forKey:@"volumeSwitch"];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
    [self archiveOptions];
}

- (IBAction)actionVolumeChange:(UISlider *)sender {
    [gOption setValue:[NSNumber numberWithFloat:sender.value] forKey:@"volume"];
    [self archiveOptions];
    [self.delegate changeVolume];
}

- (IBAction)actionSoundChange:(UISegmentedControl *)sender {
    [gOption setValue:[NSNumber numberWithInteger:sender.selectedSegmentIndex] forKey:@"sound"];
    [self archiveOptions];
    [self.delegate changeSound];
}

- (IBAction)actionPlaneModeSwitch:(UISwitch *)sender {
    [gOption setValue:[NSNumber numberWithBool:sender.on] forKey:@"planeMode"];
    [self archiveOptions];
    [self.delegate changeAirplainMode];
}

- (IBAction)actionNumberOfStepSwitch:(UISwitch *)sender {
    [gOption setValue:[NSNumber numberWithBool:sender.on] forKey:@"numberOfStep"];
    [self archiveOptions];
}

#pragma mark - Actions
- (IBAction)actionBack:(UIBarButtonItem *)sender {
    
    [self.navigationController.topViewController dismissViewControllerAnimated:YES completion:nil];
    //[self.delegate dismissViewControllerAnimated:YES completion:nil];
    
    [self archiveNameGame];
    
    if (self.isChangeSetting) {
        if (self.delegate.start.theGameContinues == NO) {
            
            extern GameOption gGameOption;
            
            self.delegate.timer.whiteTimeInterval = gGameOption.time;
            self.delegate.timer.blackTimeInterval = gGameOption.time;
            self.delegate.timer.overtimeTimeInterval = gGameOption.overtime;
            self.delegate.gameOption = gGameOption;
            
            if (gGameOption.typeDelay == GameTypeDelayDefault) {
                [self.delegate drawOvertimeTimers];
            }
            
            if (!self.delegate.start) {
                [self.delegate resetTimer];
            } else {
                [self.delegate.timer refreshTimers];
            }
            
        } else {
            [self.delegate applySettingAndResetTimer];
        }
        
        self.isChangeSetting = NO;
    }
}

@end
