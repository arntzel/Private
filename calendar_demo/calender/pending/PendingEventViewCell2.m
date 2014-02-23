
#import "PendingEventViewCell2.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>

#import "Utils.h"
#import "UserEntity.h"
#import "ContactEntity.h"
#import "CreatorEntity.h"

@implementation PendingEventViewCell2

-(void) refreshView:(FeedEventEntity*) event
{
    
    if(event == nil) {
        self.lableEmpty.hidden = NO;

        self.imgView.hidden = YES;
        self.labelTitle.hidden = YES;
        self.labelAttendees.hidden = YES;

        return;
    }
    
    self.lableEmpty.hidden = YES;

    
    self.labelTitle.text = event.title;
    
    NSString * headerUrl = event.creator.avatar_url;

    [self.imgView.layer setCornerRadius:self.imgView.frame.size.width / 2];
    self.imgView.layer.masksToBounds = YES;

    if([headerUrl isKindOfClass: [NSNull class]]) {
        self.imgView.image = [UIImage imageNamed:@"header.png"];
    } else {
        [self.imgView setImageWithURL:[NSURL URLWithString:headerUrl]
                     placeholderImage:[UIImage imageNamed:@"header.png"]];
    }
    
    self.labelAttendees.text = [Utils getAttendeeText:event];
}


+(PendingEventViewCell2*) createView {
    
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"PendingEventViewCell2" owner:self options:nil];
    PendingEventViewCell2 * view = (PendingEventViewCell2*)[nibView objectAtIndex:0];
    
    return view;
    
}
@end
