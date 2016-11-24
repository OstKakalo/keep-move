
//
//  FileHelper.m
//  Move
//
//  Created by PhelanGeek on 2016/11/5.
//  Copyright © 2016年 PhelanGeek. All rights reserved.
//

#import "FileHelper.h"
#import "Record.h"

@implementation FileHelper

+ (NSMutableArray *)recordsArray
{
    NSString *path = [FileHelper baseDir];
    
    NSError *error = nil;
    NSArray *fileArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:&error];
    
    if (error!=nil)
    {
        return nil;
    }
    else
    {
        NSMutableArray *records = [[NSMutableArray alloc] init];
        for (NSString *fileName in fileArray)
        {
            NSString *recordPath = [path stringByAppendingPathComponent:fileName];
            Record *record = [NSKeyedUnarchiver unarchiveObjectWithFile:recordPath];
            [records addObject:record];
        }
        return [NSMutableArray arrayWithArray:records];
    }
}

+ (NSString *)baseDir
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    path = [path stringByAppendingPathComponent:@"pathRecords"];
    
    return path;
}

+ (NSString *)filePathWithName:(NSString *)name
{
    NSString *path = [FileHelper baseDir];
    
    BOOL pathSuccess = [[NSFileManager defaultManager] fileExistsAtPath:path];
    
    if (! pathSuccess)
    {
        pathSuccess = [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *documentPath = [path stringByAppendingPathComponent:name];
    //NSLog(@"documentPath : %@", documentPath);
    return documentPath;
}

+ (BOOL)deleteFile:(NSString *)filename
{
    NSString *path = [FileHelper filePathWithName:filename];
    
    NSError *error = nil;
    BOOL success = [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    if (error != nil)
    {
        //NSLog(@"%@",error);
    }
    
    return success;
}



@end
