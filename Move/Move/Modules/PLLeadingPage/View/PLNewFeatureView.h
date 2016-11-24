//
//  PLNewFeatureView.h
//  Move
//
//  Created by PhelanGeek on 2016/11/10.
//  Copyright © 2016年 PhelanGeek. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PLNewFeatureView;


@protocol PLNewFeatrueViewDelegate <NSObject>

// 登录
- (void)PLNewFeatrueView:(nullable PLNewFeatureView *)keepNewFeatrueView didLogin:(nullable UIButton *)loginButton;
// 注册
- (void)PLNewFeatrueView:(nullable PLNewFeatureView *)keepNewFeatrueView didRegister:(nullable UIButton *)registerButton;

@end

@interface PLNewFeatureView : UIView

@property (nonatomic, weak, nullable) id <PLNewFeatrueViewDelegate> delegate;

@end
