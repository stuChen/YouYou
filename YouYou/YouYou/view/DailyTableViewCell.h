//
//  DailyTableViewCell.h
//  YouYou
//
//  Created by Chen on 15/7/2.
//  Copyright (c) 2015年 Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DailyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *DateLabel;
@property (weak, nonatomic) IBOutlet UILabel *TypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *Plan;
@property (weak, nonatomic) IBOutlet UILabel *Status;

- (void)initData:(NSDictionary *)dic type:(BOOL)isPlan;

@end
