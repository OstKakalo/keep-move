//
//  PLLeadingPageController.m
//  Move
//
//  Created by PhelanGeek on 2016/11/10.
//  Copyright © 2016年 PhelanGeek. All rights reserved.
//

#import "PLLeadingPageController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "PLNewFeatureView.h"
#import "AppDelegate.h"
@interface PLLeadingPageController ()
<
    PLNewFeatrueViewDelegate
>

@property (nonatomic, strong) MPMoviePlayerController *moviePlayerController;
@property (nonatomic, strong) PLNewFeatureView *keepView;
// 判断是否第一次进入应用
@property (nonatomic, assign) BOOL flag;
@end

@implementation PLLeadingPageController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *moviePath = [[NSBundle mainBundle] pathForResource:@"keepMove" ofType:@"mp4"];
    
    self.moviePlayerController.contentURL = [[NSURL alloc] initFileURLWithPath:moviePath];
    
    [self.moviePlayerController play];
    [self.moviePlayerController.view bringSubviewToFront:self.keepView];
    
}

#pragma mark - NSNotificationCenter
- (void)playbackStateChanged
{
    MPMoviePlaybackState playbackState = [self.moviePlayerController playbackState];
    if (playbackState == MPMoviePlaybackStateStopped || playbackState == MPMoviePlaybackStatePaused) {
        [self.moviePlayerController play];
    }
}

#pragma mark - KeepNewFeatrueViewDelegate

// 登录
- (void)PLNewFeatrueView:(nullable PLNewFeatureView *)keepNewFeatrueView didLogin:(nullable UIButton *)loginButton {
    _flag = YES;
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    // 保存用户数据
    [userDef setBool:_flag forKey:@"notFirsts"];
    [userDef synchronize];
    
    // 切换到根视图控制器
    AppDelegate *appDelegate =  (AppDelegate*)[UIApplication sharedApplication].delegate;
    self.view.window.rootViewController = appDelegate.rootTabBarController;
}
// 注册
- (void)PLNewFeatrueView:(nullable PLNewFeatureView *)keepNewFeatrueView didRegister:(nullable UIButton *)registerButton {
    //NSLog(@"world");
}

#pragma mark - setter and getter
- (MPMoviePlayerController *)moviePlayerController
{
    if (!_moviePlayerController) {
        
        _moviePlayerController = [[MPMoviePlayerController alloc] init];
        
        [_moviePlayerController setShouldAutoplay:YES];
        
        _moviePlayerController.movieSourceType = MPMovieSourceTypeFile;
        [_moviePlayerController setFullscreen:YES];
        
        [_moviePlayerController setRepeatMode:MPMovieRepeatModeOne];
        _moviePlayerController.controlStyle = MPMovieControlStyleNone;
        _moviePlayerController.view.frame = [UIScreen mainScreen].bounds;
        
        [self.view addSubview:self.moviePlayerController.view];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackStateChanged) name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
        
    }
    return _moviePlayerController;
}

- (PLNewFeatureView *)keepView
{
    if (!_keepView) {
        _keepView = [[PLNewFeatureView alloc] init];
        _keepView.delegate = self;
        _keepView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        [self.moviePlayerController.view addSubview:_keepView];
    }
    return _keepView;
}

@end

