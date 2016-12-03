//
//  Button.m
//  Timer
//
//  Created by Arkadiy Grigoryanc on 27.07.16.
//  Copyright © 2016 Arkadiy Grigoryanc. All rights reserved.
//

#import "Button.h"

@implementation Button

+ (Button *)buttonWithType:(ButtonType)buttonType forButton:(Button *)button center:(CGPoint)center target:(UIViewController *)vc action:(SEL)selector {
    Button *newButton;
    if (button) {
        newButton = button;
    } else {
        newButton = [Button buttonWithType:UIButtonTypeCustom];
    }
    
    [newButton.layer setFrame:CGRectMake(center.x - 25, center.y - 25, 50, 50)];
    newButton.layer.masksToBounds = YES;
    newButton.layer.cornerRadius = 25;
    
    UIImage *image;
    
    switch (buttonType) {
        case ButtonTypeStart:
            image = [UIImage imageNamed:@"start"];
            newButton.tag = CountdownFinish;
            newButton.theGameContinues = NO;
            break;
        case ButtonTypeReset:
            image = [UIImage imageNamed:@"reset"];
            break;
        case ButtonTypeSetting:
            image = [UIImage imageNamed:@"setting"];
            break;
            
        default:
            newButton.backgroundColor = [UIColor darkGrayColor];
            break;
    }
    
    [newButton setBackgroundImage:image forState:UIControlStateNormal];
    
    [newButton addTarget:vc
                  action:selector
        forControlEvents:UIControlEventTouchUpInside];
    
    return newButton;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
@end
