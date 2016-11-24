//
//  ViewController.m
//  Move
//
//  Created by PhelanGeek on 2016/11/2.
//  Copyright (c) 2015年 FENGSHENG. All rights reserved.
//

#import "MyCalendarItem.h"


@interface MyCalendarItem ()

@property (nonatomic, assign) NSInteger days;
@property (nonatomic, assign) BOOL flag;

@end

@implementation MyCalendarItem
{
    UILabel *headlabel;
    UIButton  *_selectButton;
    NSMutableArray *_daysArray;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _daysArray = [NSMutableArray arrayWithCapacity:42];
        for (int i = 0; i < 42; i++) {
            UIButton *button = [[UIButton alloc] init];
            button.titleLabel.font = [UIFont systemFontOfSize:14.0];
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            button.layer.cornerRadius = 18.0f;
            

            
            [button setTitleColor:[UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51 / 255.0 alpha:1] forState:UIControlStateSelected];

            
            
            [button addTarget:self action:@selector(logDate:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = 100 + i;
            [self addSubview:button];
            [_daysArray addObject:button];
            
        }
        self.backgroundColor = [UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51 / 255.0 alpha:1];
    }
    return self;
}

#pragma mark - date
//几天
- (NSInteger)day:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components day];
}
//几月
- (NSInteger)month:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components month];
}
//哪一年
- (NSInteger)year:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components year];
}

- (NSInteger)firstWeekdayInThisMonth:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:1];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    return firstWeekday - 1;
}
- (NSInteger)totaldaysInMonth:(NSDate *)date{
    NSRange daysInOfMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return daysInOfMonth.length;
}

