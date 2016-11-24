//
//  PLDetailGoalViewController.m
//  Move
//
//  Created by PhelanGeek on 2016/10/31.
//  Copyright © 2016年 PhelanGeek. All rights reserved.
//

#import "PLDetailGoalViewController.h"
#import "PLRecommendGoalCell.h"
#import "PLNavigationView.h"
#import "PLSignCellObject.h"

static NSString *const cellDetailIdentifier = @"cell";

@interface PLDetailGoalViewController ()
<
    UITableViewDelegate,
    UITableViewDelegate
>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, copy) NSString *goalPath;
@property (nonatomic, retain) NSMutableArray *titleStringArray;
@property (nonatomic, assign) BOOL open;
@property (nonatomic, assign) BOOL flag;

@end

@implementation PLDetailGoalViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupPath];

    self.dataArray = [NSMutableArray array];
    self.titleStringArray = [NSMutableArray array];
    
    NSArray *pArray = [NSKeyedUnarchiver unarchiveObjectWithFile:_goalPath];
    self.dataArray = [NSMutableArray arrayWithArray:pArray];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationView];
    _open = YES;
}

- (void)setupPath {
    // 拼接路径
    NSArray *libraryArray = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryPath = [libraryArray firstObject];
    
    // 列表
    NSString *path = [libraryPath stringByAppendingString:@"/Preferences"];
    path = [path stringByAppendingString:@"/Goal.plist"];
    self.goalPath = path;

}

- (void)setupNavigationView {
    // 设置导航栏view
    PLNavigationView *plNavigationView = [[PLNavigationView alloc] init];
    plNavigationView.deleteButton.hidden = YES;
    switch (_type) {
        case 0:
        {
            plNavigationView.titleString = @"作息时间";
        }
            break;
        case 1:
        {
            plNavigationView.titleString = @"运动";
        }
            break;
        case 2:
        {
            plNavigationView.titleString = @"健康饮食";
        }
            break;
        case 3:
        {
            plNavigationView.titleString = @"跑步";
        }
            break;
        case 4:
        {
            plNavigationView.titleString = @"骑车";
        }
            break;
        default:
            break;
    }
    
    plNavigationView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 64);
    plNavigationView.cancelButtonBlock = ^(UIButton *button){
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    [self.view addSubview:plNavigationView];
    // 设置tableView
    _tableView.backgroundColor = PLBLACK;
    _tableView.rowHeight = 80.f;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"PLRecommendGoalCell" bundle:nil] forCellReuseIdentifier:cellDetailIdentifier];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (_type) {
        case 0:
        {
            return 4;
        }
            break;
        case 1:
        {
            return 5;
        }
            break;
        case 2:
        {
            return 7;
        }
            break;
        case 3:
        {
            return 4;
        }
            break;
        case 4:
        {
            return 4;
        }
            break;
        default:
            break;
    }
    return 0;
    
}

