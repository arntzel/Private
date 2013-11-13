
#import "SettingViewController.h"
#import "UserModel.h"
#import "LoginMainViewController.h"
#import "RootNavContrller.h"
#import "UserSetting.h"
#import "CoreDataModel.h"
#import "UIView+LoadFromNib.h"
#import "SettingsContentView.h"

#import "EmailChangeViewController.h"
#import "RootNavContrller.h"
#import <MessageUI/MessageUI.h>
#import "PwdChangeViewController.h"
#import "ConnectAccountViewController.h"
#import "NotificaitonViewController.h"
#import "LegalViewController.h"
#import "ViewUtils.h"
#import "UIImage+CirCle.h"
#import "Model.h"
#import <SDWebImage/UIButton+WebCache.h>
#import <QuartzCore/QuartzCore.h>


#import "ShareLoginFacebook.h"
#import "LoginStatusCheck.h"
#import "LoginAccountStore.h"

#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#import "SettingsModel.h"

@interface SettingViewController ()<MFMailComposeViewControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UploadImageDelegate,GPPSignInDelegate,ShareLoginDelegate>

@property (nonatomic, strong) UIScrollView *scroller;
@property (nonatomic, strong) SettingsContentView *t_settingsContentView;
@property (nonatomic, strong) User *loginUser;
@property (nonatomic, strong) ASIFormDataRequest * request;
@property (nonatomic, strong) ShareLoginFacebook *snsLogin;

@end

@implementation SettingViewController

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
    [self setupViews];
    [self getUserInfo];
    [self setValueForViews];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Layout Helper
- (void)setupViews
{
    self.navigation.rightBtn.hidden = YES;
    self.navigation.titleLable.text = @"Accounts & Settings";
    
    [self.navigation.leftBtn addTarget:self action:@selector(btnMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    
    float scrollerY = CGRectGetMaxY(self.navigation.frame);
    self.scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, scrollerY, self.view.frame.size.width, self.view.frame.size.height - scrollerY)];
    self.scroller.backgroundColor = [UIColor clearColor];
    
    self.t_settingsContentView = [SettingsContentView tt_viewFromNibNamed:@"SettingsContentView" owner:self];
    self.t_settingsContentView.backgroundColor = [UIColor clearColor];
    [self.t_settingsContentView addTarget:self action:@selector(dismissKeyBoard:) forControlEvents:UIControlEventTouchUpInside];
    __weak SettingViewController *weakSelf = self;
    self.t_settingsContentView.pushDetailViewBlock = ^(int row)
    {
        [weakSelf pushDetail:row];
    };
    
    [self.t_settingsContentView.headPortaitBtn.layer setMasksToBounds:YES];
    self.t_settingsContentView.headPortaitBtn.layer.cornerRadius = self.t_settingsContentView.headPortaitBtn.frame.size.width/2;
    [self.t_settingsContentView.firstNameField addTarget:self action:@selector(textFieldValueChange:) forControlEvents:UIControlEventEditingChanged];
    [self.t_settingsContentView.lastNameField addTarget:self action:@selector(textFieldValueChange:) forControlEvents:UIControlEventEditingChanged];
    
    
    
    self.scroller.contentSize = CGSizeMake(self.view.frame.size.width, self.t_settingsContentView.frame.size.height);
    [self.scroller addSubview:self.t_settingsContentView];
    [self.view addSubview:self.scroller];
    
}

- (void)fbviewChangeWithConnectStatus:(BOOL)isConnect
{
    self.t_settingsContentView.fbTapGesture.enabled = isConnect;
    self.t_settingsContentView.fbLabel.hidden = !isConnect;
    self.t_settingsContentView.fbConnectBtn.hidden = isConnect;
    if (isConnect)
    {
        self.t_settingsContentView.fbLabel.text = self.loginUser.facebookEmail;
    }
}
- (void)googleviewChangeWithConnectStatus:(BOOL)isConnect
{
    self.t_settingsContentView.googleTapGesture.enabled = isConnect;
    self.t_settingsContentView.googleLabel.hidden = !isConnect;
    self.t_settingsContentView.googleConnectBtn.hidden = isConnect;
    if (isConnect)
    {
        self.t_settingsContentView.googleLabel.text = self.loginUser.googleEmail;
    }
}
#pragma mark - Data Helper
- (void)getUserInfo
{
    //self.loginUser = [[UserSetting getInstance] getLoginUserData];
    self.loginUser  = [[UserModel getInstance] getLoginUser];
}

