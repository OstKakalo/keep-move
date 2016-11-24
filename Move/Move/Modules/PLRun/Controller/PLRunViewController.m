//
//  PLRunViewController.m
//  Move
//
//  Created by PhelanGeek on 2016/10/19.
//  Copyright © 2016年 PhelanGeek. All rights reserved.
//

#import "PLRunViewController.h"
#import "PLHealthManager.h"
#import "PLRunNowViewController.h"
#import "UIImage+GIF.h"
#import "MyCalendarItem.h"
#import "PLHealthSource.h"
#import "PLPersonInformation.h"
#import "PLXHealthManager.h"
@interface PLRunViewController ()
<
UIGestureRecognizerDelegate,
PNChartDelegate,
PLHealthManagerDelegate
>

@property (weak, nonatomic) IBOutlet UIImageView *runImage;

@property (nonatomic, assign) NSInteger runImageNum;

@property (weak, nonatomic) IBOutlet UIButton *runButton;

@property (nonatomic, strong) MyCalendarItem *calendarView;

@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) UILabel *calendarLabel;

@property (nonatomic, strong) PNBarChart *barChart;

@property (nonatomic, copy) NSString *dateTime;

@property (nonatomic, copy) NSString *clickDateTime;

@property (nonatomic, strong) NSMutableArray *healthArray;

@property (weak, nonatomic) IBOutlet UILabel *energyLabel;

@property (weak, nonatomic) IBOutlet UILabel *kmLabel;

@property (weak, nonatomic) IBOutlet UILabel *floorLabel;

@property (weak, nonatomic) IBOutlet UILabel *stepLabel;

@property (weak, nonatomic) IBOutlet UILabel *goalLabel;

@property (weak, nonatomic) IBOutlet UILabel *percentLabel;

@property (nonatomic, assign) NSInteger goalStep;

@property (nonatomic, assign) NSInteger originalStep;

@property (nonatomic, assign) NSInteger clickStep;

@property (nonatomic, assign) BOOL isStepAdd;

@property (nonatomic, assign) NSInteger originalEnergy;

@property (nonatomic, assign) NSInteger clickEnergy;

@property (nonatomic, assign) BOOL isEnergyAdd;

@property (nonatomic, assign) NSInteger originalFloor;

@property (nonatomic, assign) NSInteger clickFloor;

@property (nonatomic, assign) BOOL isFloorAdd;

@property (nonatomic, assign) double originalKM;

@property (nonatomic, assign) double clickKM;

@property (nonatomic, assign) BOOL isKMAdd;

@property (nonatomic, assign) NSInteger originalPercent;

@property (nonatomic, assign) NSInteger clickPercent;

@property (nonatomic, assign) BOOL isPercentAdd;

@property (nonatomic, assign) NSInteger originalImageNum;

@property (nonatomic, assign) NSInteger clickImageNum;

@property (nonatomic, assign) BOOL isImageNumAdd;

@property (nonatomic, strong) NSTimer *stepTimer;

@property (nonatomic, strong) NSTimer *energyTimer;

@property (nonatomic, strong) NSTimer *floorTimer;

@property (nonatomic, strong) NSTimer *kmTimer;

@property (nonatomic, strong) NSTimer *imageTimer;

@property (nonatomic, strong) NSTimer *percentTimer;

@property (nonatomic, strong) NSDate *lastDate;

@property (nonatomic, strong) UILabel *noteLabel;

@end

@implementation PLRunViewController


-(MyCalendarItem *)calendarView{
    if (!_calendarView) {
        _calendarView = [[MyCalendarItem alloc] init];
        _calendarView.dayday = 14;
        _calendarView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width * 6 / 7 +  94);
        
    }
    return _calendarView;
}

