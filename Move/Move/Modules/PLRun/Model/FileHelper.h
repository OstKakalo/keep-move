//
//  FileHelper.h
//  Move
//
//  Created by PhelanGeek on 2016/11/5.
//  Copyright © 2016年 PhelanGeek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileHelper : NSObject

+ (NSString *)filePathWithName:(NSString *)name;

+ (NSMutableArray *)recordsArray;

+ (BOOL)deleteFile:(NSString *)filename;

@end
