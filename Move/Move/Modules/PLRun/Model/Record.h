//
//  Record.h
//  Move
//
//  Created by PhelanGeek on 2016/11/5.
//  Copyright © 2016年 PhelanGeek. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;

@interface Record : NSObject

- (NSString *)title;

- (NSString *)subTitle;

- (void)addLocation:(CLLocation *)location;

- (NSInteger)numOfLocations;

- (CLLocation *)startLocation;

- (CLLocation *)endLocation;

- (CLLocationCoordinate2D *)coordinates;

- (CLLocationDistance)totalDistance;

- (NSTimeInterval)totalDuration;

@end
