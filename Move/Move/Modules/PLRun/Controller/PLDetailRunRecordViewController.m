//
//  PLDetailRunRecordViewController.m
//  Move
//
//  Created by PhelanGeek on 2016/11/8.
//  Copyright © 2016年 PhelanGeek. All rights reserved.
//

#import "PLDetailRunRecordViewController.h"
#import "PLNavigationView.h"
#import "RecordViewController.h"
#import "PLDetailRecordTypeOneCell.h"
#import "PLDetailRecordTypeTwoCell.h"
#import "NSDate+Categories.h"
#import "PLInfoModel.h"
#import "Record.h"
#import "FileHelper.h"


static NSString *const cellDetailRunRecordIdentifier = @"cell";
static NSString *const cellDetailRunRecordTwoIdentifier = @"cellTwo";
@interface PLDetailRunRecordViewController ()
<
    UITableViewDelegate,
    UITableViewDataSource,
    UIPickerViewDelegate,
    UIPickerViewDataSource,
    PLTransferValueProtocol

>

@property (nonatomic, copy) NSString *goalPath;
@property (nonatomic, retain) NSMutableArray *sportRecordArray;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, retain) UITextField *timeTextFiled;
@property (nonatomic, retain) UIView *timeView;

@property (nonatomic, retain) NSMutableArray *hoursArray;
@property (nonatomic, retain) NSMutableArray *minutesArray;

@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) NSInteger selectedTwoIndex;
@property (nonatomic, assign) BOOL pickerFlag;

@property (nonatomic, retain) PLInfoModel *infoModel;

@property (nonatomic, assign) BOOL stepCountFlag;

@property (nonatomic, strong) Record *currentRecord;
@property (nonatomic, assign) float baseParameter;


@end

@implementation PLDetailRunRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationView];
    [self setupPath];
//    self.infoModel = [[PLInfoModel alloc] init];
//    _infoModel.time = @"30分钟";
    

    
    self.sportRecordArray = [NSMutableArray array];
    NSArray *pArray = [NSKeyedUnarchiver unarchiveObjectWithFile:_goalPath];
    self.sportRecordArray = [NSMutableArray arrayWithArray:pArray];

}

- (PLInfoModel *)infoModel {
    if (!_infoModel) {
        _infoModel = [[PLInfoModel alloc] init];
        _infoModel.time = @"30分钟";
        _infoModel.calorie = [NSString stringWithFormat:@"%.0f", 30 * self.baseParameter];
        
    }
    return _infoModel;
}

- (float)baseParameter {
    switch (_index) {
        case 0:
            _baseParameter = 2.5;
            break;
        case 1:
            _baseParameter = 3.4;
            break;
        case 2:
            _baseParameter = 5.2;
            break;
        case 3:
            _baseParameter = 6.4;
            break;
        case 4:
            _baseParameter = 9.0;
            break;
        case 5:
            _baseParameter = 11.7;
            break;
        case 6:
            _baseParameter = 6.9;
            break;
        case 7:
            _baseParameter = 12.8;
            break;
        case 8:
            _baseParameter = 5.5;
            break;
        case 9:
            _baseParameter = 9.0;
            break;
        case 10:
            _baseParameter = 7.8;
            break;
        case 11:
            _baseParameter = 9.9;
            break;
        case 12:
            _baseParameter = 6.7;
            break;
        case 13:
            _baseParameter = 3.0;
            break;
        default:
            break;
    }
    return _baseParameter;
}

- (void)setupPath {
    // 拼接路径
    NSArray *libraryArray = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryPath = [libraryArray firstObject];
    
    // 列表
    NSString *path = [libraryPath stringByAppendingString:@"/Preferences"];
    path = [path stringByAppendingString:@"/RunRecord.plist"];
    self.goalPath = path;
    //NSLog(@"%@", _goalPath);
}

- (void)saveRoute
{
    if (self.currentRecord == nil)
    {
        return;
    }
    
    NSString *name = self.currentRecord.title;
    NSString *path = [FileHelper filePathWithName:name];
    
    [NSKeyedArchiver archiveRootObject:self.currentRecord toFile:path];
    
    self.currentRecord = nil;
}


- (void)setupNavigationView {
    // 设置导航栏view
    PLNavigationView *plNavigationView = [[PLNavigationView alloc] init];
    plNavigationView.titleString = @"运动";
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
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"PLDetailRecordTypeOneCell" bundle:nil] forCellReuseIdentifier:cellDetailRunRecordIdentifier];
    [_tableView registerNib:[UINib nibWithNibName:@"PLDetailRecordTypeTwoCell" bundle:nil] forCellReuseIdentifier:cellDetailRunRecordTwoIdentifier];
    
    // 添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewAction:)];
    tap.cancelsTouchesInView = NO;
    [_tableView addGestureRecognizer:tap];
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    self.tableView.tableFooterView = footView;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"保存" forState:UIControlStateNormal];
    [button setTitleColor:PLYELLOW forState:UIControlStateNormal];
    button.layer.cornerRadius = 10.f;
    button.frame = CGRectMake((WIDTH - (WIDTH - 20)) / 2, 0, WIDTH - 20, 44);
    button.layer.borderColor = PLYELLOW.CGColor;
    button.layer.borderWidth = 1.f;
    button.backgroundColor = ColorWith51Black;
    [footView addSubview:button];
    [button handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        self.currentRecord = [[Record alloc] init];
        [self.sportRecordArray addObject:_infoModel];
        [NSKeyedArchiver archiveRootObject:_sportRecordArray toFile:_goalPath];
        [self saveRoute];
        UIViewController *recordController = [[RecordViewController alloc] initWithNibName:nil bundle:nil];
        [self presentViewController:recordController animated:YES completion:nil];
    }];

}

