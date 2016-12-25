//
//  WarningController.m
//  Timer
//
//  Created by Arkadiy Grigoryanc on 22.08.16.
//  Copyright © 2016 Arkadiy Grigoryanc. All rights reserved.
//

#import "WarningController.h"

#define kHoursComponent      0
#define kMinutesComponent    1
#define kSecondsComponent    2

#define kHours      @"hours"
#define kMinutes    @"minutes"
#define kSeconds    @"seconds"

@import AVFoundation;

typedef enum {
    WarningControllerCellTimeWarning = 1,
    WarningControllerCellTypeWarning = 2
} WarningControllerCell;

@interface WarningController ()

@property (strong, nonatomic, readonly) UIPickerView *pickerView;
@property (strong, nonatomic, readonly) NSDictionary *timeWarningPicker;
@property (strong, nonatomic, readonly) NSArray *typeWarningPicker;

@property (assign, nonatomic, readonly) NSInteger timePickerHours;
@property (assign, nonatomic, readonly) NSInteger timePickerMinutes;
@property (assign, nonatomic, readonly) NSInteger timePickerSeconds;

@property (assign, nonatomic, readonly) TypeWarning typeWarning;

@property (strong, nonatomic, readonly) UILabel *headerRowTimeWarningLabel;
@property (strong, nonatomic, readonly) UILabel *headerRowTypeWarningLabel;

@property (assign, nonatomic, readonly) CGFloat volumeSlider;
@property (assign, nonatomic, readonly) BOOL onForWhite;
@property (assign, nonatomic, readonly) BOOL onForBlack;

@property (strong, nonatomic, readonly) AVAudioPlayer *soundID;   // warning's sound

@end

