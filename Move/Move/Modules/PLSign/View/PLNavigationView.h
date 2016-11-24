//
//  PLNavigationView.h
//  Move
//
//  Created by PhelanGeek on 2016/10/31.
//  Copyright © 2016年 PhelanGeek. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CancelButtonBlock)(UIButton *);

@interface PLNavigationView : UIView

@property (nonatomic, copy) CancelButtonBlock cancelButtonBlock;
@property (nonatomic, copy) CancelButtonBlock deleteButtonBlock;
@property (nonatomic, copy) NSString *titleString;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@end
