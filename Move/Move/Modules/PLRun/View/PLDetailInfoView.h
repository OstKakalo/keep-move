//
//  PLDetailInfoView.h
//  Move
//
//  Created by PhelanGeek on 2016/11/3.
//  Copyright © 2016年 PhelanGeek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PLDetailInfoView : UIView

@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *km;
@property (nonatomic, copy) NSString *calorie;
@property (nonatomic, copy) NSString *rate;
@property (nonatomic, copy) NSString *stepCount;

@property (weak, nonatomic) IBOutlet UILabel *rateTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *speedRate;

@end