@implementation WarningController {
    //NSIndexPath *selectedIndexPath;
    
    NSInteger selectedRow;
}
@synthesize soundID;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    selectedRow = -1;
    
    // filling table
    extern NSMutableArray <NSDictionary *> *gWarnings;
    
    NSDictionary *dict = [gWarnings objectAtIndex:self.row];
    
    _typeWarning = [[dict objectForKey:@"TypeWarning"] intValue];
    _volumeSlider = [[dict objectForKey:@"Volume"] floatValue];
    _onForWhite = [[dict objectForKey:@"OnForWhite"] boolValue];
    _onForBlack = [[dict objectForKey:@"OnForBlack"] boolValue];
    
    CGFloat time = [[dict objectForKey:@"TimeWarning"] floatValue];
    
    _timePickerHours = time / 3600;
    _timePickerSeconds = time - (self.timePickerHours * 3600);
    _timePickerMinutes = self.timePickerSeconds / 60;
    _timePickerSeconds = self.timePickerSeconds - (self.timePickerMinutes * 60);
    
    NSMutableArray *timePickerHours = [NSMutableArray array];
    NSMutableArray *timePickerMinutes = [NSMutableArray array];
    
    for (int i = 0; i <= 20; i++) {
        [timePickerHours addObject:[NSNumber numberWithInt:i]];
    }
    
    for (int i = 0; i <= 59; i++) {
        [timePickerMinutes addObject:[NSNumber numberWithInt:i]];
    }
    
    _timeWarningPicker = @{kHours   : timePickerHours,
                           kMinutes : timePickerMinutes,
                           kSeconds : timePickerMinutes};
    
    
    // create dictionary for type delay picker
    _typeWarningPicker = @[@"Сигнал тревоги",
                           @"Гудок",
                           @"Речь",
                           @"Мигать"];
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
    
    if (_typeWarning == TypeWarningBlink) {
        return 5;
    }
    
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    // Configure the cell...
    extern NSMutableArray<NSDictionary *> *gWarnings;
    
    switch (indexPath.row) {
            
        case 0: {
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"TimeWarningCell" forIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = [self titleForRow:WarningControllerCellTimeWarning];
            
        } break;
            
        case 1: {
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"TypeWarningCell" forIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = [self titleForRow:WarningControllerCellTypeWarning];
        
        } break;
            
        case 2: {
            
            if (_typeWarning == TypeWarningBlink) {
                
                cell = [tableView dequeueReusableCellWithIdentifier:@"OnForWhiteCell" forIndexPath:indexPath];
                
                for (UISwitch *obj in cell.contentView.subviews) {
                    if ([obj class] == [UISwitch class]) {
                        obj.on = [[[gWarnings objectAtIndex:self.row] objectForKey:@"OnForWhite"] boolValue];
                    }
                }
            
            } else {
            
                cell = [tableView dequeueReusableCellWithIdentifier:@"ValumeCell" forIndexPath:indexPath];
                
                for (UISlider *obj in cell.contentView.subviews) {
                    if ([obj class] == [UISlider class]) {
                        obj.value = [[[gWarnings objectAtIndex:self.row] objectForKey:@"Volume"] floatValue];
                    }
                }
            }
            
        } break;
            
        case 3: {
            
            if (_typeWarning == TypeWarningBlink) {
                
                cell = [tableView dequeueReusableCellWithIdentifier:@"OnForBlackCell" forIndexPath:indexPath];
                
                for (UISwitch *obj in cell.contentView.subviews) {
                    if ([obj class] == [UISwitch class]) {
                        obj.on = [[[gWarnings objectAtIndex:self.row] objectForKey:@"OnForBlack"] boolValue];
                    }
                }
                
            } else {
                
                cell = [tableView dequeueReusableCellWithIdentifier:@"OnForWhiteCell" forIndexPath:indexPath];
                
                for (UISwitch *obj in cell.contentView.subviews) {
                    if ([obj class] == [UISwitch class]) {
                        obj.on = [[[gWarnings objectAtIndex:self.row] objectForKey:@"OnForWhite"] boolValue];
                    }
                }
            }
        
        } break;
            
        case 4: {
            
            if (_typeWarning == TypeWarningBlink) {
                
                cell = [tableView dequeueReusableCellWithIdentifier:@"PreviewCell" forIndexPath:indexPath];
                
            } else {
                
                cell = [tableView dequeueReusableCellWithIdentifier:@"OnForBlackCell" forIndexPath:indexPath];
                
                for (UISwitch *obj in cell.contentView.subviews) {
                    if ([obj class] == [UISwitch class]) {
                        obj.on = [[[gWarnings objectAtIndex:self.row] objectForKey:@"OnForBlack"] boolValue];
                    }
                }
            }
        
        } break;
            
        case 5: {
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"PreviewCell" forIndexPath:indexPath];
        
        } break;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([cell.reuseIdentifier isEqualToString:@"TimeWarningCell"] ||
        [cell.reuseIdentifier isEqualToString:@"TypeWarningCell"]) {
        
        // Очищаем ячейку
        for (id subView in [cell.contentView subviews]) {
            if ([subView class] != [UIButton class]) {
                [subView removeFromSuperview];
            }
        }
        
        if (indexPath.row != selectedRow) {
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:selectedRow inSection:0];
            selectedRow = indexPath.row;
            
            [self tableView:tableView updateAtIndexPath:oldIndexPath];
            
            // заполняем ячейку
            [self cellFilling:cell];
            
        } else {
            
            selectedRow = -1;
            [self tableView:tableView updateAtIndexPath:indexPath];
            
        }
        
    } else if ([cell.reuseIdentifier isEqualToString:@"PreviewCell"]) {
        
        [self previewWarning];
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat cellHeight = 40.f;
    
    if (selectedRow == indexPath.row) {
        cellHeight = 150.f;
    }
    
    return cellHeight;
}


#pragma mark - Methods

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (NSString *)titleForRow:(WarningControllerCell)type {
    
    NSMutableString *string;
    
    switch (type) {
        case WarningControllerCellTimeWarning: {
            string = [NSMutableString stringWithString:@"Время уведомления: "];
            
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
                [string appendFormat:@"0 сек"];
            }

        }
            break;
        
        case WarningControllerCellTypeWarning: {
            
            string = [NSMutableString stringWithString:@"Тип предупреждения: "];
            
            [string appendFormat:@"%@", [self.typeWarningPicker objectAtIndex:self.typeWarning]];
        }
            break;
            
        default:
            break;
    }
    
    return string;
}

- (void)tableView:(UITableView *)tableView updateAtIndexPath:(NSIndexPath *)indexPath {
    
    [UIView setAnimationsEnabled:YES];
    
    //[tableView beginUpdates];
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
    //[tableView endUpdates];
    
    [UIView setAnimationsEnabled:[UIView areAnimationsEnabled]];
}

