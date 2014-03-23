//
//  EventDetailTimeView.m
//  detail
//
//  Created by zyax86 on 13-8-4.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import "EventDetailTimeView.h"
#import "EventDetailFinailzeView.h"
#import "EventDetailHeader.h"
#import "EventDetailInviteeConformView.h"
#import "EventDetailTimeLabelView.h"
#import "EventDetailHeaderListView.h"

#import "EventDetailTimeVoteView.h"
#import "EventDetailTimeViewItem.h"

#import "Utils.h"
#import "ViewUtils.h"
#import "LogUtil.h"
#import "Model.h"
#import "UserModel.h"
#import "CoreDataModel.h"

@interface EventDetailTimeView() <EventDetailTimeViewItemDelegate, UIAlertViewDelegate>
{


}
@end

@implementation EventDetailTimeView {
    BOOL _isCreator;
    Event * _event;

    UIActivityIndicatorView * _indicatorView;
    
    ProposeStart * _finalizeTime;
}

- (id)init
{
    return [self initWithFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self updateUI];
    }
    return self;
}


-(void) showIndicatorView:(BOOL) show
{
    if(_indicatorView == nil) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicatorView.hidesWhenStopped = YES;
        [self addSubview:_indicatorView];
    }

    if(show) {
        _indicatorView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        [_indicatorView startAnimating];
        self.userInteractionEnabled = NO;
        self.alpha = 0.5;
    } else {
        [_indicatorView stopAnimating];
        self.userInteractionEnabled = YES;
        self.alpha = 1;
    }
}


- (void)layOutSubViews
{
    CGFloat offsetY = 10;
    CGRect frame;
    for(UIView * subView in self.subviews) {

        if(subView.hidden == YES)
            continue;

        frame = subView.frame;
        frame.origin = CGPointMake(0, offsetY);
        subView.frame = frame;
        offsetY += (frame.size.height + 8);
    }
    
    frame = self.frame;
    frame.size.height = offsetY + 12;
    self.frame = frame;

    [self.delegate onEventDetailTimeViewFrameChanged];
}

-(void) updateView:(BOOL) isCreator andEvent:(Event *) event
{
    _isCreator = isCreator;
    _event = event;

    [self updateView];
    
}

-(void) updateView
{
    for(UIView * subView in self.subviews) {
        [subView removeFromSuperview];
    }
    
    
    NSArray * times = _event.propose_starts;
    
    ProposeStart * finalTime = [_event getFinalEventTime];
    
    
    for(ProposeStart * eventTime in times) {
        
        if(_event.confirmed) {
            if([eventTime isEqual:finalTime]) {
                eventTime.finalized = 1;
            } else {
                eventTime.finalized = 0;
            }
        } else {
            eventTime.finalized = 0;
        }

        BOOL pastTime = [eventTime isPast];
        if( pastTime && (eventTime.finalized != 1)) {
            continue;
        }
        
        EventDetailTimeViewItem * item = (EventDetailTimeViewItem *)[ViewUtils createView:@"EventDetailTimeViewItem"];
        item.delegate = self;
        [item refreshView:_event andTime:eventTime];
        [self addSubview:item];

        if(pastTime) {
            item.buttonConform.enabled = NO;
        }
        
        int confilctCount = [self getConfilictEventCount:eventTime];
        //exclude the current event
        if(_event.confirmed && confilctCount>0) {
            confilctCount --;
        }
        
        if(confilctCount > 0)
        {
            //eventTime.confilctCount = confilctCount;
            item.labelTime.textColor = [UIColor redColor];
        }

        
        if(_event.confirmed) {
            
            if(eventTime.finalized != 1) {
                item.userInteractionEnabled = NO;
                item.alpha = 0.5;
            }
            
        } else {
            
            if(!_isCreator) {
                if (pastTime && (eventTime.finalized != 1)) {
                    item.userInteractionEnabled = NO;
                    item.alpha = 0.5;
                }
            }
        }
        
    }
    
    
    [self layOutSubViews];
}

- (void)updateUI
{
    //[self setBackgroundColor:[UIColor colorWithRed:243/255.0f green:243/255.0f blue:243/255.0f alpha:1.0]];
    [self setBackgroundColor:[UIColor clearColor]];
}



-(void) unfinalizeEvent:(ProposeStart *) eventTime
{
    LOG_D(@"unfinalizeEvent");
    
    int eventID = _event.id;
    [self showIndicatorView:YES];
    
    [[Model getInstance] unfinalizeProposeStart:eventID andCallback:^(NSInteger error, Event * newEvent) {
        
        [self showIndicatorView:NO];
        
        if(error == 0) {
            [self.delegate onEventChanged:newEvent andChangeType:EventChangeType_Unfinalize];
        } else {
            [Utils showUIAlertView:@"Error" andMessage:@"Server or network error!"];
        }
    }];
}

-(void) finalizeEvent:(ProposeStart *) eventTime
{
    LOG_D(@"finalizeEvent");

    int eventID = _event.id;

    [self showIndicatorView:YES];

    [[Model getInstance] finalizeProposeStart:eventID ProposeStart:eventTime andCallback:^(NSInteger error, Event * newEvent) {
        [self showIndicatorView:NO];

        if(error == 0) {
            [self.delegate onEventChanged:newEvent andChangeType:EventChangeType_Finalize];
        } else {
            [Utils showUIAlertView:@"Error" andMessage:@"Server or network error!"];
        }
    }];
}

-(void) onRemovePropseStart:(ProposeStart *) time
{
    [self onVoteTimeDelete:time];
}

