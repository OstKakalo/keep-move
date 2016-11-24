//
//  PLXCalorieViewController.m
//  Move
//
//  Created by dllo on 2016/11/2.
//  Copyright © 2016年 PhelanGeek. All rights reserved.
//

#import "PLXCalorieViewController.h"
#import "PLXTouchView.h"
#import "PLXHealthManager.h"

@interface PLXCalorieViewController ()
<
PNChartDelegate
>

@property (nonatomic, strong) UILabel *avgLabel;
@property (nonatomic, strong) UILabel *sumLabel;
@property (nonatomic, strong) PNBarChart *barChart;
@property (nonatomic, strong) PLXTouchView *touchView;
@property (nonatomic, assign) NSInteger lastTouch;

@property (nonatomic, strong) UILabel *noteLabel;

@end

@implementation PLXCalorieViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_barChart removeFromSuperview];
    [_noteLabel removeFromSuperview];
    PLXHealthManager *manager = [PLXHealthManager shareInstance];
    manager.days = 7;
    manager.isDay = YES;
    manager.startDate = [NSDate date];
    [manager authorizeHealthKit:^(BOOL success, NSError *error) {
        if (success) {
            [manager getStepCount:^(double value, NSArray *array, NSError *error) {
                if (error == nil && array.count > 0) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        _sumLabel.text = [NSString stringWithFormat:@"%.0lf", value / 50];
                        _avgLabel.text = [NSString stringWithFormat:@"%.0lf", value / 7 / 50];
                        NSMutableArray *valueArray = [NSMutableArray array];
                        if (array.count == 0) {
                            [valueArray addObjectsFromArray:@[@"0", @"0", @"0", @"0", @"0", @"0", @"0"]];
                        }
                        else {
                            int k = 0;
                            for (int i = 0; i < 7; i++) {
                                NSDate *date = [NSDate dateWithTimeInterval:-(6 - i) * 24 * 60 * 60 sinceDate:[NSDate date]];
                                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                                [formatter setDateFormat:@"yyyy-MM-dd"];
                                NSString *timeString = [formatter stringFromDate:date];
                                
                                
                                NSDictionary *dic = array[k];
                                if ([[dic objectForKey:@"dateTime"] isEqualToString:timeString]) {
                                    CGFloat value1 = [[dic objectForKey:@"value"] floatValue] / 35;
                                    [valueArray addObject:[NSString stringWithFormat:@"%.0lf", value1]];
                                    k++;
                                }else {
                                    [valueArray addObject:@"0"];
                                }
                            }

                        }
                        [_barChart setYValues:valueArray];
                        
                        [self.view addSubview:_barChart];
                        [_barChart strokeChart];
                        
                        
                        for (int i = 0; i < 7; i++) {
                            PNBar *bar =  _barChart.bars[i];
                            CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
                            gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:1 green:0.8 blue:0 alpha:1].CGColor, (__bridge id)[UIColor colorWithRed:1 green:0.2 + 0.6                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           * (1 - bar.grade) blue:0 alpha:1].CGColor];
                            gradientLayer.startPoint = CGPointMake(0, 1);
                            gradientLayer.endPoint = CGPointMake(0, 0);
                            
                            gradientLayer.frame = CGRectMake(0, bar.frame.size.height, bar.frame.size.width, bar.frame.size.height * bar.grade);
                            [bar.layer addSublayer:gradientLayer];
                            
                            CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
                            positionAnimation.duration = 0.5f;
                            positionAnimation.removedOnCompletion = NO;
                            positionAnimation.fillMode = kCAFillModeForwards;
                            positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(gradientLayer.position.x, gradientLayer.position.y - bar.frame.size.height * bar.grade)];
                            
                            [gradientLayer addAnimation:positionAnimation forKey:@"position"];
                        }
                        
                    });

                }
                else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.view addSubview:_noteLabel];
                    });
                }
            }];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = CGRectMake(WIDTH, 0, WIDTH, HEIGHT);
    _lastTouch = -1;
    [self createLabel];
    [self createTouchView];
    [self createBarChart];
    [self createNoteLabel];
}

- (void)createNoteLabel {
    self.noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH / 2 - 100, HEIGHT / 2, 200, 40)];
    _noteLabel.text = @"请在设置->隐私->健康中允许Keep Move访问数据";
    _noteLabel.font = [UIFont systemFontOfSize:16];
    _noteLabel.textColor = [UIColor lightGrayColor];
    _noteLabel.numberOfLines = 0;
    _noteLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_noteLabel];

}

