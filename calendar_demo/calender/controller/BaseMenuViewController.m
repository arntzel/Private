
#import "BaseMenuViewController.h"
#import "AddEventViewController.h"
#import "RootNavContrller.h"

@interface BaseMenuViewController ()
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
    self.navigation.unreadCount.hidden = NO;

    [self.view addSubview:self.navigation];
    [self.navigation.leftBtn addTarget:self action:@selector(btnMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.navigation.rightBtn addTarget:self action:@selector(btnAddEvent:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)btnMenu:(id)sender
{
    self.navigation.unreadCount.hidden = YES;
    
    if(self.delegate != nil) {
        [self.delegate onBtnMenuClick];
    }
}

#pragma mark -
#pragma mark btnEvent
- (void)btnAddEvent:(id)sender
{
    AddEventViewController *addEvent = [[AddEventViewController alloc] init];
    [[RootNavContrller defaultInstance] pushViewController:addEvent animated:YES];
}

@end
