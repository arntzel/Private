//
//  EventLocationCell.m
//  Calvin
//
//  Created by fangxiang on 14-1-15.
//  Copyright (c) 2014年 fang xiang. All rights reserved.
//

#import "EventLocationCell.h"

@implementation EventLocationCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+(EventLocationCell *) creatView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"EventLocationCell" owner:self options:nil];
    EventLocationCell * view = (EventLocationCell*)[nibView objectAtIndex:0];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

@end
