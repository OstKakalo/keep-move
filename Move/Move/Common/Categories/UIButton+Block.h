//
//  UIButton+Block.h
//  BaseProject
//
//  Created by Eiwodetianna on 15/8/5.
//  Copyright (c) 2015年 Eiwodetianna. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^Callback)();

@interface UIButton (Block)

- (void)handleControlEvent:(UIControlEvents)controlEvent withBlock:(Callback)block;

@end
