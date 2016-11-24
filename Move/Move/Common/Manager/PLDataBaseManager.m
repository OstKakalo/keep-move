//
//  PLDataBaseManager.m
//  Move
//
//  Created by 胡梦龙 on 16/10/20.
//  Copyright © 2016年 PhelanGeek. All rights reserved.
//

#import "PLDataBaseManager.h"
#import "PLHistoryInformation.h"

#import "PLPersonInformation.h"
@interface PLDataBaseManager ()

@property (nonatomic, strong) FMDatabaseQueue *dbQueue;

@property (nonatomic, assign) BOOL flag1;
@property (nonatomic, assign) BOOL flag2;






@end

@implementation PLDataBaseManager
+ (PLDataBaseManager *)shareManager {
    static PLDataBaseManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[PLDataBaseManager alloc] init];
    }) ;
    
    return manager;

}

- (BOOL)createPersonTable {
    _flag1 = NO;
    _flag2 = NO;

    
    
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *sqlFilePath = [path stringByAppendingPathComponent:@"move.sqlite"];
    
    
    self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:sqlFilePath];
    

    
    [_dbQueue inDatabase:^(FMDatabase *db) {
        
        BOOL success = [db executeUpdate:@"create table if not exists Person (id integer primary key autoincrement, gender text , brithday integer , height integer , goalweight real, goalstep real)"];
        
        if (success) {
            //NSLog(@"创建表成功");
            _flag1 = YES;
        } else {
            //NSLog(@"创建表失败");
        }
        
    }];
    
    [_dbQueue inDatabase:^(FMDatabase *db) {
        
        BOOL success = [db executeUpdate:@"create table if not exists Record (id integer primary key autoincrement, time text , weight real)"];
        
        if (success) {
            //NSLog(@"创建表成功");
            _flag2 = YES;
        } else {
            //NSLog(@"创建表失败");
        }
        
    }];
    
    if (_flag1 && _flag2) {
        return YES;
    }
    return NO;

}

- (BOOL)insertPerson:(PLPersonInformation *)person {
    _flag1 = NO;
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        
        BOOL success = [db executeUpdate:[NSString stringWithFormat:@"insert into Person values (null,'%@','%ld', '%ld','%f','%ld')", person.gender, person.brithday, person.height, person.goalWeight, person.goalStep]];
        
        if (success) {
            //NSLog(@"插入成功");
            _flag1 = YES;
            
        } else {
            //NSLog(@"插入失败");
        }
        
        
    }];
    return _flag1;
    
}

/*
 PLPersonInformation *person = [[PLPersonInformation alloc] init];
 person.gender = @"男";
 person.brithday = 1994;
 person.height = 1.53;
 person.goalWeight = 66.f;
 person.goalStep = 10000.f;
 
 [[PLDataBaseManager shareManager] insertPerson:person];
 */

- (BOOL)updatePerson:(PLPersonInformation *)person {
    _flag1 = NO;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
//         BOOL success = [db executeUpdate:@"create table if not exists Person (id integer primary key autoincrement, gender text , brithday integer , height real , goalweight real, goalstep real)"];
        BOOL success1 = [db executeUpdate:[NSString stringWithFormat:@"update Person set gender = '%@' ", person.gender]];
        BOOL success2 = [db executeUpdate:[NSString stringWithFormat:@"update Person set brithday = '%ld' ", person.brithday]];
        BOOL success3 = [db executeUpdate:[NSString stringWithFormat:@"update Person set height = '%ld' ", person.height]];
        BOOL success4 = [db executeUpdate:[NSString stringWithFormat:@"update Person set goalweight = '%f' ", person.goalWeight]];
        BOOL success5 = [db executeUpdate:[NSString stringWithFormat:@"update Person set goalstep = '%ld' ", person.goalStep]];
        if (success1&&success2&&success3&&success4&&success5) {
            //NSLog(@"修改成功");
            _flag1 = YES;
        } else {
            //NSLog(@"修改失败");
        }
        

    }];

    return _flag1;
}
- (PLPersonInformation *)personInformation {
    
    PLPersonInformation *__block person = [[PLPersonInformation alloc] init];
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:@"SELECT * FROM Person"];
        while ([result next]) {
            person.gender = [result stringForColumnIndex:1];
            person.brithday = [result intForColumnIndex:2];
            person.height = [result doubleForColumnIndex:3];
            person.goalWeight = [result doubleForColumnIndex:4];
            person.goalStep = [result intForColumnIndex:5];
        }
        
    }];
    return person;
    

}

- (BOOL)insertHistoryRecord:(PLHistoryInformation *)history {
    _flag1 = NO;
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        
        BOOL success = [db executeUpdate:[NSString stringWithFormat:@"insert into Record values (null,'%@','%f')",history.time, history.weight]];
        
        if (success) {
            //NSLog(@"插入成功");
            _flag1 = YES;
            
        } else {
            //NSLog(@"插入失败");
        }
        
        
    }];
    return _flag1;

}


- (CGFloat)currentWeight {

    
    CGFloat __block  weight = 0.f;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:@"SELECT weight FROM Record"];
        
        while ([result next]) {
            
            weight = [result doubleForColumnIndex:0];
            
            
        }
    }];
    
    return weight;

}


//CGFloat f = [[PLDataBaseManager shareManager] currentWeight];

- (NSArray *)ArrayWithRecordWeight {

    NSString __block *time = @"";
    CGFloat __block weight = 0.f;
    NSMutableArray *__block historyArray = [NSMutableArray array];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:@"SELECT * FROM Record"];
        
        while ([result next]) {
            
            time = [result stringForColumnIndex:1];
            weight = [result doubleForColumnIndex:2];
            
            PLHistoryInformation *history = [[PLHistoryInformation alloc] init];
            history.time = time;
            history.weight = weight;
            [historyArray addObject:history];
        }
    }];
    
    return historyArray;
}

//NSArray *array = [[PLDataBaseManager shareManager] ArrayWithRecordWeight];

- (BOOL)clearRecord {

    _flag1 = NO;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        
        BOOL success = [db executeUpdate:@"DELETE FROM Record"];
        
        if (success) {
            _flag1 = YES;
        } else {
            //NSLog(@"失败");
        }
    }];

    return _flag1;
}

// BOOL flag = [[PLDataBaseManager shareManager] clearRecord];

- (CGFloat)goalWeight {
    CGFloat __block goalWeight = 0;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *result= [db executeQuery:@"SELECT goalweight FROM Person"];
        while ([result next]) {
            goalWeight = [result doubleForColumnIndex:0];
        }
        
    }];
    return goalWeight;

}

@end
