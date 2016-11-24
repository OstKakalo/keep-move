//
//  PLMineViewController.m
//  Move
//
//  Created by PhelanGeek on 2016/10/19.
//  Copyright © 2016年 PhelanGeek. All rights reserved.
//

#import "PLMineViewController.h"
#import "PLInitialWeightTableViewCell.h"
#import "PLDataBaseManager.h"
#import "PLPersonInformation.h"
#import "PLHWeightTableViewCell.h"
#import "PLHistoryInformationViewController.h"
#import "PLSetInformationTableViewController.h"
#import "PLProtocolViewController.h"
static NSString *const InitialWeight = @"PLInitialWeightTableViewCell";
static NSString *const cellID = @"cell";
static NSString *const recordCell = @"recordCell";
static NSString *const setCell = @"setCell";
static NSString *const WeightCell = @"PLHWeightTableViewCell";
static NSString *const protocolCell = @"protocol";
static NSString *const haveToKnowCell = @"haveToKnow";




@interface PLMineViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
UIScrollViewDelegate
>


@property (nonatomic, strong) UILabel *timeCopy;



@end

@implementation PLMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"我";
    self.view.backgroundColor = [UIColor blackColor];
    
    
    [self.view addSubview:self.tableView];
    
    [self createButton];
    
   

    
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];

}


- (UITableView *)tableView {

    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, - 34, WIDTH, HEIGHT - 64 - 49 + 34 ) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = ColorWithBackGround;
        
    }
    return _tableView;
}


#pragma mark - tableView协议方法


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 4;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return 1;
            break;
            
        case 1:
            return 2;
            break;
            
        case 2:
            return 1;
            break;
            
        case 3:
            return 1;
            break;
            
            
        default:
            break;
    }
    
    
    
    return 0;
    

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        if ([[PLDataBaseManager shareManager] currentWeight]) {
            return 480;
        } else {
            return 220;
        }
        
        
    } else{
        return 44;
    }
    

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 1) {
        PLHistoryInformationViewController *historyVC = [[PLHistoryInformationViewController alloc] init];
        [self.navigationController pushViewController:historyVC animated:YES];
    } else if(indexPath.section == 2) {
    
        PLSetInformationTableViewController *informationVC = [PLSetInformationTableViewController pl_setInformationTableViewController];
        informationVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:informationVC animated:YES];
    
    } else if(indexPath.section == 3){
        
        PLProtocolViewController *protocolVC = [[PLProtocolViewController alloc] init];
        protocolVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:protocolVC animated:YES];
        
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    CGFloat weight = [[PLDataBaseManager shareManager] currentWeight];
    
    
    if (indexPath.section == 0) {
    
        
        
        
        if (!weight) {
            
            
            PLInitialWeightTableViewCell *initialCell = [tableView dequeueReusableCellWithIdentifier:InitialWeight];
            
            
            if (!initialCell) {
                initialCell = [[NSBundle mainBundle] loadNibNamed:InitialWeight owner:nil options:nil].lastObject;
                initialCell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            return initialCell;
            
            
        } else {
            
            
            PLHWeightTableViewCell *weightCell = [tableView dequeueReusableCellWithIdentifier:WeightCell];
            if (!weightCell) {
                weightCell = [[NSBundle mainBundle] loadNibNamed:WeightCell owner:nil options:nil].lastObject;
                weightCell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            return weightCell;
            
        
        }
        
        
    } else if(indexPath.section == 1){
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                cell.backgroundColor = ColorWith51Black;
                cell.textLabel.text = @"历史记录";
                cell.textLabel.textColor = [UIColor grayColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }
            return cell;
        } else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:recordCell];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:recordCell];
                cell.imageView.image = [UIImage imageNamed:@"record"];
                cell.textLabel.text = @"体重记录日志";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.backgroundColor = ColorWith51Black;
                cell.textLabel.textColor = [UIColor grayColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }
            return cell;
        
        }
        
    
    
    } else if (indexPath.section == 2){
    
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:setCell];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:setCell];
            cell.imageView.image = [UIImage imageNamed:@"set"];
            cell.textLabel.text = @"个人资料与设置";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.backgroundColor = ColorWith51Black;
            cell.textLabel.textColor = [UIColor grayColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    
    
    } else {
//        if (indexPath.row == 0) {
//            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:haveToKnowCell];
//            if (!cell) {
//                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:haveToKnowCell];
//                cell.backgroundColor = ColorWith51Black;
//                cell.imageView.image = [UIImage imageNamed:@"yonghuxuzhi"];
//                cell.textLabel.text = @"用户须知";
//                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//                cell.textLabel.textColor = [UIColor grayColor];
//                cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                
//            }
//            return cell;
//        } else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:protocolCell];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:protocolCell];
                cell.imageView.image = [UIImage imageNamed:@"yinsizhengce"];
                cell.textLabel.text = @"隐私政策";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.backgroundColor = ColorWith51Black;
                cell.textLabel.textColor = [UIColor grayColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }
            return cell;
            
//        }
        
       
    
    }


    
    
}

#pragma mark - 私有方法

- (void)createButton {
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200)];
    self.tableView.tableFooterView = footView;
    self.timeCopy = [[UILabel alloc] initWithFrame:CGRectMake((WIDTH - 300) / 2, 20, 300, 20)];
    _timeCopy.text = @"慎重选择哦";
    _timeCopy.textColor = [UIColor grayColor];
    _timeCopy.textAlignment = NSTextAlignmentCenter;
    [footView addSubview:_timeCopy];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"清空历史数据" forState:UIControlStateNormal];
    [button setTitleColor:PLYELLOW forState:UIControlStateNormal];
    button.layer.cornerRadius = 10.f;
    button.frame = CGRectMake((WIDTH - (WIDTH - 20)) / 2, 50, WIDTH - 20, 44);
    button.layer.borderColor = PLYELLOW.CGColor;
    button.layer.borderWidth = 1.f;
    button.backgroundColor = ColorWith51Black;
    [footView addSubview:button];
    [button addTarget:self action:@selector(pl_clear) forControlEvents:UIControlEventTouchUpInside];
    
    
    

}
- (void)pl_clear {
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"删除后体重记录会被清空哦" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [[PLDataBaseManager shareManager] clearRecord];
        
        
        [self.tableView reloadData];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
    

}


 



@end
