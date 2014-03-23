//
//  PendingCell.m
//  Calvin
//
//  Created by Yevgeny on 2/25/14.
//  Copyright (c) 2014 Pencil Me, Inc. All rights reserved.
//

#import "PendingCell.h"
#import "EventView.h"
#import "Utils.h"
#import "ViewUtils.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>

#import "UserEntity.h"
#import "ContactEntity.h"
#import "UIColor+Hex.h"
#import "CreatorEntity.h"

@implementation PendingCell

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

-(void) refreshView:(FeedEventEntity *) event lastForThisDay:(BOOL)lastForThisDay PendingCellType:(PendingCellType)ct
{
    self.separator.hidden = lastForThisDay;
    
    self.title.text = event.title;

//    if (pendingCellTypeMine == ct) {
//        if (event.propose_starts != nil && event.propose_starts.count > 0)
//        {
//            self.actionText.text = @"Confirm Time";
//            self.actionImage.image = [UIImage imageNamed:@"confirm_time_lg.png"];
//        }
//        else {
//            self.actionText.text = @"Add time";
//            self.actionImage.image = [UIImage imageNamed:@"add_time_lg.png"];
//        }
//    }
//    else
//    if (pendingCellTypeNotMine == ct) {
//        if (event.propose_starts != nil && event.propose_starts.count > 0)
//        {
//            self.actionText.text = @"Vote";
//            self.actionImage.image = [UIImage imageNamed:@"confirm_time_lg.png"];
//        }
//        else {
//            self.actionText.text = @"Propose time";
//            self.actionImage.image = [UIImage imageNamed:@"confirm_time_lg.png"];
//        }
//    }
//    else {
//        assert(NO);
//    }
    
    
    if (pendingCellTypeMine == ct) {
        if (event.max_proposed_end_time == nil ) {
            self.actionText.text = @"Propose time";
            self.actionImage.image = [UIImage imageNamed:@"add_time_lg.png"];
        }
        else {
            self.actionText.text = @"Confirm time";
            self.actionImage.image = [UIImage imageNamed:@"confirm_time_lg.png"];
        }
    }
    if (pendingCellTypeNotMine == ct) {
        if (event.max_proposed_end_time == nil ) {
            self.actionText.text = @"Propose time";
            self.actionImage.image = [UIImage imageNamed:@"add_time_lg.png"];
        }
        else {
            self.actionText.text = @"Vote";
            self.actionImage.image = [UIImage imageNamed:@"confirm_time_lg.png"];
        }
    }
    
    //CreatorEntity * user = event.creator;
    NSString * headerUrl = event.creator.avatar_url;
    
    if ( [event isBirthdayEvent] ) {
    }
    
    self.avatar.layer.cornerRadius = self.avatar.frame.size.width/2;
    self.avatar.layer.masksToBounds = YES;
    
    if (headerUrl == nil) {
        self.avatar.image = [UIImage imageNamed:@"default_person.png"];
    }
    else {
        [self.avatar setImageWithURL:[NSURL URLWithString:headerUrl] placeholderImage:[UIImage imageNamed:@"default_person.png"]];
    }
}

@end
