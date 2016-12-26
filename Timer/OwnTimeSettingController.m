//
//  OwnTimeSettingController.m
//  Timer
//
//  Created by Arkadiy Grigoryanc on 05.08.16.
//  Copyright © 2016 Arkadiy Grigoryanc. All rights reserved.
//

#import "OwnTimeSettingController.h"
#import "GameOptions.h"
#import "InfoController.h"

#define kHoursComponent      0
#define kMinutesComponent    1
#define kSecondsComponent    2

#define kHours      @"hours"
#define kMinutes    @"minutes"
#define kSeconds    @"seconds"

typedef enum {
    OwnTimeSettingControllerTypeTime = 1,
    OwnTimeSettingControllerTypeOvertime = 3,
    OwnTimeSettingControllerTypeTypeDelay = 4
} OwnTimeSettingControllerType;

@interface OwnTimeSettingController ()
// Pickers property
@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) NSDictionary *timePicker;
@property (strong, nonatomic) NSArray *typeDelayPicker;

@property (weak, nonatomic) UISwitch *hourglassSwitch;      // Тип игры (песочные часы / простой)

@property (strong, nonatomic) UITextField *nameTextField;


@property (strong, nonatomic) UILabel *headerRowTimeLabel;
@property (strong, nonatomic) UILabel *headerRowOvertimeLabel;
@property (strong, nonatomic) UILabel *headerRowTypeDelayLabel;


@property (weak, nonatomic) UIButton *infoButtonHourglass;
@property (weak, nonatomic) UIButton *infoButtonDelay;


@end

