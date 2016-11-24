//
//  PLXWeightViewController.m
//  Move
//
//  Created by dllo on 2016/11/2.
//  Copyright © 2016年 PhelanGeek. All rights reserved.
//

#import "PLXWeightViewController.h"
#import "WYLineChartView.h"
#import "WYLineChartPoint.h"
#import "PLDataBaseManager.h"
#import "PLHistoryInformation.h"
#import "PLPersonInformation.h"

@interface PLXWeightViewController ()
<
WYLineChartViewDelegate,
WYLineChartViewDatasource
>

@property (nonatomic, strong) UILabel *nLabel;
@property (nonatomic, strong) UILabel *bLabel;

@property (nonatomic, strong) WYLineChartView *lineChart;
@property (nonatomic, strong) NSMutableArray *pointsArray;
@property (nonatomic, strong) NSMutableArray *dateArray;

@property (nonatomic, assign) CGFloat maxWeight;
@property (nonatomic, assign) CGFloat minWeight;

@end

@implementation PLXWeightViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    PLDataBaseManager *manager = [PLDataBaseManager shareManager];
    
    NSArray *array = [[[manager ArrayWithRecordWeight] reverseObjectEnumerator] allObjects];
//    NSArray *array = [manager ArrayWithRecordWeight];
    
    PLHistoryInformation *infomation = [array firstObject];
    _nLabel.text = [NSString stringWithFormat:@"%.1lf", infomation.weight];
    PLPersonInformation *person = [manager personInformation];
    CGFloat height = person.height / 100.0;
    _bLabel.text = [NSString stringWithFormat:@"%.1lf", infomation.weight / (height * height)];
    
    
    if (array.count > 0) {
        [self.view addSubview:_lineChart];
        
        NSString *temp = @"";
        [_dateArray removeAllObjects];
        [_pointsArray removeAllObjects];
        for (int i = 0; i < 7; i++) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MM.dd"];
            NSString *timeString = [formatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:- (5 - i + 1) * 24 * 60 * 60]];
            [_dateArray addObject:timeString];
        }
        _maxWeight = 0;
        _minWeight = 10000;
        
        CGFloat lastWeight = 0;
        for (int i = 0; i < 7; i++) {
            for (int j = 0; j < array.count; j++) {
                PLHistoryInformation *infomation = array[j];
                NSString *str = [infomation.time substringWithRange:NSMakeRange(6, 5)];
                NSString *str2 = [str stringByReplacingOccurrencesOfString:@"月" withString:@"."];
                if (![temp isEqualToString:str2]) {
                    WYLineChartPoint *point = [[WYLineChartPoint alloc] init];
                    if ([str2 isEqualToString:_dateArray[i]]) {
                        point.value = infomation.weight;
                        lastWeight = infomation.weight;
                        _maxWeight = _maxWeight > infomation.weight ? _maxWeight : infomation.weight;
                        _minWeight = _minWeight < infomation.weight ? _minWeight : infomation.weight;
                        [_pointsArray addObject:point];
                        temp = str2;
                        break;
                    }
                }
                if (j == array.count - 1) {
                    WYLineChartPoint *point = [[WYLineChartPoint alloc] init];
                    point.value = lastWeight;
                    [_pointsArray addObject:point];
                }
            }
        }
        for (int i = 0; i < 7; i++) {
            WYLineChartPoint *point = _pointsArray[i];
            if (point.value > 0) {
                lastWeight = point.value;
                break;
            }
        }
        for (int j = 0; j < 7; j++) {
            WYLineChartPoint *point = _pointsArray[j];
            if (point.value == 0) {
                point.value = lastWeight;
            }
        }
        
        
        _lineChart.points = [NSArray arrayWithArray:_pointsArray];
        
        [_lineChart updateGraph];

    }
    else {
        [_lineChart removeFromSuperview];
    }
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = CGRectMake(WIDTH * 2, 0, WIDTH, HEIGHT);
    self.pointsArray = [NSMutableArray array];
    self.dateArray = [NSMutableArray array];
    
    [self createLabel];
    [self createLineChart];
}

