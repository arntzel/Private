

#import <UIKit/UIKit.h>
#import "EventTime.h"

@interface EventDetailTimeVoteView : UIView

-(void) updateView:(BOOL) isCreator andEventTimeVote:(EventTime *) vote;

@end