@implementation OwnTimeSettingController {
    //NSInteger selectedCell;
    NSIndexPath *selectedIndexPath;
    
    NSString *nameLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // filling table
    if (self.editIndexPath) {   // If change an existing
        
        NSDictionary *dict = [self.timeSettingController.ownGameOptions objectAtIndex:self.editIndexPath.row];
        
        _name = [dict objectForKey:@"Name"];
        _detail = [dict objectForKey:@"Detail"];
        _type = [[dict objectForKey:@"Type"] intValue];
        _typeDelay = [[dict objectForKey:@"TypeDelay"] intValue];
        
        NSInteger time = [[dict objectForKey:@"Time"] intValue];
        NSInteger overtime = [[dict objectForKey:@"Overtime"] intValue];
        
        _timePickerHours = time / 3600;
        _timePickerSeconds = time - (self.timePickerHours * 3600);
        _timePickerMinutes = self.timePickerSeconds / 60;
        _timePickerSeconds = self.timePickerSeconds - (self.timePickerMinutes * 60);
        
        _overtimePickerHours = overtime / 3600;
        _overtimePickerSeconds = overtime - (self.overtimePickerHours * 3600);
        _overtimePickerMinutes = self.overtimePickerSeconds / 60;
        _overtimePickerSeconds = self.overtimePickerSeconds - (self.overtimePickerMinutes * 60);
        
        self.navigationItem.title = self.name;
        
    } else {
        
        _type = GameTypeRapidity;
        _typeDelay = GameTypeDelayNone;
        
    }
    
    
//    if (self.name) {
//        self.navigationItem.title = self.name;
//    }
    
    
    
    // create dictionary for time picker and overtime picker
    NSMutableArray *timePickerHours = [NSMutableArray array];
    NSMutableArray *timePickerMinutes = [NSMutableArray array];
    
    for (int i = 0; i <= 20; i++) {
        [timePickerHours addObject:[NSNumber numberWithInt:i]];
    }
    
    for (int i = 0; i <= 59; i++) {
        [timePickerMinutes addObject:[NSNumber numberWithInt:i]];
    }
    
    _timePicker = @{kHours : timePickerHours,
                        kMinutes : timePickerMinutes,
                        kSeconds : timePickerMinutes};
    
    
    // create dictionary for type delay picker
    _typeDelayPicker = @[@"Без задержки",
                             @"Простая",
                             @"Фишер до",
                             @"Фишер после",
                             @"Бронштейна"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    // Configure the cell...
    
    switch (indexPath.row) {
        case 0: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"NameCell" forIndexPath:indexPath];
            
            UITextField *textField;
            
            if (self.nameTextField == nil) {
                textField = [[UITextField alloc] initWithFrame:CGRectMake(16,
                                                                          0,
                                                                          CGRectGetWidth(cell.contentView.frame) - 36,
                                                                          CGRectGetHeight(cell.contentView.frame))];
                
                textField.delegate = self;
                
                textField.placeholder = @"Введите название ограничения";
                
                textField.returnKeyType = UIReturnKeyDone;
                
                _nameTextField = textField;
                
                
                
            }
            
            if (self.name) {
                self.nameTextField.text = self.name;
                _name = nil;
            }
            
            [cell.contentView addSubview:self.nameTextField];
            
        }
            break;
            
        case 1: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"TimeCell" forIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = [self titleForRow:OwnTimeSettingControllerTypeTime];
        }
            break;
            
        case 2: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"TypeDelayCell" forIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = [self titleForRow:OwnTimeSettingControllerTypeTypeDelay];
            
            // Add info button
            UIButton *buttonInfo = [self createInfoButton:InfoControllerButtonInfoDelay];
            buttonInfo.center = CGPointMake(CGRectGetWidth(cell.frame) - (20 / 2) - 16 - 20,
                                                      CGRectGetMidY(cell.contentView.frame));
            _infoButtonDelay = buttonInfo;
            [cell.contentView addSubview:self.infoButtonDelay];
            
        }
            break;
            
        case 3: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"OvertimeCell" forIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = [self titleForRow:OwnTimeSettingControllerTypeOvertime];
        }
            break;
            
        case 4: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Hourglass" forIndexPath:indexPath];
            //cell.textLabel.text = @"Песочные часы:";
            
            // Add label
            UILabel *textLabel = [[UILabel alloc] init];
            textLabel.text = @"Песочные часы";
            [textLabel sizeToFit];
            textLabel.center = CGPointMake((CGRectGetWidth(textLabel.frame) / 2) + 16, CGRectGetMidY(cell.contentView.frame));
            
            [cell.contentView addSubview:textLabel];
            
            // Add switch
            UISwitch *hourglass = [[UISwitch alloc] init];
            hourglass.center = CGPointMake(CGRectGetWidth(cell.contentView.frame) - (CGRectGetWidth(hourglass.frame) / 2) - 16,
                                           CGRectGetMidY(cell.contentView.frame));
            
            if (self.type == GameTypeRapidity) {
                hourglass.on = NO;
            } else if (self.type == GameTypeHourglass) {
                hourglass.on = YES;
            }
            
            _hourglassSwitch = hourglass;
            
            [cell.contentView addSubview:self.hourglassSwitch];
            
            // Add info button
            UIButton *buttonInfo = [self createInfoButton:InfoControllerButtonInfoHourglass];
            buttonInfo.center = CGPointMake(CGRectGetMaxX(textLabel.frame) + 10 + (CGRectGetWidth(buttonInfo.frame) / 2),
                                            CGRectGetMidY(cell.contentView.frame));
            _infoButtonHourglass = buttonInfo;
            [cell.contentView addSubview:self.infoButtonHourglass];
            
        }
            break;
            
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([cell.reuseIdentifier isEqualToString:@"TimeCell"] ||
        [cell.reuseIdentifier isEqualToString:@"OvertimeCell"] ||
        [cell.reuseIdentifier isEqualToString:@"TypeDelayCell"]) {
        
        // Очищаем ячейку
        for (id subView in [cell.contentView subviews]) {
            if ([subView class] != [UIButton class]) {
                [subView removeFromSuperview];
            }
        }
        
        if (indexPath.row != selectedIndexPath.row) {
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:selectedIndexPath.row inSection:0];
            selectedIndexPath = indexPath;
            [self tableView:tableView updateAtIndexPath:oldIndexPath];
            
            // заполняем ячейку
            [self cellFilling:cell];
            
        } else {
            
            selectedIndexPath = nil;
            
            [self tableView:tableView updateAtIndexPath:indexPath];
            
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat cellHeight = 40.f;
    
    if ((selectedIndexPath.row == indexPath.row) && (selectedIndexPath != nil)) {
        cellHeight = 120.f;
    }
    
    return cellHeight;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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
}

