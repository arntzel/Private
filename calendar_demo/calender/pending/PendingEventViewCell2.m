
#import "PendingEventViewCell2.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>

#import "Utils.h"

@implementation PendingEventViewCell2

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
    
    self.labelAttendees.text = [Utils getAttendeeText:event];
}


+(PendingEventViewCell2*) createView {
    
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"PendingEventViewCell2" owner:self options:nil];
    PendingEventViewCell2 * view = (PendingEventViewCell2*)[nibView objectAtIndex:0];
    return view;
    
}
@end
