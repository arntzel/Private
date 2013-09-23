
#import "SignupViewController.h"
#import "LoginView.h"


#import "menuNavigation.h"

#import "LoginNowController.h"
#import "FeedViewController.h"

#import "MainViewController.h"
#import "RootNavContrller.h"
#import "UserModel.h"

#import "ShareLoginFacebook.h"
#import "LoginStatusCheck.h"
#import "LoginAccountStore.h"

#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>

#import "RegisterNewUserViewController.h"

#import "ViewUtils.h"

@interface SignupViewController () <ShareLoginDelegate, GPPSignInDelegate>

  

@end

@implementation SignupViewController {
    ShareLoginFacebook * snsLogin;
    int loginType;
    
    UIActivityIndicatorView * loadingView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //CGRect frame = self.view.frame;
    LoginView * view = [LoginView createView];
    
    [view.signupGoogle addTarget:self action:@selector(signupGoogle) forControlEvents:UIControlEventTouchUpInside];
    [view.signupFacebook addTarget:self action:@selector(signupFacebook) forControlEvents:UIControlEventTouchUpInside];
    [view.signupEmail addTarget:self action:@selector(signupEmail) forControlEvents:UIControlEventTouchUpInside];

    view.loginnow.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(login)];
    [view.loginnow addGestureRecognizer:tapGes];
                                                                                                          
    
    CGRect frame2 = self.view.bounds;
    //frame2.origin.y  = (frame.size.height - frame2.size.height)/2;
    view.frame = frame2;
    
    [self.view addSubview: view];
    
    loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    loadingView.center = self.view.center;
    loadingView.hidesWhenStopped = YES;
    [self.view addSubview:loadingView];
    
    
    //Google sign in init
    GPPSignIn * signIn = [GPPSignIn sharedInstance];
    signIn.clientID = @"925583491857-13g9a7inud7m0083m5jfbjinn3mp58ch.apps.googleusercontent.com";
    //signIn.clientID = @"1031805047217.apps.googleusercontent.com";
    //signIn.clientID = @"413114824893.apps.googleusercontent.com";
    
    signIn.shouldFetchGoogleUserEmail = YES;

    signIn.actions = [NSArray arrayWithObjects:
                                            @"http://schemas.google.com/AddActivity",
                                            @"http://schemas.google.com/BuyActivity",
                                            @"http://schemas.google.com/CheckInActivity",
                                            @"http://schemas.google.com/CommentActivity",
                                            @"http://schemas.google.com/CreateActivity",
                                            @"http://schemas.google.com/ListenActivity",
                                            @"http://schemas.google.com/ReserveActivity",
                                            @"http://schemas.google.com/ReviewActivity",
                                           nil];
    
    signIn.scopes = [NSArray arrayWithObjects:
                                              kGTLAuthScopePlusLogin,
                                              kGTLAuthScopePlusMe,
                                              @"https://www.googleapis.com/auth/calendar",
                                              @"https://www.googleapis.com/auth/userinfo.profile",
                                              @"https://www.googleapis.com/auth/userinfo.email",
                                              @"https://www.google.com/m8/feeds", 
                                              nil];
    
    signIn.delegate = self;
    
    [ViewUtils resetUILabelFont:self.view];
}

-(void)login
{
    LoginNowController * ctrl = [[LoginNowController alloc] initWithNibName:@"LoginNowController" bundle:nil];
    [self.navigationController pushViewController:ctrl animated:YES];
}

-(void)signupGoogle {
    //TODO::
    loginType = 2;
    
    [[GPPSignIn sharedInstance] signOut];
    [[GPPSignIn sharedInstance] authenticate];
}

-(void)signupFacebook {
  
    loginType = 1;
    
    if(![LoginStatusCheck isFacebookAccountLoginIn])
    {
        snsLogin = [[ShareLoginFacebook alloc]init];
        snsLogin.delegate = self;
        [snsLogin shareLogin];
    }
    else
    {
        [self shareDidLogin:nil];
    }
}