#pragma mark 上个月
- (NSDate *)lastMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}
#pragma mark  下个月
- (NSDate*)nextMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = +1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}
#pragma mark - create View
- (void)setDate:(NSDate *)date{
    _date = date;
    [self createCalendarViewWith:date];
}
- (void)createCalendarViewWith:(NSDate *)date{
    
    
    CGFloat itemW     = self.frame.size.width / 7;
    
    
    CGFloat itemH     = self.frame.size.height / 8;
    
    CGFloat lendth = 36;
    
    CGFloat margin = (itemW - lendth) / 2;
    
    UIView *headView = [[UIView alloc] init];
    headView.frame = CGRectMake(0, 0, self.frame.size.width, 64);
    headView.backgroundColor = [UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51 / 255.0 alpha:1];
    [self addSubview:headView];
    
    
    
    
    
    
    // 1.year month
    headlabel = [[UILabel alloc] init];
    headlabel.text   = [NSString stringWithFormat:@"%li年%li月",[self year:date],[self month:date]];
    headlabel.textColor = [UIColor colorWithRed:0.96 green:0.72 blue:0.07 alpha:1.0];
    headlabel.font   = [UIFont systemFontOfSize:19];
    headlabel.frame = CGRectMake(0, 4, self.frame.size.width, 60);
    headlabel.textAlignment   = NSTextAlignmentCenter;
    headlabel.userInteractionEnabled = YES;
    headlabel.backgroundColor = [UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51 / 255.0 alpha:1];

    [headView addSubview:headlabel];
    
    //2.1 上月下月按钮
    //创建左右按钮 选择月份
            NSArray * arraytitle = @[@"上一月",@"下一月"];
            for (int i = 0; i < 2; i++) {
                UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake((self.frame.size.width - 60)*i, 4, 60, 64);
                [headlabel addSubview:btn];
                btn.tag = 20 + i;
                btn.titleLabel.font = [UIFont systemFontOfSize:14.0];
                [btn setTitle:arraytitle[i] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                [btn setTitleColor:[UIColor colorWithRed:0.96 green:0.72 blue:0.07 alpha:1.0]forState:UIControlStateNormal];
                [headView addSubview:btn];
            }
    
    // 2.weekday
    NSArray *array = @[@"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六"];
    UIView *weekBg = [[UIView alloc] init];
    weekBg.backgroundColor = [UIColor colorWithRed:31 / 255.0 green:31 / 255.0 blue:31 / 255.0 alpha:1];
    weekBg.frame = CGRectMake(0, CGRectGetMaxY(headlabel.frame), self.frame.size.width, 30);
    [self addSubview:weekBg];
    for (int i = 0; i < 7; i++) {
        UILabel *week = [[UILabel alloc] init];
        week.text     = array[i];
        week.font     = [UIFont systemFontOfSize:12];
        week.frame    = CGRectMake(itemW * i, 0, itemW, 30);
        week.textAlignment   = NSTextAlignmentCenter;
        week.backgroundColor = [UIColor clearColor];
        week.textColor  = [UIColor grayColor];
        [weekBg addSubview:week];
    }
    
    //  3.days (1-31)
    for (int i = 0; i < 42; i++) {
        
        int x = (i % 7) * itemW + margin;
        int y = (i / 7) * itemH + CGRectGetMaxY(weekBg.frame) + margin;
        
        UIButton *dayButton = _daysArray[i];
        dayButton.frame = CGRectMake(x, y, lendth, lendth);
        //上个月的总天数
        NSInteger daysInLastMonth = [self totaldaysInMonth:[self lastMonth:date]];
        //这个月的总天数
        NSInteger daysInThisMonth = [self totaldaysInMonth:date];
        //重要方法 第一周第一天是周几    1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
        NSInteger firstWeekday    = [self firstWeekdayInThisMonth:date];
        
        NSInteger day = 0;
        if (i < firstWeekday) {
            day = daysInLastMonth - firstWeekday + i + 1;
            [self setStyle_BeyondThisMonth:dayButton];
            
        }else if (i > firstWeekday + daysInThisMonth - 1){
            day = i + 1 - firstWeekday - daysInThisMonth;
            [self setStyle_BeyondThisMonth:dayButton];
            
        }else{
            day = i - firstWeekday + 1;
            [self setStyle_notToday:dayButton];
        }
        
        
        
        [dayButton setTitle:[NSString stringWithFormat:@"%li", day] forState:UIControlStateNormal];
        
        // this month
        if ([self month:date] == [self month:[NSDate date]]) {
            NSInteger todayIndex = [self day:date] + firstWeekday - 1;
            if(i ==  todayIndex){
                [self setStyle_Today:dayButton];
            }
            
            if (todayIndex > self.dayday  + firstWeekday - 1) {
                if (i < todayIndex - self.dayday + 1 && i > firstWeekday - 1) {
                    [self setStyle_gray:dayButton];
                }
            }
            
            
            if (i > todayIndex && i <= firstWeekday + daysInThisMonth - 1) {
                [self setStyle_AfterToday:dayButton];
            }
        }
        
    }
}

#pragma mark 月份选择按钮
-(void)btnClick:(UIButton *)btn{
    if (btn.tag == 20) {
        //NSLog(@"上");
        _date = [self lastMonth:_date];
        headlabel.text   = [NSString stringWithFormat:@"%li年%li月",[self year:_date],[self month:_date]];
    }else{
        //NSLog(@"下");
        _date = [self nextMonth:_date];
        headlabel.text   = [NSString stringWithFormat:@"%li年%li月",[self year:_date],[self month:_date]];
    }
    [self refreshViewWithDate:_date];
}
-(void)refreshViewWithDate:(NSDate *)date{
    for (int i = 0; i < 42; i++) {
        UIButton * btn = (UIButton *)[self viewWithTag:100+i];
        if (btn.layer.borderWidth) {
            btn.layer.borderWidth = 0;
        }
        //上个月的总天数
        NSInteger daysInLastMonth = [self totaldaysInMonth:[self lastMonth:date]];
        //这个月的总天数
        NSInteger daysInThisMonth = [self totaldaysInMonth:date];
        //重要方法 第一周第第一天是周几    1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
        NSInteger firstWeekday    = [self firstWeekdayInThisMonth:date];
        
        NSInteger day = 0;
        if (i < firstWeekday) {
            day = daysInLastMonth - firstWeekday + i + 1;
            [self setStyle_BeyondThisMonth:btn];
        }else if (i > firstWeekday + daysInThisMonth - 1){
            day = i + 1 - firstWeekday - daysInThisMonth;
            [self setStyle_BeyondThisMonth:btn];
        }else{
            day = i - firstWeekday + 1;
            [self setStyle_notToday:btn];
        }
        [btn setTitle:[NSString stringWithFormat:@"%li", day] forState:UIControlStateNormal];
        // this month
        NSInteger todayIndex = [self day:date] + firstWeekday - 1;
        if (btn.selected) {
            btn.selected = NO;
            btn.backgroundColor = [UIColor clearColor];
        }
        if ([self isThisYearAndMonth]) {
            if(i ==  todayIndex){
                [self setStyle_Today:btn];
            }
            if (todayIndex > self.dayday  + firstWeekday - 1) {
                if (i < todayIndex - self.dayday + 1 && i > firstWeekday - 1) {
                    [self setStyle_gray:btn];
                    self.flag = YES;
                }
            }
            
            if (i > todayIndex &&  i <= firstWeekday + daysInThisMonth - 1) {
                [self setStyle_AfterToday:btn];
            }
            
        } else if([self isAfterThisMonth]) {
            
            if (i == todayIndex) {
                [self setStyle_notToday:btn];
            }
            if (i <=firstWeekday + daysInThisMonth - 1 && i >= firstWeekday) {
                
                [self setStyle_AfterToday:btn];
            }
            
        
        
        }else {
            
            
            NSDateComponents *comps = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:[NSDate date]];
            //NSLog(@"%ld", comps.day);
            
            if ([self isThisYearAndLastMonth] && _flag == NO) {
                if (i > firstWeekday - 1 && i <= firstWeekday + daysInThisMonth - 1 - self.dayday + comps.day) {
                    [self setStyle_gray:btn];
                }
            } else {
                [self setStyle_gray:btn];
            }
            
            
//            if (i == todayIndex) {
//                [self setStyle_notToday:btn];
//            }
        }
    }
    
}
/**
 
 *  是否为今年的当前月
 
 */

