
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
}

-(void) updateView:(BOOL) isCreator andEventTimeVote:(EventTime *) vote
{
    [self clearView];
    
    _isCreator = isCreator;
    
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
}

- (void)addConformView:(EventTime *) eventTime
{
    conformView = [[EventDetailInviteeConformView creatView] retain];
    
    CGRect frame = conformView.frame;
    frame.origin.x = 7;
    //frame.origin.y = headerListView.frame.origin.y + headerListView.frame.size.height + 15;
    conformView.frame = frame;
    conformView.eventTimeLabel.text = [self getTimeLable:eventTime];

    [self addSubview:conformView];
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
