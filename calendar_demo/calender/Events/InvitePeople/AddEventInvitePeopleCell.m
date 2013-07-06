//
//  AddEventInvitePeopleCell.m
//  calender
//
//  Created by zyax86 on 13-7-6.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "AddEventInvitePeopleCell.h"

@implementation AddEventInvitePeopleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}

- (void)initUI
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 48)];
    self.selectedBackgroundView = view;
    [view setBackgroundColor:[UIColor clearColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:NO];
    if (selected) {
        self.selectedFlagView.image = [UIImage imageNamed:@"addInviteFlag"];
    }
    else
    {
        self.selectedFlagView.image = [UIImage imageNamed:@"addInviteBox.png"];
    }

    // Configure the view for the selected state
}

@end
