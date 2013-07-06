//
//  AddEventInvitePeopleCell.h
//  calender
//
//  Created by zyax86 on 13-7-6.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddEventInvitePeopleCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *selectedFlagView;
@property (retain, nonatomic) IBOutlet UILabel *peopleName;


- (void)initUI;
@end
