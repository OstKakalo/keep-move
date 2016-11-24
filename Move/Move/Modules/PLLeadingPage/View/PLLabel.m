//
//  PLLabel.m
//  Move
//
//  Created by PhelanGeek on 2016/11/10.
//  Copyright © 2016年 PhelanGeek. All rights reserved.
//

#import "PLLabel.h"

@implementation PLLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.font = [UIFont fontWithName:@"Helvetica" size:23.0];
        self.textAlignment = NSTextAlignmentCenter;
        self.textColor = [UIColor whiteColor];
    }
    return self;
}
@end
