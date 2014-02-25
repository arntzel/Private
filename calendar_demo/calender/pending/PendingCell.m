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

    if (pendingCellTypeMine == ct) {
        if (event.propose_starts != nil && event.propose_starts.count > 0)
        {
            self.actionText.text = @"Confirm Time";
        }
        else {
            self.actionText.text = @"Add time";
        }
    }
    else
    if (pendingCellTypeNotMine == ct) {
        if (event.propose_starts != nil && event.propose_starts.count > 0)
        {
            self.actionText.text = @"Vote";
        }
        else {
            self.actionText.text = @"Propose time";
        }
    }
    else {
        assert(NO);
    }
    
    
    UserEntity * user = [event getCreator];
    NSString * headerUrl = user.contact.avatar_url;
    
    if ( [event isBirthdayEvent] ) {
    }
    
    self.avatar.layer.cornerRadius = self.avatar.frame.size.width/2;
    self.avatar.layer.masksToBounds = YES;
    
    // set user avatar's boarder to 1px solid #d1d9d2
    self.avatar.layer.borderWidth = 1.0;
    self.avatar.layer.borderColor = [[UIColor generateUIColorByHexString:@"#d1d9d2"] CGColor];
    
    
    if (headerUrl == nil) {
        self.avatar.image = [UIImage imageNamed:@"default_person.png"];
    }
    else {
        [self.avatar setImageWithURL:[NSURL URLWithString:headerUrl] placeholderImage:[UIImage imageNamed:@"default_person.png"]];
    }
}

@end
