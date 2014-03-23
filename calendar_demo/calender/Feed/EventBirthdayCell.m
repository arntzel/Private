//
//  EventBirthdayCell.m
//  Calvin
//
//  Created by Yevgeny on 3/22/14.
//  Copyright (c) 2014 Pencil Me, Inc. All rights reserved.
//

#import "EventBirthdayCell.h"
#import "EventViewCell.h"
#import "EventView.h"
#import "Utils.h"
#import "ViewUtils.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>

#import "CreatorEntity.h"
#import "ContactEntity.h"
#import "UIColor+Hex.h"

#import "EventAttendeeEntity.h"
#import "UserModel.h"


@implementation EventBirthdayCell

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

}

-(void) refreshView:(FeedEventEntity *) event lastForThisDay:(BOOL)lastForThisDay
{
    self.separator.hidden = lastForThisDay;
 
    NSString * headerUrl = event.thumbnail_url;
    
    if(headerUrl == nil) {
        self.imgUser.image = [UIImage imageNamed:@"default_person.png"];
    } else {
        [self.imgUser setImageWithURL:[NSURL URLWithString:headerUrl]
                     placeholderImage:[UIImage imageNamed:@"default_person.png"]];
    }
    
    self.imgUser.layer.cornerRadius = self.imgUser.frame.size.width/2;
    self.imgUser.layer.masksToBounds = YES;
    
    self.title.text = event.title;
}

@end