-(void) signupEmail {
//    [self finish];
//
//    [loadingView startAnimating];
//    
//    [[UserModel getInstance] login:@"zhiwehu@gmail.com" withPassword:@"111111" andCallback:^(NSInteger error, User *user) {
//        [loadingView stopAnimating];
//        
//        NSLog(@"signupEmail error=%d", error);
//
//        
//        if(error == 0) {
//            [self onLogined];
//        } else {
//            //TOODO::
//        }
//    }];
    
    RegisterNewUserViewController * ctr = [[RegisterNewUserViewController alloc] init];
    [self.navigationController pushViewController:ctr animated:YES];
}

-(void) finish {
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
//
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    
//    [[UIApplication sharedApplication] setStatusBarHidden:NO];
//}



- (void)shareDidLogin:(ShareLoginBase *)shareLogin
{
    
    LoginAccountStore * store = [LoginAccountStore defaultAccountStore];
    
    if (1 == loginType) {
        NSString * accessToken = store.facebookAccessToken;
        
        LOG_D(@"shareDidLogin:%@", accessToken);
        
        [loadingView startAnimating];
        [[UserModel getInstance] signinFacebook:accessToken andCallback:^(NSInteger error, User *user) {
            
            [loadingView stopAnimating];
            
            LOG_D(@"signinFacebook:%d", error);
            
            if(error == 0) {
                [self onLogined];
            } else {
                [self showAlert:@"Login with facebook failed."];
            }
        }];
    }
}

-(void) onLogined
{
    MainViewController *rootController = [[MainViewController alloc] init];
    
    [[RootNavContrller defaultInstance] popViewControllerAnimated:NO];
    [[RootNavContrller defaultInstance] pushViewController:rootController animated:YES];

}

- (void)shareDidNotLogin:(ShareLoginBase *)shareLogin
{
    LOG_D(@"shareDidNotLogin");
}

- (void)shareDidNotNetWork:(ShareLoginBase *)shareLogin
{
    LOG_D(@"shareDidNotNetWork");
}

- (void)shareDidLogout:(ShareLoginBase *)shareLogin
{
    LOG_D(@"shareDidNotNetWork");
    
    NSString * accessToken = FBSession.activeSession.accessToken;
    
    LOG_D(@"shareDidLogin:%@", accessToken);
    
    
    [[UserModel getInstance] signinFacebook:accessToken andCallback:^(NSInteger error, User *user) {
        if(error == 0) {
            
        } else {
            
        }
    }];
}

- (void)shareDidLoginErr:(ShareLoginBase *)shareLogin
{
    LOG_D(@"shareDidLoginErr");
}

- (void)shareDidLoginTimeOut:(ShareLoginBase *)shareLogin
{
    LOG_D(@"shareDidLoginTimeOut");
}

//google sign in delegate
// The authorization has finished and is successful if |error| is |nil|.
- (void)finishedWithAuth:(GTMOAuth2Authentication *)auth error:(NSError *)error
{
    LOG_D(@"finishedWithAuth:%@", error);
    
    if(error == nil) {
        NSString  * acesssToken  = auth.accessToken;
        LOG_D(@"Google acesssToken:%@, client secet=%@", acesssToken, auth.clientSecret);
        [loadingView startAnimating];
        [[UserModel getInstance] signinGooglePlus:acesssToken andCallback:^(NSInteger error, User *user) {
            
            LOG_D(@"signinGooglePlus:%d", error);

            
            [loadingView stopAnimating];
            
            if(error == 0) {
                [self onLogined];
            } else {
                [self showAlert:@"Login with google failed."];
            }
        }];
        
    } else {
        [self showAlert:@"Google+ auth failed, please retry again!"];   
    }

}

-(void) showAlert:(NSString *) msg
{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Warning"
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    
    [alert show];

}

- (void)didDisconnectWithError:(NSError *)error
{
    LOG_D(@"didDisconnectWithError:%@", error);
}
@end
