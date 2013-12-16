//
//  ViewController.m
//  detail
//
//  Created by zyax86 on 13-7-27.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//
#import "LogUtil.h"
#import "Utils.h"

#import "EventDetailController.h"
#import "EventTimeDetailViewController.h"
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

#import "EventLocationViewController.h"
#import "Location.h"
#import "AddLocationViewController.h"
#import "DetailInviteesController.h"
#import "DetailVoteViewController.h"
#import "CoreDataModel.h"

#import "ShareLoginFacebook.h"
#import "SharePhotoFacebook.h"
#import "LoginAccountStore.h"
#import "SettingsModel.h"
#import "UserModel.h"

#import "ATMHud.h"
#import "ATMHudDelegate.h"

#import <Social/Social.h>
#import <MessageUI/MessageUI.h>

@interface EventDetailController ()<EventDetailNavigationBarDelegate,
                                    UIActionSheetDelegate,
                                    UIAlertViewDelegate,
                                    EventDetailInviteePlaceViewDelegate,
                                    EventDetailCommentContentViewDelegate,
                                    EventDetailCommentConformViewDelegate,
                                    EventDetailTimeViewDelegate,
                                    AddEventDateViewControllerDelegate,
                                    AddLocationViewControllerDelegate,
                                    EventDetailPhotoViewDelegate,
                                    UploadImageDelegate,
                                    DetailInviteesControllerDelegate,
                                    ShareLoginDelegate,
                                    MFMailComposeViewControllerDelegate,
                                    SharePhotoDelegate>
{
    EventDetailNavigationBar *navBar;
    EventDetailPhotoView *photoView;
    
    EventDetailInviteePlaceView *invitePlaceContentView;
    
    EventDetailTimeView *timeContentView;
    
    
    EventDetailCommentConformView *conformView;
    
    EventDetailCommentContentView *commentContentView;
    
    TPKeyboardAvoidingScrollView *scrollView;
    
    UIActivityIndicatorView * indicatorView;

    //For upload Image
    ASIFormDataRequest * request;
    
    ATMHud *hud;
}


@property(nonatomic, retain) Event *event;
@property(nonatomic, retain) ShareLoginBase *shareloginFacebook;
@property(nonatomic, retain) SharePhotoBase *sharePhotoFacebook;
@end

@implementation EventDetailController
@synthesize shareloginFacebook;
@synthesize sharePhotoFacebook;

@synthesize event;

- (void)dealloc
{
    hud.delegate = nil;
    [hud release];
    
    //self.moreActionSheet.delegate = nil;
    //self.moreActionSheet = nil;
    
    self.event = nil;
    
    self.shareloginFacebook.delegate = nil;
    self.shareloginFacebook = nil;
    
    self.sharePhotoFacebook.delegate = nil;
    self.sharePhotoFacebook = nil;
    
    navBar.delegate = nil;
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

    [request release];

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

        if(error == ERROCODE_EVENT_NOTEXITED) {

            [[CoreDataModel getInstance] deleteFeedEventEntity:self.eventID];
            //[self.navigationController popViewControllerAnimated:YES];

            [Utils showUIAlertView:@"Error" andMessage:@"The event was deleted" andDeletegate:self].tag = 2;

            return;
        }

        if(error == 0) {
            self.event = evt;

            //FeedEventEntity * entity = [[CoreDataModel getInstance] getFeedEventEntity:self.event.id];

            [self configViews];
            [self updateUIByEvent];
            [self layOutSubViews];
            
            hud = [[ATMHud alloc] initWithDelegate:self];
            [self.view addSubview:hud.view];
        } else {
            [Utils showUIAlertView:@"Error" andMessage:@"Network or server error"];
        }
    }];
}

