//
//  PLXAnalyseCollectionViewCell.m
//  Move
//
//  Created by dllo on 2016/11/3.
//  Copyright © 2016年 PhelanGeek. All rights reserved.
//

#import "PLXAnalyseCollectionViewCell.h"

@interface PLXAnalyseCollectionViewCell ()

@property (nonatomic, retain)UILabel *label;

@end


@implementation PLXAnalyseCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.label = [[UILabel alloc] init];
        [self.contentView addSubview:_label];
        _label.backgroundColor = [UIColor clearColor];
        _label.textColor = [UIColor lightGrayColor];
        _label.font = [UIFont systemFontOfSize:15];
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)setText:(NSString *)text {
    _text = text;
    _label.text = text;
}

- (void)setTextFont:(NSInteger)textFont {
    _textFont = textFont;
    _label.font = [UIFont systemFontOfSize:textFont];
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    _label.textColor = textColor;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _label.frame = self.contentView.frame;
}

@end
