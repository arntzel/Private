

#import "BirthdayEventView.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>
#import "ViewUtils.h"
#import "UIColor+Hex.h"

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
    self.labTime.text = @"Exactly at";

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
    view.imgUser.layer.borderColor = [[UIColor generateUIColorByHexString:@"#d1d9d2"] CGColor];
    
    view.imgEventType.layer.cornerRadius = view.imgEventType.frame.size.width/2;
    view.imgEventType.layer.masksToBounds = YES;
    
    int color = [ViewUtils getEventTypeColor:4];
    view.imgEventType.backgroundColor = [ViewUtils getUIColor:color];
    
    
    UIColor *kalStandardColor = [UIColor generateUIColorByHexString:@"#18a48b"];
    UIColor *kalTitleColor = [UIColor generateUIColorByHexString:@"#232525"];
    [view.labTitle setTextColor:kalTitleColor];
    [view.labTime setTextColor:kalStandardColor];
    return view;
}

@end
