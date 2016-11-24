//
//  PLBounceWeightView.m
//  Move
//
//  Created by 胡梦龙 on 16/10/20.
//  Copyright © 2016年 PhelanGeek. All rights reserved.
//

#import "PLBounceWeightView.h"

#import "NSDate+Categories.h"

@interface PLBounceWeightView ()

@property (weak, nonatomic) IBOutlet UIButton *saveButton;








@end




@implementation PLBounceWeightView


- (void)awakeFromNib {

    [super awakeFromNib];
    
    self.saveButton.layer.borderColor = PLYELLOW.CGColor;
    self.saveButton.layer.borderWidth = 1;
    self.weightLabel.tintColor = PLYELLOW;
    
    self.timeLabel.text = [NSDate getSystemTimeStringWithFormat:@"yyyy年 MM月dd日 HH:mm"];
    

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (IBAction)backAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(pl_bouceWeightView:style:)]) {
        [self.delegate pl_bouceWeightView:self style:0];
    }
    
}

- (IBAction)saveAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(pl_bouceWeightView:style:)]) {
        [self.delegate pl_bouceWeightView:self style:1];
    }
}


@end
