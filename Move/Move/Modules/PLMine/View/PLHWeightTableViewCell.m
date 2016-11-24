//
//  PLHWeightTableViewCell.m
//  Move
//
//  Created by 胡梦龙 on 16/10/21.
//  Copyright © 2016年 PhelanGeek. All rights reserved.
//

#import "PLHWeightTableViewCell.h"
#import "PLBounceWeightView.h"
#import "PLMineViewController.h"

#import "PLHistoryInformation.h"

#import "WYLineChartView.h"
#import "WYLineChartPoint.h"

#import "PLPersonInformation.h"

@interface PLHWeightTableViewCell ()

<
PLBounceWeightViewDelegate,
UITextFieldDelegate,
WYLineChartViewDelegate,
WYLineChartViewDatasource
>

@property (nonatomic, strong) UIView *glassView;

@property (weak, nonatomic) IBOutlet UILabel *currentWeight;

@property (weak, nonatomic) IBOutlet UILabel *BMI;

@property (weak, nonatomic) IBOutlet UILabel *goalWeight;


@property (nonatomic, assign) BOOL isHaveDian;

@property (nonatomic, assign) BOOL isFirstZero;

@property (weak, nonatomic) IBOutlet UIImageView *chartImageView;

@property (nonatomic, strong) WYLineChartView *lineChart;

@property (nonatomic, strong) NSMutableArray *pointsArray;

@property (nonatomic, strong) NSMutableArray *dateArray;

@property (nonatomic, assign) CGFloat maxWeight;
@property (nonatomic, assign) CGFloat minWeight;

@end

@implementation PLHWeightTableViewCell

#pragma mark - 创建折线图