#pragma mark - UIAdaptivePresentationControllerDelegate

- (UIModalPresentationStyle) adaptivePresentationStyleForPresentationController:(UIPresentationController * )controller {
    return UIModalPresentationNone;
}

#pragma mark - Actions

- (void)toggleInfoPopover:(UIButton *)sender {
    
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
    
    if (sender.tag == InfoControllerButtonInfoHourglass) {
        infoController.buttonInfo = InfoControllerButtonInfoHourglass;
    } else if (sender.tag == InfoControllerButtonInfoDelay) {
        infoController.buttonInfo = InfoControllerButtonInfoDelay;
    }
    
    infoController.contentSize = contentSize;
    
    [self presentViewController:destNav animated:YES completion:nil];
}

- (IBAction)actionSaveAndBack:(UIBarButtonItem *)sender {
    
    if ((self.timePickerHours == 0 && self.timePickerMinutes == 0 && self.timePickerSeconds == 0) &&
        (self.typeDelay == GameTypeDelayNone || (self.overtimePickerHours == 0 && self.overtimePickerMinutes == 0 && self.overtimePickerSeconds == 0))) {
        
        [self alertErrorAction:@"Установите ограничение времени или задержку на ход"];
        
    } else  if ((self.timePickerHours == 0 && self.timePickerMinutes == 0 && self.timePickerSeconds == 0) &&
                (self.typeDelay == GameTypeDelayIncrementAfter || self.typeDelay == GameTypeDelayIncrementDelayedAfter)) {
        
        [self alertErrorAction:@"Тип задержки не может быть \"Фишер после\" и \"Бронштейна\" при нулевом ограничении времени"];
        
    } else {
        
        [self saveAndCancel];
    }
}

#pragma mark - Methods

- (void)alertErrorAction:(NSString *)message {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Ошибка"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ок"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}

-(BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)saveAndCancel {
    
    NSDictionary *gameOption = [self createOwnGameOption];
    
    if (!self.editIndexPath) {       // create new setting
        
        [self.timeSettingController.ownGameOptions addObject:gameOption];
        
    } else {        // change setting
        
        [self.timeSettingController.ownGameOptions replaceObjectAtIndex:self.editIndexPath.row withObject:gameOption];
        
        if ([self.timeSettingController.selectedIndexPath isEqual: self.editIndexPath]) {    // Если редактируемый таймер Выбран
            [self.timeSettingController changeGameOptions:[NSIndexPath indexPathForRow:self.editIndexPath.row inSection:[self.timeSettingController.sections indexOfObject:@"Свой"]]]; // change game option
        }

        
        //[self.delegate changeGameOptions:[NSIndexPath indexPathForRow:self.editIndexPath.row inSection:[self.delegate.sections indexOfObject:@"Свой"]]]; // change game option
    }
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
    [self.timeSettingController archiveOwnSetting];      // архивируем свои настройки
    [self.timeSettingController archiveCurrentSetting];  // архивируем текущий таймер
//    if ([self.delegate.selectedIndexPath isEqual: self.editIndexPath]) {    // Если редактируемый таймер Выбран
//        [self.delegate archiveCurrentSetting];  // архивируем текущий таймер
//    }
    
    [self.timeSettingController refresh];
    
}

