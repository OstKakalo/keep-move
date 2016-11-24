//
//  PLHistoryTableViewCell.m
//  Move
//
//  Created by 胡梦龙 on 16/10/31.
//  Copyright © 2016年 PhelanGeek. All rights reserved.
//

#import "PLHistoryTableViewCell.h"
#import "PLHistoryInformation.h"

@interface PLHistoryTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *weightLabel;


@end

@implementation PLHistoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
    
}

- (void)setHistory:(PLHistoryInformation *)history {
    _history = history;
    self.timeLabel.text = history.time;
    self.weightLabel.text = [NSString stringWithFormat:@"%.1fkg", history.weight];

}


@end
