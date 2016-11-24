//
//  PLTransferValueProtocol.h
//  Move
//
//  Created by PhelanGeek on 2016/11/8.
//  Copyright © 2016年 PhelanGeek. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PLTransferValueProtocol <NSObject>

- (void)tapViewDelegate;
- (void)tapStepCountDelegate;
- (void)tapKmDelegate;
- (void)tapCalorieDelegate;

@end
