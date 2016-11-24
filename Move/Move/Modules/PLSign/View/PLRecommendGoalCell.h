//
//  PLRecommendGoalCell.h
//  Move
//
//  Created by PhelanGeek on 2016/10/31.
//  Copyright © 2016年 PhelanGeek. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^AddButtonBlock)(UIButton *);

@interface PLRecommendGoalCell : UITableViewCell

@property (nonatomic, retain) UIImage *iconImage;
@property (nonatomic, copy) NSString *titleString;
@property (nonatomic, copy) NSString *buttonTitle;
@property (nonatomic, copy) AddButtonBlock addButtonBlock;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@end