// Заполняем ячейку
- (void)cellFilling:(UITableViewCell *)cell {
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16,
                                                               0,
                                                               CGRectGetWidth(cell.frame) - 36,
                                                               40)];
    label.text = cell.textLabel.text;
    
    cell.textLabel.text = @"";
    
    switch (cell.tag) {
        case OwnTimeSettingControllerTypeTime:
            _headerRowTimeLabel = label;
            [cell.contentView addSubview:self.headerRowTimeLabel];
            break;
        case OwnTimeSettingControllerTypeOvertime:
            _headerRowOvertimeLabel = label;
            [cell.contentView addSubview:self.headerRowOvertimeLabel];
            break;
        case OwnTimeSettingControllerTypeTypeDelay:
            _headerRowTypeDelayLabel = label;
            [cell.contentView addSubview:self.headerRowTypeDelayLabel];
            break;
            
        default:
            break;
    }
    
    // Create picker
    [self createPickerView:cell];
    
    [cell.contentView addSubview:self.pickerView];
}

- (void)tableView:(UITableView *)tableView updateAtIndexPath:(NSIndexPath *)indexPath {
    
    [UIView setAnimationsEnabled:YES];
    
    //[tableView beginUpdates];
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
    //[tableView endUpdates];
    
    [UIView setAnimationsEnabled:[UIView areAnimationsEnabled]];
}

- (UIButton *)createInfoButton:(InfoControllerButtonInfo)type {
    UIButton *buttonInfo = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [buttonInfo addTarget:self action:@selector(toggleInfoPopover:) forControlEvents:UIControlEventTouchUpInside];
    
    buttonInfo.frame = CGRectMake(0, 0, 20, 20);
    
    [buttonInfo setImage:[UIImage imageNamed:@"info"] forState:UIControlStateNormal];
    
    buttonInfo.tag = type;
    
    return buttonInfo;
}

- (NSString *)detailForOwnSetting {
    
    NSMutableString *string = [NSMutableString string];
    
    NSString *time = [self titleForRow:OwnTimeSettingControllerTypeTime];
    NSRange rangeTime = [time rangeOfString:@": "];
    [string appendString:[time substringFromIndex:rangeTime.location + rangeTime.length]];
    
    
    NSString *overtime = [self titleForRow:OwnTimeSettingControllerTypeOvertime];
    NSRange rangeOvertime = [overtime rangeOfString:@": "];
    
    switch (self.typeDelay) {
        case GameTypeDelayNone:
            [string appendString:@", без задержки"];
            break;
            
        case GameTypeDelayDefault:
            [string appendFormat:@", +%@ перед каждым ходом", [overtime substringFromIndex:rangeOvertime.location + rangeOvertime.length]];
            break;
            
        case GameTypeDelayIncrementBefore:
            [string appendFormat:@", задержка %@ на ход перед запуском таймера", [overtime substringFromIndex:rangeOvertime.location + rangeOvertime.length]];
            break;
            
        case GameTypeDelayIncrementAfter:
            [string appendFormat:@", +%@ после каждого хода", [overtime substringFromIndex:rangeOvertime.location + rangeOvertime.length]];
            break;
            
        case GameTypeDelayIncrementDelayedAfter:
            [string appendFormat:@", задержка %@, применяемая после каждого хода", [overtime substringFromIndex:rangeOvertime.location + rangeOvertime.length]];
            break;
            
        default:
            break;
    }
    
    if (self.hourglassSwitch.on) {
        [string appendFormat:@", песочные часы"];
    }
    
    return string;
    
}

