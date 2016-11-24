//
//  PLSignViewController.m
//  Move
//
//  Created by PhelanGeek on 2016/10/19.
//  Copyright © 2016年 PhelanGeek. All rights reserved.
//

#import "PLSignViewController.h"
#import "PLRecommendGoalCell.h"
#import "PLAddGoalViewController.h"
#import "PLSignRecordViewController.h"
#import "PLSignCellObject.h"
#import "NSDate+Categories.h"

static NSString *const cellReusableIdentifier = @"cell";

@interface PLSignViewController ()
<
    UITableViewDelegate,
    UITableViewDataSource
>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSString *goalPath;
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, retain) NSMutableArray *recommendGoalArray;
@property (nonatomic, assign) BOOL flag;
@property (nonatomic, assign) BOOL tempFlag;
@property (nonatomic, copy) NSString *timeStamp;
@property (nonatomic, copy) NSString *currentDate;

@end

@implementation PLSignViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupPath];
    self.dataArray = [NSMutableArray array];
    NSArray *pArray = [NSKeyedUnarchiver unarchiveObjectWithFile:_goalPath];
    self.dataArray = [NSMutableArray arrayWithArray:pArray];
    if (_dataArray.count == 0) {
        _flag = NO;
        _tempFlag = YES;
        _recommendGoalArray = nil;
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        // 保存用户数据
        [userDef setBool:_flag forKey:@"notFirst"];
        [userDef synchronize];
    }
    [_tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _tempFlag = YES;
    self.navigationItem.title = @"目标";
    [self setupTableView];
    
}

#pragma mark - 设置tableView

- (void)setupTableView {
    // 设置footerView
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 150)];
    self.tableView.tableFooterView = footView;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"添加目标" forState:UIControlStateNormal];
    [button setTitleColor:PLYELLOW forState:UIControlStateNormal];
    button.layer.cornerRadius = 10.f;
    button.frame = CGRectMake((WIDTH - (WIDTH - 20)) / 2, 50, WIDTH - 20, 44);
    button.layer.borderColor = PLYELLOW.CGColor;
    button.layer.borderWidth = 1.f;
    button.backgroundColor = ColorWith51Black;
    [button handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        PLAddGoalViewController *plAddGoalVC = [[PLAddGoalViewController alloc] init];
        [self presentViewController:plAddGoalVC animated:YES completion:nil];
    }];
    [footView addSubview:button];
    // 设置tableView
    _tableView.backgroundColor = PLBLACK;
    _tableView.rowHeight = 80.f;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"PLRecommendGoalCell" bundle:nil] forCellReuseIdentifier:cellReusableIdentifier];
}

#pragma mark - 设置路径

- (void)setupPath {
    // 拼接路径
    NSArray *libraryArray = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryPath = [libraryArray firstObject];
    
    // 列表
    NSString *path = [libraryPath stringByAppendingString:@"/Preferences"];
    path = [path stringByAppendingString:@"/Goal.plist"];
    self.goalPath = path;
    _timeStamp = [NSDate getSystemTimeStringWithFormat:@"yyyy年MM月dd日 HH:mm"];
    _currentDate = [[_timeStamp componentsSeparatedByString:@" "] firstObject];

}

#pragma mark - 懒加载

- (NSMutableArray *)recommendGoalArray {
    if (_recommendGoalArray == nil) {
        self.recommendGoalArray = [NSMutableArray array];
        PLSignCellObject *sign0 = [PLSignCellObject plSignCellObjectWithTitle:@"8小时充足睡眠" andImageView:[UIImage imageNamed:@"stopwatch"]];
        PLSignCellObject *sign1 = [PLSignCellObject plSignCellObjectWithTitle:@"健身房报道" andImageView:[UIImage imageNamed:@"dumbbell"]];
        PLSignCellObject *sign2 = [PLSignCellObject plSignCellObjectWithTitle:@"拒绝啤酒" andImageView:[UIImage imageNamed:@"beer"]];
        PLSignCellObject *sign3 = [PLSignCellObject plSignCellObjectWithTitle:@"每日1万步" andImageView:[UIImage imageNamed:@"shoe-1"]];
        [_recommendGoalArray addObjectsFromArray:@[sign0, sign1, sign2, sign3]];
        
    }

    return _recommendGoalArray;
}

#pragma mark - UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_tempFlag == YES) {
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
       
        if (![userDef boolForKey:@"notFirst"]) {
            
            if (section == 0) {
                return self.recommendGoalArray.count;
            }else {
                return _dataArray.count;
            }
        }
        return _dataArray.count;
    }else{
        if (self.recommendGoalArray.count != 0) {
            if (section == 0) {
                return self.recommendGoalArray.count;
            }else {
                return _dataArray.count;
            }
        }
    }
    return _dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (_tempFlag == YES) {
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
       
        if (![userDef boolForKey:@"notFirst"]) {
        
            return 2;
        }
        return 1;
    }else{
        if (self.recommendGoalArray.count != 0) {
            return 2;
        }else{
            return 1;
        }
    }
    return 0;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (_tempFlag == YES) {
        
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
       
        if (![userDef boolForKey:@"notFirst"]) {

            if (section == 0) {
                return @"推荐目标";
            }else {
                return @"我的目标";
            }
            
            
        }
        return @"我的目标";
    }else{
        if (self.recommendGoalArray.count != 0) {
            if (section == 0) {
                return @"推荐目标";
            }else {
                return @"我的目标";
            }
        }else {
            return @"我的目标";
        }
    }
}

