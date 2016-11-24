//
//  PLSetInformationTableViewController.m
//  Move
//
//  Created by 胡梦龙 on 16/10/31.
//  Copyright © 2016年 PhelanGeek. All rights reserved.
//

#import "PLSetInformationTableViewController.h"

#import "PLPersonInformation.h"

@interface PLSetInformationTableViewController ()
<
UIPickerViewDelegate,
UIPickerViewDataSource,
UITextFieldDelegate

>

@property (weak, nonatomic) IBOutlet UITextField *gender;

@property (weak, nonatomic) IBOutlet UITextField *brithYear;

@property (weak, nonatomic) IBOutlet UITextField *height;

@property (weak, nonatomic) IBOutlet UITextField *weight;

@property (weak, nonatomic) IBOutlet UITextField *steps;


@property (nonatomic, strong) NSArray *genderArray;

@property (nonatomic, strong) NSMutableArray *brithArray;

@property (nonatomic, strong) UIPickerView *genderPicker;

@property (nonatomic, strong) UIPickerView *brithPicker;

@property (nonatomic, assign) BOOL isHaveDian;

@property (nonatomic, assign) BOOL isFirstZero;

@end

@implementation PLSetInformationTableViewController


- (NSArray *)genderArray {
    if (!_genderArray) {
        _genderArray = [NSArray arrayWithObjects:@"男", @"女", nil];
    }
    return _genderArray;
}

- (NSMutableArray *)brithArray {
    if (!_brithArray) {
        _brithArray = [NSMutableArray array];
        for (int i = 1900; i <= 2016; i++) {
            [_brithArray addObject:[NSString stringWithFormat:@"%d", i]];
        }
    }
    return _brithArray;

}

+ (instancetype)pl_setInformationTableViewController {

    return [[UIStoryboard storyboardWithName:NSStringFromClass(self) bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass(self)];

}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    PLPersonInformation *person = [[PLPersonInformation alloc] init];
    person.gender = self.gender.text;
    person.brithday = [self.brithYear.text integerValue];
    person.height = [self.height.text floatValue];
    person.goalWeight = [self.weight.text floatValue];
    person.goalStep = [self.steps.text integerValue];
    [[PLDataBaseManager shareManager] updatePerson:person];
    
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = ColorWithBackGround;
    
    self.tableView.separatorColor = ColorWithBackGround;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    tap.cancelsTouchesInView = NO;
    tap.numberOfTapsRequired = 1;
    [self.tableView addGestureRecognizer:tap];
    
    PLPersonInformation *person = [[PLDataBaseManager shareManager] personInformation];
    self.gender.text = person.gender;
    self.brithYear.text = [NSString stringWithFormat:@"%ld", person.brithday];
    self.height.text = [NSString stringWithFormat:@"%ld", person.height];
    self.weight.text = [NSString stringWithFormat:@"%.1f", person.goalWeight];
    self.steps.text = [NSString stringWithFormat:@"%ld", person.goalStep];
    self.height.delegate = self;
    self.weight.delegate = self;
    self.steps.delegate = self;
    
    
    [self createLabel];
    
    
    
    
    
    UIView *genderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height / 3)];
    
    self.gender.inputView = genderView;
    self.genderPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT /3)];
    [genderView addSubview:_genderPicker];
    _genderPicker.delegate = self;
    _genderPicker.dataSource = self;
    
    
    UIView *birthView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height / 3)];
    
    self.brithYear.inputView = birthView;
    self.brithPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT /3)];
    [birthView addSubview:_brithPicker];
    _brithPicker.delegate = self;
    _brithPicker.dataSource = self;
    
    
    
}



#pragma mark - pickerView协议方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;

}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if ([pickerView isEqual:_genderPicker]) {
        return self.genderArray.count;
    }
    else if([pickerView isEqual:_brithPicker]) {
    
        return self.brithArray.count;
    
    }
    
    return 0;

}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if([pickerView isEqual:_genderPicker]) {
    
        return self.genderArray[row];
    }
    else if([pickerView isEqual:_brithPicker]) {
    
        
        return self.brithArray[row];
    }
    
    return nil;
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if ([pickerView isEqual:_genderPicker]) {
        
        self.gender.text = self.genderArray[row];
    } else if ([pickerView isEqual:_brithPicker]) {
    
        self.brithYear.text = self.brithArray[row];
    }
    


}

#pragma mark - 私有
- (void)createLabel {
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 200)];
    self.tableView.tableFooterView = footView;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, WIDTH, 20)];
    label.text = @"完善基本信息令运动结果更准确";
    label.textColor = [UIColor grayColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:14.f];
    [footView addSubview:label];
    

}


- (void)tapAction {
    [self.view endEditing:YES];

}

#pragma mark - textfield

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    
    if (textField == self.height) {
        if (string.length > 0) {
            unichar single = [string characterAtIndex:0];
            if (single == '.') {
                return NO;
            }
            if (textField.text.length >= 3) {
                return NO;
            }
        }
    }
    if (textField == self.weight) {
        
        if ([textField.text rangeOfString:@"."].location==NSNotFound) {
            _isHaveDian = NO;
        }
        if ([textField.text rangeOfString:@"0"].location==NSNotFound) {
            _isFirstZero = NO;
        }
        
        if ([string length]>0)
        {
            unichar single=[string characterAtIndex:0];//当前输入的字符
            if ((single >='0' && single<='9') || single=='.')//数据格式正确
            {
                
                if([textField.text length]==0){
                    if(single == '.' || single == '0'){
                        //首字母不能为小数点
                        return NO;
                    }
                    
                }
                
                if (single=='.'){
                    if(!_isHaveDian)//text中还没有小数点
                    {
                        _isHaveDian=YES;
                        return YES;
                    }else{
                        return NO;
                    }
                }else if(single=='0'){
                    if ((_isFirstZero&&_isHaveDian)||(!_isFirstZero&&_isHaveDian)) {
                        //首位有0有.（0.01）或首位没0有.（10200.00）可输入两位数的0
                        if([textField.text isEqualToString:@"0.0"]){
                            return NO;
                        }
                        NSRange ran=[textField.text rangeOfString:@"."];
                        int tt=(int)(range.location-ran.location);
                        if (tt <= 2){
                            return YES;
                        }else{
                            return NO;
                        }
                    }else if (_isFirstZero&&!_isHaveDian){
                        //首位有0没.不能再输入0
                        return NO;
                    }else{
                        return YES;
                    }
                }else{
                    if (_isHaveDian){
                        //存在小数点，保留两位小数
                        NSRange ran=[textField.text rangeOfString:@"."];
                        int tt= (int)(range.location-ran.location);
                        if (tt <= 2){
                            return YES;
                        }else{
                            return NO;
                        }
                    }else if(_isFirstZero&&!_isHaveDian){
                        //首位有0没点
                        return NO;
                    }else{
                        return YES;
                    }
                }
            }else{
                //输入的数据格式不正确
                return NO;
            }
        }else{
            return YES;
        }
        

    }
    
    if (textField == self.steps) {
        
        if (string.length > 0) {
            
            if (textField.text.length >= 5) {
                return NO;
            }
        }
        
    }
    return YES;
    
}

#pragma mark - tableView
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    switch (indexPath.row) {
        case 0:
            [self.gender becomeFirstResponder];
            break;
       
        case 1:
            [self.brithYear becomeFirstResponder];
            break;
            
        case 2:
            [self.height becomeFirstResponder];
            break;
            
        case 3:
            [self.weight becomeFirstResponder];
            break;
            
        case 4:
            [self.steps becomeFirstResponder];
            break;
            
        default:
            break;
    }
    

}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
