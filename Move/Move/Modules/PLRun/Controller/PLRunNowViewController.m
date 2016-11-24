//
//  PLRunNowViewController.m
//  Move
//
//  Created by PhelanGeek on 2016/11/2.
//  Copyright © 2016年 PhelanGeek. All rights reserved.
//

#import "PLRunNowViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CLLocationManager.h>
#import "PLNavigationView.h"
#import "PLMenuView.h"
#import "PLDetailInfoView.h"
#import "NSString+TimeFormat.h"
#import "PLInfoModel.h"
#import "Record.h"
#import "MAMutablePolyline.h"
#import "MAMutablePolylineRenderer.h"
#import "FileHelper.h"
#import "RecordViewController.h"
#import "NSDate+Categories.h"
#import "NSString+TimeFormat.h"

@import CoreMotion;

@interface PLRunNowViewController ()
<
    MAMapViewDelegate,
    AMapSearchDelegate
>

// 地图相关属性
@property (nonatomic, retain) MAMapView *mapView;
@property (nonatomic, strong) MAUserLocation *userLocation;
@property (nonatomic, strong) AMapSearchAPI *mapSearchAPI;
@property (nonatomic, strong) AMapLocalWeatherLive *live;
@property (nonatomic, strong) AMapLocalWeatherForecast *forecast;
@property (nonatomic, strong) AMapLocalDayWeatherForecast *dayForecast;
@property (nonatomic, strong) AMapReGeocodeSearchRequest *regeo;

// 运动轨迹相关属性
@property (nonatomic, strong) NSMutableArray *locationsArray;
@property (nonatomic, strong) Record *currentRecord;
@property (nonatomic, strong) MAMutablePolyline *mutablePolyline;
@property (nonatomic, strong) MAMutablePolylineRenderer *render;
@property (nonatomic, assign) BOOL startMoving;
@property (nonatomic, retain) PLInfoModel *infoModel;
@property (nonatomic, copy) NSString *goalPath;
@property (nonatomic, retain) NSMutableArray *runInfoArray;
@property (nonatomic, retain) NSMutableArray *commonPolylineCoords;
@property (nonatomic, strong) NSString *address;

// 按钮
@property (nonatomic, retain) UIButton *beginButton;
@property (nonatomic, retain) UIButton *backButton;
@property (nonatomic, retain) UIButton *locationButton;
@property (nonatomic, retain) UIButton *voiceButton;
@property (nonatomic, assign) BOOL flag;

// 自定义View
@property (nonatomic, retain) PLMenuView *plMenuView;
@property (nonatomic, retain) PLDetailInfoView *plDetailView;
@property (nonatomic, retain) PLNavigationView *plNavigationView;

@property (nonatomic, retain) UIView *blurView;
@property (nonatomic, retain) UILabel *timeLabel;
@property (nonatomic, assign) NSInteger temp;
@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, retain) NSTimer *runTimer;
@property (nonatomic, assign) int runTime;

/** 计步 */
@property (strong, nonatomic) CMPedometer *pedometer;

// 语音相关属性
@property (nonatomic, strong) NSArray<AVSpeechSynthesisVoice *> *laungeVoices;
@property (nonatomic, retain) AVSpeechUtterance *utterance;

/** 语音合成器 */
@property (nonatomic, strong) AVSpeechSynthesizer *synthesizer;
@property (nonatomic, copy) NSString *speakingString;

// 语音图片
@property (nonatomic, retain) UIImage *voiceOpenImage;
@property (nonatomic, retain) UIImage *voiceCloseImage;

@end

@implementation PLRunNowViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    _runTime = 0;
    [self setupPath];
    [self setupCustomView];
    [self setupMap];
    [self initVoiceButton];
    [self initLocationButton];
    [self setupButton];
    self.runInfoArray = [NSMutableArray array];
    NSArray *pArray = [NSKeyedUnarchiver unarchiveObjectWithFile:_goalPath];
    self.runInfoArray = [NSMutableArray arrayWithArray:pArray];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.mapView addOverlay:self.mutablePolyline];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [_plMenuView removeFromSuperview];
    [_plDetailView removeFromSuperview];
    [_mapView removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.infoModel = [[PLInfoModel alloc] init];
    self.commonPolylineCoords = [NSMutableArray array];
    _flag = YES;
    _startMoving = NO;
 
//    [self setupCustomView];
//    [self setupMap];
//    [self initVoiceButton];
//    [self initLocationButton];
//    [self setupButton];
    [self setupNavigationView];
    [self initOverlay];
    [self initLocationButton];
    [self initVoiceButton];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.mapView addOverlay:self.mutablePolyline];
    [_mapView setZoomLevel:17 animated:YES];
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
}

