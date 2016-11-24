//
//  PLNavigationView.m
//  Move
//
//  Created by PhelanGeek on 2016/10/31.
//  Copyright © 2016年 PhelanGeek. All rights reserved.
//

#import "PLNavigationView.h"

@interface PLNavigationView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation PLNavigationView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]. lastObject;
    }
    return self;
}

- (void)setTitleString:(NSString *)titleString {
    _titleLabel.text = titleString;
}

- (IBAction)cancelButtonAction:(id)sender {
    if (_cancelButtonBlock) {
        _cancelButtonBlock(sender);
    }
    
}
- (IBAction)deleteButtonAction:(id)sender {
    if (_deleteButtonBlock) {
        _deleteButtonBlock(sender);
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.frame = CGRectMake(0, 0, self.bounds.size.width, 64);
    self.backgroundColor = ColorWith51Black;
}
@end
