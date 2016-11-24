//
//  PLHistoryInformationViewController.m
//  Move
//
//  Created by 胡梦龙 on 16/10/31.
//  Copyright © 2016年 PhelanGeek. All rights reserved.
//

#import "PLHistoryInformationViewController.h"

#import "PLHistoryTableViewCell.h"

static NSString *const hCell = @"PLHistoryTableViewCell";

@interface PLHistoryInformationViewController ()

<
UITableViewDelegate,
UITableViewDataSource
>

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) NSArray*historyArray;

@end

@implementation PLHistoryInformationViewController

- (NSArray *)historyArray {

    if (!_historyArray) {
        
        NSArray *array = [[PLDataBaseManager shareManager] ArrayWithRecordWeight];
        _historyArray = array;
        
    }
    return _historyArray;


}

- (UITableView *)tableView {

    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64) style:UITableViewStylePlain];
        _tableView.backgroundColor = ColorWith51Black;
        _tableView.rowHeight = 70;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
    }
    return _tableView;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"历史记录";
    
    [self.view addSubview:self.tableView];
    
    UINib *nib = [UINib nibWithNibName:hCell bundle:nil];
    [_tableView registerNib:nib forCellReuseIdentifier:hCell];
    
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    
    
}
- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;

}

#pragma mark - tableView协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.historyArray.count;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PLHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:hCell];
    
    cell.history = self.historyArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    


}




@end
