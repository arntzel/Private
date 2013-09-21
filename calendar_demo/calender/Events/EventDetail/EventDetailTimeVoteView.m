
#import "EventDetailTimeVoteView.h"
#import "EventDetailFinailzeView.h"
#import "EventDetailHeaderListView.h"
#import "EventDetailInviteeConformView.h"
#import "Utils.h"

@implementation EventDetailTimeVoteView {
    EventDetailFinailzeView * finailzeView;
    EventDetailInviteeConformView *conformView;
    EventDetailHeaderListView * headerListView;
    BOOL _isCreator;
    EventTime * _eventTime;
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

-(void) updateView:(BOOL) isCreator andEventTimeVote:(EventTime *) vote
{
    [self clearView];
    
    _isCreator = isCreator;
    _eventTime = vote;
    [_eventTime retain];
    
    if(_isCreator) {
        
        [self addFinalzeView:vote];
        [self addInviteeListView:vote];
    } else {
        [self addConformView:vote];
        [self addInviteeListView:vote];
    }
    
    [self layOutSubViews];
}

-(void) addFinalzeView: (EventTime *) eventTime
{
    finailzeView = [[EventDetailFinailzeView creatView] retain];
    
    CGRect frame = finailzeView.frame;
    frame.origin.x = 7;
    frame.origin.y = 7;
    finailzeView.frame = frame;
    
    finailzeView.eventTimeLabel.text = [self getTimeLable:eventTime];
    [self addSubview:finailzeView];
}

-(NSString *) getTimeLable:(EventTime *) eventTime
{
    NSString * startTime = [Utils formateTimeAMPM:eventTime.startTime];
    NSString * endTime = [Utils formateTimeAMPM:eventTime.endTime];
    NSString * lable = [NSString stringWithFormat:@"%@ - %@", startTime, endTime];
    
    return lable;
}

- (void)addInviteeListView:(EventTime *) eventTime
{
    NSMutableArray * urls = [[NSMutableArray alloc] init];
    NSMutableArray * statuses = [[NSMutableArray alloc] init];
    for(EventTimeVote * vote in eventTime.votes) {
        User * user = vote.user;

        if(user.avatar_url == nil) {
            [urls addObject:@""];
        } else {
            [urls addObject:user.avatar_url];
        }

        [statuses addObject: [NSNumber numberWithInt:vote.vote]];
    }
    
    headerListView = [[EventDetailHeaderListView alloc] initWithHeaderArray:urls andStatusArray:statuses andCountLimit:8 ShowArraw:YES];
    
    CGRect frame = headerListView.frame;
    frame.origin.x = 7;
    //frame.origin.y = finailzeView.frame.origin.y + finailzeView.frame.size.height + 10;
    headerListView.frame = frame;
    
    [self addSubview:headerListView];


    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapHeaderListView:)];
    [headerListView addGestureRecognizer:gesture];
    [gesture release];
    
}

-(void) singleTapHeaderListView: (UITapGestureRecognizer*) tap
{
    LOG_D(@"singleTapHeaderListView");

    if(self.delegate != nil) {
        [self.delegate onVoteListClick:nil];
    }
}

- (void)addConformView:(EventTime *) eventTime
{
    conformView = [[EventDetailInviteeConformView creatView] retain];
    
    CGRect frame = conformView.frame;
    frame.origin.x = 7;
    //frame.origin.y = headerListView.frame.origin.y + headerListView.frame.size.height + 15;
    conformView.frame = frame;
    conformView.eventTimeLabel.text = [self getTimeLable:eventTime];

    int vote = 0;
    [conformView setVoteStatus:vote];

    if(vote == 0) {
        [conformView.tickedBtn addTarget:self action:@selector(onEventTimtVoteAgree) forControlEvents:UIControlEventTouchUpInside];
        [conformView.crossedbtn addTarget:self action:@selector(onEventTimtVoteDisagree) forControlEvents:UIControlEventTouchUpInside];
    }

    [self addSubview:conformView];
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

@end