// 绘图
- (void)drawBarChartWithDate:(NSDate *)date {
    [_barChart removeFromSuperview];
    [_noteLabel removeFromSuperview];
        PLXHealthManager *manager = [PLXHealthManager shareInstance];
        manager.days = 1;
        manager.isDay = NO;
        manager.startDate = date;
        [manager authorizeHealthKit:^(BOOL success, NSError *error) {
            if (error == nil) {
                //NSLog(@"success");
                [manager getStepCount:^(double value, NSArray *array, NSError *error) {
                    if (error == nil && array.count > 0) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSCalendar *calendar = [NSCalendar currentCalendar];
                            NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
                            [components setHour:0];
                            [components setMinute:0];
                            [components setSecond:0];
                            NSDate *date1 = [calendar dateFromComponents:components];
                            NSMutableArray *xArray = [NSMutableArray array];
                            NSMutableArray *yArray = [NSMutableArray array];
                            for (int i = 0; i < 96; i++) {
                                if (array.count > 0) {
                                    for (int j = 0; j < array.count; j++) {
                                        NSDictionary *dic = array[j];
                                        NSDate *date2 = [dic valueForKey:@"dateTime"];
                                        NSTimeInterval time = [date2 timeIntervalSinceDate:date1];
                                        if (i == (int)(time / 86400 * 96 + 0.5)) {
                                            [yArray addObject:[dic valueForKey:@"value"]];
                                            break;
                                        }
                                        if (j == array.count - 1) {
                                            [yArray addObject:@"0"];
                                        }
                                    }
                                }
                                else {
                                    [yArray addObject:@"0"];
                                }
                                
                                [xArray addObject:@""];
                            }
                            
                            [_barChart setXLabels:xArray];
                            [_barChart setYValues:yArray];
                            
                            [self.view addSubview:_barChart];
                            [_barChart strokeChart];
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


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.hidden = NO;
    //NSLog(@"%@",  [NSDate dateWithTimeIntervalSinceReferenceDate:0]);
    
    [self userDefauls];
    
    [self drawBarChartWithDate:_lastDate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.lastDate = [NSDate date];
    
    [self initHKHealth];
    
    [self createRunNowButton];
    
    [self createCalendar];
    
    [self createNavigationTitleView];
    
    [self createBarChart];
    
    [self createNoteLabel];

}

- (void)createNoteLabel {
    self.noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH / 2 - 100, HEIGHT / 1.5, 200, 40)];
    _noteLabel.text = @"请在设置->隐私->健康中允许Keep Move访问数据";
    _noteLabel.font = [UIFont systemFontOfSize:16];
    _noteLabel.textColor = [UIColor lightGrayColor];
    _noteLabel.numberOfLines = 0;
    _noteLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_noteLabel];
    
}

- (void)createNavigationTitleView {
    UIView *navigationTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 108, 25)];
    navigationTitleView.backgroundColor = ColorWith51Black;
    self.navigationItem.titleView = navigationTitleView;
    
    UIImageView *calendarImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"c5"]];
    calendarImage.frame = CGRectMake(0, 3, 20, 20);
    [navigationTitleView addSubview:calendarImage];
    
    self.calendarLabel = [[UILabel alloc] initWithFrame:CGRectMake(28, 0, 80, 25)];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@" MM月dd日"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    _calendarLabel.text = dateTime;
    _calendarLabel.textColor = [UIColor whiteColor];
    [navigationTitleView addSubview:_calendarLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(navigationTitleViewTap)];
    tap.cancelsTouchesInView = NO;
    tap.numberOfTouchesRequired = 1;
    tap.numberOfTapsRequired = 1;
    [navigationTitleView addGestureRecognizer:tap];

}


- (void)navigationTitleViewTap {
    
    [self ml_appear];
}



