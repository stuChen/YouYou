//
//  DailyWorkViewController.h
//  YouYou
//
//  Created by Chen on 15/6/29.
//  Copyright (c) 2015年 Chen. All rights reserved.
//

#import "BaseViewController.h"
#import "FSCalendar.h"

@interface DailyWorkViewController : BaseViewController <FSCalendarDataSource, FSCalendarDelegate>
@property (weak, nonatomic) FSCalendar *calendar;
@property (assign) BOOL isPlan;
@end
