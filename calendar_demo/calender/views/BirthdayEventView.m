

#import "BirthdayEventView.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>
#import "ViewUtils.h"

@implementation BirthdayEventView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(void) refreshView:(FeedEventEntity *) event
{
    self.labTitle.text = event.title;

    NSString * headerUrl = event.thumbnail_url;

    if(headerUrl == nil) {
        self.imgUser.image = [UIImage imageNamed:@"header.png"];
    } else {
        [self.imgUser setImageWithURL:[NSURL URLWithString:headerUrl]
                     placeholderImage:[UIImage imageNamed:@"header.png"]];
    }
}

+(BirthdayEventView *) createEventView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"BirthdayEventView" owner:self options:nil];
    BirthdayEventView * view = (BirthdayEventView*)[nibView objectAtIndex:0];
    view.imgUser.layer.cornerRadius = view.imgUser.frame.size.width/2;
    view.imgUser.layer.masksToBounds = YES;
    
    view.imgEventType.layer.cornerRadius = view.imgEventType.frame.size.width/2;
    view.imgEventType.layer.masksToBounds = YES;
    
    int color = [ViewUtils getEventTypeColor:4];
    view.imgEventType.backgroundColor = [ViewUtils getUIColor:color];
    
    return view;
}

@end