- (void)createLabel {
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(20, HEIGHT / 20, WIDTH / 2 - 20, HEIGHT / 30)];
    label1.text = @"平均大卡";
    label1.textAlignment = NSTextAlignmentCenter;
    label1.textColor = [UIColor whiteColor];
    label1.font = [UIFont systemFontOfSize:WIDTH / 21];
    [self.view addSubview:label1];
    
    self.avgLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, label1.frame.size.height + label1.frame.origin.y + 10, WIDTH / 2 - 20,  HEIGHT / 28)];
    _avgLabel.text = @"0";
    _avgLabel.textAlignment = NSTextAlignmentCenter;
    _avgLabel.textColor = [UIColor colorWithRed:0.9 green:0.7 blue:0.1 alpha:1];
    _avgLabel.font = [UIFont systemFontOfSize:WIDTH / 12];
    [self.view addSubview:_avgLabel];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH / 2, HEIGHT / 20, WIDTH / 2 - 20, HEIGHT / 30)];
    label2.text = @"总大卡";
    label2.textAlignment = NSTextAlignmentCenter;
    label2.textColor = [UIColor whiteColor];
    label2.font = [UIFont systemFontOfSize:WIDTH / 21];
    [self.view addSubview:label2];
    
    self.sumLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH / 2, label2.frame.size.height + label2.frame.origin.y + 10, WIDTH / 2 - 20,  HEIGHT / 28)];
    _sumLabel.text = @"0";
    _sumLabel.textAlignment = NSTextAlignmentCenter;
    _sumLabel.textColor = [UIColor colorWithRed:0.9 green:0.7 blue:0.1 alpha:1];
    _sumLabel.font = [UIFont systemFontOfSize:WIDTH / 12];
    [self.view addSubview:_sumLabel];
}


- (void)createBarChart {
    self.barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, _sumLabel.frame.origin.y + _sumLabel.frame.size.height + 70, WIDTH, HEIGHT - _sumLabel.frame.origin.y - _sumLabel.frame.size.height - 80 - 64 - 49)];
    _barChart.yChartLabelWidth = 20.0;
    _barChart.chartMarginLeft = 30.0;
    _barChart.chartMarginRight = 10.0;
    _barChart.chartMarginTop = 5.0;
    _barChart.chartMarginBottom = 10.0;
    _barChart.labelMarginTop = 2.0;
    _barChart.labelFont = [UIFont systemFontOfSize:30];
    
    _barChart.showChartBorder = NO;
    _barChart.isShowNumbers = NO;
    _barChart.isGradientShow = NO;
    _barChart.barBackgroundColor = [UIColor clearColor];
    _barChart.backgroundColor = [UIColor clearColor];
    [_barChart setStrokeColor:[UIColor clearColor]];
    
    NSMutableArray *weekArray = [NSMutableArray array];
    for (int i = 0; i < 7; i++) {
        NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *comps = [calendar components:NSCalendarUnitWeekday fromDate:[NSDate dateWithTimeIntervalSinceNow:24 * 60 * 60 * (i + 1)]];
        switch ([comps weekday]) {
            case 1:
                [weekArray addObject:@"周日"];
                break;
            case 2:
                [weekArray addObject:@"周一"];
                break;
            case 3:
                [weekArray addObject:@"周二"];
                break;
            case 4:
                [weekArray addObject:@"周三"];
                break;
            case 5:
                [weekArray addObject:@"周四"];
                break;
            case 6:
                [weekArray addObject:@"周五"];
                break;
            default:
                [weekArray addObject:@"周六"];
                break;
        }
    }
    
    [_barChart setXLabels:weekArray];
    [_barChart setYValues:@[@"0", @"0", @"0", @"0", @"0", @"0", @"0"]];
    _barChart.delegate = self;
    
}

- (void)userClickedOnBarAtIndex:(NSInteger)barIndex {
    PNBar *bar = _barChart.bars[barIndex];
    if (_lastTouch == barIndex) {
        _touchView.hidden = !_touchView.hidden;
    }
    else {
        CGFloat height =  bar.frame.size.height * bar.grade;
        CGFloat spaceHeight = _barChart.frame.size.height - 15 - height;
        CGRect frame = CGRectMake(bar.frame.origin.x - bar.frame.size.width / 2, _barChart.frame.origin.y + spaceHeight - 46, bar.frame.size.width * 2, 46);
        _touchView.frame = frame;
        _touchView.text = [NSString stringWithFormat:@"%ld", (NSInteger)(bar.grade * bar.maxDivisor)];
        _touchView.hidden = NO;
    }
    _lastTouch = barIndex;
}

- (void)createTouchView {
    self.touchView = [[PLXTouchView alloc] initWithFrame:CGRectZero];
    _touchView.hidden = YES;
    [self.view addSubview:_touchView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
