//
//  NoticeTableViewCell.m
//  YouYou
//
//  Created by Chen on 15/7/2.
//  Copyright (c) 2015年 Chen. All rights reserved.
//

#import "NoticeTableViewCell.h"

@implementation NoticeTableViewCell

- (void)awakeFromNib {
    // Initialization code
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
        _statusLabel.center = CGPointMake(ScreenWidth - 60, self.contentView.center.y);
        [self.contentView addSubview:_statusLabel];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)initData:(NSDictionary *)dic
{
    self.textLabel.text = [NSString stringWithFormat:@"%@",dic[@"msg_title"]];
        self.detailTextLabel.text = [NSString stringWithFormat:@"%@",dic[@"send_date"]];
    if (dic[@"read_status"]) {
        
        NSString *status;
//        switch ([dic[@"read_status"] integerValue]) {
//            case 0:
//                status = @"未读";
//                break;
//                
//            default:
//                break;
//        }
        [dic[@"read_status"] integerValue] == 0 ? (status = @"未读") : (status = @"已读");
        self.statusLabel.text = [NSString stringWithFormat:@"状态: %@",status];
    }
}

@end