- (void)Added:(PLRecommendGoalCell*)cell andTemp:(NSString *)temp {
    [cell.addButton setTitle:@"已添加" forState:UIControlStateNormal];
    [cell.addButton setBackgroundColor:[UIColor grayColor]];
    [cell.addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    PLSignCellObject *goal = [[PLSignCellObject alloc] init];
    goal.titleString = temp;
    [self.dataArray addObject:goal];
    [NSKeyedArchiver archiveRootObject:_dataArray toFile:_goalPath];
    
    _flag = YES;
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    // 保存用户数据
    [userDef setBool:_flag forKey:@"notFirst"];
    [userDef synchronize];
}

- (void)unAdd:(PLRecommendGoalCell*)cell andTemp:(NSString *)temp {
    [cell.addButton setTitle:@"添加" forState:UIControlStateNormal];
    [cell.addButton setBackgroundColor:PLYELLOW];
    [cell.addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    NSString *string = temp;
    NSMutableArray *array = [NSMutableArray arrayWithArray:_dataArray];
    for (PLSignCellObject *sign in array) {
        if ([sign.titleString isEqualToString:string]) {
            [_dataArray removeObject:sign];
        }
    }
    [NSKeyedArchiver archiveRootObject:_dataArray toFile:_goalPath];
}

- (void)codeBlock:(PLRecommendGoalCell*)cell {
    [cell.addButton setTitle:@"已添加" forState:UIControlStateNormal];
    [cell.addButton setBackgroundColor:[UIColor grayColor]];
    [cell.addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak PLRecommendGoalCell *cell = [tableView dequeueReusableCellWithIdentifier:cellDetailIdentifier];
    cell.backgroundColor = PLBLACK;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = [UIColor grayColor];
    cell.addButton.hidden = NO;

    switch (_type) {
           
        case 0:
        {
            NSArray *array = @[@"8小时充足睡眠", @"坚持午睡", @"早上7点起床", @"晚上12点前睡觉"];
            if (_open == YES) {
                for (NSString *string in array) {
                    for (PLSignCellObject *sign in _dataArray) {
                        if ([string isEqualToString:sign.titleString]) {
                            [_titleStringArray addObject:string];
                            
                        }
                    }
                }
                _open = NO;
            }
            cell.iconImage = [UIImage imageNamed:@"stopwatch"];
            switch (indexPath.row) {
                case 0:
                {
                    __block BOOL index = YES;
                    NSString *temp = array[0];
                    for (NSString *string in _titleStringArray) {
                        if ([temp isEqualToString:string]) {
                            [self codeBlock:cell];
                            index = NO;
                            break;

                        }
                    }
                    cell.titleString = temp;
                    cell.addButtonBlock = ^(UIButton *button) {
                        if (index == YES) {
                            [self Added:cell andTemp:temp];
                            index = NO;
                        }else {
                            [self unAdd:cell andTemp:temp];
                            index = YES;

                        }
                    };
                    return cell;
                }
                break;
                case 1:
                {
                    __block BOOL index = YES;
                    NSString *temp = array[1];
                    for (NSString *string in _titleStringArray) {
                        if ([temp isEqualToString:string]) {
                            [self codeBlock:cell];
                            index = NO;
                            break;
                            
                        }
                    }
                    cell.titleString = temp;
                    cell.addButtonBlock = ^(UIButton *button) {
                        if (index == YES) {
                            [self Added:cell andTemp:temp];
                            index = NO;
                        }else {
                            [self unAdd:cell andTemp:temp];
                            index = YES;
                            
                        }
                    };
                    return cell;
                }
                    break;
                case 2:
                {
                    __block BOOL index = YES;
                    NSString *temp = array[2];
                    for (NSString *string in _titleStringArray) {
                        if ([temp isEqualToString:string]) {
                            [self codeBlock:cell];
                            index = NO;
                            break;
                        }
                    }
                    cell.titleString = temp;
                    cell.addButtonBlock = ^(UIButton *button) {
                        if (index == YES) {
                            [self Added:cell andTemp:temp];
                            index = NO;
                        }else {
                            [self unAdd:cell andTemp:temp];
                            index = YES;
                            
                        }
                    };
                    return cell;

                }
                    break;
                case 3:
                {
                    __block BOOL index = YES;
                    NSString *temp = array[3];
                    for (NSString *string in _titleStringArray) {
                        if ([temp isEqualToString:string]) {
                            [self codeBlock:cell];
                            index = NO;
                            break;
                            
                        }
                    }
                    cell.titleString = temp;
                    cell.addButtonBlock = ^(UIButton *button) {
                        if (index == YES) {
                            [self Added:cell andTemp:temp];
                            index = NO;
                        }else {
                            [self unAdd:cell andTemp:temp];
                            index = YES;
                            
                        }
                    };
                    return cell;
                }
                    break;
                    
                default:
                    break;
            }

        }
            break;
        case 1:
        {
            NSArray *array = @[@"健身房报道", @"坚持跳绳", @"坚持打乒乓球", @"坚持打网球", @"坚持滑冰"];
            if (_open == YES) {
                for (NSString *string in array) {
                    for (PLSignCellObject *sign in _dataArray) {
                        if ([string isEqualToString:sign.titleString]) {
                            [_titleStringArray addObject:string];
                            
                        }
                    }
                }
                _open = NO;
            }
                switch (indexPath.row) {
                case 0:
                {
                    __block BOOL index = YES;
                    NSString *temp = array[0];
                    for (NSString *string in _titleStringArray) {
                        if ([temp isEqualToString:string]) {
                            [self codeBlock:cell];
                            index = NO;
                            break;
                        }
                    }
                    cell.titleString = temp;
                    cell.iconImage = [UIImage imageNamed:@"dumbbell"];
                    cell.addButtonBlock = ^(UIButton *button) {
                        if (index == YES) {
                            [self Added:cell andTemp:temp];
                            index = NO;
                        }else {
                            [self unAdd:cell andTemp:temp];
                            index = YES;
                            
                        }
                    };
                    return cell;

                }
                    break;
                case 1:
                {
                    __block BOOL index = YES;
                    NSString *temp = array[1];
                    for (NSString *string in _titleStringArray) {
                        if ([temp isEqualToString:string]) {
                            [self codeBlock:cell];
                            index = NO;
                            break;
                        }
                    }
                    cell.titleString = temp;
                    cell.iconImage = [UIImage imageNamed:@"skipping-rope"];
                    cell.addButtonBlock = ^(UIButton *button) {
                        if (index == YES) {
                            [self Added:cell andTemp:temp];
                            index = NO;
                        }else {
                            [self unAdd:cell andTemp:temp];
                            index = YES;
                            
                        }
                    };
                    return cell;

                }
                    break;
                case 2:
                {
                    __block BOOL index = YES;
                    NSString *temp = array[2];
                    for (NSString *string in _titleStringArray) {
                        if ([temp isEqualToString:string]) {
                            [self codeBlock:cell];
                            index = NO;
                            break;
                        }
                    }
                    cell.titleString = temp;
                    cell.iconImage = [UIImage imageNamed:@"ping-pong-racket"];
                    cell.addButtonBlock = ^(UIButton *button) {
                        if (index == YES) {
                            [self Added:cell andTemp:temp];
                            index = NO;
                        }else {
                            [self unAdd:cell andTemp:temp];
                            index = YES;
                            
                        }
                    };
                    return cell;

                }
                    break;
                case 3:
                {
                    __block BOOL index = YES;
                    NSString *temp = array[3];
                    for (NSString *string in _titleStringArray) {
                        if ([temp isEqualToString:string]) {
                            [self codeBlock:cell];
                            index = NO;
                            break;
                        }
                    }
                    cell.titleString = temp;
                    cell.iconImage = [UIImage imageNamed:@"tennis"];
                    cell.addButtonBlock = ^(UIButton *button) {
                        if (index == YES) {
                            [self Added:cell andTemp:temp];
                            index = NO;
                        }else {
                            [self unAdd:cell andTemp:temp];
                            index = YES;
                            
                        }
                    };
                    return cell;

                }
                    break;
                case 4:
                {
                    __block BOOL index = YES;
                    NSString *temp = array[4];
                    for (NSString *string in _titleStringArray) {
                        if ([temp isEqualToString:string]) {
                            [self codeBlock:cell];
                            index = NO;
                            break;
                        }
                    }
                    cell.titleString = temp;
                    cell.iconImage = [UIImage imageNamed:@"skates"];
                    cell.addButtonBlock = ^(UIButton *button) {
                        if (index == YES) {
                            [self Added:cell andTemp:temp];
                            index = NO;
                        }else {
                            [self unAdd:cell andTemp:temp];
                            index = YES;
                            
                        }
                    };
                    return cell;

                }
                    
                default:
                    break;
            }

        }
            break;
        case 2:
        {
            NSArray *array = @[@"拒绝甜食", @"拒绝碳酸饮料", @"多吃蔬菜", @"多吃水果", @"每天一杯茶", @"每天一杯牛奶", @"拒绝啤酒"];
            if (_open == YES) {
                for (NSString *string in array) {
                    for (PLSignCellObject *sign in _dataArray) {
                        if ([string isEqualToString:sign.titleString]) {
                            [_titleStringArray addObject:string];
                            
                        }
                    }
                }
                _open = NO;
            }

            switch (indexPath.row) {
                case 0:
                {
                    __block BOOL index = YES;
                    NSString *temp = array[0];
                    for (NSString *string in _titleStringArray) {
                        if ([temp isEqualToString:string]) {
                            [self codeBlock:cell];
                            index = NO;
                            break;
                        }
                    }
                    cell.titleString = temp;
                    cell.iconImage = [UIImage imageNamed:@"cheese"];
                    cell.addButtonBlock = ^(UIButton *button) {
                        if (index == YES) {
                            [self Added:cell andTemp:temp];
                            index = NO;
                        }else {
                            [self unAdd:cell andTemp:temp];
                            index = YES;
                            
                        }
                    };
                    return cell;

                }
                    break;
                case 1:
                {
                    __block BOOL index = YES;
                    NSString *temp = array[1];
                    for (NSString *string in _titleStringArray) {
                        if ([temp isEqualToString:string]) {
                            [self codeBlock:cell];
                            index = NO;
                            break;
                        }
                    }
                    cell.titleString = temp;
                    cell.iconImage = [UIImage imageNamed:@"soda-in-the-bank"];
                    cell.addButtonBlock = ^(UIButton *button) {
                        if (index == YES) {
                            [self Added:cell andTemp:temp];
                            index = NO;
                        }else {
                            [self unAdd:cell andTemp:temp];
                            index = YES;
                            
                        }
                    };
                    return cell;

                }
                    break;
                case 2:
                {
                    __block BOOL index = YES;
                    NSString *temp = array[2];
                    for (NSString *string in _titleStringArray) {
                        if ([temp isEqualToString:string]) {
                            [self codeBlock:cell];
                            index = NO;
                            break;
                        }
                    }
                    cell.titleString = temp;
                    cell.iconImage = [UIImage imageNamed:@"carrot"];
                    cell.addButtonBlock = ^(UIButton *button) {
                        if (index == YES) {
                            [self Added:cell andTemp:temp];
                            index = NO;
                        }else {
                            [self unAdd:cell andTemp:temp];
                            index = YES;
                            
                        }
                    };
                    return cell;

                }
                    break;
                case 3:
                {
                    __block BOOL index = YES;
                    NSString *temp = array[3];
                    for (NSString *string in _titleStringArray) {
                        if ([temp isEqualToString:string]) {
                            [self codeBlock:cell];
                            index = NO;
                            break;
                        }
                    }
                    cell.titleString = temp;
                    cell.iconImage = [UIImage imageNamed:@"美食"];
                    cell.addButtonBlock = ^(UIButton *button) {
                        if (index == YES) {
                            [self Added:cell andTemp:temp];
                            index = NO;
                        }else {
                            [self unAdd:cell andTemp:temp];
                            index = YES;
                            
                        }
                    };
                    return cell;

                }
                    break;
                case 4:
                {
                    __block BOOL index = YES;
                    NSString *temp = array[4];
                    for (NSString *string in _titleStringArray) {
                        if ([temp isEqualToString:string]) {
                            [self codeBlock:cell];
                            index = NO;
                            break;
                        }
                    }
                    cell.titleString = temp;
                    cell.iconImage = [UIImage imageNamed:@"tea"];
                    cell.addButtonBlock = ^(UIButton *button) {
                        if (index == YES) {
                            [self Added:cell andTemp:temp];
                            index = NO;
                        }else {
                            [self unAdd:cell andTemp:temp];
                            index = YES;
                            
                        }
                    };
                    return cell;

                }
                    break;
                case 5:
                {
                    __block BOOL index = YES;
                    NSString *temp = array[5];
                    for (NSString *string in _titleStringArray) {
                        if ([temp isEqualToString:string]) {
                            [self codeBlock:cell];
                            index = NO;
                            break;
                        }
                    }
                    cell.titleString = temp;
                    cell.iconImage = [UIImage imageNamed:@"milk"];
                    cell.addButtonBlock = ^(UIButton *button) {
                        if (index == YES) {
                            [self Added:cell andTemp:temp];
                            index = NO;
                        }else {
                            [self unAdd:cell andTemp:temp];
                            index = YES;
                            
                        }
                    };
                    return cell;

                }
                    break;
                case 6:
                {
                    __block BOOL index = YES;
                    NSString *temp = array[6];
                    for (NSString *string in _titleStringArray) {
                        if ([temp isEqualToString:string]) {
                            [self codeBlock:cell];
                            index = NO;
                            break;
                        }
                    }
                    cell.titleString = temp;
                    cell.iconImage = [UIImage imageNamed:@"beer"];
                    cell.addButtonBlock = ^(UIButton *button) {
                        if (index == YES) {
                            [self Added:cell andTemp:temp];
                            index = NO;
                        }else {
                            [self unAdd:cell andTemp:temp];
                            index = YES;
                            
                        }
                    };
                    return cell;
                    
                }
                    break;
                    
                default:
                    break;
            }

        }
            break;
        case 3:
        {
            NSArray *array = @[@"每日3千步", @"每日6千步", @"每日1万步", @"每日2万步"];
            if (_open == YES) {
                for (NSString *string in array) {
                    for (PLSignCellObject *sign in _dataArray) {
                        if ([string isEqualToString:sign.titleString]) {
                            [_titleStringArray addObject:string];
                            
                        }
                    }
                }
                _open = NO;
            }


            cell.iconImage = [UIImage imageNamed:@"shoe-1"];
            switch (indexPath.row) {
                case 0:
                {
                    __block BOOL index = YES;
                    NSString *temp = array[0];
                    for (NSString *string in _titleStringArray) {
                        if ([temp isEqualToString:string]) {
                            [self codeBlock:cell];
                            index = NO;
                            break;
                        }
                    }
                    cell.titleString = temp;
                    cell.addButtonBlock = ^(UIButton *button) {
                        if (index == YES) {
                            [self Added:cell andTemp:temp];
                            index = NO;
                        }else {
                            [self unAdd:cell andTemp:temp];
                            index = YES;
                            
                        }
                    };
                    return cell;
                }
                    break;
                case 1:
                {
                    __block BOOL index = YES;
                    NSString *temp = array[1];
                    for (NSString *string in _titleStringArray) {
                        if ([temp isEqualToString:string]) {
                            [self codeBlock:cell];
                            index = NO;
                            break;
                        }
                    }
                    cell.titleString = temp;
                    cell.addButtonBlock = ^(UIButton *button) {
                        if (index == YES) {
                            [self Added:cell andTemp:temp];
                            index = NO;
                        }else {
                            [self unAdd:cell andTemp:temp];
                            index = YES;
                            
                        }
                    };
                    return cell;

                }
                    break;
                case 2:
                {
                    __block BOOL index = YES;
                    NSString *temp = array[2];
                    for (NSString *string in _titleStringArray) {
                        if ([temp isEqualToString:string]) {
                            [self codeBlock:cell];
                            index = NO;
                            break;
                        }
                    }
                    cell.titleString = temp;
                    cell.addButtonBlock = ^(UIButton *button) {
                        if (index == YES) {
                            [self Added:cell andTemp:temp];
                            index = NO;
                        }else {
                            [self unAdd:cell andTemp:temp];
                            index = YES;
                            
                        }
                    };
                    return cell;

                }
                    break;
                case 3:
                {
                    __block BOOL index = YES;
                    NSString *temp = array[3];
                    for (NSString *string in _titleStringArray) {
                        if ([temp isEqualToString:string]) {
                            [self codeBlock:cell];
                            index = NO;
                            break;
                        }
                    }
                    cell.titleString = temp;
                    cell.addButtonBlock = ^(UIButton *button) {
                        if (index == YES) {
                            [self Added:cell andTemp:temp];
                            index = NO;
                        }else {
                            [self unAdd:cell andTemp:temp];
                            index = YES;
                            
                        }
                    };
                    return cell;

                }
                    break;
                    
                default:
                    break;
            }

        }
            break;
        case 4:
        {
            NSArray *array = @[@"骑行5公里", @"骑行10公里", @"骑行30公里", @"骑行100公里"];
            if (_open == YES) {
                for (NSString *string in array) {
                    for (PLSignCellObject *sign in _dataArray) {
                        if ([string isEqualToString:sign.titleString]) {
                            [_titleStringArray addObject:string];
                            
                        }
                    }
                }
                _open = NO;
                
            }

            cell.iconImage = [UIImage imageNamed:@"bicycle"];
            switch (indexPath.row) {
                case 0:
                {
                    __block BOOL index = YES;
                    NSString *temp = array[0];
                    for (NSString *string in _titleStringArray) {
                        if ([temp isEqualToString:string]) {
                            [self codeBlock:cell];
                            index = NO;
                            break;
                            
                        }
                    }
                    cell.titleString = temp;
                    cell.addButtonBlock = ^(UIButton *button) {
                        if (index == YES) {
                            [self Added:cell andTemp:temp];
                            index = NO;
                        }else {
                            [self unAdd:cell andTemp:temp];
                            index = YES;
                            
                        }
                    };
                    return cell;

                }
                    break;
                case 1:
                {
                    __block BOOL index = YES;
                    NSString *temp = array[1];
                    for (NSString *string in _titleStringArray) {
                        if ([temp isEqualToString:string]) {
                            [self codeBlock:cell];
                            index = NO;
                            break;
                            
                        }
                    }
                    cell.titleString = temp;
                    cell.addButtonBlock = ^(UIButton *button) {
                        if (index == YES) {
                            [self Added:cell andTemp:temp];
                            index = NO;
                        }else {
                            [self unAdd:cell andTemp:temp];
                            index = YES;
                            
                        }
                    };
                    return cell;

                }
                    break;
                case 2:
                {
                    __block BOOL index = YES;
                    NSString *temp = array[2];
                    for (NSString *string in _titleStringArray) {
                        if ([temp isEqualToString:string]) {
                            [self codeBlock:cell];
                            index = NO;
                            break;
                        }
                    }
                    cell.titleString = temp;
                    cell.addButtonBlock = ^(UIButton *button) {
                        if (index == YES) {
                            [self Added:cell andTemp:temp];
                            index = NO;
                        }else {
                            [self unAdd:cell andTemp:temp];
                            index = YES;
                        }
                    };
                    return cell;

                }
                    break;
                case 3:
                {
                    __block BOOL index = YES;
                    NSString *temp = array[3];
                    for (NSString *string in _titleStringArray) {
                        if ([temp isEqualToString:string]) {
                            [self codeBlock:cell];
                            index = NO;
                            break;
                        }
                    }
                    cell.titleString = temp;
                    cell.addButtonBlock = ^(UIButton *button) {
                        if (index == YES) {
                            [self Added:cell andTemp:temp];
                            index = NO;
                        }else {
                            [self unAdd:cell andTemp:temp];
                            index = YES;
                            
                        }
                    };
                    return cell;
                }
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
            return 0;
}

@end
