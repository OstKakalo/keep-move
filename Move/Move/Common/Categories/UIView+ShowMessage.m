//
//  UIView+ShowMessage.m
//  AdaptHeight
//
//  Created by PhelanGeek on 16/9/26.
//  Copyright © 2016年 PhelanGeek. All rights reserved.
//

#import "UIView+ShowMessage.h"
#import "UILabel+SizeToHeight.h"

#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define SCREEN_H [UIScreen mainScreen].bounds.size.height

@implementation UIView (ShowMessage)

+ (void)showMessage:(NSString *)message {
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *view = [[UIView alloc] init];
//    view.backgroundColor = [UIColor colorWithWhite:0.323 alpha:0.050];
    view.frame = CGRectMake(1, 1, 1, 1);
    view.alpha = 1.0;
    [window addSubview:view];
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = message;
    CGFloat width = [UILabel getWidthWithTitle:message Font:label.font];
    label.frame = CGRectMake(10, 5, width, 18);
    [view addSubview:label];
    
    view.frame = CGRectMake((SCREEN_W - width - 20) / 2, 64, width + 20, 30);
    [UIView animateWithDuration:2.0f animations:^{
        view.frame = CGRectMake((SCREEN_W - width - 20) / 2, 94, width + 20, 30);
        view.alpha = 0;
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
    }];
}

@end
