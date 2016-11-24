//
//  PLDetailRecordTypeTwoCell.m
//  Move
//
//  Created by PhelanGeek on 2016/11/8.
//  Copyright © 2016年 PhelanGeek. All rights reserved.
//

#import "PLDetailRecordTypeTwoCell.h"

@interface PLDetailRecordTypeTwoCell ()

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UIImageView *hintImageView;

@end

@implementation PLDetailRecordTypeTwoCell

- (void)setTitleString:(NSString *)titleString {
    //NSLog(@"cell : %@", titleString);
    _typeLabel.text = titleString;
}

- (void)setLeftString:(NSString *)leftString {
    _leftLabel.text = leftString;
}

- (void)setHiddenImageView:(BOOL)hiddenImageView {
    _hintImageView.hidden = hiddenImageView;
}

@end
