#import "MainViewController.h"
#import "FeedViewController.h"
#import "menuNavigation.h"
#import "PedingEventViewController.h"
#import "PedingEventViewControllerNew.h"
#import "BaseMenuViewController.h"
#import "SettingViewController.h"

#import "Model.h"
#import "UserModel.h"
#import "CoreDataModel.h"

#import "Utils.h"

@interface MainViewController () <BaseMenuViewControllerDelegate, MenuNavigationDelegate, CoreDataModelDelegate>
@end

@implementation MainViewController {

    FeedViewController * feedViewCtr;
    
//    PedingEventViewController * pendingEventViewCtr;
    PedingEventViewControllerNew * pendingEventViewCtr;
    
    SettingViewController * settingViewCtr;
    
    menuNavigation * menuNavigationController;
    int currentIndex;
}

- (id)initWithRootViewController:(UIViewController*)controller {
    assert(NO);
    return nil;
}

-(id) init
{
    LOG_D(@"MainViewController init");
    
    menuNavigation *leftController = [[menuNavigation alloc] init];
    leftController.delegate = self;

    feedViewCtr = [[FeedViewController alloc] init];
    feedViewCtr.popDelegate = self;
    
//    pendingEventViewCtr = [[PedingEventViewController alloc] init];
    pendingEventViewCtr = [[PedingEventViewControllerNew alloc] initWithNibName:@"PedingEventViewControllerNew" bundle:nil];
    pendingEventViewCtr.popDelegate = self;
    
    settingViewCtr = [[SettingViewController alloc] init];
    
    self = [super initWithRootViewController:feedViewCtr];
    
    self.leftViewController = leftController;
    
    feedViewCtr.delegate = self;
    pendingEventViewCtr.delegate = self;
    settingViewCtr.delegate = self;
    settingViewCtr.updataLeftNavBlock = ^{
     
        [leftController.tableView reloadData];
    };

    menuNavigationController = leftController;
    
    currentIndex = 0;

    User *me = [[UserModel getInstance] getLoginUser];
    [[CoreDataModel getInstance] initDBContext:me];

    
    //[feedViewCtr onCoreDataModelStarted];

    [[[Model getInstance] getEventModel] updateEventsFromLocalDevice:0 onComplete:^(NSInteger success, NSInteger totalCount) {
        
        //[feedViewCtr onCoreDataModelChanged];
        //[pendingEventViewCtr onCoreDataModelChanged];
        
    }];
    
    [[[Model getInstance] getEventModel] downloadServerEvents:nil];
    
    return self;
}

-(void) viewDidLoad
{
    [super viewDidLoad];
    LOG_D(@"MainViewController viewDidLoad");
    [[CoreDataModel getInstance] addDelegate:self];
}

-(void) viewDidUnload
{
    [[CoreDataModel getInstance] removeDelegate:self];
}

- (void)showLeftController:(BOOL)animated {
    //[menuNavigationController updateBlurBackground];
    //[super showLeftController:animated];
    //menuNavigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //[self.navigationController presentViewController:menuNavigationController animated:YES completion:nil];

    menuNavigationController.hadBlur = NO;
    menuNavigationController.view.alpha = 1;
    [self.view addSubview:menuNavigationController.view];
    
    
    [menuNavigationController reload];
    
    MessageModel * msgModel = [[Model getInstance] getMessageModel];
    if([msgModel getUnreadMsgCount] > 0) {
        
        [msgModel refreshModel:^(NSInteger error) {
            if(error ==0) {
                [msgModel updateMessageReadStatus:nil];
                [msgModel setUnReadMsgCount:0];
            } else {
                [Utils showUIAlertView:@"Error" andMessage:@"Network or server error"];
            }
        }];
    }
    if (settingViewCtr.nameChanged)
    {
        [settingViewCtr updataUserProfile:nil];
        settingViewCtr.nameChanged = NO;
    }
    [settingViewCtr dismissKeyBoard:nil];
}

-(BOOL)prefersStatusBarHidden
{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - FeedViewControllerDelegate
-(void)onBtnMenuClick {
    [self showLeftController:YES];
}
-(void)onBtnCalendarClick
{
    //self show
    [self onLogoButtonTyped];
}

#pragma mark - MenuNavigationDelegate
-(void) onMenuSelected:(int) menuIndex
{
    if (menuIndex == currentIndex) {
        [self showRootController:YES];
        return;
    }
    
    currentIndex = menuIndex;

    switch (menuIndex) {
        case 0: {
            [self setRootController:feedViewCtr animated:YES];
            break;
        }
        case 1: {
            [self setRootController:pendingEventViewCtr animated:YES];
            break;
        }

        case 2: {
            [self setRootController:settingViewCtr animated:YES];
            break;
        }

        default:
            break;
    }

}

-(void)onSettingButtonTyped
{
    if (self.rootViewController == settingViewCtr)
        return;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
    
    [self setRootViewController:settingViewCtr];
    [UIView commitAnimations];
}

-(void)onLogoButtonTyped
{
    if (self.rootViewController == feedViewCtr)
        return;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
    [self setRootViewController:feedViewCtr];
    [UIView commitAnimations];
}

-(void)onSegmentPressed:(id)sender
{
    UISegmentedControl *segControl = (UISegmentedControl*) sender;
    int selectedIndex = [segControl selectedSegmentIndex];
    if (selectedIndex == 0) {
        [UIView animateWithDuration:.1 animations:^{
            
            [self setRootViewController:feedViewCtr];
            
        } completion:^(BOOL finished) {
            //[segControl setSelectedSegmentIndex:0];
            [self showRootController:YES];
            
        }];
    } else if (selectedIndex == 1) {
        [UIView animateWithDuration:.1 animations:^{
            
            [self setRootViewController:pendingEventViewCtr];
            
        } completion:^(BOOL finished) {
            //[segControl setSelectedSegmentIndex:1];
            [self showRootController:YES];
            
        }];
    }
}

-(void) refreshViews
{
    //Do nothing
}

-(void) onControlledPopped:(BOOL)dataChanged {

    //[self refreshViews];
}

#pragma mark -
#pragma mark CoreDataModelDelegate
-(void) onCoreDataModelStarted
{
    //Do nothing
}

-(void) onCoreDataModelChanged
{
    //Do nothing

}

-(void) onEventChanged:(FeedEventEntity *) event andTpe:(EventChangeType) type
{
    LOG_D(@"onEventChanged:EventChangeType=%d, eventid=%d", type, [event.id intValue]);
    
    if(type == EventChangeType_Finalize) {
        //To show feedView
        [UIView animateWithDuration:.1 animations:^{
            [self setRootViewController:feedViewCtr];
        } completion:^(BOOL finished) {
            [feedViewCtr.navigation.calPendingSegment setSelectedSegmentIndex:0];
            [self showRootController:YES];
        }];
        
    } else if(type == EventChangeType_Unfinalize){
        
        //To show pendingView
        [UIView animateWithDuration:.1 animations:^{
            [self setRootViewController:pendingEventViewCtr];
        } completion:^(BOOL finished) {
            [pendingEventViewCtr.navigation.calPendingSegment setSelectedSegmentIndex:1];
            [self showRootController:YES];
        }];
    }
}
@end