- (void)setupPath {
    // 拼接路径
    NSArray *libraryArray = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryPath = [libraryArray firstObject];
    
    // 列表
    NSString *path = [libraryPath stringByAppendingString:@"/Preferences"];
    path = [path stringByAppendingString:@"/RunRecord.plist"];
    self.goalPath = path;
    //NSLog(@"%@", _goalPath);
}

#pragma mark - 懒加载

- (NSArray<AVSpeechSynthesisVoice *> *)laungeVoices {
    if (_laungeVoices == nil) {
        _laungeVoices = @[
                          //美式英语
                          [AVSpeechSynthesisVoice voiceWithLanguage:@"en-US"],
                          //英式英语
                          [AVSpeechSynthesisVoice voiceWithLanguage:@"en-GB"],
                          //中文
                          [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"]
                          ];
    }
    return _laungeVoices;
}

- (AVSpeechSynthesizer *)synthesizer {
    if (_synthesizer == nil) {
        _synthesizer = [[AVSpeechSynthesizer alloc] init];
        _synthesizer.delegate = (id)self;
    }
    return _synthesizer;
}

- (CMPedometer *)pedometer {
    
    if (!_pedometer) {
        _pedometer = [[CMPedometer alloc]init];
    }
    return _pedometer;
}

#pragma mark - 设置

- (void)setupMap {
    // 初始化地图
    self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, _plMenuView.frame.origin.y + _plMenuView.frame.size.height, PLWIDTH, HEIGHT - _plMenuView.frame.size.height - 64)];
    // 地图语言
    _mapView.language = MAMapLanguageZhCN;
    // 地图类型
    _mapView.mapType = MAMapTypeStandard;
    // 隐藏指南针
    _mapView.showsCompass = NO;
    // 隐藏比例尺
    _mapView.showsScale= NO;
    // 开启定位
    _mapView.showsUserLocation = YES;
    // 地图跟随用户位置移动
    [_mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES]; //地图跟着位置移动
    // 后台持续定位
    _mapView.pausesLocationUpdatesAutomatically = NO;
    _mapView.allowsBackgroundLocationUpdates = YES;//iOS9以上系统必须配置
    // 设置地图logo位置
    _mapView.logoCenter = CGPointMake(CGRectGetWidth(_mapView.bounds)-35, CGRectGetHeight(_mapView.bounds)-10);
    
    //代理
    _mapView.delegate = self;
    self.mapSearchAPI = [[AMapSearchAPI alloc] init];
    _mapSearchAPI.delegate = self;
    
    self.regeo = [[AMapReGeocodeSearchRequest alloc] init];
    [self.view addSubview:_mapView];
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        
        //定位不能用
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"为了更准确的定位计步,请前往\n设置->隐私->定位服务\n开启对Keep Move的授权" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alert addAction:sureAction];
        [self presentViewController:alert animated:YES completion:nil];
        _mapView = nil;   
    }

}

- (void)initLocationButton
{
    self.locationButton = [[UIButton alloc] initWithFrame:CGRectMake(PLWIDTH - 40, 10, 30, 30)];
    _locationButton.backgroundColor = [UIColor blackColor];
    _locationButton.layer.cornerRadius = 15;
    [_locationButton setImage:[UIImage imageNamed:@"myLocation"] forState:UIControlStateNormal];
    _locationButton.imageEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8);
    [self.locationButton addTarget:self action:@selector(actionLocation) forControlEvents:UIControlEventTouchUpInside];
    [_mapView addSubview:self.locationButton];
}

- (void)initVoiceButton {
    self.voiceButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
    _voiceButton.backgroundColor = [UIColor blackColor];
    _voiceButton.layer.cornerRadius = 15;
    self.voiceOpenImage = [UIImage imageNamed:@"openVoice"];
    self.voiceCloseImage = [UIImage imageNamed:@"closeVoice"];

    [_voiceButton setImage:_voiceOpenImage forState:UIControlStateNormal];
    _voiceButton.imageEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8);
    [_voiceButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{

        if (_flag == YES) {

            [_voiceButton setImage:_voiceCloseImage forState:UIControlStateNormal];
            _flag = NO;
            //立即暂停播放
            [self.synthesizer pauseSpeakingAtBoundary:AVSpeechBoundaryImmediate];
        }else {

             [_voiceButton setImage:_voiceOpenImage forState:UIControlStateNormal];
            _flag = YES;
            //继续播放
            [self.synthesizer continueSpeaking];
        }
        
    }];
    [_mapView addSubview:self.voiceButton];
}