- (void)createCalendar {
    
 
    __weak typeof(self) weakSelf = self;
    
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, - ([UIScreen mainScreen].bounds.size.width * 6 / 7 +  94), [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height + [UIScreen mainScreen].bounds.size.width * 6 / 7 +  94)];
    self.calendarView.date = [NSDate date];
    [_backView addSubview:self.calendarView];
    _backView.hidden = YES;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    self.dateTime = [formatter stringFromDate:[NSDate date]];
    
    
    
    _calendarView.calendarBlock = ^(NSInteger day, NSInteger month, NSInteger year) {
        
        //NSLog(@"%ld-%02ld-%02ld", (long)year, month, day);
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        weakSelf.lastDate = [formatter dateFromString:[NSString stringWithFormat:@"%ld-%02ld-%02ld 23:59:59", (long)year, month, day]];
        [weakSelf drawBarChartWithDate:weakSelf.lastDate];
        
        weakSelf.calendarLabel.text = [NSString stringWithFormat:@"%02ld月%02ld日", month, (long)day];
        
        [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            weakSelf.backView.frame = CGRectMake(0, - ([UIScreen mainScreen].bounds.size.width * 6 / 7 +  94), [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height + [UIScreen mainScreen].bounds.size.width * 6 / 7 +  94);
            weakSelf.backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
            
       
            
        } completion:^(BOOL finished) {
     
            [weakSelf.stepTimer invalidate];
            [weakSelf.energyTimer invalidate];
            [weakSelf.floorTimer invalidate];
            [weakSelf.kmTimer invalidate];
            [weakSelf.percentTimer invalidate];
            [weakSelf.imageTimer invalidate];
            weakSelf.imageTimer = nil;
            weakSelf.isStepAdd = NO;
            weakSelf.isKMAdd = NO;
            weakSelf.isFloorAdd = NO;
            weakSelf.isEnergyAdd = NO;
            weakSelf.isPercentAdd = NO;
            weakSelf.isImageNumAdd = NO;
            weakSelf.backView.hidden = YES;
            weakSelf.clickDateTime = [NSString stringWithFormat:@"%ld-%02ld-%02ld", year, month, day];
            
            
            
            
//            dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            

                
                PLHealthSource *clickHealth = [weakSelf healthSourceWithDateTime:weakSelf.clickDateTime];
                PLHealthSource *originalHealth = [weakSelf healthSourceWithDateTime:weakSelf.dateTime];
                
                NSInteger stepABS = labs([originalHealth.step integerValue] - [clickHealth.step integerValue]);
                weakSelf.originalStep = [originalHealth.step integerValue];
                weakSelf.clickStep = [clickHealth.step integerValue];
                if (weakSelf.originalStep < weakSelf.clickStep) {
                    weakSelf.isStepAdd = YES;
                }
                weakSelf.stepTimer = [NSTimer scheduledTimerWithTimeInterval:1.f / stepABS target:weakSelf selector:@selector(stepTimerAction:) userInfo:nil repeats:YES];
                
                
                
                
                weakSelf.originalFloor = [originalHealth.floor integerValue];
                weakSelf.clickFloor = [clickHealth.floor integerValue];
                NSInteger floorABS = labs(weakSelf.originalFloor - weakSelf.clickFloor);
                if (weakSelf.originalFloor < weakSelf.clickFloor) {
                    weakSelf.isFloorAdd = YES;
                }
                weakSelf.floorTimer = [NSTimer scheduledTimerWithTimeInterval:1.f / floorABS target:weakSelf selector:@selector(floorTimerAction:) userInfo:nil repeats:YES];
                
                
                
                weakSelf.originalKM = [originalHealth.km doubleValue];
                weakSelf.clickKM = [clickHealth.km doubleValue];
                double kmABS = fabs(weakSelf.originalKM - weakSelf.clickKM);
                if (weakSelf.originalKM < weakSelf.clickKM) {
                    weakSelf.isKMAdd = YES;
                }
                
                weakSelf.kmTimer = [NSTimer scheduledTimerWithTimeInterval:1.f / (kmABS * 100) target:weakSelf selector:@selector(kmTimerAction:) userInfo:nil repeats:YES];
                
                
                
                weakSelf.originalEnergy = weakSelf.originalStep / 30;
                weakSelf.clickEnergy = weakSelf.clickStep / 30;
                NSInteger energyABS = labs(weakSelf.originalEnergy - weakSelf.clickEnergy);
                if (weakSelf.originalEnergy < weakSelf.clickEnergy) {
                    weakSelf.isEnergyAdd = YES;
                }
                weakSelf.energyTimer = [NSTimer scheduledTimerWithTimeInterval:1.f / energyABS target:weakSelf selector:@selector(energyTimerAction:) userInfo:nil repeats:YES];
                
                
                
                
                CGFloat originalPercentFloat = [originalHealth.step doubleValue] / self.goalStep;
                weakSelf.originalPercent = originalPercentFloat * 100;
                CGFloat clickPercentFloat = [clickHealth.step doubleValue] / self.goalStep;
                weakSelf.clickPercent = clickPercentFloat * 100;
                NSInteger percentABS = labs(weakSelf.originalPercent - weakSelf.clickPercent);
                if (weakSelf.originalPercent < weakSelf.clickPercent) {
                    weakSelf.isPercentAdd = YES;
                }
                weakSelf.percentTimer = [NSTimer scheduledTimerWithTimeInterval:1.f / percentABS target:weakSelf selector:@selector(percentTimerAction:) userInfo:nil repeats:YES];
                
                
                
                weakSelf.originalImageNum = originalPercentFloat * 55;
                weakSelf.clickImageNum = clickPercentFloat * 55;
                NSInteger imageNumABS = labs(weakSelf.originalImageNum - weakSelf.clickImageNum);
                if (weakSelf.originalImageNum < weakSelf.clickImageNum) {
                    weakSelf.isImageNumAdd = YES;
                }
                weakSelf.imageTimer = [NSTimer scheduledTimerWithTimeInterval:1.f / imageNumABS target:weakSelf selector:@selector(imageTimerAction:) userInfo:nil repeats:YES];
                
            
//            });
            
            
            
            ////
            weakSelf.dateTime = weakSelf.clickDateTime;
            
            
            
            
            
            
            
            
        }];
        
        
        
        
    };
    
    
    
    _backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:_backView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:nil];
    tap.delegate = self;
    [_backView addGestureRecognizer:tap];
    
    
    

}
- (void)imageTimerAction:(NSTimer *)timer {

    if (self.isImageNumAdd) {
        self.originalImageNum += 1;
    } else {
        
        self.originalImageNum -= 1;
    }
    
    
    NSInteger tamp = self.originalImageNum;
    
    if (tamp > 55) {
        tamp = 55;
    }
    
    self.runImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"activity_circle-%ld_150x130_@2x", tamp]];
    
    
    if (self.originalImageNum == self.clickImageNum) {
        [timer invalidate];
    }
    

}

