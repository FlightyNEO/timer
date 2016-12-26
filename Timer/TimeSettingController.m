//
//  TimeSettingController.m
//  Timer
//
//  Created by Arkadiy Grigoryanc on 31.07.16.
//  Copyright © 2016 Arkadiy Grigoryanc. All rights reserved.
//

#import "TimeSettingController.h"
#import "OwnTimeSettingController.h"
#import "SettingController.h"

@interface TimeSettingController ()

@property (assign, nonatomic) NSIndexPath *editIndexPath;

@end

@implementation TimeSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItems = [self.navigationItem.rightBarButtonItems arrayByAddingObject:self.editButtonItem];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Настройки"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(actionBack:)];  // ИЗМЕНИТЬ
    self.navigationItem.leftBarButtonItem = backButton;
    
    // Разархивируем массив с собственными вариантами таймера
    NSString *pathOwnGameOptions = [NSString stringWithFormat:@"%@/ownGameOptions", NSTemporaryDirectory()];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:pathOwnGameOptions] == YES) {      // если массив существует
        
        NSMutableArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:pathOwnGameOptions];
        NSLog(@"%@", array);
        
        _ownGameOptions = array;
        
    } else {
        
        _ownGameOptions = [NSMutableArray array];
        
    }
    
    // Разархивируем дефолтные настройки
    [self unarchiveSetting];
    [self refresh];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}