// Заполняем ячейку
- (void)cellFilling:(UITableViewCell *)cell {
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16,
                                                               0,
                                                               CGRectGetWidth(cell.contentView.frame) - 36,
                                                               40)];
    label.text = cell.textLabel.text;
    
    cell.textLabel.text = @"";
    
    switch (cell.tag) {
        case WarningControllerCellTimeWarning:
            _headerRowTimeWarningLabel = label;
            [cell.contentView addSubview:self.headerRowTimeWarningLabel];
            break;
        case WarningControllerCellTypeWarning:
            _headerRowTypeWarningLabel = label;
            [cell.contentView addSubview:self.headerRowTypeWarningLabel];
            break;
        default:
            break;
    }
    
    // Create picker
    [self createPickerView:cell];
    
    [cell.contentView addSubview:self.pickerView];
}

- (void)createPickerView:(UITableViewCell *)cell {
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(16,
                                                                     40,
                                                                     CGRectGetWidth(cell.frame) - 36,
                                                                     CGRectGetHeight(cell.frame) - 40)];
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    
    if (cell.tag == WarningControllerCellTimeWarning) {
        
        [self.pickerView selectRow:self.timePickerHours inComponent:kHoursComponent animated:NO];
        [self.pickerView selectRow:self.timePickerMinutes inComponent:kMinutesComponent animated:NO];
        [self.pickerView selectRow:self.timePickerSeconds inComponent:kSecondsComponent animated:NO];
        
    } else if (cell.tag == WarningControllerCellTypeWarning) {
        
        NSInteger selectRow;
        
        switch (self.typeWarning) {
                
            case TypeWarningAlarm:
                selectRow = 0;
                break;
                
            case TypeWarningBeep:
                selectRow = 1;
                break;
                
            case TypeWarningSpeech:
                selectRow = 2;
                break;
                
            case TypeWarningBlink:
                selectRow = 3;
                break;
                
            default:
                selectRow = -1;
                break;
        }
        
        [self.pickerView selectRow:selectRow inComponent:0 animated:NO];
    }
}

- (NSDictionary *)createWarning {
    
    NSTimeInterval time = (self.timePickerHours * 3600) + (self.timePickerMinutes * 60) + self.timePickerSeconds;
    
    NSDictionary *warning = [NSDictionary dictionaryWithObjectsAndKeys:
                             [self titleForWarning], @"Name",
                             [self detailForWarning], @"Detail",
                             [NSNumber numberWithInt:time], @"TimeWarning",
                             [NSNumber numberWithInt:self.typeWarning], @"TypeWarning",
                             [NSNumber numberWithFloat:self.volumeSlider], @"Volume",
                             [NSNumber numberWithBool:self.onForWhite], @"OnForWhite",
                             [NSNumber numberWithBool:self.onForBlack], @"OnForBlack",
                             nil];
    
    NSLog(@"New game option %@", warning);
    
    return warning;
}

- (NSString *)titleForWarning {
    
    NSMutableString *string = [NSMutableString string];
    
    NSString *type = [self titleForRow:WarningControllerCellTypeWarning];
    NSRange rangeType = [type rangeOfString:@": "];
    [string appendString:[type substringFromIndex:rangeType.location + rangeType.length]];
    
    NSString *time = [self titleForRow:WarningControllerCellTimeWarning];
    NSRange rangeTime = [time rangeOfString:@": "];
    [string appendFormat:@", %@", [time substringFromIndex:rangeTime.location + rangeTime.length]];
    
    return string;
    
}

- (NSString *)detailForWarning {
    
    NSMutableString *string = [NSMutableString string];
    
    if (self.onForWhite && !self.onForBlack) {
        [string appendString:@"только для белых"];
    } else if (!self.onForWhite && self.onForBlack) {
        [string appendString:@"только для черных"];
    } else if (!self.onForWhite && !self.onForBlack) {
        [string appendString:@"отключенно"];
    }
    
    return string;
    
}

#pragma mark - Preview Warning Methods

- (void)previewWarning {
    
    switch (self.typeWarning) {
        case TypeWarningAlarm:  // сигнал тревоги
            [self playSound:[[NSBundle mainBundle] pathForResource:@"alarm" ofType:@"mp3"]
                 withVolume:self.volumeSlider];
            break;
        case TypeWarningBeep:   // гудок
            [self playSound:[[NSBundle mainBundle] pathForResource:@"beep" ofType:@"mp3"]
                 withVolume:self.volumeSlider];
            break;
        case TypeWarningSpeech: // речь
            [self playSpeech:(self.timePickerHours * 3600) + (self.timePickerMinutes * 60) + self.timePickerSeconds
                  withVolume:self.volumeSlider];
            break;
        case TypeWarningBlink:  // мигание
            [self flash];
            break;
    }
}

