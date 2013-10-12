
#import "EventDetailTimeVoteView.h"
#import "EventDetailFinailzeView.h"
#import "EventDetailHeaderListView.h"
#import "EventDetailInviteeConformView.h"
#import "EventDetailFinailzeView2.h"

#import "Utils.h"
#import "LogUtil.h"
#import "UserModel.h"
#import "CoreDataModel.h"

@interface EventDetailTimeVoteView() <EventDetailFinailzeViewDelegate>

@end


@implementation EventDetailTimeVoteView {
    EventDetailFinailzeView * finailzeView;
    EventDetailInviteeConformView *conformView;
    EventDetailHeaderListView * headerListView;
    BOOL _isCreator;
    ProposeStart * _eventTime;
}

-(void) dealloc {
    [self clearView];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) clearView
{
    [finailzeView removeFromSuperview];
    [conformView removeFromSuperview];
    [headerListView removeFromSuperview];
    
    [finailzeView release];
    [conformView release];
    [headerListView release];

    [_eventTime release];
    _eventTime = nil;
}

-(void) updateView:(BOOL) isCreator andEvent:(Event*) event andEventTimeVote:(ProposeStart *) start;
{
    [self clearView];
    
    _isCreator = isCreator;

    _eventTime = start;
    [_eventTime retain];
    
    if(_isCreator) {
        [self addFinalzeView];
    } else {
        [self addConformView:event];
    }

    [self addInviteeListView:event];
    [self layOutSubViews];
}

-(void) addFinalzeView
{
    if(_eventTime.finalized == 1) {

       [self addFinalView];

    } else {
        
        finailzeView = [[EventDetailFinailzeView creatView] retain];
        [finailzeView updateView:_eventTime];
        finailzeView.eventTimeConflictLabel.text = [self getConfilictEventCount];
        finailzeView.delegate = self;
        [self addSubview:finailzeView];

        UITapGestureRecognizer *tapGestureTel = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapEventTimeLabel:)];
        [finailzeView.eventTimeLabel addGestureRecognizer:tapGestureTel];
        [tapGestureTel release];
    }
}

-(NSString *) getTimeLable
{
    NSString * startTime = [Utils formateTimeAMPM:_eventTime.start];
    NSString * endTime = [Utils formateTimeAMPM:[_eventTime getEndTime]];
    NSString * lable = [NSString stringWithFormat:@"%@ - %@", startTime, endTime];
    return lable;
}

-(NSString *) getConfilictEventCount
{
    NSDate * start = _eventTime.start;
    NSDate * end = [_eventTime getEndTime];
    int count = [[CoreDataModel getInstance] getFeedEventCountByStart:start andEnd:end];
    return [NSString stringWithFormat:@"%d CONFLICT", count];
}

- (void)addInviteeListView:(Event *) event
{
    NSMutableArray * urls = [[NSMutableArray alloc] init];
    NSMutableArray * statuses = [[NSMutableArray alloc] init];
    
    //如果creator finalize一个event, 那么相当于他也为这个time投票了
    if(_eventTime.finalized == 1) {
        
        NSString * email = event.creator.email;
        BOOL voted = NO;
        for(EventTimeVote * vote in _eventTime.votes) {
            if([email isEqualToString:vote.email]) {
                voted = YES;
                break;
            }
        }
        
        if(!voted) {
            if(event.creator.avatar_url == nil) {
                [urls addObject: @""];
            } else {
                [urls addObject: event.creator.avatar_url];
            }
            
            [statuses addObject: [NSNumber numberWithInt:1]];
        }
    }
    
    
    
    for(EventTimeVote * vote in _eventTime.votes) {

        EventAttendee * attendee = [[event getAttendeesDic] objectForKey:vote.email];
        Contact * contact = attendee.contact;

        if(contact.avatar_url == nil) {
            [urls addObject:@""];
        } else {
            [urls addObject:contact.avatar_url];
        }

        [statuses addObject: [NSNumber numberWithInt:vote.status]];
    }

    headerListView = [[EventDetailHeaderListView alloc] initWithHeaderArray:urls andStatusArray:statuses andCountLimit:8 ShowArraw:YES];

    [urls release];
    [statuses release];
    
    CGRect frame = headerListView.frame;
    frame.origin.x = 7;
    //frame.origin.y = finailzeView.frame.origin.y + finailzeView.frame.size.height + 10;
    headerListView.frame = frame;
    
    [self addSubview:headerListView];


    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapHeaderListView:)];
    [headerListView addGestureRecognizer:gesture];
    [gesture release];

    if(_eventTime.finalized == 2) {
        headerListView.userInteractionEnabled = NO;
        headerListView.alpha = ALPHA;
    }
}

