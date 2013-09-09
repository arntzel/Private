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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
//    [self.view setBackgroundColor:[UIColor colorWithRed:231/255.0f green:231/255.0f blue:231/255.0f alpha:1.0]];
    [self.view setBackgroundColor:[UIColor colorWithRed:243/255.0f green:243/255.0f blue:243/255.0f alpha:1.0]];
    [self addPhotoView];
    [self addNavBar];
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, navBar.frame.size.height, 320, 524)];
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
    
    [[Model getInstance] getEvent:self.eventID andCallback:^(NSInteger error, Event *event) {
        
        [self hideIndicatorView];
        
        if(error == 0) {
            
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

@end
