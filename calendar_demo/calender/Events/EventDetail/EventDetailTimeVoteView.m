
#import "EventDetailTimeVoteView.h"
#import "EventDetailFinailzeView.h"
#import "EventDetailHeaderListView.h"
#import "EventDetailInviteeConformView.h"

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
        
        [self addFinalzeView];
        [self addInviteeListView];
    } else {
        [self addConformView];
        [self addInviteeListView];
    }
    
    [self layOutSubViews];
}

-(void) addFinalzeView
{
    finailzeView = [[EventDetailFinailzeView creatView] retain];
    
    CGRect frame = finailzeView.frame;
    frame.origin.x = 7;
    frame.origin.y = 7;
    finailzeView.frame = frame;
    
    [self addSubview:finailzeView];
}

- (void)addInviteeListView
{
    NSArray *headerArray = @[[UIImage imageNamed:@"header1.jpg"],
                             [UIImage imageNamed:@"header2.jpg"],
                             [UIImage imageNamed:@"header3.jpg"],
                             [UIImage imageNamed:@"header4.jpg"],
                             [UIImage imageNamed:@"header5.jpg"],
                             [UIImage imageNamed:@"header6.jpg"],
                             [UIImage imageNamed:@"header7.jpg"],
                             [UIImage imageNamed:@"header8.jpg"],
                             [UIImage imageNamed:@"header9.jpg"]];
    
    
    
    
    headerListView = [[EventDetailHeaderListView alloc] initWithHeaderArray:headerArray andCountLimit:8 ShowArraw:YES ShowSelectedStatu:YES];
    
    CGRect frame = headerListView.frame;
    frame.origin.x = 7;
    frame.origin.y = finailzeView.frame.origin.y + finailzeView.frame.size.height + 10;
    headerListView.frame = frame;
    
    [self addSubview:headerListView];
}

- (void)addConformView
{
    conformView = [[EventDetailInviteeConformView creatView] retain];
    
    CGRect frame = conformView.frame;
    frame.origin.x = 7;
    frame.origin.y = headerListView.frame.origin.y + headerListView.frame.size.height + 15;
    conformView.frame = frame;
    
    [self addSubview:conformView];
}

- (void)layOutSubViews
{
    CGFloat offsetY = 0;
    CGRect frame;
    for(UIView * subView in self.subviews) {
        frame = subView.frame;
        frame.origin = CGPointMake(0, offsetY);
        subView.frame = frame;
        offsetY += frame.size.height;
    }
    
    frame = self.frame;
    frame.size.height = offsetY;
    self.frame = frame;
}

@end
