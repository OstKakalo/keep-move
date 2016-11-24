//
//  PLInitialWeightTableViewCell.m
//  Move
//
//  Created by 胡梦龙 on 16/10/19.
//  Copyright © 2016年 PhelanGeek. All rights reserved.
//

#import "PLInitialWeightTableViewCell.h"

#import "PLBounceWeightView.h"
#import "PLMineViewController.h"

#import "PLHistoryInformation.h"
@interface PLInitialWeightTableViewCell ()

<
PLBounceWeightViewDelegate,
UITextFieldDelegate
>

@property (nonatomic, strong) UIView *glassView;

@property (nonatomic, assign) BOOL isHaveDian;
@property (nonatomic, assign) BOOL isFirstZero;

@end

@implementation PLInitialWeightTableViewCell


- (IBAction)writeWeight:(id)sender {
    
    
    [self pl_createGlass];
    
}


#pragma mark - textField协议


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    
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
    
    return YES;
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//
//    return [self validateNumberByRegExp:string];
//}
//
//
//
//
//#pragma mark - 私有方法
//
//
//- (BOOL)validateNumberByRegExp:(NSString *)string {
//    BOOL isValid = YES;
//    NSUInteger len = string.length;
//    if (len > 0) {
//         NSString *numberRegex = @"^[0-9]*$";
//         NSPredicate *numberPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];
//         isValid = [numberPredicate evaluateWithObject:string];
//     }
//    return isValid;
//}



- (void)pl_bouceWeightView:(PLBounceWeightView *)bouceWeightView style:(NSInteger)style {
    if (style == 0) {
        [_glassView removeFromSuperview];
    } else {
        
        
        
        CGFloat num = [bouceWeightView.weightLabel.text floatValue];
        
        if (num < 500 && num > 0) {
            
            
            
            [_glassView removeFromSuperview];
            
            PLHistoryInformation *history = [[PLHistoryInformation alloc] init];
            history.weight = num;
            
            history.time = bouceWeightView.timeLabel.text;
            
            [[PLDataBaseManager shareManager] insertHistoryRecord:history];
            
           

            
            [((PLMineViewController *)[self ml_viewController]).tableView reloadData];
            
            
            
            
            
            
        } else {
            
            
            
            [UIView showMessage:@"请输入真实体重哦"];
            bouceWeightView.weightLabel.text = nil;
          
            
        
        }
        
        
    }

}

- (void)pl_createGlass {
    
    
    self.glassView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *visualView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    visualView.frame = [UIScreen mainScreen].bounds;
    [_glassView addSubview:visualView];
    [self.window addSubview:_glassView];
    
    UIView *view = [[UIView alloc] init];
    view.layer.cornerRadius = 10.f;
    view.frame = CGRectMake((WIDTH - (WIDTH - 40)) / 2, 100, WIDTH - 40, 240);
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.7;
    [_glassView addSubview:view];
    
    
    
    PLBounceWeightView *bounceWeight = [[NSBundle mainBundle] loadNibNamed:@"PLBounceWeightView" owner:nil options:nil].lastObject;
    bounceWeight.layer.cornerRadius = 10.f;
    bounceWeight.delegate = self;
    [bounceWeight.weightLabel becomeFirstResponder];
    bounceWeight.weightLabel.delegate = self;
    bounceWeight.frame = CGRectMake((WIDTH - (WIDTH - 40)) / 2, 100, WIDTH - 40, 240);
    [_glassView addSubview:bounceWeight];
    

}



- (UIViewController *)ml_viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}


@end
