//
//  PLXTouchView.m
//  Move
//
//  Created by dllo on 2016/11/1.
//  Copyright © 2016年 PhelanGeek. All rights reserved.
//

#import "PLXTouchView.h"

@interface PLXTouchView ()

@property (nonatomic, strong) UILabel *touchLabel;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation PLXTouchView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.touchLabel = [[UILabel alloc] init];
        _touchLabel.textAlignment = NSTextAlignmentCenter;
        _touchLabel.textColor = [UIColor whiteColor];
        _touchLabel.font = [UIFont systemFontOfSize:WIDTH / 35];
        [self addSubview:_touchLabel];

        self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"三角"]];
        [self addSubview:_imageView];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    _frame = frame;
    _touchLabel.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 20);
    _imageView.frame = CGRectMake(frame.origin.x + frame.size.width / 2 - 4, frame.origin.y + 20, 8, 8);
}
- (void)setText:(NSString *)text {
    _text = text;
    _touchLabel.text = text;
}
- (void)setHidden:(BOOL)hidden {
    _hidden = hidden;
    _touchLabel.hidden = hidden;
    _imageView.hidden = hidden;
}

@end
