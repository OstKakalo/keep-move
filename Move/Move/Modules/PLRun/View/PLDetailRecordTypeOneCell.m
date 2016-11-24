//
//  PLDetailRecordTypeOneCell.m
//  Move
//
//  Created by PhelanGeek on 2016/11/8.
//  Copyright © 2016年 PhelanGeek. All rights reserved.
//

#import "PLDetailRecordTypeOneCell.h"
#import "PLInfoModel.h"

@interface PLDetailRecordTypeOneCell ()
<
    UITextFieldDelegate
>
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UITextField *stepCountTextField;
@property (weak, nonatomic) IBOutlet UITextField *kmTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *calorieTextField;

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *stepCountView;
@property (weak, nonatomic) IBOutlet UIView *kmView;
@property (weak, nonatomic) IBOutlet UIView *calorieView;

@end

@implementation PLDetailRecordTypeOneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _stepCountTextField.delegate = self;
    _stepCountTextField.keyboardType = UIKeyboardTypeNumberPad;
    [_stepCountTextField setValue:PLYELLOW forKeyPath:@"_placeholderLabel.textColor"];

    _kmTextFiled.delegate = self;
    _kmTextFiled.keyboardType = UIKeyboardTypeNumberPad;
    [_kmTextFiled setValue:PLYELLOW forKeyPath:@"_placeholderLabel.textColor"];
    
    _calorieTextField.delegate = self;
    _calorieTextField.keyboardType = UIKeyboardTypeNumberPad;
    [_calorieTextField setValue:PLYELLOW forKeyPath:@"_placeholderLabel.textColor"];
    

    UITapGestureRecognizer *tapTopView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTopView:)];
    [_topView addGestureRecognizer:tapTopView];
    
    UITapGestureRecognizer *tapStepCountView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapStepCountView:)];
    [_stepCountView addGestureRecognizer:tapStepCountView];
    
    UITapGestureRecognizer *tapkmView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapkmView:)];
    [_kmView addGestureRecognizer:tapkmView];
    
    UITapGestureRecognizer *calorieView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCalorieView:)];
    [_calorieView addGestureRecognizer:calorieView];

}


- (void)tapTopView:(UITapGestureRecognizer *)tap {
    //NSLog(@"tapView");
    [self.delegate tapViewDelegate];
}

- (void)tapStepCountView:(UITapGestureRecognizer *)tap {
    //NSLog(@"tapStepCountView");
    [self.delegate tapStepCountDelegate];
}

- (void)tapkmView:(UITapGestureRecognizer *)tap {
    //NSLog(@"tapkmView");
    [self.delegate tapKmDelegate];
}

- (void)tapCalorieView:(UITapGestureRecognizer *)tap {
    //NSLog(@"tapCalorieView");
    [self.delegate tapCalorieDelegate];
}

- (void)setTime:(NSString *)time {
    _timeLabel.text = time;
}

- (void)setInfoModel:(PLInfoModel *)infoModel {
    _infoModel = infoModel;
    if (_infoModel.time == nil) {
        _timeLabel.text = @"30分钟";
    }else{
        _timeLabel.text = infoModel.time;
    }
    
    _stepCountTextField.text = _infoModel.stepCount;
    _kmTextFiled.text = _infoModel.km;
    _calorieTextField.text = _infoModel.calorie;

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //NSLog(@"%@", string);
    if (string.length > 0) {
        if (textField.text.length >= 4) {
            return NO;
        }
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    //NSLog(@"%@", textField.text);
    NSString *string = textField.text;
    
    if ([string hasPrefix:@"0"]) {
        string = [string substringFromIndex:1];
        if ([string hasPrefix:@"0"]) {
            string = [string substringFromIndex:1];
            if ([string hasPrefix:@"0"]) {
                string = [string substringFromIndex:1];
                if ([string hasPrefix:@"0"]) {
                    if ([textField isEqual:_stepCountTextField]) {
                        _stepCountTextField.text = @"0";
                        _infoModel.stepCount = @"0";
                    }else if ([textField isEqual:_kmTextFiled]){
                        _kmTextFiled.text = @"0";
                        _infoModel.km = @"0";
                    }else{
                        _calorieTextField.text = @"0";
                        _infoModel.calorie = @"0";
                    }
                }else{
                    if ([textField isEqual:_stepCountTextField]) {
                        _stepCountTextField.text = string;
                        _infoModel.stepCount = string;
                    }else if ([textField isEqual:_kmTextFiled]){
                        _kmTextFiled.text = string;
                        _infoModel.km = string;
                    }else{
                        _calorieTextField.text = string;
                        _infoModel.calorie = string;
                    }
                }
            }else{
                if ([textField isEqual:_stepCountTextField]) {
                    _stepCountTextField.text = string;
                    _infoModel.stepCount = string;
                }else if ([textField isEqual:_kmTextFiled]){
                    _kmTextFiled.text = string;
                    _infoModel.km = string;
                }else{
                    _calorieTextField.text = string;
                    _infoModel.calorie = string;
                }
            }
        }else{
            if ([textField isEqual:_stepCountTextField]) {
                _stepCountTextField.text = string;
                _infoModel.stepCount = string;
            }else if ([textField isEqual:_kmTextFiled]){
                _kmTextFiled.text = string;
                _infoModel.km = string;
            }else{
                _calorieTextField.text = string;
                _infoModel.calorie = string;
            }
        }
    }else{
        if ([textField isEqual:_stepCountTextField]) {
            _stepCountTextField.text = string;
            _infoModel.stepCount = string;
        }else if ([textField isEqual:_kmTextFiled]){
            _kmTextFiled.text = string;
            _infoModel.km = string;
        }else{
            _calorieTextField.text = string;
            _infoModel.calorie = string;
        }
    }
    //NSLog(@"%@", _infoModel);
}



@end