- (void)setupNavigationView {
    // 设置导航栏view
    self.plNavigationView = [[PLNavigationView alloc] init];
    _plNavigationView.frame = CGRectMake(0, 0, PLWIDTH, 64);
    _plNavigationView.titleString = @"GPS运动";
    [_plNavigationView.cancelButton setBackgroundImage:[UIImage imageNamed:@"weather"] forState:UIControlStateNormal];
    [_plNavigationView.deleteButton setBackgroundImage:[UIImage imageNamed:@"historyRecord"] forState:UIControlStateNormal];
    __weak typeof(self) weekSelf = self;
    _plNavigationView.cancelButtonBlock = ^(UIButton *button){
        // 天气信息
        NSString *address = [NSString stringWithFormat:@"%@", weekSelf.live.city];
        NSString *weather = [NSString stringWithFormat:@"天气 : %@", weekSelf.live.weather];
        NSString *temperature = [NSString stringWithFormat:@"温度 : %@°", weekSelf.live.temperature];
        NSString *humidity = [NSString stringWithFormat:@"湿度 : %@%%", weekSelf.live.humidity];
        NSString *wind = [NSString stringWithFormat:@"%@风%@级", weekSelf.live.windDirection, weekSelf.live.windPower];

        [FTPopOverMenu showForSender:button withMenu:@[address, weather, temperature, humidity, wind] doneBlock:nil dismissBlock:nil];
    };
    _plNavigationView.deleteButtonBlock = ^(UIButton *button) {
        UIViewController *recordController = [[RecordViewController alloc] initWithNibName:nil bundle:nil];
        [weekSelf.plMenuView removeFromSuperview];
        [weekSelf.plDetailView removeFromSuperview];
        [weekSelf presentViewController:recordController animated:YES completion:nil];
    };
    [self.view addSubview:_plNavigationView];
    
}

- (void)setupCustomView {
    self.plMenuView = [[PLMenuView alloc] init];
    _plMenuView.frame = CGRectMake(0, 64, PLWIDTH, HEIGHT * 0.35);
    [self.view addSubview:_plMenuView];
    
    self.plDetailView = [[PLDetailInfoView alloc] init];
    _plDetailView.alpha = 0.0;
    _plDetailView.frame = CGRectMake(0, 64, PLWIDTH, HEIGHT * 0.35);

}