- (void)percentTimerAction:(NSTimer *)timer {
    if (self.isPercentAdd) {
        self.originalPercent += 1;
    } else {
        
        self.originalPercent -= 1;
    }
    self.percentLabel.text = [NSString stringWithFormat:@"%ld%% 已经完成", self.originalPercent];
    
    if ([self.percentLabel.text isEqualToString:[NSString stringWithFormat:@"%ld%% 已经完成", self.clickPercent]]) {
        [timer invalidate];
    }

}

- (void)stepTimerAction:(NSTimer *)timer {
    if (self.isStepAdd) {
        self.originalStep += 1;
    } else {
    
        self.originalStep -= 1;
    }
    self.stepLabel.text = [NSString stringWithFormat:@"%ld", self.originalStep];
    
    if ([self.stepLabel.text isEqualToString:[NSString stringWithFormat:@"%ld", self.clickStep]]) {
        [timer invalidate];
    }

}

- (void)energyTimerAction:(NSTimer *)timer {
    if (self.isEnergyAdd) {
        self.originalEnergy += 1;
    } else {
        
        self.originalEnergy -= 1;
    }
    self.energyLabel.text = [NSString stringWithFormat:@"%ld", self.originalEnergy];
    
    if ([self.energyLabel.text isEqualToString:[NSString stringWithFormat:@"%ld", self.clickEnergy]]) {
        [timer invalidate];
    }
    
}

- (void)floorTimerAction:(NSTimer *)timer {
    if (self.isFloorAdd) {
        self.originalFloor += 1;
    } else {
        
        self.originalFloor -= 1;
    }
    self.floorLabel.text = [NSString stringWithFormat:@"%ld", self.originalFloor];
    
    if ([self.floorLabel.text isEqualToString:[NSString stringWithFormat:@"%ld", self.clickFloor]]) {
        [timer invalidate];
    }


}

- (void)kmTimerAction:(NSTimer *)timer {
    if (self.isKMAdd) {
        self.originalKM += 0.01;
    } else {
        
        self.originalKM -= 0.01;
    }
    self.kmLabel.text = [NSString stringWithFormat:@"%.2f", self.originalKM];
    
    if ([self.kmLabel.text isEqualToString:[NSString stringWithFormat:@"%.2f", self.clickKM]]) {
        [timer invalidate];
    }

}


- (PLHealthSource *)healthSourceWithDateTime:(NSString *)dateTime {
    for (int i = 0; i < self.healthArray.count; i++) {
        PLHealthSource *health = self.healthArray[i];
        if ([health.dateTime isEqualToString:dateTime]) {
            return health;
        }
    }
    return nil;


}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {

        if ([touch.view isEqual:_backView]) {
            [self ml_dismiss];
        }
    return YES;


}

- (void)ml_appear {
    
    self.backView.hidden = NO;
    
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        _backView.frame = CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height + [UIScreen mainScreen].bounds.size.width * 6 / 7 +  94);
    } completion:^(BOOL finished) {
        //
    }];
    
    
}

- (void)ml_dismiss {
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _backView.frame = CGRectMake(0, - ([UIScreen mainScreen].bounds.size.width * 6 / 7 +  94), [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height + [UIScreen mainScreen].bounds.size.width * 6 / 7 +  94);
        _backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    } completion:^(BOOL finished) {
        _backView.hidden = YES;
        
    }];

}



