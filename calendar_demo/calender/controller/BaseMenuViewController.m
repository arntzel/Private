#import "BaseMenuViewController.h"
#import "AddEventControllerV2.h"
#import "RootNavContrller.h"
#import "Model.h"
#import "MessageModel.h"
#import "MainViewController.h"

@interface BaseMenuViewController () <MessageModelDelegate>
@end

@implementation BaseMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigation = [Navigation createNavigationView];
    [self.navigation setUpMainNavigationButtons:FEED_PENDING];
    
    [self.view addSubview:self.navigation];
    [self.navigation.leftBtn addTarget:self action:@selector(btnMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.navigation.rightBtn addTarget:self action:@selector(btnAddEvent:) forControlEvents:UIControlEventTouchUpInside];

    [[[Model getInstance] getMessageModel] addDelegate:self];
    
    [self onMessageModelChanged];
}

-(void) viewWillUnload {
    [[[Model getInstance] getMessageModel] removeDelegate:self];
    [super viewWillUnload];    
}

- (void)btnMenu:(id)sender
{
    if (self.delegate != nil) {
       [self.delegate onBtnMenuClick];
    }
}

-(BOOL)prefersStatusBarHidden
{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark -
#pragma mark btnEvent
- (void)btnAddEvent:(id)sender
{
    AddEventControllerV2 *addEvent = [[AddEventControllerV2 alloc] init];
    addEvent.popDelegate = self;
    
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.3];
    [animation setType: kCATransitionMoveIn];
    [animation setSubtype: kCATransitionFromTop];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    
    [[RootNavContrller defaultInstance] pushViewController:addEvent animated:NO];
    [[RootNavContrller defaultInstance].view.layer  addAnimation:animation forKey:nil];
}

-(void) onMessageModelChanged
{
    int count = [[[Model getInstance] getMessageModel] getUnreadMsgCount];
    
    if(count>0) {
        self.navigation.unreadCount.text = [NSString stringWithFormat:@"%d", count];
        self.navigation.unreadCount.hidden = NO;
    } else {
        self.navigation.unreadCount.hidden = YES;
    }
}

-(void)onControlledPopped:(BOOL)dataChanged
{
    [self.delegate onControlledPopped:dataChanged];
}

@end