- (void)setupButton {
    
        self.beginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _beginButton.layer.cornerRadius = 5.0f;
        _beginButton.titleLabel.font = [UIFont systemFontOfSize:15];
        CGFloat buttonW = (PLWIDTH - 20 * 3) / 2;
        CGFloat buttonH = 50;
        CGFloat buttonX = 20;
        CGFloat buttonY = _mapView.frame.size.height - 20 - buttonH;;
        _beginButton.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        [_beginButton setTitle:@"开始" forState:UIControlStateNormal];
        [_beginButton setTitleColor:PLBLACK forState:UIControlStateNormal];
        [_beginButton setBackgroundColor:PLYELLOW];
        [_mapView addSubview:_beginButton];
    
        [_beginButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            if ([_beginButton.titleLabel.text isEqualToString:@"开始"]) {
                
                // 开始计步
                [self.pedometer startPedometerUpdatesFromDate:[NSDate date] withHandler:^(CMPedometerData * _Nullable pedometerData, NSError * _Nullable error) {
                    
                    // 更新数值
                    [self updateLabels:pedometerData];
                    
                }];

                NSString *typeNumber = [NSString stringWithFormat:@"%d", _plMenuView.type];

                NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
                [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
                NSNumber *numTemp = [numberFormatter numberFromString:typeNumber];
                _infoModel.type = numTemp;
                
                // 为地图添加临时模糊效果
                self.blurView = [[UIView alloc] init];
                _blurView.backgroundColor = [UIColor blackColor];
                _blurView.frame = _mapView.frame;
                _blurView.alpha = 0.5f;
                
                // 3秒倒计时
                self.temp = 3;
                
                // 倒计时Label
                self.timeLabel = [[UILabel alloc] init];
                _timeLabel.textAlignment = NSTextAlignmentCenter;
                [_blurView addSubview:_timeLabel];
                [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.center.mas_equalTo(_blurView);
                    make.width.mas_equalTo(_blurView);
                    make.height.mas_equalTo(@100);
                }];
                
                _timeLabel.font = [UIFont systemFontOfSize:100];
                _timeLabel.textColor = [UIColor whiteColor];
                _plMenuView.hidden = YES;
                _beginButton.hidden = YES;
                _backButton.hidden = YES;
                [self.view addSubview:_blurView];
                
                // 倒计时
                self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
                [_timer fire];
            
                [UIView animateWithDuration:3.0f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{

                    _plMenuView.alpha = 0.0f;
                    if (_plMenuView.type == NO) {
                        _plDetailView.speedRate.text = @"配速(Min/Km)";
                        _plDetailView.rateTitleLabel.text = @"速度(KM/H)";
                    }
                    _plDetailView.alpha = 1.0f;
                     [self.view addSubview:_plDetailView];
        
                } completion:^(BOOL finished) {
                
                }];
            
                [UIView animateWithDuration:0 delay:3.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{

                    _blurView.alpha = 0.0;

                    
                } completion:^(BOOL finished) {
                    if(finished) {
                        _beginButton.hidden = NO;
                        _backButton.hidden = NO;
                        [_beginButton setTitle:@"结束" forState:UIControlStateNormal];
                        [_backButton setTitle:@"暂停" forState:UIControlStateNormal];
                        [_timer invalidate];
                        
                        if ([_voiceButton.currentImage isEqual:_voiceOpenImage]) {
                            self.speakingString = @"运动开始";
                            // 关闭历史记录按钮的交互
                            _plNavigationView.deleteButton.userInteractionEnabled = NO;
                            _infoModel.date = [NSDate getSystemTimeStringWithFormat:@"yyyy年MM月dd日 HH:mm"];
                            //创建一个会话
                            self.utterance = [[AVSpeechUtterance alloc] initWithString:_speakingString];
                            //选择语言发音的类别
                            _utterance.voice = self.laungeVoices[2];
                            
                            //播放语言
                            [self.synthesizer speakUtterance:_utterance];

                            // 设置开关
                            _startMoving = YES;
                            
                            if (self.currentRecord == nil)
                            {
                                self.currentRecord = [[Record alloc] init];
                            }
                            
                            // 开始计时
                            self.runTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(callTime) userInfo:nil repeats:YES];
                            [[NSRunLoop currentRunLoop] addTimer:_runTimer forMode:NSRunLoopCommonModes];
                        }

                    }
                }];
     

            }else {
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"结束本次运动?" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    if ([_voiceButton.currentImage isEqual:_voiceOpenImage]) {
                        self.speakingString = @"运动结束";
                        // 开启历史记录按钮的交互
                        _plNavigationView.deleteButton.userInteractionEnabled = YES;
                        //创建一个会话
                        self.utterance = [[AVSpeechUtterance alloc] initWithString:_speakingString];
                        _utterance.voice = self.laungeVoices[2];
                        [self.synthesizer speakUtterance:_utterance];
                        
                        // 运动结束
                        [_pedometer stopPedometerUpdates];
                        _pedometer = nil;
                        _startMoving = NO;
                        [self.locationsArray removeAllObjects];
                        [self saveRoute];
                        [self.mutablePolyline.pointArray removeAllObjects];
                        [self.render invalidatePath];
                        
                        // 销毁定时器
                        [self.runTimer invalidate];
                        self.runTimer = nil;
                        
                        [self.runInfoArray addObject:_infoModel];
                        [NSKeyedArchiver archiveRootObject:_runInfoArray toFile:_goalPath];

                        UIViewController *recordController = [[RecordViewController alloc] initWithNibName:nil bundle:nil];
                        [self presentViewController:recordController animated:YES completion:nil];
  
                    }
                    [_beginButton setTitle:@"开始" forState:UIControlStateNormal];
                    [_backButton setTitle:@"返回" forState:UIControlStateNormal];
                    
                  
                }];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:sureAction];
                [alert addAction:cancelAction];
                [self presentViewController:alert animated:YES completion:nil];

            }
   
            }];

    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _backButton.layer.cornerRadius = 5.0f;
    _backButton.titleLabel.font = [UIFont systemFontOfSize:15];
    _backButton.frame = CGRectMake(20 * 2 + buttonW, buttonY, buttonW, buttonH);
    [_backButton setTitle:@"返回" forState:UIControlStateNormal];
    [_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_backButton setBackgroundColor:[UIColor grayColor]];
    [_mapView addSubview:_backButton];
    
    [_backButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        if ([_backButton.titleLabel.text isEqualToString:@"返回"]) {
            [self.navigationController popViewControllerAnimated:YES];
        }else if([_backButton.titleLabel.text isEqualToString:@"暂停"]) {
            [_backButton setTitle:@"继续" forState:UIControlStateNormal];
            if ([_voiceButton.currentImage isEqual:_voiceOpenImage]) {
                
                [_pedometer stopPedometerUpdates];
                
                _speakingString = @"运动暂停";
                _startMoving = NO;
                self.utterance = [[AVSpeechUtterance alloc] initWithString:_speakingString];
                _utterance.voice = self.laungeVoices[2];
                [self.synthesizer speakUtterance:_utterance];
                
                // 暂停定时器
                [self.runTimer invalidate];
                self.runTimer = nil;
            }
        }else {
            [_backButton setTitle:@"暂停" forState:UIControlStateNormal];
            if ([_voiceButton.currentImage isEqual:_voiceOpenImage]) {
                _speakingString = @"运动继续";
                _startMoving = YES;
                self.utterance = [[AVSpeechUtterance alloc] initWithString:_speakingString];
                _utterance.voice = self.laungeVoices[2];
                [self.synthesizer speakUtterance:_utterance];

                // 开启定时器
                self.runTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(callTime) userInfo:nil repeats:YES];
            }
        }
        
    }];
}