- (void)configViews
{
    
    BOOL isCreator = [self isMyCreatEvent];
    navBar.rightbtn.hidden = !isCreator;
    [self addPhotoView];
    if (isCreator) {
        [photoView addCreatorAction];
    }
    
    int height = self.view.frame.size.height - navBar.frame.size.height;
    scrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, navBar.frame.size.height, 320, height)];
    [scrollView setBackgroundColor:[UIColor clearColor]];
    [scrollView setShowsVerticalScrollIndicator:NO];
    [scrollView setBounces:NO];
    [scrollView setClipsToBounds:YES];
    [self.view insertSubview:scrollView belowSubview:photoView];
    [photoView setScrollView:scrollView];
    
    height = photoView.frame.size.height - navBar.frame.size.height;
    UIView * emptyView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, height)] autorelease];
    [scrollView addSubview:emptyView];
    
    invitePlaceContentView = [[EventDetailInviteePlaceView alloc] initByCreator:isCreator CanChangeLocation:self.event.allow_new_location];
    invitePlaceContentView.delegate = self;
    [scrollView addSubview:invitePlaceContentView];
    
    timeContentView = [[EventDetailTimeView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
    timeContentView.delegate = self;

    [scrollView addSubview:timeContentView];
    
    conformView = [[EventDetailCommentConformView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
    conformView.delegate = self;
    [scrollView addSubview:conformView];
    
    commentContentView = [[EventDetailCommentContentView alloc] init];
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


- (void)updateUIByEvent
{
    [photoView setImageUrl:event.thumbnail_url];
    photoView.titleLabel.text = event.title;
    
    [invitePlaceContentView updateInvitee:event.attendees];
    [invitePlaceContentView setLocation:event.location];
    [invitePlaceContentView setDesciption:event.description];
    
    [self updateEventTimeView];

    [self updateConformView];
    

    BOOL isDecline = [self.event isDeclineEvent];
    [commentContentView setDecliend:isDecline];
    
    if(commentContentView.loaded == NO) {
        [commentContentView startLoadComment];
    }
}


-(void) updateEventTimeView
{
    BOOL isCreator = [self isMyCreatEvent];
    [timeContentView updateView:isCreator andEvent:event];
}


-(void) updateConformView
{
    BOOL isCreator = [self isMyCreatEvent];
    BOOL isDecline = [self.event isDeclineEvent];
    
    if(self.event.confirmed || isDecline) {
        conformView.hidden = YES;
    } else {
        conformView.hidden = NO;
        int count = event.propose_starts.count;
        [conformView updateUI:isCreator andInviteeCanProposeTime:event.allow_new_dt andProposeTimeCount:count];
    }
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
        
    } else if(actionSheet.tag == 3) {
        [self leftBtnPress:nil];
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
                                    otherButtonTitles:@"Share on Facebook", @"Share via Email", /*@"Edit Event Details",*/ nil];
    moreActionSheet.tag = 1;
    [moreActionSheet showInView:self.view];
    [moreActionSheet release];
}

- (void)addPhotoView
{
    photoView = [[EventDetailPhotoView creatView] retain];
    [self.view insertSubview:photoView belowSubview:navBar];
    photoView.controller = self;
    [photoView setDefaultImage];
    [photoView setNavgation:navBar];
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
    
    [[[Model getInstance] getEventModel] synchronizedFromServer];
}

#pragma mark -
#pragma mark EventDetailTimeViewDelegate
-(void) onProposeNewTime
{
    LOG_D(@"onProposeNewTime");
    [self onAddNewTime];
}

-(void) onAddNewTime
{
    LOG_D(@"onAddNewTime");
    
    if ([self.event.propose_starts count] >= 3) {
        [Utils showUIAlertView:@"Warning" andMessage:@"Only Three Times Can Be Set!!"];
        return;
    }
    
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

-(void) onVoteListClick:(ProposeStart *) eventTime
{
    LOG_D(@"EventDetailController onVoteListClick");
    
    DetailVoteViewController *controller = [[DetailVoteViewController alloc] initWithNibName:@"DetailVoteViewController" bundle:nil];
    controller.eventTime = eventTime;
    controller.event = self.event;
    controller.titleBgImage = [photoView getImage];
    
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
    
}

-(void) onVoteTimeClick:(ProposeStart *) eventTime
{
    LOG_D(@"EventDetailController onVoteTimeClick");
    
    EventTimeDetailViewController * controller = [[EventTimeDetailViewController alloc] init];
    controller.eventTime = eventTime;
    controller.titleBgImage = [photoView getImage];
    
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}


- (void)setEventDate:(ProposeStart *)eventDate
{
    
    eventDate.start = [Utils convertGMTDate:eventDate.start];
    for(ProposeStart * p in self.event.propose_starts) {
        if([eventDate isEqual:p]) {
            [Utils showUIAlertView:@"Warning" andMessage:@"Already picked that time"];
            return;
        }
    }
    

    [eventDate retain];

    [timeContentView showIndicatorView:YES];

    [[Model getInstance] createProposeStart:self.event andPropose:eventDate andCallback:^(NSInteger error, ProposeStart *proposeStat) {

        [timeContentView showIndicatorView:NO];

        if(error == 0) {
            NSMutableArray * array = [NSMutableArray arrayWithArray:self.event.propose_starts];
            [array addObject:proposeStat];

            self.event.propose_starts = [array sortedArrayUsingSelector:@selector(compare:)];

        } else {
            [Utils showUIAlertView:@"Error" andMessage:@"Add new event time failed, please try again!"];
        }
        
        [timeContentView updateView:[self isMyCreatEvent] andEvent:self.event];
        [self updateConformView];
        [self layOutSubViews];
        
        [eventDate release];
    }];
}

-(void) onDeclineTime
{
    LOG_D(@"onDeclineTime");
    
    
    User * me = [[UserModel getInstance] getLoginUser];
    
    for(EventAttendee * atd in self.event.attendees) {
        
        if([atd.contact.email caseInsensitiveCompare:me.email] == NSOrderedSame) {
            [self declineEvent:atd];
            break;
        }
    }
}

-(void) declineEvent:(EventAttendee *) atd
{
    [self showIndicatorView];
    
    [[Model getInstance] updateEventAttendeeStatus:atd.id andInviteeKey:atd.invite_key andStatus:-1 andCallback:^(NSInteger error) {
        
        [self hideIndicatorView];
        
        if(error == 0) {
            atd.status = -1;
            atd.modified = [Utils convertGMTDate:[NSDate date]];
            [self updateUIByEvent];
            [self layOutSubViews];
        } else {
            [Utils showUIAlertView:@"Error" andMessage:@"Decline event failed"];
        }
    }];
}

#pragma mark -
#pragma mark DetailMoreAction

-(void) deleteEvent
{
     UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                          message:@"Are you sure delete this event?"
                                                         delegate:self
                                                cancelButtonTitle:@"Cancel"
                                                otherButtonTitles:@"Yes", nil];
    
    [alertView show];
    [alertView release];
}

-(void) begindeleteEvent
{
    LOG_D(@"deleteEvent");
    
    [self showIndicatorView];
    [[Model getInstance] deleteEvent:self.eventID andCallback:^(NSInteger error) {
        
        [self hideIndicatorView];
        
        if(error == 0) {
            
            [[CoreDataModel getInstance] deleteFeedEventEntity:self.eventID];
            [self.navigationController popViewControllerAnimated:YES];
            
        } else {
            [Utils showUIAlertView:@"Error" andMessage:@"Delete event failed."];
        }
    }];
}



-(void) editEvent
{
    LOG_D(@"editEvent");
}

- (NSMutableDictionary *)msgToFacebook
{
    NSString *msg = [NSString stringWithFormat:@""];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:msg forKey:@"text"];
    return dict;
}

-(void) shareOnFacebook
{
    LOG_D(@"shareOnFacebook");
    [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    SLComposeViewController *fbController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    SLComposeViewControllerCompletionHandler fbBlock = ^(SLComposeViewControllerResult result)
    {
        if (result == SLComposeViewControllerResultCancelled)
        {
        }
        else
        {
        }
        [fbController dismissViewControllerAnimated:YES completion:Nil];
    };
    fbController.completionHandler = fbBlock;

    NSURL *url = [NSURL URLWithString:@"calvinapp.com"];
    [fbController setInitialText:@""];
//    UIImage *image = [UIImage imageNamed:@"Icon@2x.png"];
//    [fbController addImage:image];
    [fbController addURL:url];

    [self presentViewController:fbController animated:YES completion:nil];

    return;
    
    
    if ([ShareLoginFacebook isFacebookLoginIn]) {
        [self shareToFacebook];
    }
    else
    {
        self.shareloginFacebook.delegate = nil;
        self.shareloginFacebook = [[[ShareLoginFacebook alloc] init] autorelease];
        self.shareloginFacebook.delegate = self;
        [self.shareloginFacebook shareLogin];
    }
}

-(void) shareViaEmail
{
    LOG_D(@"shareViaEmail");
    
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    
    if (mailClass != nil)
    {
        if ([mailClass canSendMail])
        {
            [self displayComposerSheet];
        }
        else
        {
            [self showEmailSetup];
        }
    }
    else
    {
        [self showEmailSetup];
    }
}

- (void)showEmailSetup
{
    [self alertWithTitle:nil msg:@"email accout need setup in ios setting!"];
}

- (void)displayComposerSheet
{
    MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
    mailController.mailComposeDelegate = self;
    
    [mailController setSubject: @"calvin event subject"];
    NSArray *toRecipients = [NSArray arrayWithObject: @"shurarai@gmail.com"];
    
    NSArray *ccRecipients = [NSArray arrayWithObjects:@"fx.fangxiang@gmail.com", nil];
    NSArray *bccRecipients = [NSArray arrayWithObjects:@"fx.fangxiang@gmail.com", nil];
    [mailController setToRecipients: toRecipients];
    [mailController setCcRecipients:ccRecipients];
    [mailController setBccRecipients:bccRecipients];
    
    UIImage *addPic = [UIImage imageNamed: @"123.jpg"];
    NSData *imageData = UIImagePNGRepresentation(addPic);
    [mailController addAttachmentData: imageData mimeType: @"" fileName: @"123.jpg"];
    
    NSString *emailBody = @"";
    [mailController setMessageBody:emailBody isHTML:YES];
    
    [self presentViewController:mailController animated:YES completion:nil];
    [mailController release];
}

- (void) alertWithTitle: (NSString *)_title_ msg: (NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:_title_
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    NSString *msg;
    
    switch (result)
    {
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            break;
        case MFMailComposeResultSent:
            break;
        case MFMailComposeResultFailed:
            msg = @"email failed!";
            [self alertWithTitle:nil msg:msg];
            break;
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark ShareLoginDelegate
- (void)shareDidLoginErr:(ShareLoginBase *)shareLogin
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"login failed!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    [alert release];
}


- (void)shareDidLogin:(ShareLoginBase *)shareLogin
{
    LoginAccountStore * store = [LoginAccountStore defaultAccountStore];
    NSString * accessToken = store.facebookAccessToken;
    LOG_D(@"shareDidLogin:%@", accessToken);
    SettingsModel *settingsModel = [[SettingsModel alloc] init];
    [settingsModel updateConnect:ConnectFacebook tokenVale:accessToken IsConnectOrNot:YES andCallback:^(NSInteger error,NSString *message) {
        
        if (error != -1)
        {
            User *user = [[UserModel getInstance] getLoginUser];
            user.facebookEmail = store.facebookEmail;
            [[[Model getInstance] getEventModel] notifyUserAccountChanged];
    
            [self shareToFacebook];
        }
    }];
}

- (void)shareToFacebook
{
    [self.sharePhotoFacebook setDelegate:nil];
    self.sharePhotoFacebook = [[[SharePhotoFacebook alloc] init] autorelease];
    self.sharePhotoFacebook.delegate = self;
    [self.sharePhotoFacebook updateStatuses:[self msgToFacebook]];
    [self startLoadingAnimation];
}

- (void)startLoadingAnimation
{
    [hud setCaption:@"Sharing To Facebook..."];
    [hud show];
    [hud setBlockTouches:YES];
}

- (void)stopLoadingAnimation
{
    [hud hide];
}

- (void)sharePhotoSuccess:(SharePhotoBase* )sharePhotoBase
{
    [hud hide];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"success" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    [alert release];
}

- (void)sharePhotoFailed:(SharePhotoBase* )sharePhotoBase withErrorNo:(NSInteger) errorNO
{
    [hud hide];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"share failed!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    [alert release];
}

- (void)sharePhotoNetDidNotWork:(SharePhotoBase *)sharePhotoBase
{
    [hud hide];
}

#pragma mark -
#pragma mark EventDetailInviteePlaceViewDelegate
-(void) changeLocation
{
    LOG_D(@"changeLocation");
    AddLocationViewController * changeLocationController = [[AddLocationViewController alloc] init];
    [self.navigationController pushViewController:changeLocationController animated:YES];

    Location *location = [self.event.location copy];
    changeLocationController.location = location;
    [location release];
    changeLocationController.delegate = self;
    [changeLocationController release];
}

-(void) viewInMaps
{
    LOG_D(@"viewInMaps");
    EventLocationViewController * mapViewController = [[EventLocationViewController alloc] init];
    [mapViewController setPlaceLocation:self.event.location];
    [self.navigationController pushViewController:mapViewController animated:YES];

    [mapViewController release];
    
}

- (void) onInviteeViewClicked
{
    LOG_D(@"onInviteeViewClicked");
    
    DetailInviteesController * inviteesController = [[DetailInviteesController alloc] initWithNibName:@"DetailInviteesController" bundle:nil];
    inviteesController.event = self.event;
    inviteesController.titleBgImage = [photoView getImage];
    inviteesController.delegate = self;
    
    [self.navigationController pushViewController:inviteesController animated:YES];
    [inviteesController release];
}

#pragma mark -
#pragma mark AddLocationViewControllerDelegate
- (void)setLocation:(Location *)location
{
    
    [self showIndicatorView];
    
    [location retain];
    [[Model getInstance] updateLocation:self.eventID Location:location andCallback:^(NSInteger error) {
        
        if(error == 0) {
            [invitePlaceContentView setLocation:location];
            self.event.location = location;
        } else {
            [Utils showUIAlertView:@"Error" andMessage:@"Update Location Error!"];
        }
        
        [self hideIndicatorView];
        [location release];
    }];
}

#pragma mark -
#pragma mark EventDetailPhotoViewDelegate
- (void)detailPhotoDidChanged:(UIImage *)image
{
    if(request != nil)
    {
        [request cancel];
        [request release];
        request = nil;
    }

    [self showIndicatorView];
    request =[[Model getInstance] uploadImage:image andCallback:self];
    [request retain];
}

-(void) onUploadStart
{

}

-(void) onUploadProgress: (long long) progress andSize: (long long) Size
{
    LOG_D(@"onUploadProgress");
    //float progressVal = (progress*1.0)/Size;
}

-(void) onUploadCompleted: (int) error andUrl:(NSString *) url
{
    LOG_D(@"onUploadCompleted");
    [self hideIndicatorView];

    [request release];
    request = nil;

    if(error != 0) {
        [Utils showUIAlertView:@"Error" andMessage:@"Upload Image failed."];
        [photoView setImage:nil];
        return;
    }

    [[Model getInstance] updateEventPhoto:self.eventID PhotoUrl:url andCallback:^(NSInteger error) {
        if(error == 0) {
            //TODO::
            self.event.thumbnail_url = url;
        } else {
            [Utils showUIAlertView:@"Error" andMessage:@"Update event photo failed."];
            [photoView setImage:nil];
        }
    }];
}

#pragma mark -
#pragma mark UIAlertViewDeletegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(alertView.tag == 2) {
        
        [self leftBtnPress:nil];
        
    } else if(buttonIndex == 1) {
        
        [self begindeleteEvent];
    }
}

#pragma mark -
#pragma mark DetailInviteesControllerDelegate
- (void)addNewPeopleArray:(NSArray *)inviteArray andNewEvent:(Event *) newEvent;
{
    self.event = newEvent;
    [invitePlaceContentView updateInvitee:newEvent.attendees];
    
    [[[Model getInstance] getEventModel] synchronizedFromServer];
}

@end
