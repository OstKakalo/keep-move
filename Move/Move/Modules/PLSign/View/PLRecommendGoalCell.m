//
//  PLRecommendGoalCell.m
//  Move
//
//  Created by PhelanGeek on 2016/10/31.
//  Copyright © 2016年 PhelanGeek. All rights reserved.
//

#import "PLRecommendGoalCell.h"

@interface PLRecommendGoalCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation PLRecommendGoalCell

- (void)setIconImage:(UIImage *)iconImage {
    _iconImageView.image = iconImage;
}

- (void)setTitleString:(NSString *)titleString {
    _titleLabel.text = titleString;
}

- (void)setButtonTitle:(NSString *)buttonTitle {
    [_addButton setTitle:buttonTitle forState:UIControlStateNormal];
}

- (IBAction)addButtonAction:(id)sender {
    if (_addButtonBlock) {
        _addButtonBlock(sender);
    }
}

@end