- (void)setupPickerView {
    self.timeView = [[UIView alloc] initWithFrame:CGRectMake(0, PLHEIGHT - 200 , WIDTH, 200)];
    _timeView.backgroundColor = [UIColor grayColor];
    

    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, _timeView.frame.size.height)];
    [_timeView addSubview:_pickerView];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    [self.view addSubview:_timeView];
    
    _pickerFlag = YES;
    
}

#pragma mark - lazy loading

- (NSMutableArray *)hoursArray {
    if (!_hoursArray) {
        _hoursArray = [NSMutableArray array];
        for (int i = 0; i <= 23; i++) {
            [_hoursArray addObject:[NSString stringWithFormat:@"%d", i]];
        }
    }
    return _hoursArray;
}

- (NSMutableArray *)minutesArray {
    if (!_minutesArray) {
        _minutesArray = [NSMutableArray array];
        for (int i = 0; i <= 59; i++) {
            [_minutesArray addObject:[NSString stringWithFormat:@"%d", i]];
        }
    }
    return _minutesArray;
}

#pragma mark - tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return PLHEIGHT * 0.27;

    }
    return 60.0f;
    
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PLWIDTH, 20)];
    view.backgroundColor = PLBLACK;
    return view;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        PLDetailRecordTypeOneCell *cell = [tableView dequeueReusableCellWithIdentifier:cellDetailRunRecordIdentifier];
        cell.delegate = self;
        if (cell == nil) {
            cell = [[PLDetailRecordTypeOneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellDetailRunRecordIdentifier];
        }
        cell.contentView.backgroundColor = ColorWith51Black;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.infoModel = self.infoModel;
        return cell;
    }else{
        PLDetailRecordTypeTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellDetailRunRecordTwoIdentifier];
        cell.contentView.backgroundColor = ColorWith51Black;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (cell == nil) {
            cell = [[PLDetailRecordTypeTwoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellDetailRunRecordTwoIdentifier];
        }
        if (indexPath.row == 0) {
            cell.titleString = _typeString;
            return cell;
        }else{
            cell.leftString = @"日期";
            cell.titleString = [NSDate getSystemTimeStringWithFormat:@"yyyy年MM月dd日 HH:mm"];
            _infoModel.date = [NSDate getSystemTimeStringWithFormat:@"yyyy年MM月dd日 HH:mm"];
            _infoModel.type = @2;
            _infoModel.title = _typeString;
            cell.hiddenImageView = YES;
            return cell;
        }


    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Custom Delegate Way

- (void)tapViewDelegate {
    //NSLog(@"one");
    [self.view endEditing:YES];
    [self setupPickerView];

}

- (void)tapStepCountDelegate {
    //NSLog(@"two");
    if (_pickerFlag == YES) {
        [_timeView removeFromSuperview];
        _pickerFlag = NO;
    }
}

- (void)tapKmDelegate {
    //NSLog(@"three");
    if (_pickerFlag == YES) {
        [_timeView removeFromSuperview];
        _pickerFlag = NO;
    }
}

- (void)tapCalorieDelegate {
    //NSLog(@"four");
    if (_pickerFlag == YES) {
        [_timeView removeFromSuperview];
        _pickerFlag = NO;
    }
}

#pragma mark - pickerView delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 4;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (0 == component) {
        return self.hoursArray.count;
    }else if (1 == component) {
        return 1;
    }else if (2 == component) {
        return self.minutesArray.count;
    }
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (0 == component) {
        NSString *hours = _hoursArray[row];
        return hours;
    }else if (1 == component) {
        return @"小时";
    }else if (2 == component) {
        NSString *minutes = _minutesArray[row];
        return minutes;
    }
    return @"分钟";
}
// 修改pickview字体颜色
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        pickerLabel.textColor = [UIColor whiteColor];
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:20]];
    }
    // Fill the label text here
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (0 == component) {
        self.selectedIndex = row;
    }else {
        self.selectedTwoIndex = row;
    }

}

- (void)tableViewAction:(UITapGestureRecognizer *)tap {
    [self.view endEditing:YES];

    if (_pickerFlag == YES) {
        
        NSString *string = [NSString stringWithFormat:@"%@小时", _hoursArray[_selectedIndex]];
        string = [string stringByAppendingString:[NSString stringWithFormat:@"%@分钟", _minutesArray[_selectedTwoIndex]]];
        NSLog(@"time :%@", string);
        [_timeView removeFromSuperview];
        NSLog(@"%@ %@",_hoursArray[_selectedIndex], _minutesArray[_selectedTwoIndex] );
        NSString *hours = _hoursArray[_selectedIndex];
        NSString *minute = _minutesArray[_selectedTwoIndex];
        NSInteger minutes = [hours integerValue] * 60 + [minute integerValue];

        _infoModel.calorie = [NSString stringWithFormat:@"%.0f", minutes * self.baseParameter];
        _infoModel.time = string;
        
        // 刷新指定行cell
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
       
    }
    _pickerFlag = NO;
    PLDetailRecordTypeOneCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    self.infoModel = cell.infoModel;
    //NSLog(@"%@", _infoModel);
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    //NSLog(@"return");
    //NSLog(@"%@", textField.text);

    [textField resignFirstResponder];
    return YES;
}

@end
