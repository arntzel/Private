//
//  PwdChangeViewController.m
//  Calvin
//
//  Created by tu changwei on 13-9-27.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "PwdChangeViewController.h"
#import "SettingsModel.h"
#define oldPwdViewTag 1
#define newPwdViwTag 2
#define rePwdViewTag 3

@interface PwdChangeViewController ()

- (IBAction)showKeyboard:(UITapGestureRecognizer *)sender;

@end

@implementation PwdChangeViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Setup Views
- (void)setupViews
{
    self.navigation.titleLable.text = @"Change Password";
    self.navigation.leftBtn.frame = CGRectMake(8, 9, 67, 26);
    [self.navigation.leftBtn setBackgroundImage:[UIImage imageNamed:@"settings_detail_cancel_btn"] forState:UIControlStateNormal];
    [self.navigation.leftBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    self.navigation.rightBtn.frame = CGRectMake(245, 9, 67, 26);
    [self.navigation.rightBtn setBackgroundImage:[UIImage imageNamed:@"settings_detail_cancel_btn"] forState:UIControlStateNormal];
    [self.navigation.rightBtn setTitle:@"Save" forState:UIControlStateNormal];
    [self.navigation.rightBtn addTarget:self action:@selector(rightNavBtnBeClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.oldPwdField becomeFirstResponder];
}

#pragma mark - User Interaction
- (void)leftNavBtnClicked:(UIButton *)btn
{
    [self.oldPwdField resignFirstResponder];
    [self.pwdField resignFirstResponder];
    [self.rePwdField resignFirstResponder];
    [super  leftNavBtnClicked:btn];
}
- (void)rightNavBtnBeClicked:(UIButton *)btn
{
    [self changePwd];
    
}

- (IBAction)showKeyboard:(UITapGestureRecognizer *)sender
{
    switch (sender.view.tag)
    {
        case oldPwdViewTag:
            [self.oldPwdField becomeFirstResponder];
            break;
        case newPwdViwTag:
            [self.pwdField becomeFirstResponder];
            break;
        case rePwdViewTag:
            [self.rePwdField becomeFirstResponder];
            break;
            
        default:
            break;
    }
}

#pragma mark - Logic Helper
- (void)changePwd
{
    
    if ([self canContinue])
    {
        UIActivityIndicatorView *indi = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        indi.center = self.view.center;
        [self.view addSubview:indi];
        [indi startAnimating];
        SettingsModel *settingsModel = [[SettingsModel alloc] init];
        NSMutableDictionary *dic  = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.oldPwdField.text,@"oldpassword",self.pwdField.text,@"newpassword",nil];
        [settingsModel updateUserPwd:dic andCallback:^(NSInteger error) {
            
            [indi stopAnimating];
            [indi removeFromSuperview];
            if (error == -1)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Change Password Failed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
                
            }
            else
            {
                [self leftNavBtnClicked:nil];
            }
        }];
    }
    
}

- (BOOL)canContinue
{
    if (self.oldPwdField.text.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Old Password is nil." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return NO;
    }
    if (self.pwdField.text.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"New Password is nil." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return NO;
    }
    if (self.rePwdField.text.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Re-type Password is nil." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return NO;
    }
    if (![self.pwdField.text isEqualToString:self.rePwdField.text])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Re-type Password is not same with New Password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return NO;
    }
    return YES;
}

@end
