//
//  PLGoalViewController.m
//  Move
//
//  Created by PhelanGeek on 2016/10/19.
//  Copyright © 2016年 PhelanGeek. All rights reserved.
//

#import "PLGoalViewController.h"
#import "PLGoalHeaderView.h"
#import "PLGoalHeaderModel.h"
#import "PLTargetView.h"
#import "PLTargetModel.h"
#import "PLDefeatView.h"
#import "PLDefeatModel.h"
#import "PLCareerView.h"
#import "PLCareerModel.h"
#import "UIImage+GIF.h"

@interface PLGoalViewController ()

@property (nonatomic, retain) PLGoalHeaderView *plGoalHeaderView;
@property (nonatomic, retain) PLTargetView *plTargetView;
@property (nonatomic, retain) PLDefeatView *plDefeatView;
@property (nonatomic, retain) PLCareerView *plCareerView;
@property (nonatomic, assign) CGFloat mul;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UIImageView *hoopImageView;
@property (nonatomic, retain) UIImageView *roopImageView;
@property (nonatomic, assign) BOOL isSwitch;

@property (nonatomic, assign) BOOL roopFlag;
@property (nonatomic, assign) BOOL hoopFlag;


@end

@implementation PLGoalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"成就";
    self.mul = WIDTH / 320;
    _isSwitch = YES;
    _roopFlag = YES;
    _hoopFlag = YES;
    [self createHeaderView];
    [self createTargetView];
    [self createDefeatView];
    [self createCareerView];
    [self createButton];
}

#pragma mark - Create CustomView

- (void)createHeaderView {
    self.plGoalHeaderView = [[PLGoalHeaderView alloc] init];
    _plGoalHeaderView.frame = CGRectMake(0, 0, PLWIDTH, HEIGHT / 4);
    PLGoalHeaderModel *model = [[PLGoalHeaderModel alloc] init];

    _plGoalHeaderView.plGoalHeaderModel = model;
    [self.view addSubview:_plGoalHeaderView];
}

- (void)createTargetView {
    self.plTargetView = [[PLTargetView alloc] init];
    _plTargetView.alpha = 0.0;
    _plTargetView.frame = CGRectMake(0, 0, PLWIDTH, HEIGHT / 4);
    PLTargetModel *model = [[PLTargetModel alloc] init];
    _plTargetView.plTargetModel = model;
    [self.view addSubview:_plTargetView];
}

- (void)createDefeatView {
    self.plDefeatView = [[PLDefeatView alloc] init];
    _plDefeatView.alpha = 0.0;
    _plDefeatView.frame = CGRectMake(0, 0, PLWIDTH, HEIGHT / 4);
    PLDefeatModel *model = [[PLDefeatModel alloc] init];
    _plDefeatView.plDefeatModel = model;
    [self.view addSubview:_plDefeatView];
}

- (void)createCareerView {
    self.plCareerView = [[PLCareerView alloc] init];
    _plCareerView.alpha = 0.0;
    _plCareerView.frame = CGRectMake(0, 0, PLWIDTH, HEIGHT / 4);
    PLCareerModel *model = [[PLCareerModel alloc] init];
    _plCareerView.plCareerModel = model;
    [self.view addSubview:_plCareerView];
}

