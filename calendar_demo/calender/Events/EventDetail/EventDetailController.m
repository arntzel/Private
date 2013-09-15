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

@interface EventDetailController ()<EventDetailNavigationBarDelegate, UIGestureRecognizerDelegate, UIActionSheetDelegate>
{
    EventDetailNavigationBar *navBar;
    EventDetailPhotoView *photoView;
    
    EventDetailInviteePlaceView *invitePlaceContentView;
    EventDetailTimeView *timeContentView;
    EventDetailCommentConformView *conformView;
    EventDetailCommentContentView *commentContentView;
    UIScrollView *scrollView;
    
    UIActivityIndicatorView * indicatorView;
    
    Event * event;
}
@end

@implementation EventDetailController

- (void)dealloc
{
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
	// Do any additional setup after loading the view, typically from a nib.
    
//    [self.view setBackgroundColor:[UIColor colorWithRed:231/255.0f green:231/255.0f blue:231/255.0f alpha:1.0]];
    [self.view setBackgroundColor:[UIColor colorWithRed:243/255.0f green:243/255.0f blue:243/255.0f alpha:1.0]];
    [self addPhotoView];
    [self addNavBar];
    
    int height = self.view.frame.size.height - navBar.frame.size.height;
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, navBar.frame.size.height, 320, height)];
    [scrollView setBackgroundColor:[UIColor clearColor]];
    [scrollView setShowsVerticalScrollIndicator:NO];
    [scrollView setBounces:NO];
    [self.view addSubview:scrollView];
    
    [photoView setImage:[UIImage imageNamed:@"2.png"]];
    [photoView setScrollView:scrollView];
    [photoView setNavgation:navBar];

    height = photoView.frame.size.height - navBar.frame.size.height;
    UIView * emptyView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, height)] autorelease];
    [scrollView addSubview:emptyView];

    invitePlaceContentView = [[EventDetailInviteePlaceView alloc] init];
    [scrollView addSubview:invitePlaceContentView];




    timeContentView = [[EventDetailTimeView alloc] init];
    [scrollView addSubview:timeContentView];
    
    conformView = [[EventDetailCommentConformView creatView] retain];
    [scrollView addSubview:conformView];
    
    commentContentView = [[EventDetailCommentContentView alloc] init];
    [scrollView addSubview:commentContentView];
    
    [self layOutSubViews];
    
    
    [self registerKeyboardEvents];
    
    [self showIndicatorView];
    scrollView.hidden = YES;
    
    [[Model getInstance] getEvent:self.eventID andCallback:^(NSInteger error, Event * evt) {
        
        [self hideIndicatorView];
        scrollView.hidden = NO;
        
        if(error == 0) {
            event = evt;
            [event retain];

            if([self isMyCreatEvent]) {
                navBar.rightbtn.hidden = NO;
            } else {
                navBar.rightbtn.hidden = YES;
            }
            
            [photoView setImageUrl:event.thumbnail_url];
            photoView.titleLabel.text = event.title;
            
            [invitePlaceContentView.inviteeView updateInvitee:event.attendees];
            [invitePlaceContentView.placeView setLocation:event.location];
            [invitePlaceContentView setDesciption:event.description];
            
            [self updatecommentContentView];
            
            [self layOutSubViews];
            
        } else {
            UIAlertView * alert = [[[UIAlertView alloc]initWithTitle:@"Error"
                                                            message:@"Event does't exsit"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil] autorelease];
            
            [alert show];
        }
    }];
    
    
    UITapGestureRecognizer *t = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapLocation:)];
    t.delegate = self;
    [invitePlaceContentView.placeView addGestureRecognizer:t];
    [t release];
    
    UITapGestureRecognizer *t2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapInvitees:)];
    t2.delegate = self;
    [invitePlaceContentView.inviteeView addGestureRecognizer:t2];

    UITapGestureRecognizer *t3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapDescitpion:)];
    t3.delegate = self;
    [invitePlaceContentView.desciptionView addGestureRecognizer:t3];

    
    [t2 release];
}

-(BOOL) isMyCreatEvent
{
    User * user =  [[UserModel getInstance] getLoginUser];
    User * creator = event.creator;
    return user.id == creator.id;
}

-(void) singleTapLocation:(UITapGestureRecognizer*) tap
{
    LOG_D(@"singleTapLocation");
    
    UIActionSheet *actionSheet = nil;
    
    if([self isMyCreatEvent]) {
        
        actionSheet = [[UIActionSheet alloc]
                        initWithTitle:nil
                        delegate:self
                        cancelButtonTitle:@"Cancel"
                        destructiveButtonTitle:nil
                        otherButtonTitles:@"Change Location", @"View in Maps", nil];
        actionSheet.tag = 0;
        
    } else {
        
        actionSheet = [[UIActionSheet alloc]
                       initWithTitle:nil
                       delegate:self
                       cancelButtonTitle:@"Cancel"
                       destructiveButtonTitle:nil
                       otherButtonTitles:@"View in Maps", nil];
        
        actionSheet.tag = 1;
    }
    
    [actionSheet showInView:self.view];
    [actionSheet release];
}

-(void) singleTapInvitees: (UITapGestureRecognizer*) tap
{
    
}

-(void) singleTapDescitpion: (UITapGestureRecognizer*) tap
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];

    [invitePlaceContentView toggleDesciptionView];
    [self layOutSubViews];
   
    [UIView commitAnimations];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    LOG_D(@"actionSheet:clickedButtonAtIndex:tag=%d, buttonindex=%d", actionSheet.tag, buttonIndex);
    
    if(actionSheet.tag == 0) {
        
        if(buttonIndex == 0) {
            [self changeLocation];
        } else {
            [self viewInMaps];
        }
        
    } else if(actionSheet.tag == 1){

        [self viewInMaps];

    } else if(actionSheet.tag == 2) {

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

-(void) changeLocation
{
    LOG_D(@"changeLocation");

}

-(void) viewInMaps
{
    LOG_D(@"viewInMaps");
}

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

-(void) showIndicatorView
{
    if(indicatorView == nil) {
        indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicatorView.hidesWhenStopped = YES;
        indicatorView.center = self.view.center;
        [self.view addSubview:indicatorView];
        
        [indicatorView retain];
    }
    
    indicatorView.hidden = NO;
}

-(void) hideIndicatorView
{
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

    UIActionSheet *actionSheet  = [[UIActionSheet alloc]
                                   initWithTitle:nil
                                   delegate:self
                                   cancelButtonTitle:@"Cancel"
                                   destructiveButtonTitle:@"Delete Event"
                                   otherButtonTitles:@"Share on Facebook", @"Share via Email", @"Edit Event Details", nil];

    actionSheet.tag = 2;


    [actionSheet showInView:self.view];
    [actionSheet release];

}

- (void)addPhotoView
{
    photoView = [[EventDetailPhotoView creatView] retain];
    [self.view addSubview:photoView];
}

//垂直方向线性布局
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


-(void) updatecommentContentView
{
   
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
@end