#pragma mark - timerAction

- (void)timerAction {

    _timeLabel.text = [NSString stringWithFormat:@"%ld", (long)_temp];
    _temp--;
}

#pragma mark - map Delegate

// 实时更新定位
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    
    if (!updatingLocation)
    {
        return;
    }
    
    self.userLocation = userLocation;
    // 参数1 : 纬度   参数2 : 经度
    _regeo.location = [AMapGeoPoint locationWithLatitude:_mapView.userLocation.coordinate.latitude longitude:_mapView.userLocation.coordinate.longitude];
    // 是否返回扩展信息
    _regeo.requireExtension = YES;
    [self.mapSearchAPI AMapReGoecodeSearch:_regeo];
    
    if (_startMoving == YES) {

        if (userLocation.location.horizontalAccuracy < 80 && userLocation.location.horizontalAccuracy > 0)
        {
            [self.locationsArray addObject:userLocation.location];
            [self.currentRecord addLocation:userLocation.location];
 
            [self.mutablePolyline appendPoint: MAMapPointForCoordinate(userLocation.location.coordinate)];
            
            [self.mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
            
            [self.render invalidatePath];
        }
    }
    
}

// 逆地理编码回调
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response {
    if (response.regeocode != nil) {
        AMapReGeocode *reGeocode = response.regeocode;
        self.address = reGeocode.addressComponent.adcode;
        [self showWeatherInfo];
    }
}

// 设置折线样式
- (MAOverlayPathRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAMutablePolyline class]])
    {
        MAMutablePolylineRenderer *renderer = [[MAMutablePolylineRenderer alloc] initWithOverlay:overlay];
        renderer.lineWidth = 4.0f;
        
        renderer.strokeColor = [UIColor redColor];
        self.render = renderer;
        
        return renderer;
    }
    
    return nil;
}

- (void)actionLocation
{
    [self.mapView setUserTrackingMode:MAUserTrackingModeFollow];
    [_mapView setZoomLevel:17 animated:YES];
}

#pragma mark - 天气信息

- (void)showWeatherInfo {
    AMapWeatherSearchRequest *weatherRequest = [[AMapWeatherSearchRequest alloc] init];
    weatherRequest.city = _address;
    weatherRequest.type = AMapWeatherTypeLive;
    [self.mapSearchAPI AMapWeatherSearch:weatherRequest];
    
    AMapWeatherSearchRequest *weatherRequest2 = [[AMapWeatherSearchRequest alloc] init];
    weatherRequest2.city = _address;
    weatherRequest2.type = AMapWeatherTypeForecast;
    
    [self.mapSearchAPI AMapWeatherSearch:weatherRequest2];
}

- (void)onWeatherSearchDone:(AMapWeatherSearchRequest *)request response:(AMapWeatherSearchResponse *)response {
    if (request.type == AMapWeatherTypeLive) {
        if (response.lives.count == 0) {
            return;
        }
        for (AMapLocalWeatherLive *live in response.lives) {
            self.live = live;
        }
    } else {
        if(response.forecasts.count == 0)
        {
            return;
        }
        for (AMapLocalWeatherForecast *forecast in response.forecasts) {
            self.forecast = forecast;
        }
    }
}

