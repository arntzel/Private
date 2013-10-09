

#import <UIKit/UIKit.h>
#import "Event.h"
#import "ProposeStart.h"

#define ALPHA  0.2;

@protocol EventDetailTimeVoteViewDelegate <NSObject>

-(void) onVoteListClick;

-(void) onVoteTimeClick;

-(void) onVoteTimeFinalize:(ProposeStart *) eventTime;

-(void) onVoteTimeDelete:(ProposeStart *) eventTime;

-(void) onVoteTimeConform:(ProposeStart *) eventTime andChecked:(BOOL) checked;


@end

@interface EventDetailTimeVoteView : UIView

@property(nonatomic, assign) id<EventDetailTimeVoteViewDelegate> delegate;

-(void) updateView:(BOOL) isCreator andEvent:(Event*) event andEventTimeVote:(ProposeStart *) start;

@end
