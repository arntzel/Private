//
//  CustomPickerCell.m
//  AddDate
//
//  Created by zyax86 on 13-6-23.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import "CustomPickerCell.h"

@implementation CustomPickerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)initUI
{
    CGFloat width = self.bounds.size.width * 3 / 8;
    CGRect labelFrame = self.labValue.frame;
    labelFrame.size.width = width;
    labelFrame.origin.x = 0;

    width = self.bounds.size.width * 4 / 8;
    labelFrame = self.labUnit.frame;
    labelFrame.size.width = width;
    labelFrame.origin.x = self.bounds.size.width * 4 / 8;
    self.labUnit.frame = labelFrame;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_labValue release];
    [_labUnit release];
    [super dealloc];
}
@end