#pragma mark - update sports infomation

- (void)updateLabels:(CMPedometerData *)pedometerData {
   
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    formatter.maximumFractionDigits = 2;
    
    // step counting
    if ([CMPedometer isStepCountingAvailable]) {
        if (_plMenuView.type == YES) {
            self.plDetailView.stepCount = [pedometerData.numberOfSteps stringValue];
            _infoModel.stepCount =  [pedometerData.numberOfSteps stringValue];
            self.plDetailView.calorie = [NSString stringWithFormat:@"%.2f", [pedometerData.numberOfSteps integerValue] * 0.04];
            _infoModel.calorie = [NSString stringWithFormat:@"%.2f", [pedometerData.numberOfSteps integerValue] * 0.04];
        }
    } else {
        //NSLog(@"Step Counter not available");
    }
   
    // distance
    if ([CMPedometer isDistanceAvailable]) {
        CGFloat meter = [pedometerData.distance floatValue];
        if (_plMenuView.type == YES) {
            // 跑步距离
            self.plDetailView.km = [NSString stringWithFormat:@"%.1f", meter / 1000];
            _infoModel.km = [NSString stringWithFormat:@"%.1f", meter / 1000];
        }else {
            
            NSString *tempOne = [NSString stringWithFormat:@"%.1f", meter / 1000];
            float distance = [tempOne floatValue];
            
            // 骑车距离
            self.plDetailView.km = [NSString stringWithFormat:@"%.1f", distance];
            _infoModel.km = [NSString stringWithFormat:@"%.1f", distance];
        
            // 骑车大卡
            self.plDetailView.calorie = [NSString stringWithFormat:@"%.2f", distance * 43];
            _infoModel.calorie = [NSString stringWithFormat:@"%.2f", distance * 43];
            
            // 骑车速度(KM/H)
            // 小时
            double rate = meter  / _runTime;
            _plDetailView.stepCount = [NSString stringWithFormat:@"%.2f", rate * 3.6];
            _infoModel.stepCount = [NSString stringWithFormat:@"%.2f", rate * 3.6];
            
            // 骑车配速
            NSString *temp = [NSString stringWithFormat:@"%.1f", ((meter / _runTime) * 0.06)];
            
            NSString *speedRate = [NSString stringWithFormat:@"%@", [temp timeFormat]];
            self.plDetailView.rate = speedRate;
            _infoModel.rate = speedRate;

        }

    } else {
        //NSLog(@"Distance not available");
    }
    
    // cadence
    if ([CMPedometer isCadenceAvailable] && pedometerData.currentCadence) {
        if (_plMenuView.type == YES) {
            // 跑步节奏
            self.plDetailView.rate = [NSString stringWithFormat:@"%ld", [pedometerData.currentCadence integerValue]];
            _infoModel.rate = [NSString stringWithFormat:@"%ld", [pedometerData.currentCadence integerValue]];
        }
    }
}

// 计时
- (void)callTime
{
    
    self.runTime ++;
    // 分别计算 时分秒
    int hour = _runTime / 3600;
    int minute = (_runTime - hour * 3600) / 60;
    int second = _runTime - hour * 3600 - minute * 60;
    
    if (hour > 0) {
        // 保证数字是两位，如果不满足，使用0来补位
        _plDetailView.time = [NSString stringWithFormat:@"%02d:%02d:%02d", hour, minute, second];
        _infoModel.time = [NSString stringWithFormat:@"%02d:%02d:%02d", hour, minute, second];

    }else if(minute > 0){
        _plDetailView.time = [NSString stringWithFormat:@"%02d:%02d", minute, second];
        _infoModel.time = [NSString stringWithFormat:@"%02d:%02d", minute, second];
    }else {
        _plDetailView.time = [NSString stringWithFormat:@"00:%02d", second];
        _infoModel.time = [NSString stringWithFormat:@"00:%02d", second];
    }
}

#pragma mark - Utility

- (void)saveRoute
{
    if (self.currentRecord == nil)
    {
        return;
    }
    
    NSString *name = self.currentRecord.title;
    NSString *path = [FileHelper filePathWithName:name];
    
    [NSKeyedArchiver archiveRootObject:self.currentRecord toFile:path];
    
    self.currentRecord = nil;
}

- (void)initOverlay
{
    self.mutablePolyline = [[MAMutablePolyline alloc] initWithPoints:@[]];
}

@end
