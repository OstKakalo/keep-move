//
//  PLXHealthManager.m
//  Move
//
//  Created by dllo on 2016/11/7.
//  Copyright © 2016年 PhelanGeek. All rights reserved.
//

#import "PLXHealthManager.h"

#define HKVersion [[[UIDevice currentDevice] systemVersion] doubleValue]
#define CustomHealthErrorDomain @"com.sdqt.healthError"

@implementation PLXHealthManager
// 创建单例
+ (id)shareInstance {
    static id manager ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[[self class] alloc] init];
    });
    return manager;
}

// 检查是否支持
- (void)authorizeHealthKit:(void(^)(BOOL success, NSError *error))compltion {
    if(HKVersion >= 8.0)
    {
        if (![HKHealthStore isHealthDataAvailable]) {
            NSError *error = [NSError errorWithDomain: @"com.raywenderlich.tutorials.healthkit" code: 2 userInfo: [NSDictionary dictionaryWithObject:@"HealthKit is not available in this Device"                                                                      forKey:NSLocalizedDescriptionKey]];
            if (compltion != nil) {
                compltion(false, error);
            }
            return;
        }
        if ([HKHealthStore isHealthDataAvailable]) {
            if(self.healthStore == nil)
                self.healthStore = [[HKHealthStore alloc] init];
            /*
             组装需要读写的数据类型
             */
//            NSSet *writeDataTypes = [self dataTypesToWrite];
            NSSet *readDataTypes = [self dataTypesRead];
            
            /*
             注册需要读写的数据类型，也可以在“健康”APP中重新修改
             */
            [self.healthStore requestAuthorizationToShareTypes:nil readTypes:readDataTypes completion:^(BOOL success, NSError *error) {
                
                if (compltion != nil) {
                    //NSLog(@"error->%@", error.localizedDescription);
                    compltion (success, error);
                }
            }];
        }
    }
    else {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"iOS 系统低于8.0"                                                                      forKey:NSLocalizedDescriptionKey];
        NSError *aError = [NSError errorWithDomain:CustomHealthErrorDomain code:0 userInfo:userInfo];
        compltion(0,aError);
    }
}

- (NSSet *)dataTypesToWrite {
    HKQuantityType *heightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
    HKQuantityType *weightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    HKQuantityType *temperatureType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyTemperature];
    HKQuantityType *activeEnergyType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
    
    return [NSSet setWithObjects:heightType, temperatureType, weightType,activeEnergyType,nil];
}

- (NSSet *)dataTypesRead {
    HKQuantityType *stepCountType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    HKQuantityType *distance = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
    HKQuantityType *activeEnergyType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
    HKQuantityType *stairs = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierFlightsClimbed];
    
    return [NSSet setWithObjects:stepCountType, distance, activeEnergyType, stairs,nil];
}

// 当天时间段
- (NSPredicate *)predicateForSamplesToday {
    NSDate *endDate = self.startDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:endDate];
    [components setHour:24];
    [components setMinute:0];
    [components setSecond:0];
    NSDate *date = [calendar dateFromComponents:components];
    
    NSDate *startDate = [NSDate dateWithTimeInterval:-(_days) * 24 * 60 * 60 sinceDate:date];
    //NSLog(@"%@", startDate);
    //NSLog(@"%@", endDate);
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionNone];
    return predicate;
}

// 获取每段时间的步数
- (void)getStepCount:(void (^)(double, NSArray *, NSError *))completion {
    
    HKQuantityType *stepType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    NSSortDescriptor *timeSortDescriptor = [[NSSortDescriptor alloc] initWithKey:HKSampleSortIdentifierStartDate ascending:NO];
    
    HKSampleQuery *query = [[HKSampleQuery alloc] initWithSampleType:stepType predicate:[self predicateForSamplesToday] limit:HKObjectQueryNoLimit sortDescriptors:@[timeSortDescriptor] resultsHandler:^(HKSampleQuery *query, NSArray *results, NSError *error) {
        if(error)
        {
            completion(0, @[], error);
        }
        else
        {
            double allSteps = 0;
            NSMutableArray *array = [NSMutableArray array];
            for(HKQuantitySample *quantitySample in results)
            {
                double totleSteps = [quantitySample.quantity doubleValueForUnit:[HKUnit countUnit]];
                NSString *stepString = [NSString stringWithFormat:@"%lf", totleSteps];
                NSDate *time = quantitySample.startDate;
                NSDate *time2 = quantitySample.endDate;
                NSString *duration = [NSString stringWithFormat:@"%f", [time2 timeIntervalSinceDate:time]];
                NSDictionary *dic = @{@"dateTime" : time, @"value" : stepString, @"duration" : duration};
                [array addObject:dic];
                allSteps = allSteps + totleSteps;
            }
            if (_isDay == YES) {
                completion(allSteps, [[[self getArrayByDay:array] reverseObjectEnumerator] allObjects], error);
            } else {
                completion(allSteps, array, error);
            }
        }
    }];
    
    [self.healthStore executeQuery:query];
}

- (NSArray *)getArrayByDay:(NSArray *)array {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[NSDate date]];
    [components setHour:24];
    [components setMinute:0];
    [components setSecond:0];
    NSDate *date2 = [calendar dateFromComponents:components];
    NSMutableArray *array2 = [NSMutableArray array];
    NSInteger sum = 0;
    NSInteger b = 24 * 60 * 60;
    NSDate *date = [[NSDate alloc] init];
    for (int i = 0; i < array.count; i++) {
        NSDictionary *dic = array[i];
        NSDate *date1 = [dic valueForKey:@"dateTime"];
        NSString *string = [dic valueForKey:@"value"];
        double a = [string doubleValue];
        NSTimeInterval between = [date2 timeIntervalSinceDate:date1];
        if (between < b && i < array.count - 1) {
            sum = sum + a;
            date = date1;
        }else {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSString *timeString = [formatter stringFromDate:date];
            NSDictionary *dic2 = @{@"dateTime" : timeString, @"value" : [NSString stringWithFormat:@"%ld", sum]};
            [array2 addObject:dic2];
            sum = 0;
            sum = sum + a;
            b = b + 24 * 60 * 60;
        }
    }
    return array2;
}


//获取公里数
- (void)getDistance:(void (^)(double, NSArray *, NSError *))completion {
    HKQuantityType *distanceType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
    NSSortDescriptor *timeSortDescriptor = [[NSSortDescriptor alloc] initWithKey:HKSampleSortIdentifierEndDate ascending:NO];
    HKSampleQuery *query = [[HKSampleQuery alloc] initWithSampleType:distanceType predicate:[self predicateForSamplesToday] limit:HKObjectQueryNoLimit sortDescriptors:@[timeSortDescriptor] resultsHandler:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {
        
        if(error)
        {
            completion(0, @[], error);
        }
        else
        {
            double totleSteps = 0;
            NSMutableArray *array = [NSMutableArray array];
            for(HKQuantitySample *quantitySample in results)
            {
                HKQuantity *quantity = quantitySample.quantity;
                HKUnit *distanceUnit = [HKUnit meterUnitWithMetricPrefix:HKMetricPrefixKilo];
                double usersHeight = [quantity doubleValueForUnit:distanceUnit];
                totleSteps += usersHeight;
            }
            completion(totleSteps, array, error);
        }
    }];
    [self.healthStore executeQuery:query];
}

- (void)getKilocalorie:(void (^)(double, NSArray *, NSError *))completion {
    
}



@end