- (void)setValueForViews
{
    self.t_settingsContentView.firstNameField.text = self.loginUser.first_name;
    self.t_settingsContentView.lastNameField.text = self.loginUser.last_name;
    self.t_settingsContentView.emailLabel.text = self.loginUser.email;
    
    [self.t_settingsContentView.headPortaitBtn setImageWithURL:[NSURL URLWithString:self.loginUser.avatar_url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"settings_main_head_portait_default"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        
        if (error)
        {
            [self.t_settingsContentView.headPortaitBtn setImage:[UIImage imageNamed:@"settings_main_head_portait_default"] forState:UIControlStateNormal];
            LOG_D(@"get avatar from remote failed.");
        }
    }];
    
    if (self.loginUser.facebookEmail)
    {
        [self fbviewChangeWithConnectStatus:YES];
    }
    else
    {
        [self fbviewChangeWithConnectStatus:NO];
    }
    if (self.loginUser.googleEmail)
    {
        [self googleviewChangeWithConnectStatus:YES];
    }
    else
    {
        [self googleviewChangeWithConnectStatus:NO];
    }
}

#pragma mark - User Interaction Helper
- (void)btnMenu:(id)sender
{
    if(self.delegate != nil) {
        
        [self.delegate onBtnMenuClick];
    }
}

- (void)dismissKeyBoard:(id)sender
{
    [self.t_settingsContentView.firstNameField resignFirstResponder];
    [self.t_settingsContentView.lastNameField resignFirstResponder];
}

-(IBAction) logout:(id)sender
{
    [[UserModel getInstance] setLoginUser:nil];

    [[UserSetting getInstance] reset];
    [[CoreDataModel getInstance] reset];
    
    RootNavContrller *navController = [RootNavContrller defaultInstance];

        
    [navController popToRootViewControllerAnimated:NO];

    LoginMainViewController* loginController = [[LoginMainViewController alloc] init];
    [navController pushViewController:loginController animated:NO];
}