- (void)createLineChart {
    PLDataBaseManager *manager = [PLDataBaseManager shareManager];
    
    NSArray *array = [[[manager ArrayWithRecordWeight] reverseObjectEnumerator] allObjects];
    
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
                //NSLog(@"6246245624---%@", str2);
                //NSLog(@"6426426246246---%@", _dateArray[i]);
                if ([str2 isEqualToString:_dateArray[i]]) {
                    point.value = infomation.weight;
                    //NSLog(@"%lf", point.value);
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

    self.lineChart = [[WYLineChartView alloc] initWithFrame:CGRectMake(0, 0, WIDTH * 0.9, 260)];
    _lineChart.backgroundColor = [UIColor clearColor];
    _lineChart.delegate = self;
    _lineChart.datasource = self;
    _lineChart.scrollable = NO;
    _lineChart.lineStyle = kWYLineChartMainBezierWaveLine;
    
    _lineChart.points = [NSArray arrayWithArray:_pointsArray];
    
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

    
    [_chartImageView addSubview:_lineChart];
    [_lineChart updateGraph];
}

#pragma mark - delegate
- (NSInteger)numberOfLabelOnXAxisInLineChartView:(WYLineChartView *)chartView {
    return _pointsArray.count;
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








- (IBAction)writeWeight:(id)sender {
    
    
    [self pl_createGlass];
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    CGFloat weight = [[PLDataBaseManager shareManager] currentWeight];
    self.currentWeight.text = [NSString stringWithFormat:@"%.1f", weight];

    
    PLPersonInformation *person = [[PLDataBaseManager shareManager] personInformation];
    
    NSInteger height = person.height;
    CGFloat fHeight = height  / 100.f;
    
    
    CGFloat fBMI = weight / (fHeight * fHeight);

    self.BMI.text = [NSString stringWithFormat:@"BMI %.1f", fBMI];
    
    self.goalWeight.text = [NSString stringWithFormat:@"目标体重%.1fkg",[[PLDataBaseManager shareManager] goalWeight]];
    

    _chartImageView.backgroundColor = [UIColor clearColor];
    
    self.pointsArray = [NSMutableArray array];
    self.dateArray = [NSMutableArray array];
    
    [self createLineChart];


}

#pragma mark - textField协议



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
        
        if ([textField.text rangeOfString:@"."].location==NSNotFound) {
            _isHaveDian = NO;
        }
        if ([textField.text rangeOfString:@"0"].location==NSNotFound) {
            _isFirstZero = NO;
        }
        
        if ([string length]>0)
        {
            unichar single=[string characterAtIndex:0];//当前输入的字符
            if ((single >='0' && single<='9') || single=='.')//数据格式正确
            {
                
                if([textField.text length]==0){
                    if(single == '.' || single == '0'){
                        //首字母不能为小数点
                        return NO;
                    }
                    
                }
                
                if (single=='.'){
                    if(!_isHaveDian)//text中还没有小数点
                    {
                        _isHaveDian=YES;
                        return YES;
                    }else{
                        return NO;
                    }
                }else if(single=='0'){
                    if ((_isFirstZero&&_isHaveDian)||(!_isFirstZero&&_isHaveDian)) {
                        //首位有0有.（0.01）或首位没0有.（10200.00）可输入两位数的0
                        if([textField.text isEqualToString:@"0.0"]){
                            return NO;
                        }
                        NSRange ran=[textField.text rangeOfString:@"."];
                        int tt=(int)(range.location-ran.location);
                        if (tt <= 2){
                            return YES;
                        }else{
                            return NO;
                        }
                    }else if (_isFirstZero&&!_isHaveDian){
                        //首位有0没.不能再输入0
                        return NO;
                    }else{
                        return YES;
                    }
                }else{
                    if (_isHaveDian){
                        //存在小数点，保留两位小数
                        NSRange ran=[textField.text rangeOfString:@"."];
                        int tt= (int)(range.location-ran.location);
                        if (tt <= 2){
                            return YES;
                        }else{
                            return NO;
                        }
                    }else if(_isFirstZero&&!_isHaveDian){
                        //首位有0没点
                        return NO;
                    }else{
                        return YES;
                    }
                }
            }else{
                //输入的数据格式不正确
                return NO;
            }
        }else{
            return YES;
        }
    
    return YES;
}

//
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    
//    return [self validateNumberByRegExp:string];
//}
//
//
//
//
//#pragma mark - 私有方法
//
//
//- (BOOL)validateNumberByRegExp:(NSString *)string {
//    BOOL isValid = YES;
//    NSUInteger len = string.length;
//    if (len > 0) {
//        NSString *numberRegex = @"^\d+(\.\d{2})?$";
//        NSPredicate *numberPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];
//        isValid = [numberPredicate evaluateWithObject:string];
//    }
//    return isValid;
//}



- (void)pl_bouceWeightView:(PLBounceWeightView *)bouceWeightView style:(NSInteger)style {
    if (style == 0) {
        [_glassView removeFromSuperview];
    } else {
        
        
        
        CGFloat num = [bouceWeightView.weightLabel.text floatValue];
        
        if (num < 500 && num > 0) {
            
            
            
            [_glassView removeFromSuperview];
            
            PLHistoryInformation *history = [[PLHistoryInformation alloc] init];
            history.weight = num;
            
            history.time = bouceWeightView.timeLabel.text;
            
            [[PLDataBaseManager shareManager] insertHistoryRecord:history];
            
            
            
            
            
            [((PLMineViewController *)[self ml_viewController]).tableView reloadData];
            
            
            
            
            
            
        } else {
            
            
            
            [UIView showMessage:@"请输入真实体重哦"];
            bouceWeightView.weightLabel.text = nil;
            
            
            
        }
        
        
    }
    
}

- (void)pl_createGlass {
    
    
    self.glassView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *visualView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    visualView.frame = [UIScreen mainScreen].bounds;
    [_glassView addSubview:visualView];
    [self.window addSubview:_glassView];
    
    
    UIView *view = [[UIView alloc] init];
    view.layer.cornerRadius = 10.f;
    view.frame = CGRectMake((WIDTH - (WIDTH - 40)) / 2, 100, WIDTH - 40, 240);
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.7;
    [_glassView addSubview:view];
    
    
    
    PLBounceWeightView *bounceWeight = [[NSBundle mainBundle] loadNibNamed:@"PLBounceWeightView" owner:nil options:nil].lastObject;
    bounceWeight.layer.cornerRadius = 10.f;
    bounceWeight.delegate = self;
    [bounceWeight.weightLabel becomeFirstResponder];
    bounceWeight.weightLabel.delegate = self;
    bounceWeight.frame = CGRectMake((WIDTH - (WIDTH - 40)) / 2, 100, WIDTH - 40, 240);
    [_glassView addSubview:bounceWeight];
    
    
}

- (UIViewController *)ml_viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

@end
