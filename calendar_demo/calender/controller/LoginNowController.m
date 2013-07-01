
#import "LoginNowController.h"
#import "UserModel.h"
#import "FeedViewController.h"
#import "MainViewController.h"
#import "RootNavContrller.h"
#import "menuNavigation.h"

@interface LoginNowController ()

@end

@implementation LoginNowController

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

    self.progress.hidesWhenStopped = YES;
    [self.progress stopAnimating];

    //For Test
    self.tvUsername.text = @"fx.fangxiang@gmail.com";
    self.tvPassword.text = @"pass1234";
}

-(IBAction) back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction) login:(id)sender
{
    [self.progress startAnimating];
    self.btnLogin.userInteractionEnabled = NO;

    NSString * username = self.tvUsername.text;
    NSString * password = self.tvPassword.text;

    [[UserModel getInstance] login:username withPassword:password andCallback:^(NSInteger error, User *user) {

        [self.progress stopAnimating];
        self.btnLogin.userInteractionEnabled = YES;

        if(error == 0) {

            [self onLogined];

        } else {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Error"
                                                          message:@"Login failed！"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];

            [alert show];
        }
        
    }];
}

-(void) onLogined
{
    menuNavigation *leftController = [[menuNavigation alloc] init];
    FeedViewController * fdController = [[FeedViewController alloc] init];


    MainViewController *rootController = [[MainViewController alloc] initWithRootViewController:fdController];
    rootController.leftViewController = leftController;

    fdController.delegate = rootController;

    [[RootNavContrller defaultInstance] popViewControllerAnimated:NO];
    [[RootNavContrller defaultInstance] pushViewController:rootController animated:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