-(void) onVoteTimeDelete:(ProposeStart *) eventTime
{
    LOG_D(@"onVoteTimeDelete");

    int pid = eventTime.id;
    
    [self showIndicatorView:YES];
    
    [[Model getInstance] deleteProposeStart:pid andCallback:^(NSInteger error) {
        
        [self showIndicatorView:NO];

        if(error == 0) {
            
            NSMutableArray * array = [[NSMutableArray alloc] init];
            for(ProposeStart * p in _event.propose_starts) {
                if(p.id != eventTime.id) {
                    [array addObject:p];
                }
            }
            
            _event.propose_starts = array;
            
            [self.delegate onEventChanged:_event andChangeType:EventChangeType_Update];
            
        } else {
            [Utils showUIAlertView:@"Error" andMessage:@"Delete failed, please try again!"];
            [self updateView];
        }
    }];
}

-(void) updateVote:(EventTimeVote *) vote andproposeStartID:(int)proposeStartID andOldStatus:(int) oldStatus
{
    
    [self showIndicatorView:YES];
    [[Model getInstance] updateVote:vote  andproposeStartID:proposeStartID andCallback:^(NSInteger error) {
        [self showIndicatorView:NO];
        if (error == 0) {
            
            [self updateView];
            [self.delegate onEventChanged:_event andChangeType:EventChangeType_Update];
            
        } else {
            vote.status = oldStatus;
            [Utils showUIAlertView:@"Error" andMessage:@"Vote failed, please try again!"];
        }
    }];
}

-(EventTimeVote *) getMyVote:(ProposeStart*) eventTime
{
    
    User * me = [[UserModel getInstance] getLoginUser];
    
    for(EventTimeVote * vote in eventTime.votes)
    {
        if([me.email isEqualToString:vote.email]) {
            return vote;
        }
    }
    
    return nil;
}


-(void) onVoteBtnClicked:(ProposeStart *) time
{
    User * me = [[UserModel getInstance] getLoginUser];
    
    int myVoteStatus = 0;
    for(EventTimeVote * vote in time.votes)
    {
        if([vote.email isEqualToString:me.email]) {
            myVoteStatus = vote.status;
            break;
        }
    }
    
    [self onVoteTimeConform:time andChecked:(myVoteStatus != 1)];
}


-(NSInteger) getConfilictEventCount:(ProposeStart *) eventtime
{
    NSDate * start = eventtime.start;
    NSDate * end = [eventtime getEndTime];
    int count = [[CoreDataModel getInstance] getFeedEventCountByStart:start andEnd:end];
   
    return count;
}

-(void) onConformBtnClicked:(ProposeStart *) time
{
    _finalizeTime = time;
    
    if(_event.confirmed) {
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Are you sure you want to unconfirm this event?"
                                                        message:@"Unconfirming this event will remove it from all invitee's calendars"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Unconfirm",nil];
        alert.tag = 0;
        [alert show];

        
        
    } else {
        
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Are you sure you want to confirm this event?"
                                                        message:@"Confirming this event will add it to all invitee's calendars"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Confirm",nil];
        alert.tag = 1;
        [alert show];
    }
}

-(void) onTimeLabelClicked:(ProposeStart *) time
{
    //if(time.confilctCount == 0) return;
    
    if(self.delegate) {
        [self.delegate onVoteTimeClick:time];
    }
}

-(void) onAttendeeLabelClicked:(ProposeStart *) time
{
    if(self.delegate) {
        [self.delegate onVoteListClick:time];
    }
}


-(void) onVoteTimeConform:(ProposeStart *) eventTime andChecked:(BOOL) checked
{
    LOG_D(@"onVoteTimeConform, %d", checked);

    int status = checked ? 1 : 0;
 
    EventTimeVote * vote = [self getMyVote:eventTime];
    if(vote != nil)
    {
        if(vote.status != status) {
            int oldStatus = vote.status;
            vote.status = status;
            [self updateVote:vote andproposeStartID:eventTime.id andOldStatus:oldStatus];
        }
        
        return;
    }
    
    
    [self showIndicatorView:YES];
    
    [[Model getInstance] createVote:eventTime.id andVoteStatus:status andCallback:^(NSInteger error, int voteID) {
        
        if (error == 0) {
            
            [self updateEvent];
            
//            for(ProposeStart * p in _event.propose_starts) {
//                
//                if(p.id == eventTime.id) {
//                    NSMutableArray * array = [NSMutableArray arrayWithArray:p.votes];
//                    
//                    EventTimeVote * vote = [[EventTimeVote alloc] init];
//                    vote.id = voteID;
//                    vote.email = [[UserModel getInstance] getLoginUser].email;
//                    vote.status = status;
//                    
//                    [array addObject:vote];
//                    p.votes = array;
//                    
//                    [vote release];
//                    
//                    break;
//                }
//            }
//            
//            [self updateView];
            
        } else {
            [self showIndicatorView:NO];
            [Utils showUIAlertView:@"Error" andMessage:@"Vote failed, please try again!"];
        }
    }];
}


-(void) updateEvent
{
    [[Model getInstance] getEvent:_event.id andCallback:^(NSInteger error, Event *event) {
        
        [self showIndicatorView:NO];
        if(error == 0) {
            [self.delegate onEventChanged:event andChangeType:EventChangeType_Update];
        } else {
            
        }
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    LOG_D(@"alertView, buttonIndex=%d", buttonIndex);
    
    if(buttonIndex == 1) {
        
        if ( alertView.tag ==0 ) //unfinalize
        {
            [self unfinalizeEvent:_finalizeTime];
            
        } else {
            
            [self finalizeEvent:_finalizeTime];
        }
        
    } else {
        _finalizeTime = nil;
    }
}
@end