- (void)playSound:(NSString *)path withVolume:(CGFloat)volume {
    
    NSURL *soundURL = [NSURL fileURLWithPath:path];
    NSError *error;
    
    soundID = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:&error];
    
    //[soundID prepareToPlay];
    //[soundID setNumberOfLoops:0];
    //[soundID setCurrentTime:3];
    [soundID setVolume:volume];
    [soundID play];
    
}

- (void)playSpeech:(NSInteger)time withVolume:(CGFloat)volume {
    
    NSInteger hours = time / 3600;
    NSInteger seconds = time - (hours * 3600);
    NSInteger minutes = seconds / 60;
    seconds = seconds - (minutes * 60);
    
    NSMutableString *text = [NSMutableString string];
    
    if (hours == 1) {
        [text appendFormat:@"%ld час,", hours];
    } else if (hours > 1 && hours <= 4) {
        [text appendFormat:@"%ld часа,", hours];
    } else if (hours > 4) {
        [text appendFormat:@"%ld часов,", hours];
    }
    
    if (minutes == 1 || minutes == 21 || minutes == 31 || minutes == 41 || minutes == 51) {
        [text appendFormat:@"%ld минута,", minutes];
    } else if ((minutes > 1 && minutes <= 4) || (minutes > 21 && minutes <= 24) || (minutes > 31 && minutes <= 34) ||
               (minutes > 41 && minutes <= 44) || (minutes > 51 && minutes <= 54)) {
        [text appendFormat:@"%ld минуты,", minutes];
    } else if ((minutes > 4 && minutes <= 20) || (minutes > 24 && minutes <= 30) || (minutes > 34 && minutes <= 40) ||
               (minutes > 44 && minutes <= 50) || (minutes > 54 && minutes <= 60)) {
        [text appendFormat:@"%ld минут,", minutes];
    }
    
    if (seconds == 1 || seconds == 21 || seconds == 31 || seconds == 41 || seconds == 51) {
        [text appendFormat:@"%ld секунда,", seconds];
    } else if ((seconds > 1 && seconds <= 4) || (seconds > 21 && seconds <= 24) || (seconds > 31 && seconds <= 34) ||
               (seconds > 41 && seconds <= 44) || (seconds > 51 && seconds <= 54)) {
        [text appendFormat:@"%ld секунды,", seconds];
    } else if ((seconds > 4 && seconds <= 20) || (seconds > 24 && seconds <= 30) || (seconds > 34 && seconds <= 40) ||
               (seconds > 44 && seconds <= 50) || (seconds > 54 && seconds <= 60)) {
        [text appendFormat:@"%ld секунд,", seconds];
    }
    
    if (seconds == 0 && minutes == 0 && hours == 0) {
        [text appendFormat:@"Время вышло"];
    }
    
    
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:text];
    [utterance setVolume:volume];
    [utterance setVoice:[AVSpeechSynthesisVoice voiceWithLanguage:@"ru-RU"]];
    AVSpeechSynthesizer *syn = [[AVSpeechSynthesizer alloc] init];
    [syn speakUtterance:utterance];
}

- (void)flash {
    
    UIView *flash = [[UIView alloc] initWithFrame:CGRectMake(0, 0,
                                                             CGRectGetWidth(self.view.frame),
                                                             CGRectGetHeight(self.view.frame))];
    
    flash.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:flash];
    
    [UIView animateWithDuration:0.3f
                          delay:0.f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         flash.alpha = 0.f;
                     }
                     completion:^(BOOL finished) {
                         [flash removeFromSuperview];
                     }];
}

#pragma mark - Picker Data Source Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedRow inSection:0]];
    
    NSInteger numberOfComponents = 0;
    
    switch (cell.tag) {
        case WarningControllerCellTimeWarning:
            numberOfComponents = [self.timeWarningPicker count];
            break;
            
        case WarningControllerCellTypeWarning:
            numberOfComponents = 1;
            break;
    }
    
    return numberOfComponents;
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedRow inSection:0]];
    
    NSInteger numberOfRows;
    
    switch (cell.tag) {
        case WarningControllerCellTimeWarning: {
            
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
            
            numberOfRows = [[self.timeWarningPicker objectForKey:key] count];
        }
            break;
            
        case WarningControllerCellTypeWarning: {
            
            numberOfRows = [self.typeWarningPicker count];
        }
            break;
            
        default:
            break;
    }
    
    return numberOfRows;
}