- (void)deleteAccount
{
    SettingsModel *model = [[SettingsModel alloc] init];
    [model deleteAccount:^(NSInteger error) {
        
        if (error==0)
        {
            NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
            [accountDefaults removeObjectForKey:@"email"];
            [self logout:nil];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Delete account failed." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }
    }];
}
- (void)pushDetail:(int)row
{
    [self dismissKeyBoard:nil];
    
    if (row == emailViewTag
        ||row == pwdViewTag
        ||row == connectFacebookBtnTag
        ||row == connectGoogleBtnTag
        ||row == notificationViewTag
        ||row == termViewTag
        ||row == policyViewTag
        ||row == aboutUsViewTag
        )
    {
        UIViewController *viewCtr = nil;
        switch (row)
        {
            case emailViewTag:
            {
                viewCtr = [[EmailChangeViewController alloc] initWithNibName:@"EmailChangeViewController" bundle:[NSBundle mainBundle]];
                ((EmailChangeViewController *)viewCtr).emailChangedBlock = ^{
                    
                    self.t_settingsContentView.emailLabel.text = self.loginUser.email;
                    if (self.updataLeftNavBlock)
                    {
                        self.updataLeftNavBlock();
                    }
                };
                break;
            }
            case pwdViewTag:
                viewCtr = [[PwdChangeViewController alloc] initWithNibName:@"PwdChangeViewController" bundle:[NSBundle mainBundle]];
                [(PwdChangeViewController *)viewCtr setHas_usable_password:self.loginUser.has_usable_password];
                break;
            case connectFacebookBtnTag:
//                viewCtr = [[ConnectAccountViewController alloc] initWithNibName:@"ConnectAccountViewController" bundle:[NSBundle mainBundle]];
//                [(ConnectAccountViewController *)viewCtr setType:ConnectFacebook];
                [self connectFacebook];
                break;
            case connectGoogleBtnTag:
//                viewCtr = [[ConnectAccountViewController alloc] initWithNibName:@"ConnectAccountViewController" bundle:[NSBundle mainBundle]];
//                [(ConnectAccountViewController *)viewCtr setType:ConnectGoogle];
                [self connectGoogle];
                break;
            case notificationViewTag:
                viewCtr = [[NotificaitonViewController alloc] initWithNibName:@"NotificaitonViewController" bundle:[NSBundle mainBundle]];

                break;
            case termViewTag:
                viewCtr = [[LegalViewController alloc] initWithNibName:@"LegalViewController" bundle:[NSBundle mainBundle]];
                [(LegalViewController *)viewCtr setType:TermsOfUs];
                break;
            case policyViewTag:
                viewCtr = [[LegalViewController alloc] initWithNibName:@"LegalViewController" bundle:[NSBundle mainBundle]];
                [(LegalViewController *)viewCtr setType:PrivacyPolicy];
                break;
            case aboutUsViewTag:
                viewCtr = [[LegalViewController alloc] initWithNibName:@"LegalViewController" bundle:[NSBundle mainBundle]];
                [(LegalViewController *)viewCtr setType:AboutUs];
                break;
            default:
                break;
        }
        
        [[RootNavContrller defaultInstance] pushViewController:viewCtr animated:YES];
    }

    else if (row == logoutBtnTag || row == deleteAccountBtnTag)
    {
        [self createActionSheetWithRow:row];
    }
    else if (row == fbViewTag || row == googleViewTag)
    {
        [self createActionSheetWithRow:row];
    }
    else if (row == sendFeedBackBtnTag)
    {
        [self   sendEmail];
    }
    else if (row == headPortraitBtnTag)
    {
        [self createActionSheetWithRow:row];
    }
   
}

#pragma mark - Logic Helper
-(void)sendEmail
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailView = [[MFMailComposeViewController alloc] init];

        mailView.mailComposeDelegate = self;
        [mailView setSubject:@"Calvin Feedback"];
        [mailView setToRecipients:@[@"feedback@calvinapp.com"]];
        [self presentViewController:mailView animated:YES completion:nil];
        
    }
    else
    {
        
    }
}

- (void)createActionSheetWithRow:(int)row
{
    UIActionSheet *sheet = nil;
    if (row == headPortraitBtnTag)
    {
        sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Picker Photo From Album" otherButtonTitles:@"Picker Photo From Camera", nil];

    }
    else if (row == fbViewTag || row == googleViewTag)
    {
        NSString *destructiveButtonTitle = row==fbViewTag ? @"Unlink Facebook":@"Unlink Google";
        sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:nil];
    }
    else if (row == logoutBtnTag || row == deleteAccountBtnTag)
    {
        NSString *destructiveButtonTitle = row==logoutBtnTag ? @"Log Out":@"Delete Account";
        
        sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:nil];
    }
    
    sheet.tag = row;
    [sheet showInView:self.view];
}


- (void)getImageFrom:(UIImagePickerControllerSourceType)type
{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = type;
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
}

-(void) uploadImage:(UIImage *) img
{
    SettingsModel *model = [[SettingsModel alloc] init];
    [model updateAvatar:img andCallback:^(NSInteger error, NSString *url) {
        
        if(error == 0)
        {
            
            [self updataUserProfile:url];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Upload Failed" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
            [self.t_settingsContentView.headPortaitBtn setImage:[UIImage imageNamed:@"settings_main_head_portait_default"] forState:UIControlStateNormal];
        }
    }];
}

- (void)connectGoogle
{
    [self configGPPSignIn];
    [[GPPSignIn sharedInstance] signOut];
    [[GPPSignIn sharedInstance] authenticate];
}

