//
//  PLSignCellObject.m
//  Move
//
//  Created by PhelanGeek on 2016/10/31.
//  Copyright © 2016年 PhelanGeek. All rights reserved.
//

#import "PLSignCellObject.h"

@implementation PLSignCellObject

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_titleString forKey:@"titleString"];
    [aCoder encodeObject:_signArray forKey:@"signArray"];

}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.titleString = [aDecoder decodeObjectForKey:@"titleString"];
        self.signArray = [aDecoder decodeObjectForKey:@"signArray"];
    }
    return self;
}


- (instancetype)initWithTitle:(NSString *)titleString andImageView:(UIImage *)imageView {
    self = [super init];
    if (self) {
        _titleString = titleString;
        _imageView = imageView;
    }
    return self;
}

+ (instancetype)plSignCellObjectWithTitle:(NSString *)titleString andImageView:(UIImage *)imageView {
    return [[self alloc] initWithTitle:titleString andImageView:imageView];
}
@end
