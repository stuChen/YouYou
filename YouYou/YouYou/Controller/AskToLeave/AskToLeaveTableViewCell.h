//
//  AskToLeaveTableViewCell.h
//  YouYou
//
//  Created by Chen on 15/7/10.
//  Copyright (c) 2015年 Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AskToLeaveTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *howLong;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *remark;

- (void)initData:(NSDictionary *)data;
@end
