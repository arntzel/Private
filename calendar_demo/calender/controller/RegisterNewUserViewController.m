
#import "RegisterNewUserViewController.h"
#import "UserModel.h"

@interface RegisterNewUserViewController ()

@end

@implementation RegisterNewUserViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction) cancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction) signup:(id)sender
{
    
    NSString * usename = self.tfUsername.text;
    NSString * email = self.tfEmail.text;
    NSString * password = self.tfPassword.text;

    //{"username":"user1", "password":"111111", "email":"user1@pencilme.com"}

    CreateUser * user = [[CreateUser alloc] init];
    user.username = usename;
    user.email = email;
    user.password = password;

    [self.indicator startAnimating];

    [[UserModel getInstance] createUser:user andCallback:^(NSInteger error) {

        [self.indicator stopAnimating];

        
        if(error == 0) {
            UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                          message:@"注册成功！"
                                                         delegate:nil
                                                cancelButtonTitle:@"确定"
                                                otherButtonTitles:nil];
            [alert show];
        } else {
            UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                          message:@"注册失败！"
                                                         delegate:nil
                                                cancelButtonTitle:@"确定"
                                                otherButtonTitles:nil];
            [alert show];
        }
    }];
}

@end
