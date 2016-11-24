//
//  PLTargetView.m
//  Move
//
//  Created by PhelanGeek on 2016/10/19.
//  Copyright © 2016年 PhelanGeek. All rights reserved.
//

#import "PLTargetView.h"
#import "PLTargetModel.h"
#import "PLDataBaseManager.h"
#import "PLPersonInformation.h"
#import "PLXHealthManager.h"

@interface PLTargetView ()
@property (weak, nonatomic) IBOutlet UILabel *targetLabel;
@property (weak, nonatomic) IBOutlet UILabel *basicGoalLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastWeekCalorieLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic, strong) UIView *lineView;

@end

@implementation PLTargetView
- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
        [self createLineView];
    }
    return self;
}

- (void)createLineView {
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(_imageView.frame.origin.x, _imageView.frame.origin.y, 0, _imageView.frame.size.height)];
    _lineView.backgroundColor = [UIColor colorWithRed:0.9 green:0.7 blue:0.1 alpha:1];
    [self addSubview:_lineView];
}

- (void)setPlTargetModel:(PLTargetModel *)plTargetModel {
    
    PLDataBaseManager *dataBaseManager = [PLDataBaseManager shareManager];
    PLPersonInformation *imformation = [dataBaseManager personInformation];
    _basicGoalLabel.text = [NSString stringWithFormat:@"基础目标:%ld大卡", imformation.goalStep / 35 * 7];
    
    PLXHealthManager *manager = [PLXHealthManager shareInstance];
    manager.isDay = YES;
    manager.startDate = [NSDate date];
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [calendar components:NSCalendarUnitWeekday fromDate:[NSDate date]];
    switch ([comps weekday]) {
        case 1:
            manager.days = 7;
            break;
        case 2:
            manager.days = 1;
            break;
        case 3:
            manager.days = 2;
            break;
        case 4:
            manager.days = 3;
            break;
        case 5:
            manager.days = 4;
            break;
        case 6:
            manager.days = 5;
            break;
        default:
            manager.days = 6;
            break;
    }
    [manager getStepCount:^(double value, NSArray *array, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _targetLabel.text = [NSString stringWithFormat:@"%.0lf", value / 35];
            
            [UIView animateWithDuration:3 animations:^{
                CGFloat a = [_targetLabel.text floatValue] / (imformation.goalStep / 35 * 7);
                if (a > 1) {
                    a = 1;
                }
                _lineView.frame = CGRectMake(_imageView.frame.origin.x, _imageView.frame.origin.y, (WIDTH - 40) * a, _imageView.frame.size.height);
            }];
            _imageView.hidden = NO;
        });
    }];
    
    
    _lastWeekCalorieLabel.text = plTargetModel.lastWeekCalorie;
}

@end
