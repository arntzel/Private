//
//  ViewController.m
//  detail
//
//  Created by zyax86 on 13-7-27.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import "EventDetailController.h"

#import "EventDetailNavigationBar.h"
#import "EventDetailPhotoView.h"

#import "EventDetailInviteePlaceView.h"
#import "EventDetailTimeView.h"
#import "EventDetailCommentConformView.h"
#import "EventDetailCommentContentView.h"

#import "Model.h"
#import "UserModel.h"
#import "EventTime.h"

@interface EventDetailController ()<EventDetailNavigationBarDelegate, UIActionSheetDelegate, EventDetailInviteePlaceViewDelegate>
{
    EventDetailNavigationBar *navBar;
    EventDetailPhotoView *photoView;
    
    EventDetailInviteePlaceView *invitePlaceContentView;
    
    EventDetailTimeView *timeContentView;
    
    
    EventDetailCommentConformView *conformView;
    
    EventDetailCommentContentView *commentContentView;
    
    UIScrollView *scrollView;
    
    UIActivityIndicatorView * indicatorView;
}

@property(nonatomic, retain) UIActionSheet *moreActionSheet;
@property(nonatomic, retain) Event *event;
@end

@implementation EventDetailController
@synthesize event;
@synthesize moreActionSheet;

- (void)dealloc
{
    self.moreActionSheet.delegate = nil;
    self.moreActionSheet = nil;
    
    self.event = nil;
    
    [self unregisterKeyboardEvents];
    
    [navBar release];
    [photoView setScrollView:nil];
    [photoView setNavgation:nil];
    [photoView release];
    
    [invitePlaceContentView release];
    [timeContentView release];
    [conformView release];
    [commentContentView release];
    [scrollView release];
 
    [indicatorView release];
    
    [event release];
    
    [super dealloc];
}

-(void) registerKeyboardEvents
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void) unregisterKeyboardEvents
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.view setBackgroundColor:[UIColor colorWithRed:243/255.0f green:243/255.0f blue:243/255.0f alpha:1.0]];
    [self addNavBar];
    

    [self showIndicatorView];
    
    [[Model getInstance] getEvent:self.eventID andCallback:^(NSInteger error, Event * evt) {
        
        [self hideIndicatorView];
        
        if(error == 0) {
            self.event = evt;


            [self configViews];
            [self updateUIByEvent];
            [self layOutSubViews];
        }
        else {
            UIAlertView * alert = [[[UIAlertView alloc]initWithTitle:@"Error"
                                                            message:@"Event does't exsit"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil] autorelease];
            
            [alert show];
        }
    }];
}