- (void)refresh {

    if ([self.ownGameOptions count] > 0) {
        
        [self.timeLimit setObject:self.ownGameOptions forKey:@"Свой"];
        
    }
    
    _sections = [self.timeLimit allKeys];
    
    NSString *obj = @"Свой";
    
    if ([_sections containsObject:obj]) {
        NSMutableArray *tmpArray = [_sections mutableCopy];
        [tmpArray removeObject:obj];
        [tmpArray insertObject:obj atIndex:0];
        _sections = tmpArray;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)changeGameOptions:(NSIndexPath *)indexPath {
    
    extern GameOption gGameOption;
    
    // Type Game
    gGameOption.type = [[[[self.timeLimit objectForKey:[self.sections objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row] objectForKey:@"Type"] intValue];
    
    // Type Delay Game
    gGameOption.typeDelay = [[[[self.timeLimit objectForKey:[self.sections objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row] objectForKey:@"TypeDelay"] intValue];
    
    // Time Game
    gGameOption.time = [[[[self.timeLimit objectForKey:[self.sections objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row] objectForKey:@"Time"] intValue];
    
    // Overtime Game
    gGameOption.overtime = [[[[self.timeLimit objectForKey:[self.sections objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row] objectForKey:@"Overtime"] intValue];
    
    self.topNavigationController.isChangeSetting = YES;   // Настройки были изменены
    
}

#pragma mark - Archiving

- (void)archiveCurrentSetting {
    // Архивируем выбранный таймер
    extern GameOption gGameOption;
    
    NSNumber *type = [NSNumber numberWithInt:gGameOption.type];
    NSNumber *typeDelay = [NSNumber numberWithInt:gGameOption.typeDelay];
    NSNumber *time = [NSNumber numberWithInt:gGameOption.time];
    NSNumber *overtime = [NSNumber numberWithInt:gGameOption.overtime];
    
    NSDictionary *dict = @{@"GameType" : type,
                           @"GameTypeDelay" : typeDelay,
                           @"GameTime" : time,
                           @"GameOvertime" : overtime,
                           @"IndexPath" : self.selectedIndexPath};
    
    NSString *path = [NSString stringWithFormat:@"%@/game.arch", NSTemporaryDirectory()];
    [NSKeyedArchiver archiveRootObject:dict toFile:path];
}

- (void)archiveOwnSetting {
    // Архивируем массив с собственными вариантами таймера
    NSString *pathOwnGameOptions = [NSString stringWithFormat:@"%@/ownGameOptions", NSTemporaryDirectory()];
    [NSKeyedArchiver archiveRootObject:self.ownGameOptions toFile:pathOwnGameOptions];
}

- (void)unarchiveSetting {
    // Разархивируем дефолтные настройки
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Setting" ofType:@"plist"];
    _timeLimit = [NSMutableDictionary dictionaryWithContentsOfFile:path];
}

#pragma mark - Action

- (void)actionBack:(UIBarButtonItem *)sender {
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.selectedIndexPath];
    
    extern NSDictionary *gGameName;
    gGameName = [NSDictionary dictionaryWithObjectsAndKeys:
                 cell.textLabel.text, @"Title",
                 cell.detailTextLabel.text, @"Detail",
                 nil];
    
    [self.topNavigationController.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone]; // ЗАМЕНИТЬ НА ЛУЧШИЙ КОД (убрать константы)
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - Methods

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.timeLimit.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.sections[section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.timeLimit objectForKey:[self.sections objectAtIndex:section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    if ([[self tableView:tableView titleForHeaderInSection:indexPath.section] isEqualToString:@"Свой"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"OwnCell" forIndexPath:indexPath];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"TimeCell" forIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    // Configure the cell...
    // Text Label //
    cell.textLabel.text = [[[self.timeLimit objectForKey:[self.sections objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row] objectForKey:@"Name"];
    
    // Text Detail //
    cell.detailTextLabel.text = [[[self.timeLimit objectForKey:[self.sections objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row] objectForKey:@"Detail"];
    
    void(^selected)(void) = ^(void) {
        _selectedIndexPath = indexPath;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    };
    
    NSString *path = [NSString stringWithFormat:@"%@/game.arch", NSTemporaryDirectory()];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path] == YES) {
        
        NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        NSLog(@"%@", dict);
        
        NSIndexPath *indexPath2 = [dict objectForKey:@"IndexPath"];
        
        if ([indexPath2 isEqual:indexPath]) {
            selected();
        }
    } else {
        if ([[[[self.timeLimit objectForKey:[self.sections objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row] objectForKey:@"Default"] boolValue]) {
            selected();
        }
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:self.selectedIndexPath];
    selectedCell.accessoryType = UITableViewCellAccessoryNone;
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    _selectedIndexPath = indexPath;
    
    [self changeGameOptions:indexPath];
    
    [self archiveCurrentSetting];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return YES;
    } else {
        return NO;
    }
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *title = [self tableView:tableView titleForHeaderInSection:indexPath.section];
    
    if ([title isEqualToString:@"Свой"]) {
        
        UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
                                                                              title:@"Изменить"
                                                                            handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
                                                                                //insert your editAction here
                                                                                
                                                                                _editIndexPath = indexPath;
                                                                                
                                                                                
                                                                                [self performSegueWithIdentifier:@"Edit" sender:self];
                                                                                NSLog(@"edit");
                                                                            }];
        editAction.backgroundColor = [UIColor blueColor];
        
        UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
                                                                                title:@"Удалить"
                                                                              handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
                                                                                  //insert your deleteAction here
                                                                                  
                                                                                  if ([indexPath isEqual:self.selectedIndexPath]) {     // если удаляем выбранную ячейку
                                                                                      
                                                                                      NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                                                                                      [self tableView:self.tableView didSelectRowAtIndexPath:newIndexPath];
                                                                                      
                                                                                  }
                                                                                  
                                                                                  [self.ownGameOptions removeObjectAtIndex:indexPath.row];
                                                                                  
                                                                                  [self archiveOwnSetting];
                                                                                  
                                                                                  if ([self.ownGameOptions count] == 0) {
                                                                                      [self unarchiveSetting];
                                                                                  }
                                                                                  
                                                                                  [self refresh];
                                                                                  
                                                                                  if ([self.ownGameOptions count] >= 1) {
                                                                                      [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                                                                                  } else {
                                                                                      [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
                                                                                  }
                                                                                  
                                                                                  NSLog(@"delete");
                                                                              }];
        deleteAction.backgroundColor = [UIColor redColor];
        
        return @[deleteAction,editAction];
    } else {
        return nil;
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *title = [self tableView:tableView titleForHeaderInSection:indexPath.section];
    
    if (![title isEqualToString:@"Свой"]) {
        return UITableViewCellEditingStyleNone;
    } else {
        return UITableViewCellEditingStyleDelete;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = CGRectGetWidth(self.tableView.frame);
    
    UIFont *fontThin = [UIFont systemFontOfSize:16 weight:UIFontWeightThin];
    
    UIFont *fontLight = [UIFont systemFontOfSize:11 weight:UIFontWeightLight];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSMutableAttributedString *nameAttributeString = [[NSMutableAttributedString alloc] initWithString:[[[self.timeLimit objectForKey:[self.sections objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row] objectForKey:@"Name"]];
    [nameAttributeString addAttribute:NSFontAttributeName
                                value:fontThin
                                range:NSMakeRange(0, nameAttributeString.length)];
    [nameAttributeString addAttribute:NSParagraphStyleAttributeName
                                value:paragraphStyle
                                range:NSMakeRange(0, nameAttributeString.length)];
    
    NSMutableAttributedString *detailAttributeString = [[NSMutableAttributedString alloc] initWithString:[[[self.timeLimit objectForKey:[self.sections objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row] objectForKey:@"Detail"]];
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
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    OwnTimeSettingController *navigationController = segue.destinationViewController;
    navigationController.timeSettingController = self;
    
    if ([[segue identifier] isEqualToString:@"addOwnGameOption"]) {
        navigationController.editIndexPath = nil;      // nathing
    }
    
    if ([[segue identifier] isEqualToString:@"Edit"]) {
        navigationController.editIndexPath = self.editIndexPath;
    }
}

@end
