//
//  PLProtocolViewController.m
//  Move
//
//  Created by 胡梦龙 on 16/11/11.
//  Copyright © 2016年 PhelanGeek. All rights reserved.
//

#import "PLProtocolViewController.h"

@interface PLProtocolViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textViews;

@end

@implementation PLProtocolViewController








- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {

    [super viewDidLayoutSubviews];
    self.textViews.contentOffset = CGPointMake(0, 0);
    self.textViews.editable = NO;

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
