//
//  PLXHealthManager.h
//  Move
//
//  Created by dllo on 2016/11/7.
//  Copyright © 2016年 PhelanGeek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HealthKit/HealthKit.h>
#import <UIKit/UIDevice.h>


@interface PLXHealthManager : NSObject

@property (nonatomic, strong) HKHealthStore *healthStore;
@property (nonatomic, assign) NSInteger days;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, assign) BOOL isDay;

+ (id)shareInstance;

- (void)authorizeHealthKit:(void(^)(BOOL success, NSError *error))compltion;

- (void)getStepCount:(void(^)(double value, NSArray *array,NSError *error))completion;

- (void)getDistance:(void(^)(double value, NSArray *array,NSError *error))completion;

- (void)getKilocalorie:(void(^)(double value, NSArray *array,NSError *error))completion;


@end