-(void) singleTapEventTimeLabel: (UITapGestureRecognizer*) tap
{
    LOG_D(@"singleTapEventTimeLabel");

    if(self.delegate != nil) {
        [self.delegate onVoteTimeClick:_eventTime];
    }
}

-(void) singleTapHeaderListView: (UITapGestureRecognizer*) tap
{
    LOG_D(@"singleTapHeaderListView");

    if(self.delegate != nil) {
        [self.delegate onVoteListClick:_eventTime];
    }
}

- (void)addConformView:(Event *)event
{
    if(_eventTime.finalized == 1) {

        [self addFinalView];
        
    } else {

        conformView = [[EventDetailInviteeConformView creatView] retain];

        CGRect frame = conformView.frame;
        frame.origin.x = 7;
        //frame.origin.y = headerListView.frame.origin.y + headerListView.frame.size.height + 15;
        conformView.frame = frame;
        conformView.eventTimeLabel.text = [self getTimeLable];
        conformView.eventTimeConflictLabel.text = [self getConfilictEventCount];
        
        int status = 0;
        User * me = [[UserModel getInstance] getLoginUser];

        for (EventTimeVote * vote in _eventTime.votes) {
            if([me.email isEqualToString:vote.email]) {
                status = vote.status;
                break;
            }
        }


        [conformView setVoteStatus:status];

        if(status == 0) {

            if([event isDeclineEvent]) {
                conformView.tickedBtn.userInteractionEnabled = NO;
                conformView.crossedbtn.userInteractionEnabled = NO;
            } else {
                [conformView.tickedBtn addTarget:self action:@selector(onEventTimtVoteAgree) forControlEvents:UIControlEventTouchUpInside];
                [conformView.crossedbtn addTarget:self action:@selector(onEventTimtVoteDisagree) forControlEvents:UIControlEventTouchUpInside];
            }

        } else {
            conformView.tickedBtn.userInteractionEnabled = NO;
            conformView.crossedbtn.userInteractionEnabled = NO;
        }

        [self addSubview:conformView];

        if(_eventTime.finalized == 2) {
            conformView.tickedBtn.userInteractionEnabled = NO;
            conformView.crossedbtn.userInteractionEnabled = NO;
            conformView.alpha = ALPHA;
        }
        
        
        UITapGestureRecognizer *tapGestureTel = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapEventTimeLabel:)];
        conformView.eventTimeLabel.userInteractionEnabled = YES;
        [conformView.eventTimeLabel addGestureRecognizer:tapGestureTel];
        [tapGestureTel release];
    }    
}



-(void) addFinalView
{
    EventDetailFinailzeView2 * view = [EventDetailFinailzeView2 creatView];
    CGRect frame = view.frame;
    frame.origin.x = 7;
    frame.origin.y = 7;
    view.frame = frame;

    view.eventTimeLabel.text = [self getTimeLable];
    
    [self addSubview:view];


    UITapGestureRecognizer *tapGestureTel = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapEventTimeLabel:)];
    [view.eventTimeLabel addGestureRecognizer:tapGestureTel];
    [tapGestureTel release];
}

-(void) onEventTimtVoteAgree
{
    LOG_D(@"onEventTimtVoteAgree");

    if(self.delegate != nil) {
        [self.delegate onVoteTimeConform:_eventTime andChecked:YES];
    }
}

-(void) onEventTimtVoteDisagree
{
    LOG_D(@"onEventTimtVoteDisagree");

    if(self.delegate != nil) {
        [self.delegate onVoteTimeConform:_eventTime andChecked:NO];
    }
}


- (void)layOutSubViews
{
    CGFloat offsetY = 0;
    CGRect frame;
    for(UIView * subView in self.subviews) {
        frame = subView.frame;
        frame.origin.y = offsetY;
        subView.frame = frame;
        offsetY += frame.size.height;
        offsetY += 5;
    }
    
    frame = self.frame;
    frame.size.height = offsetY + 10;
    self.frame = frame;
}


-(void) onRemovePropseStart
{
    [self.delegate onVoteTimeDelete:_eventTime];
}

-(void) onSetFinilzeTime
{
    [self.delegate onVoteTimeFinalize:_eventTime];
}
@end
