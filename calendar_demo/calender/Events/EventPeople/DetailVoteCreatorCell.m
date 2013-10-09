

#import "DetailVoteCreatorCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>

@implementation DetailDeclinedCell(DetailVoteCreatorCell)

- (void)setAvaliable:(BOOL)avaliable
{
    NSString *nameStr = nil;
    if (avaliable) {
        nameStr = @"event_detail_header_tick.png";
    }
    else
    {
        nameStr = @"event_detail_header_cross.png";
    }
    UIImage *stateImage = [UIImage imageNamed:nameStr];
    UIImageView *stateImageView = [[UIImageView alloc] initWithImage:stateImage];
    for (UIView *view in self.peopleHeader.subviews)
    {
        [view removeFromSuperview];
    }
    CGRect frame = self.peopleHeader.frame;
    frame.origin.x = frame.origin.x + frame.size.width - 13 + 2;
    frame.origin.y = frame.origin.y + frame.size.height - 13 + 4;
    frame.size.width = 13;
    frame.size.height = 13;
    stateImageView.frame = frame;
    [stateImageView setFrame:frame];
    [self addSubview:stateImageView];
}

@end
