

#import "PedingEventViewController.h"
#import "Navigation.h"
#import "EventPendingView.h"

#import "RootNavContrller.h"

@interface PedingEventViewController ()

@end

@implementation PedingEventViewController {
    Navigation * navigation;
    EventPendingView * pendingView;
}



- (void)viewDidLoad
{
    [super viewDidLoad];

    navigation = [Navigation createNavigationView];
    navigation.titleLable.text = @"PENDING";
    [self.view addSubview:navigation];

    [navigation.leftBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];

    pendingView = [EventPendingView createView];
    CGRect frame = self.view.bounds;
    frame.origin.y = navigation.frame.size.height;
    frame.size.height -= frame.origin.y;
    pendingView.frame = frame;

    [self.view addSubview:pendingView];

}

-(void)back:(id)sender {
    [[RootNavContrller defaultInstance] popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
