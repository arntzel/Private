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

@interface EventDetailController ()<EventDetailNavigationBarDelegate>
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

    invitePlaceContentView = [[EventDetailInviteePlaceView alloc] init];
    [scrollView addSubview:invitePlaceContentView];
    
    timeContentView = [[EventDetailTimeView alloc] init];
    [scrollView addSubview:timeContentView];
    
    conformView = [[EventDetailCommentConformView creatView] retain];
    [scrollView addSubview:conformView];

    commentContentView = [[EventDetailCommentContentView alloc] init];
    [scrollView addSubview:commentContentView];
    
    [self layOutSubViews];
    
    [self showIndicatorView];
    
    [self registerKeyboardEvents];
    
    [[Model getInstance] getEvent:self.eventID andCallback:^(NSInteger error, Event *event) {
        
        [self hideIndicatorView];
        
        if(error == 0) {
            
            [photoView setImageUrl:event.thumbnail_url];
            photoView.titleLabel.text = event.title;
            
            [invitePlaceContentView.placeView setLocation:event.location];
            
        } else {
            UIAlertView * alert = [[[UIAlertView alloc]initWithTitle:@"Error"
                                                            message:@"Event does't exsit"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil] autorelease];
            
            [alert show];
        }
    }];
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
    
}

- (void)addPhotoView
{
    photoView = [[EventDetailPhotoView creatView] retain];
    [self.view addSubview:photoView];
}

- (void)layOutSubViews
{
    CGFloat offsetY = photoView.frame.size.height - navBar.frame.size.height;
    
    CGRect placeViewFrame = invitePlaceContentView.frame;
    placeViewFrame.origin = CGPointMake(0, offsetY);
    invitePlaceContentView.frame = placeViewFrame;
    
    CGRect timeContentViewFrame = timeContentView.frame;
    timeContentViewFrame.origin = CGPointMake(0, invitePlaceContentView.frame.size.height + invitePlaceContentView.frame.origin.y);
    timeContentView.frame = timeContentViewFrame;
    
    CGRect conformViewframe = conformView.frame;
    conformViewframe.origin = CGPointMake(7, timeContentView.frame.size.height + timeContentView.frame.origin.y);
    conformView.frame = conformViewframe;
    
    CGRect commentContentViewFrame = commentContentView.frame;
    commentContentViewFrame.origin = CGPointMake(0, conformView.frame.origin.y +  conformView.frame.size.height + 30);
    commentContentView.frame = commentContentViewFrame;
    
    [scrollView setContentSize:CGSizeMake(320, commentContentViewFrame.origin.y + commentContentViewFrame.size.height)];
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
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary* userInfo = [notification userInfo];
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

@end
