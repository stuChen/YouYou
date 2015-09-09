//
//  NoticeTableViewCell.h
//  YouYou
//
//  Created by Chen on 15/7/2.
//  Copyright (c) 2015年 Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoticeTableViewCell : UITableViewCell
@property (strong) UILabel *statusLabel;

- (void)initData:(NSDictionary *)dic;
@end