- (NSDictionary *)createOwnGameOption {
    
    NSTimeInterval time = (self.timePickerHours * 3600) + (self.timePickerMinutes * 60) + self.timePickerSeconds;
    NSTimeInterval overtime = (self.overtimePickerHours * 3600) + (self.overtimePickerMinutes * 60) + self.overtimePickerSeconds;
    
    if (overtime == 0) {
        _typeDelay = GameTypeDelayNone;
    }
    
    if (self.hourglassSwitch.on) {
        _type = GameTypeHourglass;
    } else {
        _type = GameTypeRapidity;
    }
    
    
    if ([self.nameTextField.text isEqualToString:@""]) {
        self.nameTextField.text = @"Без названия";
    }
    
    NSDictionary *gameOption = [NSDictionary dictionaryWithObjectsAndKeys:
                                self.nameTextField.text, @"Name",
                                [self detailForOwnSetting], @"Detail",
                                [NSNumber numberWithInt:time], @"Time",
                                [NSNumber numberWithInt:overtime], @"Overtime",
                                [NSNumber numberWithInt:self.type], @"Type",
                                [NSNumber numberWithInt:self.typeDelay], @"TypeDelay",
                                [NSNumber numberWithBool:NO], @"Default",
                                nil];
    
    NSLog(@"New game option %@", gameOption);
    
    return gameOption;
}

// Create picker
- (void)createPickerView:(UITableViewCell *)cell {
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(16,
                                                                 40,
                                                                 CGRectGetWidth(cell.frame) - 36,
                                                                 CGRectGetHeight(cell.frame) - 40)];
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    
    if (cell.tag == OwnTimeSettingControllerTypeTime) {
        
        [self.pickerView selectRow:self.timePickerHours inComponent:kHoursComponent animated:NO];
        [self.pickerView selectRow:self.timePickerMinutes inComponent:kMinutesComponent animated:NO];
        [self.pickerView selectRow:self.timePickerSeconds inComponent:kSecondsComponent animated:NO];
        
    } else if (cell.tag == OwnTimeSettingControllerTypeOvertime) {
        
        [self.pickerView selectRow:self.overtimePickerHours inComponent:kHoursComponent animated:NO];
        [self.pickerView selectRow:self.overtimePickerMinutes inComponent:kMinutesComponent animated:NO];
        [self.pickerView selectRow:self.overtimePickerSeconds inComponent:kSecondsComponent animated:NO];
        
        if (self.typeDelay == GameTypeDelayNone) {
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(cell.frame), 30)];
            label.center = CGPointMake(CGRectGetMidX(cell.bounds), CGRectGetMidY(cell.bounds));
            label.text = @"Укажите тип задержки";
            label.textColor = [UIColor redColor];
            label.textAlignment = NSTextAlignmentCenter;
            
            [cell.contentView addSubview:label];
            
            self.pickerView.alpha = 0.2;
            self.pickerView.userInteractionEnabled = NO;
            
        }
        
    } else if (cell.tag == OwnTimeSettingControllerTypeTypeDelay) {
        
        NSInteger selectRow;
        
        switch (self.typeDelay) {
                
            case GameTypeDelayNone:
                selectRow = 0;
                break;
                
            case GameTypeDelayDefault:
                selectRow = 1;
                break;
                
            case GameTypeDelayIncrementBefore:
                selectRow = 2;
                break;
                
            case GameTypeDelayIncrementAfter:
                selectRow = 3;
                break;
                
            case GameTypeDelayIncrementDelayedAfter:
                selectRow = 4;
                break;
                
            default:
                selectRow = -1;
                break;
        }
        
        [self.pickerView selectRow:selectRow inComponent:0 animated:NO];
        
    }
}

