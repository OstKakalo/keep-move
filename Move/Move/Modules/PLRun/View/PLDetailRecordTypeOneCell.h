//
//  PLDetailRecordTypeOneCell.h
//  Move
//
//  Created by PhelanGeek on 2016/11/8.
//  Copyright © 2016年 PhelanGeek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PLTransferValueProtocol.h"
@class PLInfoModel;

@interface PLDetailRecordTypeOneCell : UITableViewCell

@property (nonatomic, assign) id<PLTransferValueProtocol>delegate;
@property (nonatomic, copy) NSString *time;

@property (nonatomic, retain) PLInfoModel *infoModel;
@end
