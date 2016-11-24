//
//  PLAddGoalViewController.m
//  Move
//
//  Created by PhelanGeek on 2016/10/31.
//  Copyright © 2016年 PhelanGeek. All rights reserved.
//

#import "PLAddGoalViewController.h"
#import "PLRecommendGoalCell.h"
#import "PLNavigationView.h"
#import "PLDetailGoalViewController.h"

static NSString *const cellIdentifier = @"cell";

@interface PLAddGoalViewController ()
<
    UITableViewDelegate,
    UITableViewDataSource
>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation PLAddGoalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航栏view
    PLNavigationView *plNavigationView = [[PLNavigationView alloc] init];
    plNavigationView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 64);
    plNavigationView.deleteButton.hidden = YES;
    plNavigationView.cancelButtonBlock = ^(UIButton *button){
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    [self.view addSubview:plNavigationView];
    // 设置tableView
    _tableView.backgroundColor = PLBLACK;
    _tableView.rowHeight = 80.f;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"PLRecommendGoalCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
}

#pragma mark - UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 5;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PLRecommendGoalCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    cell.backgroundColor = PLBLACK;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = [UIColor grayColor];
    cell.addButton.hidden = YES;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                cell.titleString = @"作息时间";
                cell.addButtonBlock = ^(UIButton *button) {
                    
                };
                return cell;
            }
                break;
            case 1:
            {
                cell.titleString = @"运动";
                cell.iconImage = [UIImage imageNamed:@"dumbbell"];
                cell.addButtonBlock = ^(UIButton *button) {
                    //NSLog(@"hello");
                };
                return cell;
            }
                break;
            case 2:
            {
                cell.titleString = @"健康饮食";
                cell.iconImage = [UIImage imageNamed:@"cheese"];
                cell.addButtonBlock = ^(UIButton *button) {
                    //NSLog(@"hello beer");
                };
                return cell;
            }
                break;
            case 3:
            {
                cell.titleString = @"跑步";
                cell.iconImage = [UIImage imageNamed:@"shoe-1"];
                cell.addButtonBlock = ^(UIButton *button) {
                    //NSLog(@"run");
                };
                return cell;
            }
                break;
            case 4:
            {
                cell.titleString = @"骑车";
                cell.iconImage = [UIImage imageNamed:@"bicycle"];
                cell.addButtonBlock = ^(UIButton *button) {
                    //NSLog(@"bicyle");
                };
                return cell;
            }
                break;
                
            default:
                break;
        }
    }
    return 0;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
            PLDetailGoalViewController *plDetailVC = [[PLDetailGoalViewController alloc] init];
            plDetailVC.type = 0;
            [self presentViewController:plDetailVC animated:YES completion:nil];
        }
            break;
        case 1:
        {
            PLDetailGoalViewController *plDetailVC = [[PLDetailGoalViewController alloc] init];
            plDetailVC.type = 1;
            [self presentViewController:plDetailVC animated:YES completion:nil];
        }
            break;
        case 2:
        {
            PLDetailGoalViewController *plDetailVC = [[PLDetailGoalViewController alloc] init];
            plDetailVC.type = 2;
            [self presentViewController:plDetailVC animated:YES completion:nil];
        }
            break;
        case 3:
        {
            PLDetailGoalViewController *plDetailVC = [[PLDetailGoalViewController alloc] init];
            plDetailVC.type = 3;
            [self presentViewController:plDetailVC animated:YES completion:nil];
        }
            break;
        case 4:
        {
            PLDetailGoalViewController *plDetailVC = [[PLDetailGoalViewController alloc] init];
            plDetailVC.type = 4;
            [self presentViewController:plDetailVC animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}

@end
