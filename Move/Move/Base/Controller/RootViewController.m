//
//  RootViewController.m
//  GP_ITHome
//
//  Created by PhelanGeek on 16/10/2.
//  Copyright © 2016年 PhelanGeek. All rights reserved.
//

#import "RootViewController.h"
#import "PLRunNowViewController.h"
#import "PLAddRunRecordViewController.h"
#import "PLHWeightTableViewCell.h"
#import "PLSetInformationTableViewController.h"

#import <AssetsLibrary/AssetsLibrary.h>

@interface RootViewController ()

@property (nonatomic, retain) UIBarButtonItem *rightBarButton;
@property (nonatomic, assign) BOOL flag;

@end

@implementation RootViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //修改状态栏颜色为白色
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = PLBLACK;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = ColorWith51Black;
    self.navigationController.navigationBar.tintColor = PLYELLOW;
    _flag = YES;
    
    // leftBarButton
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"camera"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonAction:)];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    // rightBarButton
    self.rightBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"dd_creategroup@2x.png"] style:UIBarButtonItemStylePlain target:self action:@selector(rigthBarButtonAction:)];
    self.navigationItem.rightBarButtonItem = _rightBarButton;
    
}

#pragma mark - BarbuttonAction

- (void)leftBarButtonAction:(UIBarButtonItem *)leftBarButton {
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == ALAuthorizationStatusNotDetermined) {
        UIWindow *screenWindow = [[UIApplication sharedApplication] keyWindow];
        UIGraphicsBeginImageContextWithOptions(screenWindow.frame.size, NO, [UIScreen mainScreen].scale);
        [screenWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        UIImageWriteToSavedPhotosAlbum(image, nil, nil,nil);
        return;

    }
    if (author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied){
        //无权限 做一个友好的提示
        UIAlertView * alart = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请先设置允许Keep Move访问您的相册\n设置->隐私->照片" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alart show];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"截图已保存到本地相册" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            UIWindow *screenWindow = [[UIApplication sharedApplication] keyWindow];
            UIGraphicsBeginImageContextWithOptions(screenWindow.frame.size, NO, [UIScreen mainScreen].scale);
            [screenWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            UIImageWriteToSavedPhotosAlbum(image, nil, nil,nil);
            
        }];
        [alert addAction:sureAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)rigthBarButtonAction:(UIBarButtonItem *)rightBarButton {

    [FTPopOverMenu showFromSenderFrame:CGRectMake(PLWIDTH - 40, 20, 100, 40)
                              withMenu:@[@"GPS运动",@"录入运动",@"录入信息"]
                        imageNameArray:@[@"run",@"writeData",@"writeWeight"]
                             doneBlock:^(NSInteger selectedIndex) {
                                 _rightBarButton.image = [UIImage imageNamed:@"dd_creategroup@2x.png"];
                                 _flag = YES;
                                 
                                 switch (selectedIndex) {
                                     case 0:
                                     {
                                         // GPS运动
                                         PLRunNowViewController *runNowVC = [[PLRunNowViewController alloc] init];
                                         runNowVC.hidesBottomBarWhenPushed = YES;
                                         [self.navigationController pushViewController:runNowVC animated:YES];
                                     }
                                         break;
                                         
                                     case 1:
                                     {
                                         // 录入运动
                                         PLAddRunRecordViewController *runRecordVC = [[PLAddRunRecordViewController alloc] init];
                                         
                                         [self presentViewController:runRecordVC animated:YES completion:nil];
                                     }
                                         break;
                                         
                                     case 2:
                                     {
                                         // 录入体重
                                         self.tabBarController.selectedViewController = self.tabBarController.viewControllers[4];
                                         PLSetInformationTableViewController *informationVC = [PLSetInformationTableViewController pl_setInformationTableViewController];
                                         [(UINavigationController *)self.tabBarController.viewControllers[4] pushViewController:informationVC animated:YES];
                                         

                                     }
                                         break;
                                         
                                     default:
                                         break;
                                 }
                             } dismissBlock:^{
                                 _rightBarButton.image = [UIImage imageNamed:@"dd_creategroup@2x.png"];
                                 _flag = YES;
                             }];
    if (_flag == YES) {
        _rightBarButton.image = [UIImage imageNamed:@"close"];
        _flag = NO;
    }else {
        _rightBarButton.image = [UIImage imageNamed:@"dd_creategroup@2x.png"];
        _flag = YES;
    }
    
}

@end
