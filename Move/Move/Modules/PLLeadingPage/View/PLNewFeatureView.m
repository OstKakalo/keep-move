//
//  PLNewFeatureView.m
//  Move
//
//  Created by PhelanGeek on 2016/11/10.
//  Copyright © 2016年 PhelanGeek. All rights reserved.
//

#import "PLNewFeatureView.h"
#import "PLScrollView.h"

@interface PLNewFeatureView ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *moveImageView;

@property (nonatomic, strong) UIButton *registerButton;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) PLScrollView *adScrollView;
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, assign) CGFloat mul;

@end

@implementation PLNewFeatureView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.mul = WIDTH / 320;
        [self addSubview:self.imageView];
        [self addSubview:self.moveImageView];
        
//        [self addSubview:self.registerButton];
        
        [self addSubview:self.loginButton];
        [self addSubview:self.adScrollView];
        
        self.adScrollView.titles = @[@"全程记录你的运动数据",@"规范你的训练过程",@"陪伴你迈出跑步的第一步",@"分享汗水后你的性感"];
        
        self.pageControl.numberOfPages = self.adScrollView.titles.count;
    }
    return self;
}

- (void)registerClick:(UIButton *)registerButton
{
    if ([self.delegate respondsToSelector:@selector(PLNewFeatrueView:didRegister:)]) {
        [self.delegate PLNewFeatrueView:self didRegister:registerButton];
    }
}

- (void)login:(UIButton *)loginButton
{
    if ([self.delegate respondsToSelector:@selector(PLNewFeatrueView:didLogin:)]) {
        [self.delegate PLNewFeatrueView:self didLogin:loginButton];
    }
}

#pragma mark - setter and getter
- (UIImageView *)imageView
{
    if (!_imageView) {
        UIImage *image = [UIImage imageNamed:@"keep"];
        _imageView = [[UIImageView alloc] initWithImage:image];
        CGFloat X = ([UIScreen mainScreen].bounds.size.width - image.size.width) * 0.5;
        CGFloat Y = [UIScreen mainScreen].bounds.size.height * 0.3;
        _imageView.frame = CGRectMake(X, Y, image.size.width, image.size.height);
    
    }
    return _imageView;
}

- (UIImageView *)moveImageView {
    if (!_moveImageView) {
        UIImage *moveImage = [UIImage imageNamed:@"move"];
        _moveImageView = [[UIImageView alloc] initWithImage:moveImage];
        
        CGFloat X = ([UIScreen mainScreen].bounds.size.width - moveImage.size.width * 0.5) * 0.5;
        CGFloat Y = _imageView.bounds.origin.y + _imageView.bounds.size.height + 180 * _mul;
        _moveImageView.frame = CGRectMake(X, Y, moveImage.size.width * 0.5, moveImage.size.height * 0.5);

    }
    return _moveImageView;
}

- (UIButton *)registerButton
{
    if (!_registerButton) {
        _registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat W = [UIScreen mainScreen].bounds.size.width * 0.75;
        CGFloat H = 50;
        CGFloat X = ([UIScreen mainScreen].bounds.size.width - W) * 0.5;
        CGFloat Y = [UIScreen mainScreen].bounds.size.height - H - 15;
        _registerButton.frame = CGRectMake(X, Y, W, H);
        [_registerButton setTitle:@"注册" forState:UIControlStateNormal];
        [_registerButton setBackgroundColor:[UIColor blackColor]];
        _registerButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [_registerButton addTarget:self action:@selector(registerClick:) forControlEvents:UIControlEventTouchUpInside];
        _registerButton.layer.cornerRadius = 3.0f;
        _registerButton.alpha = 0.4f;
    }
    return _registerButton;
}

- (UIButton *)loginButton
{
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat W = [UIScreen mainScreen].bounds.size.width * 0.5;
        CGFloat H = 50;
        CGFloat X = ([UIScreen mainScreen].bounds.size.width - W) * 0.5;
        CGFloat Y = [UIScreen mainScreen].bounds.size.height - H - 15;
        _loginButton.frame = CGRectMake(X, Y, W, H);
        [_loginButton setTitle:@"Let's move" forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_loginButton setBackgroundColor:[UIColor whiteColor]];
        [_loginButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
        _loginButton.titleLabel.font = [UIFont systemFontOfSize:18];
        _loginButton.layer.cornerRadius = 3.0f;
        _loginButton.alpha = 0.4f;
    }
    return _loginButton;
}

- (PLScrollView *)adScrollView
{
    if (!_adScrollView) {
        _adScrollView = [[PLScrollView alloc] init];
        _adScrollView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 105);
        _adScrollView.pageControl = self.pageControl;
    }
    return _adScrollView;
}

- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        CGFloat W = self.adScrollView.titles.count * 5;
        _pageControl.frame = CGRectMake(0, CGRectGetMaxY(self.adScrollView.frame) + 10, W, 10);
        _pageControl.currentPage = 0;
        [self addSubview:_pageControl];
    }
    return _pageControl;
}

@end

