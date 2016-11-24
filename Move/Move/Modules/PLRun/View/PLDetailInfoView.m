//
//  PLDetailInfoView.m
//  Move
//
//  Created by PhelanGeek on 2016/11/3.
//  Copyright © 2016年 PhelanGeek. All rights reserved.
//

#import "PLDetailInfoView.h"



@interface PLDetailInfoView ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *kmLabel;
@property (weak, nonatomic) IBOutlet UILabel *calorieLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;
@property (weak, nonatomic) IBOutlet UILabel *stepCountLabel;

@end

@implementation PLDetailInfoView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
    }
    return self;
}

- (void)setTime:(NSString *)time {
    _timeLabel.text = time;
}

- (void)setKm:(NSString *)km {
    _kmLabel.text = km;
}

- (void)setCalorie:(NSString *)calorie {
    _calorieLabel.text = calorie;
}

- (void)setRate:(NSString *)rate {
    _rateLabel.text = rate;
}

- (void)setStepCount:(NSString *)stepCount {
    _stepCountLabel.text = stepCount;
}

@end
