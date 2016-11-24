//
//  UILabel+SizeToHeight.m
//  AdaptHeight
//
//  Created by PhelanGeek on 16/9/26.
//  Copyright © 2016年 PhelanGeek. All rights reserved.
//

#import "UILabel+SizeToHeight.h"

@implementation UILabel (SizeToHeight)

+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title Font:(UIFont *)font {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    label.text = title;
    label.font = font;
    label.numberOfLines = 0;
    [label sizeToFit];
    CGFloat height = label.frame.size.height;
    return height;
}

+ (CGFloat)getWidthWithTitle:(NSString *)title Font:(UIFont *)font {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1000, 0)];
    label.text = title;
    label.font = font;
    label.numberOfLines = 0;
    [label sizeToFit];
    return label.frame.size.width;
}

@end
