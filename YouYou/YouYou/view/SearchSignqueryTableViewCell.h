//
//  SearchSignqueryTableViewCell.h
//  YouYou
//
//  Created by Chen on 15/7/4.
//  Copyright (c) 2015年 Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchSignqueryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *DateLabe;
@property (weak, nonatomic) IBOutlet UILabel *WeekDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *signInLabel;
@property (weak, nonatomic) IBOutlet UILabel *SignInTImeLabel;
@property (weak, nonatomic) IBOutlet UILabel *SignOutLabel;
@property (weak, nonatomic) IBOutlet UILabel *SignOutTImeLabel;
@property (weak, nonatomic) IBOutlet UILabel *StatusLabel;

- (void)initData:(NSDictionary *)data;

@end
