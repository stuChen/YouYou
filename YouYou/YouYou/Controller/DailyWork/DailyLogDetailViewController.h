//
//  DailyLogDetailViewController.h
//  YouYou
//
//  Created by Chen on 15/7/3.
//  Copyright (c) 2015年 Chen. All rights reserved.
//

#import "BaseViewController.h"

@interface DailyLogDetailViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *ComStatus;
@property (weak, nonatomic) IBOutlet UILabel *typelabel;
@property (weak, nonatomic) IBOutlet UILabel *cust_name;
@property (weak, nonatomic) IBOutlet UILabel *Content;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *completeTime;


@property (weak, nonatomic) IBOutlet UILabel *dateType;
@property (weak, nonatomic) IBOutlet UILabel *contentType;
@property (weak, nonatomic) IBOutlet UILabel *workResult;


@property (weak, nonatomic) IBOutlet UILabel *audit_remark;
@property (weak, nonatomic) IBOutlet UILabel *audit_remarkDetail;




@property (strong) NSDictionary *data;

@property (assign) BOOL isPlan;

@end
