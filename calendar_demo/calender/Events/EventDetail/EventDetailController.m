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
#import "AddEventDateViewController.h"
#import "TPKeyboardAvoidingScrollView.h"

@interface EventDetailController ()<EventDetailNavigationBarDelegate, UIActionSheetDelegate, EventDetailInviteePlaceViewDelegate, EventDetailCommentContentViewDelegate, EventDetailCommentConformViewDelegate, EventDetailTimeViewDelegate, AddEventDateViewControllerDelegate>
{
    EventDetailNavigationBar *navBar;
    EventDetailPhotoView *photoView;
    
    EventDetailInviteePlaceView *invitePlaceContentView;
    
    EventDetailTimeView *timeContentView;
    
    
    EventDetailCommentConformView *conformView;
    
    EventDetailCommentContentView *commentContentView;
    
    TPKeyboardAvoidingScrollView *scrollView;
    
    UIActivityIndicatorView * indicatorView;
}


@property(nonatomic, retain) Event *event;
@end

@implementation EventDetailController

@synthesize event;

- (void)dealloc
{
    //self.moreActionSheet.delegate = nil;
    //self.moreActionSheet = nil;
    
    self.event = nil;
    
    [navBar release];
    [photoView setScrollView:nil];
    [photoView setNavgation:nil];
    [photoView release];

    invitePlaceContentView.delegate = nil;
    [invitePlaceContentView release];

    timeContentView.delegate = nil;
    [timeContentView release];

    conformView.delegate = nil;
    [conformView release];
    
    commentContentView.delegate = nil;
    [commentContentView release];
    [scrollView release];
 
    [indicatorView release];
    
    [event release];
    
    [super dealloc];
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
    [self addPhotoView:isCreator];

    int height = self.view.frame.size.height - navBar.frame.size.height;
    scrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, navBar.frame.size.height, 320, height)];
    [scrollView setBackgroundColor:[UIColor clearColor]];
    [scrollView setShowsVerticalScrollIndicator:NO];
    [scrollView setBounces:NO];
    [scrollView setClipsToBounds:YES];
    [self.view insertSubview:scrollView belowSubview:photoView];
    
    
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
    timeContentView.delegate = self;

    [scrollView addSubview:timeContentView];
    
    conformView = [[EventDetailCommentConformView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
    conformView.delegate = self;
    [scrollView addSubview:conformView];
    
    commentContentView = [[EventDetailCommentContentView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
    commentContentView.eventID = self.eventID;
    commentContentView.delegate = self;
    [scrollView addSubview:commentContentView];
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

- (void)updateUIByEvent
{
    [photoView setImageUrl:event.thumbnail_url];
    photoView.titleLabel.text = event.title;
    
    [invitePlaceContentView updateInvitee:event.attendees];
    [invitePlaceContentView setLocation:event.location];
    [invitePlaceContentView setDesciption:event.description];
    
    [self updateEventTimeView];

    BOOL isCreator = [self isMyCreatEvent];

    if(self.event.confirmed) {
        conformView.hidden = YES;
    } else {
        conformView.hidden = NO;
        [conformView updateUI:isCreator andInviteeCanProposeTime:event.allow_new_dt];
    }

    [commentContentView beginLoadComments];
}

-(void) updateEventTimeView
{
    BOOL isCreator = [self isMyCreatEvent];
    [timeContentView updateView:isCreator andEvent:event];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 1) {
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
    } else if(actionSheet.tag == 2) {
        
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
    navBar.rightbtn.hidden = YES;
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
    UIActionSheet * moreActionSheet = [[UIActionSheet alloc]
                                        initWithTitle:nil
                                             delegate:self
                                    cancelButtonTitle:@"Cancel"
                               destructiveButtonTitle:@"Delete Event"
                                    otherButtonTitles:@"Share on Facebook", @"Share via Email", @"Edit Event Details", nil];
    moreActionSheet.tag = 1;
    [moreActionSheet showInView:self.view];
    [moreActionSheet release];
}

- (void)addPhotoView:(BOOL) isCreator
{
    photoView = [[EventDetailPhotoView creatView] retain];
    photoView.photoView.userInteractionEnabled = YES;
    
    [self.view insertSubview:photoView belowSubview:navBar];

    if(isCreator) {
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapPhotoView:)];
        [photoView.photoView addGestureRecognizer:gesture];
        [gesture release];
    }
}

-(void) singleTapPhotoView:(id)sender
{
    UIActionSheet * actionSheet = [[UIActionSheet alloc]
                                       initWithTitle:nil
                                            delegate:self
                                    cancelButtonTitle:@"Cancel"
                               destructiveButtonTitle:nil
                                    otherButtonTitles:@"Add from Camera Roll", @"Use Facebook Cover Photo", @"Take Photo", nil];
    
    actionSheet.tag = 2;
    [actionSheet showInView:self.view];
    [actionSheet release];
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

        if(subView.hidden == YES) continue;

        CGRect frame = subView.frame;
        frame.origin = CGPointMake(0, offsetY);
        subView.frame = frame;
        offsetY += frame.size.height;
    }
    
    [scrollView setContentInset:UIEdgeInsetsZero];
    LOG_D(@"scrollView.contentInset :%f,%f",scrollView.contentInset.top,scrollView.contentInset.bottom);
    
    [scrollView setContentSize:CGSizeMake(320, offsetY)];
//    [scrollView contentSizeToFit];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark EventDetailCommentContentView
-(void) onEventDetailCommentContentViewFrameChanged
{
    LOG_D(@"EventDetail onEventDetailCommentContentViewFrameChanged");

    [self layOutSubViews];
}

-(void) onEventDetailTimeViewFrameChanged {
    LOG_D(@"EventDetail onEventDetailTimeViewFrameChanged");
    [self layOutSubViews];
}


-(void) onEventChanged:(Event *) newEvent;
{
    self.event = newEvent;
    [self updateUIByEvent];
}

#pragma mark -
#pragma mark EventDetailCommentContentView
-(void) onProposeNewTime
{
    LOG_D(@"onProposeNewTime");
    [self onAddNewTime];
}

-(void) onAddNewTime
{
    LOG_D(@"onAddNewTime");
    
    ProposeStart *tempEventDate = [[ProposeStart alloc] init];
    tempEventDate.duration_hours = 1;
    tempEventDate.start = [NSDate dateWithTimeIntervalSinceNow:300];
    tempEventDate.start_type = START_TYPEEXACTLYAT;
    [tempEventDate convertMinToQuarterMode];
    
    AddEventDateViewController *addDate = [[AddEventDateViewController alloc] initWithEventDate:tempEventDate];
    addDate.delegate = self;
    [self.navigationController pushViewController:addDate animated:YES];
    
    [tempEventDate release];
}

- (void)setEventDate:(ProposeStart *)eventDate
{

    [eventDate retain];

    [timeContentView showIndicatorView:YES];

    [[Model getInstance] createProposeStart:self.event andPropose:eventDate andCallback:^(NSInteger error, ProposeStart *proposeStat) {

        [timeContentView showIndicatorView:NO];

        if(error == 0) {
            NSMutableArray * array = [NSMutableArray arrayWithArray:self.event.propose_starts];
            [array addObject:proposeStat];

            self.event.propose_starts = [array sortedArrayUsingSelector:@selector(compare:)];

        } else {
            //TODO::
        }
        
        [timeContentView updateView:[self isMyCreatEvent] andEvent:self.event];
        
        [eventDate release];
    }];
}

-(void) onDeclineTime
{
    LOG_D(@"onDeclineTime");
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

- (void) onInviteeViewClicked
{
    LOG_D(@"onInviteeViewClicked");
}
@end
