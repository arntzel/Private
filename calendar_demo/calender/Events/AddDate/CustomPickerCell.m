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
    self.selectedBackgroundView = [[[UIView alloc] initWithFrame:self.bounds] autorelease];
    self.backgroundView.backgroundColor = [UIColor clearColor];
    
    CGRect labelFrame = self.labValue.frame;
    labelFrame.size.width = self.labelWidth;
    labelFrame.origin.x = 0;
    self.labValue.frame = labelFrame;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_labValue release];
    [super dealloc];
}
@end
