//
//  PLDefeatView.m
//  
//
//  Created by PhelanGeek on 2016/10/20.
//
//

#import "PLDefeatView.h"
#import "PLDefeatModel.h"
#import "PLXHealthManager.h"

@interface PLDefeatView ()

@property (weak, nonatomic) IBOutlet UILabel *defeatPeoplePercentageLabel;
@property (weak, nonatomic) IBOutlet UILabel *activeAgeLabel;
@property (weak, nonatomic) IBOutlet UILabel *describeLabel;

@end

@implementation PLDefeatView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
    }
    return self;
}

- (void)setPlDefeatModel:(PLDefeatModel *)plDefeatModel {
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
    NSInteger temp = manager.days * 20000;
    [manager getStepCount:^(double value, NSArray *array, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            CGFloat a = value / temp * 100;
            if (a > 100) {
                a = 100;
            }
            _defeatPeoplePercentageLabel.text = [NSString stringWithFormat:@"%.1lf%%", a];
            if (a > 80) {
                _activeAgeLabel.text = @"21岁";
                _describeLabel.text = @"精力很旺盛啊!";
            } else if (a > 60) {
                _activeAgeLabel.text = @"27岁";
                _describeLabel.text = @"人类已经无法阻止你了!";
            } else if (a == 0) {
                _activeAgeLabel.text = @"???岁";
                _describeLabel.text = @"你来自太空吗?";
            } else {
                _activeAgeLabel.text = @"30岁";
                _describeLabel.text = @"继续加油.";
            }
        });
    }];
}

@end