#pragma mark Picker Delegate Methods

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedRow inSection:0]];
    
    NSString *string;
    
    switch (cell.tag) {
        case WarningControllerCellTimeWarning: {
            
            switch (component) {
                case kHoursComponent:
                    string = [NSString stringWithFormat:@"%d ч", [[[self.timeWarningPicker objectForKey:@"hours"] objectAtIndex:row] intValue]];;
                    break;
                case kMinutesComponent:
                    string = [NSString stringWithFormat:@"%d мин", [[[self.timeWarningPicker objectForKey:@"minutes"] objectAtIndex:row] intValue]];;
                    break;
                case kSecondsComponent:
                    string = [NSString stringWithFormat:@"%d сек", [[[self.timeWarningPicker objectForKey:@"seconds"] objectAtIndex:row] intValue]];;
                    break;
            }
        }
            break;
            
        case WarningControllerCellTypeWarning: {
            
            string = [self.typeWarningPicker objectAtIndex:row];
        }
            break;
            
        default:
            break;
    }
    
    return  string;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedRow inSection:0]];
    
    CGFloat width;
    
    switch (cell.tag) {
        case WarningControllerCellTimeWarning:
            width = CGRectGetWidth(pickerView.frame) / 3;
            break;
        
        case WarningControllerCellTypeWarning:
            width = CGRectGetWidth(pickerView.frame);
            break;
            
        default:
            break;
    }
    
    return  width;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedRow inSection:0]];
    
    
    switch (cell.tag) {
        case WarningControllerCellTimeWarning: {
            
            switch (component) {
                case kHoursComponent: {
                    _timePickerHours = [[[self.timeWarningPicker objectForKey:kHours] objectAtIndex:row] intValue];
                }
                    break;
                    
                case kMinutesComponent: {
                    _timePickerMinutes = [[[self.timeWarningPicker objectForKey:kMinutes] objectAtIndex:row] intValue];
                }
                    
                    break;
                case kSecondsComponent: {
                    _timePickerSeconds = [[[self.timeWarningPicker objectForKey:kSeconds] objectAtIndex:row] intValue];
                }
                    break;
                    
                default:
                    break;
            }
            
            self.headerRowTimeWarningLabel.text = [self titleForRow:WarningControllerCellTimeWarning];
        }
            break;
            
        case WarningControllerCellTypeWarning: {
            
            if ([[self.typeWarningPicker objectAtIndex:row] isEqualToString:@"Сигнал тревоги"]) {
                _typeWarning = TypeWarningAlarm;
            } else if ([[self.typeWarningPicker objectAtIndex:row] isEqualToString:@"Гудок"]) {
                _typeWarning = TypeWarningBeep;
            } else if ([[self.typeWarningPicker objectAtIndex:row] isEqualToString:@"Речь"]) {
                _typeWarning = TypeWarningSpeech;
            } else if ([[self.typeWarningPicker objectAtIndex:row] isEqualToString:@"Мигать"]) {
                _typeWarning = TypeWarningBlink;
            }
            
            // если тип переключается на "мигание" убираем шкалу громкости
            if (_typeWarning == TypeWarningBlink &&
                [self.tableView numberOfRowsInSection:0] == 6) {
                
                [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                
            } else if (_typeWarning != TypeWarningBlink &&
                       [self.tableView numberOfRowsInSection:0] == 5) {
                
                [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            }
            
            self.headerRowTypeWarningLabel.text = [self titleForRow:WarningControllerCellTypeWarning];
            
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark - Actions

- (IBAction)actionSaveAndBack:(UIBarButtonItem *)sender {
    
    extern NSMutableArray <NSDictionary *> *gWarnings;
    
    NSDictionary *warning = [self createWarning];
    
    [gWarnings replaceObjectAtIndex:self.row withObject:warning];
        
    [self.topNavigationController archiveWarnings];
    
    [self.topNavigationController.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.row inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)actionVolumeChange:(UISlider *)sender {
    _volumeSlider = sender.value;
}

- (IBAction)actionOnForWhite:(UISwitch *)sender {
    _onForWhite = sender.on;
}

- (IBAction)actionOnForBlack:(UISwitch *)sender {
    _onForBlack = sender.on;
}

@end
