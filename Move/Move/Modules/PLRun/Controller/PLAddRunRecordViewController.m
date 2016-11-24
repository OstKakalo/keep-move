//
//  PLAddRunRecordViewController.m
//  Move
//
//  Created by PhelanGeek on 2016/11/8.
//  Copyright © 2016年 PhelanGeek. All rights reserved.
//

#import "PLAddRunRecordViewController.h"
#import "PLNavigationView.h"
#import "PLAddRunRecordCell.h"
#import "RecordViewController.h"
#import "PLDetailRunRecordViewController.h"

static NSString *const cellRecordIdentifier = @"cell";

@interface PLAddRunRecordViewController ()
<
    UITableViewDelegate,
    UITableViewDataSource
>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *titleArray;

@end

@implementation PLAddRunRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationView];
    
}

- (NSMutableArray *)titleArray {
    if (!_titleArray) {
        _titleArray = [NSMutableArray arrayWithArray:@[@"走路(散步)", @"走路(正常)", @"走路(快走)", @"慢跑(低强度)", @"跑步(低强度)", @"跑步(高强度)", @"自行车(低强度)", @"自行车(高强度)", @"游泳(低强度)", @"游泳(高强度)", @"运动(低强度)", @"运动(高强度)", @"有氧运动", @"瑜伽"]];
        
    }
    return _titleArray;
}

- (void)setupNavigationView {
    // 设置导航栏view
    PLNavigationView *plNavigationView = [[PLNavigationView alloc] init];
    plNavigationView.titleString = @"录入运动";
    plNavigationView.frame = CGRectMake(0, 0, PLWIDTH, 64);
        [plNavigationView.deleteButton setBackgroundImage:[UIImage imageNamed:@"historyRecord"] forState:UIControlStateNormal];
    
    plNavigationView.cancelButtonBlock = ^(UIButton *button){
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    plNavigationView.deleteButtonBlock = ^(UIButton *button) {
        UIViewController *recordController = [[RecordViewController alloc] initWithNibName:nil bundle:nil];
        [self presentViewController:recordController animated:YES completion:nil];
    };
    [self.view addSubview:plNavigationView];
    
    // 设置tableView
    _tableView.backgroundColor = PLBLACK;
    _tableView.rowHeight = 60.f;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"PLAddRunRecordCell" bundle:nil] forCellReuseIdentifier:cellRecordIdentifier];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PLAddRunRecordCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell = [[NSBundle mainBundle] loadNibNamed:@"PLAddRunRecordCell" owner:nil options:nil].lastObject;

    cell.backgroundColor = PLBLACK;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (0 <= indexPath.row && indexPath.row <= 2 ) {
        cell.titleString = _titleArray[indexPath.row];
        return cell;
    }else if(3 <= indexPath.row && indexPath.row <= 5) {
        cell.iconImage = [UIImage imageNamed:@"wreiteRun"];
        cell.titleString = _titleArray[indexPath.row];
        return cell;
    }else if (6 <= indexPath.row && indexPath.row <= 7) {
        cell.iconImage = [UIImage imageNamed:@"writeRide"];
        cell.titleString = _titleArray[indexPath.row];
        return cell;
    }else if (8 <= indexPath.row && indexPath.row <= 9) {
        cell.iconImage = [UIImage imageNamed:@"writeSwim"];
        cell.titleString = _titleArray[indexPath.row];
        return cell;
    }else if (10 <= indexPath.row && indexPath.row <= 11) {
        cell.iconImage = [UIImage imageNamed:@"writeSports"];
        cell.titleString = _titleArray[indexPath.row];
        return cell;
    }
    if (indexPath.row == 12) {
        cell.iconImage = [UIImage imageNamed:@"writeO2"];
        cell.titleString = _titleArray[indexPath.row];
        return cell;
    }
    
    cell.iconImage = [UIImage imageNamed:@"writeYoga"];
    cell.titleString = _titleArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    PLDetailRunRecordViewController *detailRunVC = [[PLDetailRunRecordViewController alloc] init];
    detailRunVC.index = indexPath.row;
    detailRunVC.typeString = _titleArray[indexPath.row];
    [self presentViewController:detailRunVC animated:YES completion:nil];
}
@end
