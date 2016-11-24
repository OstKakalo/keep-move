//
//  PLMenuView.m
//  Move
//
//  Created by PhelanGeek on 2016/11/2.
//  Copyright © 2016年 PhelanGeek. All rights reserved.
//

#import "PLMenuView.h"

@interface PLMenuView ()

@property (weak, nonatomic) IBOutlet UILabel *runLabel;
@property (weak, nonatomic) IBOutlet UILabel *rideLabel;

@property (weak, nonatomic) IBOutlet UIImageView *iconRunImageView;
@property (weak, nonatomic) IBOutlet UIImageView *iconRideImageView;

@property (weak, nonatomic) IBOutlet UIView *runView;
@property (weak, nonatomic) IBOutlet UIView *rideView;

@end

@implementation PLMenuView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
        
        _type = YES;
        
        _runLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
        _runView.userInteractionEnabled = YES;
        _rideView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapRun = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRunAction:)];
        [_runView addGestureRecognizer:tapRun];
        
        UITapGestureRecognizer *tapRide = [[UITapGestureRecognizer alloc] init];
        [tapRide addTarget:self action:@selector(tapRideAction:)];
        [_rideView addGestureRecognizer:tapRide];
        
    }
    return self;
}

- (void)tapRunAction:(UITapGestureRecognizer *)tap {
    _type = YES;
    _runLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    _iconRunImageView.image = [UIImage imageNamed:@"menuSelected"];
    
    _rideLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    _iconRideImageView.image = [UIImage imageNamed:@"menuNormal"];
}

- (void)tapRideAction:(UITapGestureRecognizer *)tap {
    _type = NO;
    _rideLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    _iconRideImageView.image = [UIImage imageNamed:@"menuSelected"];
    
    _runLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    _iconRunImageView.image = [UIImage imageNamed:@"menuNormal"];
}


@end
