//
//  PLCareerView.m
//  Move
//
//  Created by PhelanGeek on 2016/10/20.
//  Copyright © 2016年 PhelanGeek. All rights reserved.
//

#import "PLCareerView.h"
#import "PLCareerModel.h"
#import "PLXHealthManager.h"

@interface PLCareerView ()

@property (weak, nonatomic) IBOutlet UILabel *stepCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *calorieLabel;
@property (weak, nonatomic) IBOutlet UILabel *kilometreLabel;
@property (weak, nonatomic) IBOutlet UILabel *hoursLabel;

@end

@implementation PLCareerView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]. lastObject;
    }
    return self;
}

- (void)setPlCareerModel:(PLCareerModel *)plCareerModel {
    NSDate *firstDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"firstLaunchDate"];
    NSDate *date = [NSDate date];
    //NSLog(@"---%@", date);
    //NSLog(@"-----%@", firstDate);
    NSInteger days = (NSInteger)([date timeIntervalSinceDate:firstDate] / 86400) + 1 ;
    //NSLog(@"days-------%ld", days);
    PLXHealthManager *manager = [PLXHealthManager shareInstance];
    manager.days = days;
    manager.isDay = NO;
    manager.startDate = [NSDate date];
    [manager getStepCount:^(double value, NSArray *array, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _stepCountLabel.text = [NSString stringWithFormat:@"%.0lf", value];
            _calorieLabel.text = [NSString stringWithFormat:@"%.0lf", value / 35];
            CGFloat time = 0;
            for (NSDictionary *dic in array) {
                CGFloat duration = [[dic objectForKey:@"duration"] floatValue];
                time = time + duration;
                //NSLog(@"time------------%lf", time);
            }
            if (time / 3600 < 1) {
                _hoursLabel.text = @"<1";
            }
            else {
               _hoursLabel.text = [NSString stringWithFormat:@"%.0lf", time / 3600]; 
            }
        });
    }];
    [manager getDistance:^(double value, NSArray *array, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _kilometreLabel.text = [NSString stringWithFormat:@"%.0lf", value];
        });

    }];
}

@end