- (void)initHKHealth{
    
    PLHealthManager *manager = [PLHealthManager shareInstance];
    NSString *model = [[UIDevice currentDevice] model];
    if ([model hasPrefix:@"iPh"]) {
        [manager getIphoneHealthData];
    }

    manager.days = 14;
    
    manager.delegate = self;
    
    
//    
//    manager.blockSteps = ^(NSArray *stepArray, BOOL flag) {
//        
//    
//        //NSLog(@"%@,%d", stepArray, flag);
//        if (flag) {
//            self.healthArray = [NSMutableArray array];
//            for (int i = 0; i < manager.healthSteps.count; i++) {
//                PLHealthSource *health = [[PLHealthSource alloc] init];
//                health.step = manager.healthSteps[i][@"value"];
//                health.km = manager.healthDistances[i][@"step and running"];
//                health.floor = manager.healthStairsClimbed[i][@"value"];
//                health.dateTime = manager.healthSteps[i][@"dateTime"];
//                [weakSelf.healthArray addObject:health];
//            }
//        }
//        
//    };
//    manager.blockDistances = ^(NSArray *distanceArray, BOOL flag) {
//    
//        //NSLog(@"%@, %d", distanceArray, flag);
//        if (flag) {
//            self.healthArray = [NSMutableArray array];
//            for (int i = 0; i < manager.healthSteps.count; i++) {
//                PLHealthSource *health = [[PLHealthSource alloc] init];
//                health.step = manager.healthSteps[i][@"value"];
//                health.km = manager.healthDistances[i][@"step and running"];
//                health.floor = manager.healthStairsClimbed[i][@"value"];
//                health.dateTime = manager.healthSteps[i][@"dateTime"];
//                [weakSelf.healthArray addObject:health];
//            }
//        }
//    };
//    manager.blockStairs = ^ (NSArray *stairsArray, BOOL flag) {
//        //NSLog(@"%@, %d", stairsArray, flag);
//        if (flag) {
//            self.healthArray = [NSMutableArray array];
//            for (int i = 0; i < manager.healthSteps.count; i++) {
//                PLHealthSource *health = [[PLHealthSource alloc] init];
//                health.step = manager.healthSteps[i][@"value"];
//                health.km = manager.healthDistances[i][@"step and running"];
//                health.floor = manager.healthStairsClimbed[i][@"value"];
//                health.dateTime = manager.healthSteps[i][@"dateTime"];
//                [weakSelf.healthArray addObject:health];
//            }
//        }
//    
//    };
    
    
    
    
    

    
}

- (void)managerWithStairsArray:(NSArray *)stairsArray flag:(BOOL)flag {

    //NSLog(@"%@ %d", stairsArray, flag);
    [self getSourceWithArray:stairsArray flag:flag];
}

- (void)managerWithDistancesArray:(NSArray *)distanceArray flag:(BOOL)flag {

    //NSLog(@"%@ %d", distanceArray, flag);
    [self getSourceWithArray:distanceArray flag:flag];
}

- (void)managerWithStepArray:(NSArray *)stepArray flag:(BOOL)flag {
    //NSLog(@"%@ %d", stepArray, flag);
    
    [self getSourceWithArray:stepArray flag:flag];
}



