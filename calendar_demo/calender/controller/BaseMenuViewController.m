
#import "BaseMenuViewController.h"
#import "AddEventViewController.h"
#import "RootNavContrller.h"
#import "Model.h"
#import "MessageModel.h"

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
    [self.navigation setUpMainNavigationButtons];
    
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
    if(self.delegate != nil) {
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
    AddEventViewController *addEvent = [[AddEventViewController alloc] init];
    [[RootNavContrller defaultInstance] pushViewController:addEvent animated:YES];
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
@end
