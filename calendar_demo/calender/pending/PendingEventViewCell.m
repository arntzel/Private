

#import "PendingEventViewCell.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>

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


-(void) refreshView:(Event*) event
{

    self.labelTitle.text = event.title;

    NSString * headerUrl = event.creator.avatar_url;

    if([headerUrl isKindOfClass: [NSNull class]]) {
        self.imgView.image = [UIImage imageNamed:@"header.png"];
    } else {
        [self.imgView setImageWithURL:[NSURL URLWithString:headerUrl]
                     placeholderImage:[UIImage imageNamed:@"header.png"]];
    }

    self.labelAttendees.text = [self getAttendeeText:event];
}

-(NSString *) getAttendeeText:(Event*)event {

    NSArray * atendees = event.attendees;

    int respCount = 0;
    int allCount = atendees.count;

    for(int i=0;i<allCount;i++) {

        EventAttendee * atd = [atendees objectAtIndex:i];

        if([atd.status isEqualToString:@"ACCEPT"]) {
            respCount ++;
        }
    }

    return [NSString stringWithFormat:@"%d/%d invitees have responsed", respCount, allCount];
}

+(PendingEventViewCell*) createView {

    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"PendingEventViewCell" owner:self options:nil];
    PendingEventViewCell * view = (PendingEventViewCell*)[nibView objectAtIndex:0];
    return view;
    
}

@end
