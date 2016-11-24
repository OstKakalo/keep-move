//
//  PLSignCellObject.h
//  Move
//
//  Created by PhelanGeek on 2016/10/31.
//  Copyright © 2016年 PhelanGeek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PLSignCellObject : NSObject
<
    NSCoding
>

@property (nonatomic, copy) NSString *titleString;
@property (nonatomic, retain) NSArray *signArray;

@property (nonatomic, retain) UIImage *imageView;


- (instancetype)initWithTitle:(NSString *)titleString andImageView:(UIImage *)imageView;
+ (instancetype)plSignCellObjectWithTitle:(NSString *)titleString andImageView:(UIImage *)imageView;

@end
