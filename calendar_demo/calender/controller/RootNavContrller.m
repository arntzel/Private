
#import "RootNavContrller.h"

static RootNavContrller* defaultNavController = nil;

@interface RootNavContrller ()

@end

@implementation RootNavContrller

+ (RootNavContrller *)defaultInstance
{
    if (defaultNavController == nil) {
        defaultNavController = [[RootNavContrller alloc] init];
    }
    return defaultNavController;
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

- (BOOL)shouldAutorotate
{
    return self.topViewController.shouldAutorotate;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return self.topViewController.supportedInterfaceOrientations;
}
@end
