//
//  PLSignRecordViewController.m
//  Move
//
//  Created by PhelanGeek on 2016/11/2.
//  Copyright © 2016年 PhelanGeek. All rights reserved.
//

#import "PLSignRecordViewController.h"
#import "PLNavigationView.h"
#import "PLSignCellObject.h"

static NSString *const cellRecordIdentifier = @"cell";

@interface PLSignRecordViewController ()
<
    UITableViewDelegate,
    UITableViewDataSource
>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, copy) NSString *goalPath;
@property (nonatomic, retain) NSMutableArray *tempArray;

@end

@implementation PLSignRecordViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupNavigationView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getDataSource];
 
}

- (void)getDataSource {
    [self setupPath];
    self.dataArray = [NSMutableArray array];
    NSArray *pArray = [NSKeyedUnarchiver unarchiveObjectWithFile:_goalPath];
    self.tempArray = [NSMutableArray arrayWithArray:pArray];
    PLSignCellObject *sign = _tempArray[_index];
    self.dataArray = [NSMutableArray arrayWithArray:sign.signArray];
    if (_dataArray.count == 0) {
        [_tableView removeFromSuperview];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH / 2 - 100, HEIGHT / 2 - 50, 200, 50)];
        label.text = @"打卡记录为空";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = PLYELLOW;
        [self.view addSubview:label];
    }
    
}

- (void)setupNavigationView {
    // 设置导航栏view
    PLNavigationView *plNavigationView = [[PLNavigationView alloc] init];
    plNavigationView.titleString = @"打卡记录";
    plNavigationView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 64);
    
    if (_dataArray.count == 0) {
        plNavigationView.deleteButton.hidden = YES;
    }else{
        plNavigationView.deleteButton.hidden = NO;
    }
    
    plNavigationView.cancelButtonBlock = ^(UIButton *button){
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    plNavigationView.deleteButtonBlock = ^(UIButton *button) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"清空打卡记录" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [_dataArray removeAllObjects];
            PLSignCellObject *sign = _tempArray[_index];
            sign.signArray = nil;
            [_tempArray replaceObjectAtIndex:_index withObject:sign];
            [NSKeyedArchiver archiveRootObject:_tempArray toFile:_goalPath];
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:sureAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    };
    [self.view addSubview:plNavigationView];
    
    // 设置tableView
    _tableView.backgroundColor = PLBLACK;
    _tableView.rowHeight = 60.f;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellRecordIdentifier];
}

- (void)setupPath {
    // 拼接路径
    NSArray *libraryArray = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryPath = [libraryArray firstObject];
    
    // 列表
    NSString *path = [libraryPath stringByAppendingString:@"/Preferences"];
    path = [path stringByAppendingString:@"/Goal.plist"];
    self.goalPath = path;
    //NSLog(@"%@", _goalPath);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellRecordIdentifier];
    cell.backgroundColor = PLBLACK;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = PLYELLOW;
    cell.textLabel.text = _dataArray[indexPath.row];
    return cell;
}
@end