- (void)codeBlock:(PLSignCellObject *)sign andCell:(PLRecommendGoalCell *)cell {
    [self.dataArray addObject:sign];
    [NSKeyedArchiver archiveRootObject:_dataArray toFile:_goalPath];
    [cell removeFromSuperview];
    _tempFlag = NO;
    [_recommendGoalArray removeObject:sign];
    [_tableView reloadData];
    _flag = YES;
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    // 保存用户数据
    [userDef setBool:_flag forKey:@"notFirst"];
    [userDef synchronize];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 21)];
    view.backgroundColor = PLBLACK;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, 100, 21)];
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:15];
    [view addSubview:label];
    
    if (_tempFlag == YES) {
        
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
       
        if (![userDef boolForKey:@"notFirst"]) {
        
            if (section == 0) {
                label.text = @"推荐目标";
                return view;
            }else {
                label.text = @"我的目标";
                return view;
            }
            
        }
        label.text = @"我的目标";
        return view;
    }else {
        if (self.recommendGoalArray.count != 0) {
            if (section == 0) {
                label.text = @"推荐目标";
                return view;
            }else {
                label.text = @"我的目标";
                return view;
            }
        }
    }
    label.text = @"我的目标";
    return view;
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    
    if (_tempFlag == YES) {
        
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        
        if (![userDef boolForKey:@"notFirst"]) {
            
            if (indexPath.section == 0) {
                [_recommendGoalArray removeObjectAtIndex:indexPath.row];
                [_tableView reloadData];
            }
            else {
                if (editingStyle == UITableViewCellEditingStyleDelete) {
                    [_dataArray removeObjectAtIndex:indexPath.row];
                    [NSKeyedArchiver archiveRootObject:_dataArray toFile:_goalPath];
                    [_tableView reloadData];
                }
            }
            
        }else {
            if (editingStyle == UITableViewCellEditingStyleDelete) {
                [_dataArray removeObjectAtIndex:indexPath.row];
                [NSKeyedArchiver archiveRootObject:_dataArray toFile:_goalPath];
                [_tableView reloadData];
            }
        }
    }else {
        if (self.recommendGoalArray.count != 0) {
            if (indexPath.section == 0) {
                [_recommendGoalArray removeObjectAtIndex:indexPath.row];
                [_tableView reloadData];
            }else {
                if (editingStyle == UITableViewCellEditingStyleDelete) {
                    [_dataArray removeObjectAtIndex:indexPath.row];
                    [NSKeyedArchiver archiveRootObject:_dataArray toFile:_goalPath];
                    [_tableView reloadData];
                }
            }
        }else {
            if (editingStyle == UITableViewCellEditingStyleDelete) {
                [_dataArray removeObjectAtIndex:indexPath.row];
                [NSKeyedArchiver archiveRootObject:_dataArray toFile:_goalPath];
                [_tableView reloadData];
            }
        }
    }

    
    
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak PLRecommendGoalCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell = [[NSBundle mainBundle] loadNibNamed:@"PLRecommendGoalCell" owner:nil options:nil].lastObject;
    cell.backgroundColor = PLBLACK;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = [UIColor grayColor];
    if (_tempFlag == YES) {
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
       
        if (![userDef boolForKey:@"notFirst"]) {
            
            if (self.recommendGoalArray.count != 0) {
                
                if (indexPath.section == 0) {
                    cell.buttonTitle = @"添加";
                    PLSignCellObject *sign = _recommendGoalArray[indexPath.row];
                    cell.titleString = sign.titleString;
                    cell.iconImage = sign.imageView;
                    switch (indexPath.row) {
                        case 0:
                        {
                            cell.addButtonBlock = ^(UIButton *button) {
                            [self codeBlock:sign andCell:cell];
    
                            };
                            return cell;
                        }
                            break;
                        case 1:
                        {
                            
                            cell.addButtonBlock = ^(UIButton *button) {
                                [self codeBlock:sign andCell:cell];
                            };
                            return cell;
                        }
                            break;
                        case 2:
                        {
                            
                            cell.addButtonBlock = ^(UIButton *button) {
                            [self codeBlock:sign andCell:cell];
                            };
                            return cell;
                        }
                            break;
                        case 3:
                        {
                            
                            cell.addButtonBlock = ^(UIButton *button) {
                            [self codeBlock:sign andCell:cell];
                            };
                            return cell;
                        }
                            break;
                            
                        default:
                            break;
                    }
                }
            }

        }else {
            PLSignCellObject *sign = _dataArray[indexPath.row];
            cell.titleString = sign.titleString;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            NSString *temp = [[sign.signArray.lastObject componentsSeparatedByString:@" "] firstObject];
            if ([temp isEqualToString:_currentDate]) {
                cell.iconImage = [UIImage imageNamed:@"over"];
                cell.buttonTitle = @"已打卡";
                cell.addButton.userInteractionEnabled = NO;
                [cell.addButton setBackgroundColor:PLYELLOW];
                [cell.addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }else{
                cell.iconImage = [UIImage imageNamed:@"unover"];
                cell.buttonTitle = @"打卡";
                [cell.addButton setBackgroundColor:[UIColor grayColor]];
                [cell.addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
            cell.addButtonBlock = ^(UIButton *button) {
                cell.iconImage = [UIImage imageNamed:@"over"];
                cell.buttonTitle = @"已打卡";
                cell.addButton.userInteractionEnabled = NO;
                [cell.addButton setBackgroundColor:PLYELLOW];
                [cell.addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                NSString *time = [NSDate getSystemTimeStringWithFormat:@"yyyy年MM月dd日 HH:mm"];
                NSMutableArray *tempArray = [NSMutableArray arrayWithArray:sign.signArray];
                [tempArray addObject:time];
                sign.signArray = tempArray;
                [_dataArray replaceObjectAtIndex:indexPath.row withObject:sign];
                [NSKeyedArchiver archiveRootObject:_dataArray toFile:_goalPath];
            };
            return cell;
        }
    }else {
        if (self.recommendGoalArray.count != 0) {
            
            if (indexPath.section == 0) {
                cell.buttonTitle = @"添加";
                PLSignCellObject *sign = _recommendGoalArray[indexPath.row];
                cell.titleString = sign.titleString;
                cell.iconImage = sign.imageView;
                switch (indexPath.row) {
                    case 0:
                    {
                        cell.addButtonBlock = ^(UIButton *button) {
                        [self codeBlock:sign andCell:cell];
                            
                        };
                        return cell;
                    }
                        break;
                    case 1:
                    {
                        
                        cell.addButtonBlock = ^(UIButton *button) {
                        [self codeBlock:sign andCell:cell];
                        };
                        return cell;
                    }
                        break;
                    case 2:
                    {
                        
                        cell.addButtonBlock = ^(UIButton *button) {
                        [self codeBlock:sign andCell:cell];
                        };
                        return cell;
                    }
                        break;
                    case 3:
                    {
                        
                        cell.addButtonBlock = ^(UIButton *button) {
                        [self codeBlock:sign andCell:cell];
                        };
                        return cell;
                    }
                        break;
                        
                    default:
                        break;
                }
            }
        }
        PLSignCellObject *sign = _dataArray[indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.titleString = sign.titleString;
        NSString *temp = [[sign.signArray.lastObject componentsSeparatedByString:@" "] firstObject];
        
        if ([temp isEqualToString:_currentDate]) {
            cell.iconImage = [UIImage imageNamed:@"over"];
            cell.buttonTitle = @"已打卡";
            cell.addButton.userInteractionEnabled = NO;
            [cell.addButton setBackgroundColor:PLYELLOW];
            [cell.addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else{
            cell.iconImage = [UIImage imageNamed:@"unover"];
            cell.buttonTitle = @"打卡";
            [cell.addButton setBackgroundColor:[UIColor grayColor]];
            [cell.addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        cell.addButtonBlock = ^(UIButton *button) {
            cell.iconImage = [UIImage imageNamed:@"over"];
            cell.buttonTitle = @"已打卡";
            cell.addButton.userInteractionEnabled = NO;
            [cell.addButton setBackgroundColor:PLYELLOW];
            [cell.addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            NSString *time = [NSDate getSystemTimeStringWithFormat:@"yyyy年MM月dd日 HH:mm"];
            NSMutableArray *tempArray = [NSMutableArray arrayWithArray:sign.signArray];
            [tempArray addObject:time];
            sign.signArray = tempArray;
            [_dataArray replaceObjectAtIndex:indexPath.row withObject:sign];
            [NSKeyedArchiver archiveRootObject:_dataArray toFile:_goalPath];
        };
        return cell;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_tempFlag == YES) {
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
       
        if (![userDef boolForKey:@"notFirst"]) {
            
        }else{
            PLSignRecordViewController *recordVC = [[PLSignRecordViewController alloc] init];
            recordVC.index = indexPath.row;
            [self presentViewController:recordVC animated:YES completion:nil];
        }
    }
    else{
        if (self.recommendGoalArray.count != 0) {
            if (indexPath.section == 1) {
                PLSignRecordViewController *recordVC = [[PLSignRecordViewController alloc] init];
                recordVC.index = indexPath.row;
                [self presentViewController:recordVC animated:YES completion:nil];
            }
           
        }else{
            PLSignRecordViewController *recordVC = [[PLSignRecordViewController alloc] init];
            recordVC.index = indexPath.row;
            [self presentViewController:recordVC animated:YES completion:nil];
        }
    }
    
}

@end
