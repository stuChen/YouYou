//
//  AskToLeaveTableViewCell.m
//  YouYou
//
//  Created by Chen on 15/7/10.
//  Copyright (c) 2015年 Chen. All rights reserved.
//

#import "AskToLeaveTableViewCell.h"

@implementation AskToLeaveTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)initData:(NSDictionary *)data
{
    self.time.text = [NSString stringWithFormat:@"休假时间:  %@~%@",data[@"begin_date"],data[@"end_date"]];
    self.howLong.text = [NSString stringWithFormat:@"%@天",data[@"day_count"]];
    self.type.text = [[Data Share] ChooseInfo:data key:@"off_status" array:[Data Share].OffStatusArray];
    self.remark.text = [NSString stringWithFormat:@"%@",data[@"audit_remark"]];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