- (void)configGPPSignIn
{
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
}
- (void)connectFacebook
{
    //loginType

    self.snsLogin = [[ShareLoginFacebook alloc]init];
    self.snsLogin.delegate = self;
    [self.snsLogin shareLogin];
   

}

- (void)disconnect:(ConnectType) type
{
    SettingsModel *model = [[SettingsModel alloc] init];
    NSString * accessToken = @"";
    if (type == ConnectFacebook)
    {
        LoginAccountStore * store = [LoginAccountStore defaultAccountStore];
        accessToken = store.facebookAccessToken;
    }
    [model updateConnect:type tokenVale:accessToken IsConnectOrNot:NO andCallback:^(NSInteger error,NSString *message) {
        
        NSString *msg = @"";
        if (type == ConnectGoogle)
        {
            if (error == -1)
            {
                msg = @"Disconnect Google Failed";
                
            }
            else
            {
                if (message)
                {
                    msg = message;
                }
                else
                {
                    msg = @"Disconnect Google Succeeded";
                    [self googleviewChangeWithConnectStatus:NO];
                }
                
                
        
            }
        }
        else
        {
            if (error == -1)
            {
                msg = @"Disconnect Facebook Failed";
                
            }
            else
            {
                if (message)
                {
                    msg = message;
                }
                else
                {
                    msg = @"Disconnect Facebook Succeeded";
                    [self fbviewChangeWithConnectStatus:NO];
                }
                
            }
        }
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
    }];
}

- (void)updataUserProfile:(NSString *)avatar_url
{
    SettingsModel *model = [[SettingsModel alloc] init];
    User *tmpUser = [[User alloc] init];
    tmpUser.id = self.loginUser.id;
    tmpUser.profileUrl = self.loginUser.profileUrl;
    tmpUser.first_name = self.t_settingsContentView.firstNameField.text;
    tmpUser.last_name = self.t_settingsContentView.lastNameField.text;
    tmpUser.avatar_url =  avatar_url;
    if (!tmpUser.first_name)
    {
        tmpUser.first_name = @"";
    }
    if (!tmpUser.last_name)
    {
        tmpUser.last_name = @"";
    }

    [model updateUserProfile:tmpUser andCallback:^(NSInteger error) {
        
        if (error == -1)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Update Profile Failed" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
            [self.t_settingsContentView.headPortaitBtn setImageWithURL:[NSURL URLWithString:self.loginUser.avatar_url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"settings_main_head_portait_default"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                
                if (error)
                {
                    [self.t_settingsContentView.headPortaitBtn setImage:[UIImage imageNamed:@"settings_main_head_portait_default"] forState:UIControlStateNormal];
                    LOG_D(@"get avatar from remote failed.");
                }
            }];
            self.t_settingsContentView.firstNameField.text = self.loginUser.first_name;
            self.t_settingsContentView.lastNameField.text = self.loginUser.last_name;
            
        }
        else
        {
            self.loginUser.first_name = tmpUser.first_name;
            self.loginUser.last_name = tmpUser.last_name;
            if (tmpUser.avatar_url)
            {
                self.loginUser.avatar_url = tmpUser.avatar_url;
            }
            
            if (self.updataLeftNavBlock)
            {
                self.updataLeftNavBlock();
            }
        }
    }];
}
- (void)textFieldValueChange:(UITextField *)field
{
    self.nameChanged = YES;
}
#pragma mark - UploadImageDelegate
-(void) onUploadStart
{
    
}
-(void) onUploadProgress: (long long) progress andSize: (long long) Size
{
    float prg = (float)progress / (float)Size;
    //self.t_settingsContentView.headPortaitBtn.alpha = 0.3 + prg*0.7;
    LOG_D(@"onUploadProgress: progress=%f", prg);
}

