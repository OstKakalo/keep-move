//
//  PLInfoModel.h
//  Move
//
//  Created by PhelanGeek on 2016/11/5.
//  Copyright © 2016年 PhelanGeek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PLInfoModel : UIView
<
    NSCoding
>
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *km;
@property (nonatomic, copy) NSString *calorie;
@property (nonatomic, copy) NSString *rate;
@property (nonatomic, copy) NSString *stepCount;
@property (nonatomic, copy) NSString *date;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, retain) NSNumber *type;

@end
