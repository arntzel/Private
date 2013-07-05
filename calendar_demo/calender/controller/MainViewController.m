
#import "MainViewController.h"
#import "FeedViewController.h"
#import "menuNavigation.h"
#import "PedingEventViewController.h"
#import "BaseMenuViewController.h"

@interface MainViewController () <BaseMenuViewControllerDelegate, MenuNavigationDelegate>

   


@end

@implementation MainViewController {

    FeedViewController * feedViewCtr;
    PedingEventViewController * pendingEventViewCtr;

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

    self = [super initWithRootViewController:feedViewCtr];
    
    self.leftViewController = leftController;
    
    feedViewCtr.delegate = self;
    pendingEventViewCtr.delegate = self;
    
    

    currentIndex = 0;
    
    return self;
}

- (void)showLeftController:(BOOL)animated {

    [super showLeftController:animated];

    feedViewCtr.navigation.unreadCount.hidden = YES;
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
            

        default:
            break;
    }

}
@end