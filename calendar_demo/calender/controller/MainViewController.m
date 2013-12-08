
#import "MainViewController.h"
#import "FeedViewController.h"
#import "menuNavigation.h"
#import "PedingEventViewController.h"
#import "BaseMenuViewController.h"
#import "SettingViewController.h"

#import "Model.h"
#import "UserModel.h"
#import "CoreDataModel.h"

#import "Utils.h"

@interface MainViewController () <BaseMenuViewControllerDelegate, MenuNavigationDelegate>
@end

@implementation MainViewController {

    FeedViewController * feedViewCtr;
    PedingEventViewController * pendingEventViewCtr;
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
    menuNavigation *leftController = [[menuNavigation alloc] init];
    leftController.delegate = self;

    feedViewCtr = [[FeedViewController alloc] init];
    pendingEventViewCtr = [[PedingEventViewController alloc] init];
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

    User * me = [[UserModel getInstance] getLoginUser];
    [[CoreDataModel getInstance] initDBContext:me];
    
    return self;
}

- (void)showLeftController:(BOOL)animated {

    //[super showLeftController:animated];
    [self.navigationController presentViewController:menuNavigationController animated:YES completion:nil];

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
    [UIView animateWithDuration:.2 animations:^{
        
        [self setRootViewController:settingViewCtr];
        
    } completion:^(BOOL finished) {
        
        [self showRootController:YES];
        
    }];
    
    //[self presentViewController:settingViewCtr animated:YES completion:nil];
    
    //UIView *view = settingViewCtr.view;
    //view.frame = self.view.bounds;
    //[self.view addSubview:view];
    
    //[super addPanGesture];
}

-(void)onLogoButtonTyped
{
    [UIView animateWithDuration:.2 animations:^{
        
        [self setRootViewController:feedViewCtr];
        
    } completion:^(BOOL finished) {
        
        [self showRootController:YES];
        
    }];
}
@end
