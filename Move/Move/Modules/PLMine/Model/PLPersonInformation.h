//
//  PLPersonInformation.h
//  Move
//
//  Created by 胡梦龙 on 16/10/21.
//  Copyright © 2016年 PhelanGeek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PLPersonInformation : NSObject

// id integer primary key autoincrement, gender text , brithday integer , height real , goalweight real

@property (nonatomic, copy) NSString *gender;
@property (nonatomic, assign) NSInteger brithday;
@property (nonatomic, assign) NSInteger height;
@property (nonatomic, assign) CGFloat goalWeight;
@property (nonatomic, assign) NSInteger goalStep;

@end