- (void)createButton {
    CGFloat margin = (WIDTH - 120) / 4;
    
    for (int i = 1; i <= 3; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 1000 + i;
        [button handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            [_plGoalHeaderView.layer removeAllAnimations];
            [_plDefeatView.layer removeAllAnimations];
            [_plCareerView.layer removeAllAnimations];
            [_plTargetView.layer removeAllAnimations];
            
            switch (button.tag) {
                case 1001:
                {
                    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut  animations:^{
                        
                        _plGoalHeaderView.alpha = 0.0f;
                        _plDefeatView.alpha = 0.0;
                        _plCareerView.alpha = 0.0;
                        
                    } completion:^(BOOL finished) {
                        if (finished) {
                            
                            [UIView animateWithDuration:0.3f animations:^{
                                
                                _plTargetView.alpha = 1.0f;
                            } completion:^(BOOL finished) {
                                
                            }];
                        }
                        
                        
                    }];
                    
                }
                    break;
                case 1002:
                {
                    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut  animations:^{
                        _plGoalHeaderView.alpha = 0.0f;
                        _plTargetView.alpha = 0.0;
                        _plCareerView.alpha = 0.0;
                    } completion:^(BOOL finished) {
                        if (finished) {
                            
                            [UIView animateWithDuration:0.3f animations:^{
                                _plDefeatView.alpha = 1.0;
                                
                            } completion:^(BOOL finished) {
                                
                            }];
                        }
                        
                    }];
                    
                }
                    break;
                case 1003:
                {
                    
                    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut  animations:^{
                        _plTargetView.alpha = 0.0f;
                        _plGoalHeaderView.alpha = 0.0f;
                        _plDefeatView.alpha = 0.0;
                        
                    } completion:^(BOOL finished) {
                        if (finished) {
                            
                            [UIView animateWithDuration:0.3f animations:^{
                                _plCareerView.alpha = 1.0f;
                                
                            } completion:^(BOOL finished) {
                                
                            }];
                        }
                        
                        
                        
                    }];
                    
                }
                    break;
                default:
                    break;
            }
        }];
        [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"goal%d", i]] forState:UIControlStateNormal];
        button.frame = CGRectMake(margin * i + (i - 1) * 40, HEIGHT - 49 - 64 - 70, 40, 40);
        [self.view addSubview:button];
    }
    
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"weight_empty_pic.png"]];
    _imageView.userInteractionEnabled = YES;
    _imageView.frame = CGRectMake((WIDTH - 155 * _mul * 0.7) / 2 , _plGoalHeaderView.frame.origin.y + _plGoalHeaderView.frame.size.height + 80, 155 * _mul * 0.7, 111 * _mul * 0.7);
    [self.view addSubview:_imageView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [tap addTarget:self action:@selector(tapAction:)];
    [_imageView addGestureRecognizer:tap];
    
    UIImage *hoopImage = [UIImage sd_animatedGIFNamed:@"dongdongjun_hula_hoop"];
    self.hoopImageView = [[UIImageView alloc] initWithImage:hoopImage];
    _hoopImageView.frame = CGRectMake(30, _imageView.frame.origin.y + _imageView.frame.size.height + 10, 82 * _mul * 0.7, 100 * _mul * 0.7);
    [self.view addSubview:_hoopImageView];
    
    
    UITapGestureRecognizer *tapHoop = [[UITapGestureRecognizer alloc] init];
    [tapHoop addTarget:self action:@selector(tapHoopAction:)];
    _hoopImageView.userInteractionEnabled = YES;
    [_hoopImageView addGestureRecognizer:tapHoop];

    UIImage *roopImage = [UIImage sd_animatedGIFNamed:@"dongdongjun_skip_rope"];
    self.roopImageView = [[UIImageView alloc] initWithImage:roopImage];
    _roopImageView.frame = CGRectMake(WIDTH - 30 - 82 * _mul * 0.7, _imageView.frame.origin.y + _imageView.frame.size.height + 10, 82 * _mul * 0.7, 100 * _mul * 0.7);
    [self.view addSubview:_roopImageView];
    
    UITapGestureRecognizer *tapRoop = [[UITapGestureRecognizer alloc] init];
    [tapRoop addTarget:self action:@selector(tapRoopAction:)];
    _roopImageView.userInteractionEnabled = YES;
    [_roopImageView addGestureRecognizer:tapRoop];
    
}

#pragma mark - tapAction

- (void)tapAction:(UITapGestureRecognizer *)tap {
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut  animations:^{
        _plDefeatView.alpha = 0.0f;
        _plTargetView.alpha = 0.0;
        _plCareerView.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.3f animations:^{
                
                _plGoalHeaderView.alpha = 1.0f;
                
            } completion:^(BOOL finished) {
                
            }];
            
        }
    }];
    
    
    if (_isSwitch == YES) {
        _isSwitch = NO;
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _hoopImageView.frame = CGRectMake(PLWIDTH - 30 - 82 * _mul * 0.7, _imageView.frame.origin.y + _imageView.frame.size.height + 10, 82 * _mul * 0.7, 100 * _mul * 0.7);
            _roopImageView.frame = CGRectMake(30, _imageView.frame.origin.y + _imageView.frame.size.height + 10, 82 * _mul * 0.7, 100 * _mul * 0.7);
            
        } completion:nil];
    }else {
        _isSwitch = YES;
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _hoopImageView.frame = CGRectMake(30, _imageView.frame.origin.y + _imageView.frame.size.height + 10, 82 * _mul * 0.7, 100 * _mul * 0.7);
            _roopImageView.frame = CGRectMake(PLWIDTH - 30 - 82 * _mul * 0.7, _imageView.frame.origin.y + _imageView.frame.size.height + 10, 82 * _mul * 0.7, 100 * _mul * 0.7);
            
        } completion:nil];
    }
}

- (void)tapHoopAction:(UITapGestureRecognizer *)tap {
    if (_hoopFlag == YES) {
        UIImage *roopImage = [UIImage sd_animatedGIFNamed:@"dongdongjun_skip_rope"];
        self.hoopImageView.image = roopImage;
        _hoopFlag = NO;
    }else {        
        UIImage *hoopImage = [UIImage sd_animatedGIFNamed:@"dongdongjun_hula_hoop"];
        self.hoopImageView.image = hoopImage;
        _hoopFlag = YES;
    }
}

- (void)tapRoopAction:(UITapGestureRecognizer *)tap {
    if (_roopFlag == YES) {
        UIImage *hoopImage = [UIImage sd_animatedGIFNamed:@"dongdongjun_hula_hoop"];
        self.roopImageView.image = hoopImage;
        _roopFlag = NO;

    }else {
        UIImage *roopImage = [UIImage sd_animatedGIFNamed:@"dongdongjun_skip_rope"];
        self.roopImageView.image = roopImage;
        _roopFlag = YES;
    }
}

@end