- (NSString *)titleForRow:(OwnTimeSettingControllerType)type {
    
    NSMutableString *string;
    
    switch (type) {
        case OwnTimeSettingControllerTypeTime: {
            string = [NSMutableString stringWithString:@"Ограничение времени: "];
            
            if (self.timePickerHours != 0) {
                [string appendFormat:@"%ld ч", self.timePickerHours];
            }
            
            if (self.timePickerMinutes != 0) {
                if (self.timePickerHours != 0) {
                    [string appendFormat:@", "];
                }
                [string appendFormat:@"%ld мин", self.timePickerMinutes];
            }
            
            if (self.timePickerSeconds != 0) {
                if ((self.timePickerHours != 0) || (self.timePickerMinutes != 0)) {
                    [string appendFormat:@", "];
                }
                [string appendFormat:@"%ld сек", self.timePickerSeconds];
            }
            
            if (self.timePickerHours == 0 && self.timePickerMinutes == 0 && self.timePickerSeconds == 0) {
                [string appendFormat:@"нет"];
            }
            
        }
            break;
            
        case OwnTimeSettingControllerTypeOvertime: {
            
            string = [NSMutableString stringWithString:@"Задержка на ход: "];
            
            if (self.typeDelay == GameTypeDelayNone) {
                [string appendFormat:@"нет"];
            } else {
                
                if (self.overtimePickerHours != 0) {
                    [string appendFormat:@"%ld ч", self.overtimePickerHours];
                }
                
                if (self.overtimePickerMinutes != 0) {
                    if (self.overtimePickerHours != 0) {
                        [string appendFormat:@", "];
                    }
                    [string appendFormat:@"%ld мин", self.overtimePickerMinutes];
                }
                
                if (self.overtimePickerSeconds != 0) {
                    if ((self.overtimePickerHours != 0) || (self.overtimePickerMinutes != 0)) {
                        [string appendFormat:@", "];
                    }
                    [string appendFormat:@"%ld сек", self.overtimePickerSeconds];
                }
                
                if ((self.overtimePickerHours == 0 && self.overtimePickerMinutes == 0 && self.overtimePickerSeconds == 0)) {
                    [string appendFormat:@"нет"];
                }

            }
        }
            break;
            
        case OwnTimeSettingControllerTypeTypeDelay: {
            
            string = [NSMutableString stringWithString:@"Тип задержки: "];
            
            [string appendFormat:@"%@", [self.typeDelayPicker objectAtIndex:self.typeDelay]];
            
            
        }
            break;
            
        default:
            break;
    }
    
    return string;
    
}

#pragma mark - Picker Data Source Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:selectedIndexPath];
    
    NSInteger numberOfComponents = 0;
    
    switch (cell.tag) {
        case OwnTimeSettingControllerTypeTime:
            numberOfComponents = [self.timePicker count];
            break;
            
        case OwnTimeSettingControllerTypeOvertime:
            numberOfComponents = [self.timePicker count];
            break;
            
        case OwnTimeSettingControllerTypeTypeDelay:
            numberOfComponents = 1;
            break;
    }
    
    return numberOfComponents;
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:selectedIndexPath];
    
    NSInteger numberOfRows;
    
    if ((cell.tag == OwnTimeSettingControllerTypeTime) ||
        (cell.tag == OwnTimeSettingControllerTypeOvertime)) {
        
        NSString *key;
        
        switch (component) {
            case kHoursComponent:
                key = kHours;
                break;
            case kMinutesComponent:
                key = kMinutes;
                break;
            case kSecondsComponent:
                key = kSeconds;
                break;
        }
        
        numberOfRows = [[self.timePicker objectForKey:key] count];
        
    } else if (cell.tag == OwnTimeSettingControllerTypeTypeDelay) {
        
        numberOfRows = [self.typeDelayPicker count];
        
    }
    
    return numberOfRows;
}

