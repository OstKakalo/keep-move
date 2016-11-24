//
//  PLGoalHeaderView.m
//  Move
//
//  Created by PhelanGeek on 2016/10/19.
//  Copyright © 2016年 PhelanGeek. All rights reserved.
//

#import "PLGoalHeaderView.h"
#import "PLGoalHeaderModel.h"
#import "PLXHealthManager.h"

@interface PLGoalHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *stepLabel;

@end

@implementation PLGoalHeaderView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
    }
    return self;
}

- (void)setPlGoalHeaderModel:(PLGoalHeaderModel *)plGoalHeaderModel {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *timeString = [formatter stringFromDate:[NSDate date]];
    _dateLabel.text = timeString;
    
    
    PLXHealthManager *manager = [PLXHealthManager shareInstance];
    manager.isDay = YES;
    manager.days = 1;
    manager.startDate = [NSDate date];
    [manager getStepCount:^(double value, NSArray *array, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _stepLabel.text = [NSString stringWithFormat:@"%.0lf", value];
        });
    }];
}

@end
