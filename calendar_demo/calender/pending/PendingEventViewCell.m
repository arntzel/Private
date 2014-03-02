

#import "PendingEventViewCell.h"
#import "Utils.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>
#import "UserEntity.h"
#import "ContactEntity.h"
#import "CreatorEntity.h"

@implementation PendingEventViewCell

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


-(void) refreshView:(FeedEventEntity*) event
{

    if(event == nil) {
        self.lableEmpty.hidden = NO;

        self.imgView.hidden = YES;
        self.labelTitle.hidden = YES;
        self.labelAttendees.hidden = YES;
        self.lableFinalTime.hidden = YES;

        return;
    }
    
    self.lableEmpty.hidden = YES;
    
    self.labelTitle.text = event.title;

    NSString * headerUrl = event.creator.avatar_url;

    [self.imgView.layer setCornerRadius:self.imgView.frame.size.width / 2];
    self.imgView.layer.masksToBounds = YES;
    
    [self.imgView setImageWithURL:[NSURL URLWithString:headerUrl] placeholderImage:[UIImage imageNamed:@"header.png"]];

    self.labelAttendees.text = [Utils getAttendeeText:event];
}


+(PendingEventViewCell*) createView {

    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"PendingEventViewCell" owner:self options:nil];
    PendingEventViewCell * view = (PendingEventViewCell*)[nibView objectAtIndex:0];
    return view;
    
}

@end
