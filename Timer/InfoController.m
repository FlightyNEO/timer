//
//  InfoController.m
//  Timer
//
//  Created by Arkadiy Grigoryanc on 17.08.16.
//  Copyright © 2016 Arkadiy Grigoryanc. All rights reserved.
//

#import "InfoController.h"

@interface InfoController ()

@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UITextView *textView;

@end

@implementation InfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(5, 20, self.contentSize.width - 5, self.contentSize.height + 30)];
    textView.font = [UIFont fontWithName:@"Helvetica" size:14];
    textView.contentInset = UIEdgeInsetsMake(0, -5, 5, -5);
    textView.selectable = NO;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.contentSize.width, 20)];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor blueColor];
    label.textColor = [UIColor whiteColor];
    
    _label = label;
    _textView = textView;
    
    [self.view addSubview:self.label];
    [self.view addSubview:self.textView];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    dispatch_queue_t queueLoadText = dispatch_queue_create("com.agrigoryanc.queue_load_text", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queueLoadText, ^{
        
        if (self.buttonInfo == InfoControllerButtonInfoHourglass) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.label.text = @"Режим песочных часов";
                self.textView.text = @"Когда таймер находится в режиме песочных часов, прошедшее время прибавляется к таймеру оппонента.";
            });
            
        } else if (self.buttonInfo == InfoControllerButtonInfoDelay) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.label.text = @"Типы задержек";
            });
            
            NSString *delayDefaultTitle = @"Простая задержка";
            NSString *delayFisherTitle = @"Фишер до и Фишер после";
            NSString *delayBronshteynaTitle = @"Бронштейна";
            
            
            NSString *delayDefault = @"Простая задержка откладывает запуск таймера на каждом ходу на фиксированный период. Если ход завершается до истечения задержки, игрок не теряет секунды.";
            NSString *delayFisher = @"Задержка Фишера, изобретенная Бобби Фишером, добавляет задержку к суммарному времени игрока на каждом ходу. Параметр \"Фишер до\" добавляет время до завершения хода. Параметр \"Фишер после\" добавляет время завершения хода";
            NSString *delayBronshteyna = @"Задержка Бронштейна, изобретенная Давидом Бронштейном, функционально близкая к простой задержке. Разница в том, что таймер начинает отсчет немедленно. Прошедшее время задержки добавляется к таймеру игрока в конце хода. Это отличается от параметра \"Фишер после\" тем, что игроки не могут превысить свое суммарное время.";
            
            NSMutableString *tmpString = [NSMutableString stringWithFormat:@"\t%@\n %@\n\n\t%@\n %@\n\n\t%@\n %@",
                                          delayDefaultTitle,
                                          delayDefault,
                                          delayFisherTitle,
                                          delayFisher,
                                          delayBronshteynaTitle,
                                          delayBronshteyna];
            
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:tmpString];
            
            
            NSSet *setRange = [NSSet setWithObjects:
                               [NSValue valueWithRange:[tmpString rangeOfString:delayDefaultTitle]],
                               [NSValue valueWithRange:[tmpString rangeOfString:delayFisherTitle]],
                               [NSValue valueWithRange:[tmpString rangeOfString:delayBronshteynaTitle]],
                               nil];
            
            for (NSValue *range in setRange) {
                [string addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:[range rangeValue]];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.textView.attributedText = string;
            });
            
        } else if (self.buttonInfo == InfoControllerButtonInfoPlaneMode) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.label.text = @"Напоминание о режиме самолета";
                self.textView.text = @"Если работа приложения прерывается уведомлением или телефонным звонком, таймер останавливается. Что бы предотвратить это, переведите телефон в режим полета. Функция напоминания о режиме самолета отображает на таймере значек, напоминающий о необходимости включить режим полета. Значек напоминания отображается, только если режим полета отключен.";
            });
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.textView.textAlignment = NSTextAlignmentJustified;
        });
        
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