- (void)createLabel {
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(20, HEIGHT / 20, WIDTH / 2 - 20, HEIGHT / 30)];
    label1.text = @"最新";
    label1.textAlignment = NSTextAlignmentCenter;
    label1.textColor = [UIColor whiteColor];
    label1.font = [UIFont systemFontOfSize:WIDTH / 21];
    [self.view addSubview:label1];
    
    self.nLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, label1.frame.size.height + label1.frame.origin.y + 10, WIDTH / 2 - 20,  HEIGHT / 28)];
    _nLabel.text = @"59";
    _nLabel.textAlignment = NSTextAlignmentCenter;
    _nLabel.textColor = [UIColor colorWithRed:0.9 green:0.7 blue:0.1 alpha:1];
    _nLabel.font = [UIFont systemFontOfSize:WIDTH / 12];
    [self.view addSubview:_nLabel];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH / 2, HEIGHT / 20, WIDTH / 2 - 20, HEIGHT / 30)];
    label2.text = @"BMI";
    label2.textAlignment = NSTextAlignmentCenter;
    label2.textColor = [UIColor whiteColor];
    label2.font = [UIFont systemFontOfSize:WIDTH / 21];
    [self.view addSubview:label2];
    
    self.bLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH / 2, label2.frame.size.height + label2.frame.origin.y + 10, WIDTH / 2 - 20,  HEIGHT / 28)];
    _bLabel.text = @"697";
    _bLabel.textAlignment = NSTextAlignmentCenter;
    _bLabel.textColor = [UIColor colorWithRed:0.9 green:0.7 blue:0.1 alpha:1];
    _bLabel.font = [UIFont systemFontOfSize:WIDTH / 12];
    [self.view addSubview:_bLabel];
}

- (void)createLineChart {
//    [_dateArray addObjectsFromArray:@[@"10/27", @"10/28", @"10/29", @"10/30", @"10/31", @"11/01", @"11/02"]];
//    for (int i = 0; i < 7; i++) {
//        WYLineChartPoint *point = [[WYLineChartPoint alloc] init];
//        point.value = arc4random() % 10 + 50;
//        [_pointsArray addObject:point];
//    }

    
    
    self.lineChart = [[WYLineChartView alloc] initWithFrame:CGRectMake(0, _nLabel.frame.origin.y + _nLabel.frame.size.height + 70, WIDTH, HEIGHT - _nLabel.frame.origin.y - _nLabel.frame.size.height - 80 - 64 - 49)];
    _lineChart.backgroundColor = [UIColor clearColor];
    _lineChart.delegate = self;
    _lineChart.datasource = self;
    _lineChart.scrollable = NO;
    _lineChart.lineStyle = kWYLineChartMainStraightLine;
    _lineChart.lineBottomMargin = 5;
    _lineChart.lineTopMargin = 0;
    _lineChart.averageLineColor = [UIColor colorWithRed:0.9 green:0.7 blue:0.1 alpha:1];
    _lineChart.labelsColor = [UIColor lightGrayColor];
    
    _lineChart.gradientColors = @[[UIColor colorWithWhite:1 alpha:0.8],
                                  [UIColor colorWithWhite:1 alpha:0]];
    _lineChart.gradientColorsLocation = @[@0, @0.9];
    _lineChart.drawGradient = YES;
    
    _lineChart.yAxisHeaderPrefix = @"体重";
    _lineChart.yAxisHeaderSuffix = @"日期";
    
}

#pragma mark - delegate
- (NSInteger)numberOfLabelOnXAxisInLineChartView:(WYLineChartView *)chartView {
    return _dateArray.count;
}
- (CGFloat)gapBetweenPointsHorizontalInLineChartView:(WYLineChartView *)chartView {
    return 60.f;
}
- (CGFloat)maxValueForPointsInLineChartView:(WYLineChartView *)chartView {
    return _maxWeight + 5;
}

- (CGFloat)minValueForPointsInLineChartView:(WYLineChartView *)chartView {
    return _minWeight - 5;
}

- (NSInteger)numberOfReferenceLineVerticalInLineChartView:(WYLineChartView *)chartView {
    return _pointsArray.count;
}

- (NSInteger)numberOfReferenceLineHorizontalInLineChartView:(WYLineChartView *)chartView {
    return _pointsArray.count;
}

#pragma mark - datasource
- (WYLineChartPoint *)lineChartView:(WYLineChartView *)chartView pointReferToXAxisLabelAtIndex:(NSInteger)index {
    return _pointsArray[index];
}
- (NSString *)lineChartView:(WYLineChartView *)chartView contentTextForXAxisLabelAtIndex:(NSInteger)index {
    return _dateArray[index];
}

- (CGFloat)lineChartView:(WYLineChartView *)chartView valueReferToHorizontalReferenceLineAtIndex:(NSInteger)index {
    return ((WYLineChartPoint *)_pointsArray[index]).value;
}

- (WYLineChartPoint *)lineChartView:(WYLineChartView *)chartView pointReferToVerticalReferenceLineAtIndex:(NSInteger)index {
    return _pointsArray[index];
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