- (void)getSourceWithArray:(NSArray *)array flag:(BOOL)flag {
    
    PLHealthManager *manager = [PLHealthManager shareInstance];
    
    
    if (flag) {
        self.healthArray = [NSMutableArray array];
        if (!manager.healthSteps.count) {
//            NSDateComponents *comps = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
//            NSInteger day = comps.day;
            NSDate *date = [NSDate date];
            
            for (int i = 0; i < 14; i++) {
                NSDateComponents *comp = [[NSDateComponents alloc] init];
                comp.day = -i;
                NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:comp toDate:date options:0];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                NSString *time = [formatter stringFromDate:newDate];
                
                PLHealthSource *health = [[PLHealthSource alloc] init];
                health.step = [NSString stringWithFormat:@"%d", arc4random() % 9000 + 1000];
                CGFloat km = (arc4random() % 900 + 100) / 100.f;
                health.km = [NSString stringWithFormat:@"%.2f", km];
                health.floor = [NSString stringWithFormat:@"%d" , arc4random() % 25 + 5];
                health.dateTime = time;
                [self.healthArray addObject:health];
            }
        }
        
        for (int i = 0; i < manager.healthSteps.count; i++) {
            PLHealthSource *health = [[PLHealthSource alloc] init];
            health.step = manager.healthSteps[i][@"value"];
            
            
            if (i <= manager.healthDistances.count - 1) {
                health.km = manager.healthDistances[i][@"step and running"];
            } else {
            
                health.km = @"0.00";
            }
    
            if (i <= manager.healthStairsClimbed.count - 1) {
                
                health.floor = manager.healthStairsClimbed[i][@"value"];
            } else {
                health.floor = @"0";
            }
            
            health.dateTime = manager.healthSteps[i][@"dateTime"];
            [self.healthArray addObject:health];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            PLHealthSource *todayHealthy = _healthArray.lastObject;
            self.floorLabel.text = todayHealthy.floor;
            self.kmLabel.text = todayHealthy.km;
            self.stepLabel.text = todayHealthy.step;
            self.energyLabel.text =  [NSString stringWithFormat:@"%ld", [todayHealthy.step integerValue] / 30];
            CGFloat percentFloat = [todayHealthy.step doubleValue] / self.goalStep;
            NSInteger percentInteger = percentFloat * 100;
            self.percentLabel.text = [NSString stringWithFormat:@"%ld%% 已经完成", percentInteger];
            
            self.runImageNum = 55 * percentFloat;
            if (_runImageNum > 55) {
                _runImageNum = 55;
            }
            self.runImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"activity_circle-%ld_150x130_@2x", _runImageNum]];
        
        });
        
    }
}

- (void)createRunNowButton {
    
    UIImage *runImage = [UIImage sd_animatedGIFNamed:@"weRunConnecting"];
    _runButton.imageEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 8);
    _runButton.layer.cornerRadius = 20.f;
    _runButton.layer.borderColor = [UIColor grayColor].CGColor;
    _runButton.layer.borderWidth = 1;
    [_runButton setImage:runImage forState:UIControlStateNormal];

    [_runButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        PLRunNowViewController *runNowVC = [[PLRunNowViewController alloc] init];
        runNowVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:runNowVC animated:YES];

    }];

}


- (void)userDefauls {
    [[PLDataBaseManager shareManager] createPersonTable];
    NSUserDefaults *userDefauls1 = [NSUserDefaults standardUserDefaults];
    
    if (![userDefauls1 boolForKey:@"notFirst"]) {
        
        NSUserDefaults *userDefauls2 = [NSUserDefaults standardUserDefaults];
        [userDefauls2 setBool:YES forKey:@"notFirst"];
        
        PLPersonInformation *person = [[PLPersonInformation alloc] init];
        person.gender = @"男";
        person.brithday = 1994;
        person.height = 178;
        person.goalWeight = 60.3f;
        person.goalStep = 10000;
        
        [[PLDataBaseManager shareManager] insertPerson:person];
        
        
    }
    
    PLPersonInformation *person1 = [[PLDataBaseManager shareManager] personInformation];
    
    self.goalStep = person1.goalStep;
    self.goalLabel.text = [NSString stringWithFormat:@"目标: %ld", person1.goalStep];
    
}

#pragma mark - 时间段柱状图
- (void)createBarChart {
    self.barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(10, HEIGHT / 1.6, WIDTH - 20, HEIGHT / 16 * 6 - 64 - 55)];
    _barChart.yChartLabelWidth = 0;
    _barChart.chartMarginLeft = -1.0;
    _barChart.chartMarginRight = 0.0;
    _barChart.chartMarginTop = 5.0;
    _barChart.chartMarginBottom = 10.0;
    _barChart.labelMarginTop = 2.0;
    
    [_barChart setStrokeColor:PNWhite];
    _barChart.showLabel = YES;
    _barChart.showLevelLine = NO;
    _barChart.showChartBorder = YES;
    _barChart.isGradientShow = NO;
    _barChart.isShowNumbers = NO;
    
    _barChart.backgroundColor = [UIColor clearColor];
    _barChart.barBackgroundColor = [UIColor clearColor];
    _barChart.delegate = self;
    
    for (int i = 0; i < 3; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH / 4 * (i + 1) - 15, _barChart.frame.origin.y + _barChart.frame.size.height - 20, 30, 20)];
        label.text = [NSString stringWithFormat:@"%d:00", 6 * (i + 1)];
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:10];
        [self.view addSubview:label];
    }
}


@end
