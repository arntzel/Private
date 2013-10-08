//
//  EmailChangeViewController.m
//  Calvin
//
//  Created by tu changwei on 13-9-26.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "EmailChangeViewController.h"
#import "DeviceInfo.h"
#import "SettingsModel.h"
#import "UserModel.h"
#define emailViewTag 1
#define confirmViewTag 2
@interface EmailChangeViewController ()

- (IBAction)showKeyboard:(UITapGestureRecognizer *)sender;

@end

@implementation EmailChangeViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setup Views
- (void)setupViews
{
    self.navigation.titleLable.text = @"Email";
    self.navigation.leftBtn.frame = CGRectMake(8, 9, 67, 26);
    [self.navigation.leftBtn setBackgroundImage:[UIImage imageNamed:@"settings_detail_cancel_btn"] forState:UIControlStateNormal];
    [self.navigation.leftBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    self.navigation.rightBtn.frame = CGRectMake(245, 9, 67, 26);
    [self.navigation.rightBtn setBackgroundImage:[UIImage imageNamed:@"settings_detail_cancel_btn"] forState:UIControlStateNormal];
    [self.navigation.rightBtn setTitle:@"Save" forState:UIControlStateNormal];
    [self.navigation.rightBtn addTarget:self action:@selector(rightNavBtnBeClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.emailField becomeFirstResponder];
}

#pragma mark - User Interaction
- (void)leftNavBtnClicked:(UIButton *)btn
{
    [self.emailField resignFirstResponder];
    [super  leftNavBtnClicked:btn];
}
- (void)rightNavBtnBeClicked:(UIButton *)btn
{
    
    [self changeEmail];
}

- (IBAction)showKeyboard:(UITapGestureRecognizer *)sender
{
    switch (sender.view.tag)
    {
        case emailViewTag:
            [self.emailField becomeFirstResponder];
            break;
        case  confirmViewTag:
            [self.confirmEmailField becomeFirstResponder];
            break;
            
        default:
            break;
    }

}

#pragma mark - Logic Helper
- (void)changeEmail
{
    
    if ([self canContinue])
    {
        UIActivityIndicatorView *indi = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        indi.center = self.view.center;
        [self.view addSubview:indi];
        [indi startAnimating];
        SettingsModel *settingsModel = [[SettingsModel alloc] init];
        [settingsModel updateUserEmail:self.emailField.text andCallback:^(NSInteger error) {
            
            [indi stopAnimating];
            [indi removeFromSuperview];
            if (error == -1)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Change Email Failed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
                
            }
            else
            {
                if (self.emailChangedBlock)
                {
                    [[UserModel getInstance] getLoginUser].email = self.emailField.text;
                    self.emailChangedBlock();
                }
                [self leftNavBtnClicked:nil];
            }
        }];
    }
    
}

-(BOOL)isValidateEmail:(NSString *)email

{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    return [emailTest evaluateWithObject:email];
    
}
- (BOOL)canContinue
{
    if (![self isValidateEmail:self.emailField.text] || ![self isValidateEmail:self.confirmEmailField.text])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Email format is not legal" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return NO;
    }
    NSString *email = self.emailField.text;
    NSString *confirmEmail = self.confirmEmailField.text;
    if (![email isEqualToString:confirmEmail])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Two input is inconsistent" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return NO;
    }
    return YES;
}
@end
