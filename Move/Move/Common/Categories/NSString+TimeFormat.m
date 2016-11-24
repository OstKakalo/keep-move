//
//  NSString+TimeFormat.m
//  GP_ITHome
//
//  Created by PhelanGeek on 2016/10/5.
//  Copyright © 2016年 PhelanGeek. All rights reserved.
//

#import "NSString+TimeFormat.h"

@implementation NSString (TimeFormat)

- (NSString *)timeFormat {
    NSInteger secondInteger = [self integerValue];

    if (secondInteger < 60) {
        if (secondInteger < 10) {
            return [NSString stringWithFormat:@"00:0%ld", (long)secondInteger];
        }else {
            return [NSString stringWithFormat:@"00:%ld", (long)secondInteger];
        }
        
    }else if (secondInteger == 60) {
        return [NSString stringWithFormat:@"01:00"];
    }
    
    NSInteger minute = secondInteger / 60;
    NSInteger second = secondInteger - minute * 60;

    if (minute < 10) {
        if (second < 10) {
            return [NSString stringWithFormat:@"0%ld:0%ld", (long)minute, (long)second];
        }else {
            return [NSString stringWithFormat:@"0%ld:%ld", (long)minute, (long)second];
        }
    }else if (minute == 10) {
        if (second < 10) {
            return [NSString stringWithFormat:@"10:0%ld", (long)second];
        }else {
            return [NSString stringWithFormat:@"10:%ld", (long)second];
        }
    }
    if (second < 10) {
        [NSString stringWithFormat:@"%ld:0%ld", (long)minute,(long)second];
    }
    return [NSString stringWithFormat:@"%ld:%ld",(long)minute, (long)second];
   
}
@end