#pragma mark Picker Delegate Methods

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:selectedIndexPath];
    
    NSString *string;
    
    if ((cell.tag == OwnTimeSettingControllerTypeTime) ||
        (cell.tag == OwnTimeSettingControllerTypeOvertime)) {
        
        switch (component) {
            case kHoursComponent:
                string = [NSString stringWithFormat:@"%d ч", [[[self.timePicker objectForKey:@"hours"] objectAtIndex:row] intValue]];;
                break;
            case kMinutesComponent:
                string = [NSString stringWithFormat:@"%d мин", [[[self.timePicker objectForKey:@"minutes"] objectAtIndex:row] intValue]];;
                break;
            case kSecondsComponent:
                string = [NSString stringWithFormat:@"%d сек", [[[self.timePicker objectForKey:@"seconds"] objectAtIndex:row] intValue]];;
                break;
        }
        
    } else if (cell.tag == OwnTimeSettingControllerTypeTypeDelay) {
        
        string = [self.typeDelayPicker objectAtIndex:row];
        
    }
    
    return  string;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:selectedIndexPath];
    
    CGFloat width;
    
    if ((cell.tag == OwnTimeSettingControllerTypeTime) ||
        (cell.tag == OwnTimeSettingControllerTypeOvertime)) {
        
        width = CGRectGetWidth(pickerView.frame) / 3;
        
    } else if (cell.tag == OwnTimeSettingControllerTypeTypeDelay) {
        
        width = CGRectGetWidth(pickerView.frame);
        
    }
    
    return  width;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:selectedIndexPath];
    
    if (cell.tag == OwnTimeSettingControllerTypeTime) {
        
        switch (component) {
            case kHoursComponent: {
                _timePickerHours = [[[self.timePicker objectForKey:kHours] objectAtIndex:row] intValue];
            }
                break;
            
            case kMinutesComponent: {
                _timePickerMinutes = [[[self.timePicker objectForKey:kMinutes] objectAtIndex:row] intValue];
            }
                
                break;
            case kSecondsComponent: {
                _timePickerSeconds = [[[self.timePicker objectForKey:kSeconds] objectAtIndex:row] intValue];
            }
                break;
                
            default:
                break;
        }
        
        self.headerRowTimeLabel.text = [self titleForRow:OwnTimeSettingControllerTypeTime];
        
    } else if (cell.tag == OwnTimeSettingControllerTypeOvertime) {
        
        switch (component) {
            case kHoursComponent: {
                _overtimePickerHours = [[[self.timePicker objectForKey:kHours] objectAtIndex:row] intValue];
            }
                break;
                
            case kMinutesComponent: {
                _overtimePickerMinutes = [[[self.timePicker objectForKey:kMinutes] objectAtIndex:row] intValue];
            }
                break;
                
            case kSecondsComponent: {
                _overtimePickerSeconds = [[[self.timePicker objectForKey:kSeconds] objectAtIndex:row] intValue];
            }
                break;
                
            default:
                break;
        }
        
        self.headerRowOvertimeLabel.text = [self titleForRow:OwnTimeSettingControllerTypeOvertime];
        
    } else if (cell.tag == OwnTimeSettingControllerTypeTypeDelay) {
        if ([[self.typeDelayPicker objectAtIndex:row] isEqualToString:@"Без задержки"]) {
            _typeDelay = GameTypeDelayNone;
        } else if ([[self.typeDelayPicker objectAtIndex:row] isEqualToString:@"Простая"]) {
            _typeDelay = GameTypeDelayDefault;
        } else if ([[self.typeDelayPicker objectAtIndex:row] isEqualToString:@"Фишер до"]) {
            _typeDelay = GameTypeDelayIncrementBefore;
        } else if ([[self.typeDelayPicker objectAtIndex:row] isEqualToString:@"Фишер после"]) {
            _typeDelay = GameTypeDelayIncrementAfter;
        } else if ([[self.typeDelayPicker objectAtIndex:row] isEqualToString:@"Бронштейна"]) {
            _typeDelay = GameTypeDelayIncrementDelayedAfter;
        }
        
        self.headerRowOvertimeLabel.text = [self titleForRow:OwnTimeSettingControllerTypeOvertime];
        self.headerRowTypeDelayLabel.text = [self titleForRow:OwnTimeSettingControllerTypeTypeDelay];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
    
}

#pragma mark - Text field Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    NSString *resultString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    BOOL isPressedBackspaceAfterSingleSpaceSymbol = ([string isEqualToString:@""] &&
                                                     [resultString isEqualToString:@""] &&
                                                     range.location == 0 &&
                                                     range.length == 1);
    
    if (isPressedBackspaceAfterSingleSpaceSymbol) {
        self.navigationItem.title = @"Свой таймер";
    } else {
        self.navigationItem.title = resultString;
    }
    return YES;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return  YES;
}

@end
