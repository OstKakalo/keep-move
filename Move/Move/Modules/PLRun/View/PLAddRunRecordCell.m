//
//  PLAddRunRecordCell.m
//  Move
//
//  Created by PhelanGeek on 2016/11/8.
//  Copyright © 2016年 PhelanGeek. All rights reserved.
//

#import "PLAddRunRecordCell.h"

@interface PLAddRunRecordCell ()
@property (weak, nonatomic) IBOutlet UIButton *iconButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation PLAddRunRecordCell

- (void)setIconImage:(UIImage *)iconImage {
//    _iconButton.backgroundColor = PLYELLOW;
//    _iconButton.layer.cornerRadius = 15;
//    _iconButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    [_iconButton setBackgroundImage:iconImage forState:UIControlStateNormal];
}

- (void)setTitleString:(NSString *)titleString {
    _titleLabel.text = titleString;
}
@end
