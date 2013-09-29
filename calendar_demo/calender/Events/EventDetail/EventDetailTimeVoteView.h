

#import <UIKit/UIKit.h>
#import "ProposeStart.h"

@protocol EventDetailTimeVoteViewDelegate <NSObject>

-(void) onVoteListClick:(ProposeStart *) eventTime;

-(void) onVoteTimeClick:(ProposeStart *) eventTime;

-(void) onVoteTimeFinalize:(ProposeStart *) eventTime;

-(void) onVoteTimeDelete:(ProposeStart *) eventTime;

-(void) onVoteTimeConform:(ProposeStart *) eventTime andChecked:(BOOL) checked;


@end

@interface EventDetailTimeVoteView : UIView

@property(nonatomic, assign) id<EventDetailTimeVoteViewDelegate> delegate;

-(void) updateView:(BOOL) isCreator andEventTimeVote:(ProposeStart *) vote;

@end