- (void)configViews
{
    BOOL isCreator = [self isMyCreatEvent];
    navBar.rightbtn.hidden = !isCreator;

    [self addPhotoView];

    int height = self.view.frame.size.height - navBar.frame.size.height;
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, navBar.frame.size.height, 320, height)];
    [scrollView setBackgroundColor:[UIColor clearColor]];
    [scrollView setShowsVerticalScrollIndicator:NO];
    [scrollView setBounces:NO];
    [self.view addSubview:scrollView];
    
    [photoView setImage:[self getRandomPhoto]];
    [photoView setScrollView:scrollView];
    [photoView setNavgation:navBar];
    
    height = photoView.frame.size.height - navBar.frame.size.height;
    UIView * emptyView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, height)] autorelease];
    [scrollView addSubview:emptyView];
    
    invitePlaceContentView = [[EventDetailInviteePlaceView alloc] initByCreator:isCreator];
    invitePlaceContentView.delegate = self;
    [scrollView addSubview:invitePlaceContentView];
    
    timeContentView = [[EventDetailTimeView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
    [scrollView addSubview:timeContentView];
    
    conformView = [[EventDetailCommentConformView creatView] retain];
    [scrollView addSubview:conformView];
    
    commentContentView = [[EventDetailCommentContentView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
    [scrollView addSubview:commentContentView];
    
    [self layOutSubViews];
    
    [self registerKeyboardEvents];
}

-(BOOL) isMyCreatEvent
{
    User * user =  [[UserModel getInstance] getLoginUser];
    User * creator = event.creator;
    return user.id == creator.id;
}

-(UIImage *) getRandomPhoto
{
    //event_detail_random_header1.png
    int value = (arc4random() % 8) + 1;

    NSString * name = [NSString stringWithFormat:@"event_detail_random_header%d.png", value];
    UIImage * img = [UIImage imageNamed:name];
    return img;
}

-(void) singleTapLocation:(UITapGestureRecognizer*) tap
{
    
}

- (void)updateUIByEvent
{
    [photoView setImageUrl:event.thumbnail_url];
    photoView.titleLabel.text = event.title;
    
    [invitePlaceContentView updateInvitee:event.attendees];
    [invitePlaceContentView setLocation:event.location];
    [invitePlaceContentView setDesciption:event.description];
    
    [self updateEventTimeView];
    
    
    User * me = [[UserModel getInstance] getLoginUser];
    NSMutableArray * comments = [[NSMutableArray alloc] init];
    
    for(int i=0;i<10;i++) {
        Comment * cmt = [[Comment alloc] init];
        cmt.msg = @"teststddddddddsaadfa";
        cmt.createTime = [NSDate date];
        if(i==8) {
            cmt.commentor = nil;
        } else {
            cmt.commentor = me;
        }
        [comments addObject:cmt];
        [cmt release];
    }
    
    [commentContentView updateView:me andComments:comments];
    [comments release];
}

-(void) updateEventTimeView
{
    BOOL isCreator = [self isMyCreatEvent];
    
    NSMutableArray * array = [[NSMutableArray alloc] init];
    
    EventTime * time1 = [[EventTime alloc] init];
    time1.startTime = [NSDate date];
    time1.endTime = [time1.startTime dateByAddingTimeInterval:3600];
    NSMutableArray * votes = [[NSMutableArray alloc] init];
    for(int i=0;i<3;i++) {
        EventTimeVote * vote = [[EventTimeVote alloc] init];
        [votes addObject:vote];
        [vote release];

        if(i==2) {
            vote.vote = 0;
        } else {
            vote.vote = 1;
        }
    }
    
    time1.votes = votes;
    [votes release];
    
    [array addObject:time1];
    [time1 release];

    NSDate * startTime =  [[NSDate date] dateByAddingTimeInterval:3600*27];
    
    for(int i=0;i<3;i++) {
        EventTime * time2 = [[EventTime alloc] init];
        time2.startTime = startTime;
        time2.endTime = [time1.startTime dateByAddingTimeInterval:3600];
        votes = [[NSMutableArray alloc] init];
        for(int i=0;i<3;i++) {
            EventTimeVote * vote = [[EventTimeVote alloc] init];
            vote.user = event.creator;

            if(event.attendees.count >0) {
                EventAttendee * atd = [event.attendees objectAtIndex:0];
                vote.user = atd.user;
            }

            if(i==1) {
                vote.vote = 1;
            } else {
                vote.vote = 0;
            }
            
            [votes addObject:vote];
            [vote release];
        }

        time2.votes = votes;
        [votes release];

        [array addObject:time2];
        [time2 release];

    }
    
    
    [timeContentView updateView:isCreator andEventTimes: array];
    
    [array release];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet == moreActionSheet) {
        switch (buttonIndex) {
            case 0:
                [self deleteEvent];
                break;
                
            case 1:
                [self shareOnFacebook];
                break;
                
            case 2:
                [self shareViaEmail];
                break;
                
            case 3:
                [self editEvent];
                break;
                
            default:
                break;
        }
    }
}

-(void) showIndicatorView
{
    if(indicatorView == nil) {
        indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicatorView.hidesWhenStopped = YES;
        indicatorView.center = self.view.center;
        [self.view addSubview:indicatorView];
        
        [indicatorView retain];
    }
    [indicatorView startAnimating];
    indicatorView.hidden = NO;
}

-(void) hideIndicatorView
{
    [indicatorView stopAnimating];
    indicatorView.hidden = YES;
}

- (void)addNavBar
{
    navBar = [[EventDetailNavigationBar creatView] retain];
    navBar.delegate = self;
    [self.view addSubview:navBar];
}

- (void)leftBtnPress:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBtnPress:(id)sender
{
    LOG_D(@"rightBtnPress");
    self.moreActionSheet = [[[UIActionSheet alloc]
                                   initWithTitle:nil
                                   delegate:self
                                   cancelButtonTitle:@"Cancel"
                                   destructiveButtonTitle:@"Delete Event"
                             otherButtonTitles:@"Share on Facebook", @"Share via Email", @"Edit Event Details", nil] autorelease];
    [moreActionSheet showInView:self.view];
}

- (void)addPhotoView
{
    photoView = [[EventDetailPhotoView creatView] retain];
    [self.view insertSubview:photoView belowSubview:navBar];
}

//垂直方向线性布局
- (void)frameDidChanged
{
    [self layOutSubViews];
}

- (void)layOutSubViews
{
    CGFloat offsetY = 0;
    
    for(UIView * subView in scrollView.subviews) {
        CGRect frame = subView.frame;
        frame.origin = CGPointMake(0, offsetY);
        subView.frame = frame;
        offsetY += frame.size.height;
    }
    
    [scrollView setContentSize:CGSizeMake(320, offsetY)];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Responding to keyboard events
- (void)keyboardWillShow:(NSNotification *)notification {

    NSDictionary *userInfo = [notification userInfo];
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    // Get the duration of the animation.
    //NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    //NSTimeInterval animationDuration;
    //[animationDurationValue getValue:&animationDuration];
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    //[self moveInputBarWithKeyboardHeight:keyboardRect.size.height withDuration:animationDuration];
    
    int height = self.view.frame.size.height - navBar.frame.size.height - keyboardRect.size.height;
    CGRect frame = CGRectMake(0, navBar.frame.size.height, 320, height);
    scrollView.frame = frame;
    
    CGPoint  contentOffset = scrollView.contentOffset;
    contentOffset.y += keyboardRect.size.height;
    scrollView.contentOffset = contentOffset;
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    //NSDictionary* userInfo = [notification userInfo];
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.
     */
    //NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    //NSTimeInterval animationDuration;
    //[animationDurationValue getValue:&animationDuration];
    //[self moveInputBarWithKeyboardHeight:0.0 withDuration:animationDuration];
    
    int height = self.view.frame.size.height - navBar.frame.size.height;
    CGRect frame = CGRectMake(0, navBar.frame.size.height, 320, height);
    scrollView.frame = frame;
}

#pragma mark -
#pragma mark DetailMoreAction
-(void) deleteEvent
{
    LOG_D(@"deleteEvent");
}

-(void) editEvent
{
    LOG_D(@"editEvent");
}

-(void) shareOnFacebook
{
    LOG_D(@"shareOnFacebook");
}

-(void) shareViaEmail
{
    LOG_D(@"shareViaEmail");
}

#pragma mark -
#pragma mark EventDetailInviteePlaceViewDelegate
-(void) changeLocation
{
    LOG_D(@"changeLocation");
    
}

-(void) viewInMaps
{
    LOG_D(@"viewInMaps");
}
@end