- (BOOL)isThisYearAndMonth{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitYear | NSCalendarUnitMonth;
    // 1.获得当前时间的年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    
    // 2.获得self的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self.date];
    return (nowCmps.year == selfCmps.year)&&(nowCmps.month == selfCmps.month);
}

- (BOOL)isThisYearAndLastMonth {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitYear | NSCalendarUnitMonth;
    // 1.获得当前时间的年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    // 2.获得self的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self.date];
    return (nowCmps.year == selfCmps.year)&&(nowCmps.month - 1 == selfCmps.month);


}

- (BOOL) isAfterThisMonth {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitYear | NSCalendarUnitMonth;
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    NSDateComponents *selfCmps = [calendar components:unit fromDate:_date];
    if (nowCmps.year < selfCmps.year) {
        return YES;
    }
    
    if (nowCmps.year == selfCmps.year) {
        if (nowCmps.month < selfCmps.month) {
            return YES;
        }
        return NO;
    }
    
    return NO;


}




#pragma mark - output date
-(void)logDate:(UIButton *)dayBtn
{
    _selectButton.selected = NO;
    _selectButton.backgroundColor = [UIColor clearColor];
    dayBtn.selected = YES;
    _selectButton = dayBtn;
    if (_selectButton.selected) {
        _selectButton.backgroundColor = [UIColor colorWithRed:0.96 green:0.72 blue:0.07 alpha:1.0];
        
    }
    
    
    NSInteger day = [[dayBtn titleForState:UIControlStateNormal] integerValue];
    NSDateComponents *comp = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.date];
    if (self.calendarBlock) {
        self.calendarBlock(day, [comp month], [comp year]);
    }
}


#pragma mark - date button style

// 单纯置灰

- (void)setStyle_gray:(UIButton *)btn {

    btn.enabled = NO;
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];


}

//不是这个月的 置灰点击
- (void)setStyle_BeyondThisMonth:(UIButton *)btn
{
    btn.enabled = NO;
    [btn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
}
//今天之前的日期置灰不可点击
- (void)setStyle_BeforeToday:(UIButton *)btn
{
    btn.enabled = NO;
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
}
//今天的日期  黄色背景
- (void)setStyle_Today:(UIButton *)btn
{
    btn.enabled = YES;
    [btn setTitleColor:[UIColor colorWithRed:0.96 green:0.72 blue:0.07 alpha:1.0] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51 / 255.0 alpha:1] forState:UIControlStateSelected];
    btn.layer.borderWidth = 1.5f;
    btn.layer.borderColor = [UIColor colorWithRed:0.96 green:0.72 blue:0.07 alpha:1.0].CGColor;
    
    
    
}
- (void)setStyle_notToday:(UIButton *)btn
{
    btn.enabled = YES;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    

}
//今天之后的日期不能点击
- (void)setStyle_AfterToday:(UIButton *)btn
{
    btn.enabled = NO;
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
}

//将NSDate按yyyy-MM-dd格式时间输出
-(NSString*)nsdateToString:(NSDate *)date
{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString* string=[dateFormat stringFromDate:date];
    return string;
}
@end