-(void) onUploadCompleted: (int) error andUrl:(NSString *) url
{
    LOG_D(@"onUploadCompleted: url=%@", url);
    
    //self.t_settingsContentView.headPortaitBtn.alpha = 1;
    
    if(error == 0)
    {
        
        [self updataUserProfile:url];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Upload Failed" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        [self.t_settingsContentView.headPortaitBtn setImage:[UIImage imageNamed:@"settings_main_head_portait_default"] forState:UIControlStateNormal];
    }
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (actionSheet.tag == headPortraitBtnTag)
    {
        if (buttonIndex == 0)
        {
            [self getImageFrom:UIImagePickerControllerSourceTypePhotoLibrary];
        }
        else if(buttonIndex == 1)
        {
            [self getImageFrom:UIImagePickerControllerSourceTypeCamera];
        }
    }
    else if (actionSheet.tag == logoutBtnTag)
    {
        if (buttonIndex == 0)
        {
            [self logout:nil];
        }
    }
    else if (actionSheet.tag == deleteAccountBtnTag)
    {
        if (buttonIndex == 0)
        {
            [self deleteAccount];
        }
    }
    else if (actionSheet.tag ==  fbViewTag)
    {
        if (buttonIndex == 0)
        {
            [self disconnect:ConnectFacebook];
        }
        
    }
    else if (actionSheet.tag ==  googleViewTag)
    {
        if (buttonIndex == 0)
        {
            [self disconnect:ConnectGoogle];
        }
        
    }
    
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    
    CGSize targetSize = self.t_settingsContentView.headPortaitBtn.frame.size;
    UIImage * newImage = [ViewUtils imageByScalingAndCroppingForSize:targetSize andUIImage:image];
    
    [self.t_settingsContentView.headPortaitBtn setImage:newImage forState:UIControlStateNormal];
    [picker dismissModalViewControllerAnimated:YES];
    
    [self uploadImage:newImage];
}

#pragma mark GPPSignInDelegate
- (void)finishedWithAuth:(GTMOAuth2Authentication *)auth
                   error:(NSError *)error
{
    LOG_D(@"finishedWithAuth:%@", error);
    
    if(error == nil) {
        NSString  * acesssToken  = auth.accessToken;
        LOG_D(@"Google acesssToken:%@, client secet=%@", acesssToken, auth.clientSecret);
        SettingsModel *settingsModel = [[SettingsModel alloc] init];
        [settingsModel updateConnect:ConnectGoogle tokenVale:acesssToken IsConnectOrNot:YES andCallback:^(NSInteger error, NSString *message) {
            
            NSString *msg = @"";
            if (error == -1)
            {
                msg = @"Connect Google Failed";
                
            }
            else
            {
                if (message)
                {
                    msg = message;
                }
                else
                {
                    msg = @"Connect Google Succeeded";
                    self.loginUser.googleEmail = auth.userEmail;
                    [self googleviewChangeWithConnectStatus:YES];
                }
            }
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }];
    }
    else
    {
        LOG_D(@"%@",error);
    }
}

- (void)didDisconnectWithError:(NSError *)error
{
    LOG_D(@"didDisconnectWithError:%@", error);
}

#pragma mark ShareLoginDelegate
- (void)shareDidLogin:(ShareLoginBase *)shareLogin
{
    LoginAccountStore * store = [LoginAccountStore defaultAccountStore];
    NSString * accessToken = store.facebookAccessToken;
    LOG_D(@"shareDidLogin:%@", accessToken);
    SettingsModel *settingsModel = [[SettingsModel alloc] init];
    [settingsModel updateConnect:ConnectFacebook tokenVale:accessToken IsConnectOrNot:YES andCallback:^(NSInteger error,NSString *message) {
        
        NSString *msg = @"";
        if (error == -1)
        {
            msg = @"Connect Facebook Failed";
            
        }
        else
        {
            if (message)
            {
                msg = message;
            }
            else
            {
                msg = @"Connect Facebook Succeeded";
                self.loginUser.facebookEmail = store.facebookEmail;
                [self fbviewChangeWithConnectStatus:YES];
            }
           
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
    }];
    
}

#pragma mark - MFMailComposeViewControllerDelegate
- (void) mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            break;
        case MFMailComposeResultSent:
            break;
        case MFMailComposeResultFailed:
            break;
            
        default:
            break;
    }
 
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
