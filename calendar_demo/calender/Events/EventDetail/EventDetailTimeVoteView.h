

#import <UIKit/UIKit.h>
#import "EventTime.h"

@protocol EventDetailTimeVoteViewDelegate <NSObject>

-(void) onVoteListClick:(EventTime *) eventTime;

-(void) onVoteTimeClick:(EventTime *) eventTime;

-(void) onVoteTimeFinalize:(EventTime *) eventTime;

-(void) onVoteTimeDelete:(EventTime *) eventTime;

-(void) onVoteTimeConform:(EventTime *) eventTime andChecked:(BOOL) checked;


@end

@interface EventDetailTimeVoteView : UIView

@property(nonatomic, assign) id<EventDetailTimeVoteViewDelegate> delegate;

-(void) updateView:(BOOL) isCreator andEventTimeVote:(EventTime *) vote;

@end
