//
//  PLHealthManager.h
//  Move
//
//  Created by PhelanGeek on 2016/10/21.
//  Copyright © 2016年 PhelanGeek. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PLHealthManagerDelegate <NSObject>

- (void)managerWithStepArray:(NSArray *)stepArray flag:(BOOL)flag;
- (void)managerWithDistancesArray:(NSArray *)distanceArray flag:(BOOL)flag;
- (void)managerWithStairsArray:(NSArray *)stairsArray flag:(BOOL)flag;

@end


@interface PLHealthManager : NSObject





- (void)getIphoneHealthData;

+ (id)shareInstance;




@property (nonatomic, assign) NSInteger days;
@property (nonatomic, strong) NSMutableArray *healthSteps;
@property (nonatomic, strong) NSMutableArray *healthDistances;
@property (nonatomic, strong) NSMutableArray *healthStairsClimbed;
@property (nonatomic, copy) void(^blockSteps)(NSArray *stepArray, BOOL flag);
@property (nonatomic, copy) void(^blockDistances)(NSArray *distancesArray, BOOL flag);
@property (nonatomic, copy) void(^blockStairs)(NSArray *stairsArray, BOOL flag);

@property (nonatomic, assign) id<PLHealthManagerDelegate>delegate;



@end
