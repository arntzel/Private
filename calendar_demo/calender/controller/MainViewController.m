
#import "MainViewController.h"
#import "FeedViewController.h"
#import "menuNavigation.h"

@interface MainViewController () <FeedViewControllerDelegate, >

@end

@implementation MainViewController



- (id)initWithRootViewController:(UIViewController*)controller {
    assert(NO);
    return nil;
}

-(id) init
{
    menuNavigation *leftController = [[menuNavigation alloc] init];
    FeedViewController * fdController = [[FeedViewController alloc] init];
    
    self = [super initWithRootViewController:fdController];
    
    self.leftViewController = leftController;
    
    fdController.delegate = self;

    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - FeedViewControllerDelegate
-(void)onBtnMenuClick {
    [self showLeftController:YES];
}
@end
