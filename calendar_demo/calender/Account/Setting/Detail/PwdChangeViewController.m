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
    if (self.has_usable_password)
    {
        self.navigation.titleLable.text = @"Change Password";
    }
    else
    {
       self.navigation.titleLable.text = @"Set Password";
        self.oldPwdView.hidden = YES;
        CGRect frame = self.setPwdView.frame;
        frame.origin.y = self.oldPwdView.frame.origin.y;
        self.setPwdView.frame = frame;
    }
    
    UIColor *color = [UIColor colorWithRed:61/255.0f green:173/255.0f blue:145/255.0f alpha:1];
    
    
    self.navigation.leftBtn.frame = CGRectMake(8, 29, 67, 26);
    //[self.navigation.leftBtn setBackgroundImage:[UIImage imageNamed:@"settings_detail_cancel_btn"] forState:UIControlStateNormal];
    [self.navigation.leftBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    [self.navigation.leftBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self.navigation.leftBtn.titleLabel setFont:[UIFont systemFontOfSize:17.0f]];
    [self.navigation.leftBtn setTitleColor:color forState:UIControlStateHighlighted];
    [self.navigation.leftBtn setTitleColor:color forState:UIControlStateNormal];
    
    self.navigation.titleLable.textColor = color;
    
    self.navigation.rightBtn.frame = CGRectMake(245, 29, 67, 26);
    //[self.navigation.rightBtn setBackgroundImage:[UIImage imageNamed:@"settings_detail_cancel_btn"] forState:UIControlStateNormal];
    [self.navigation.rightBtn setTitle:@"Save" forState:UIControlStateNormal];
    [self.navigation.rightBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [self.navigation.rightBtn.titleLabel setFont:[UIFont systemFontOfSize:17.0f]];
    
    [self.navigation.rightBtn setTitleColor:color forState:UIControlStateHighlighted];
    [self.navigation.rightBtn setTitleColor:color forState:UIControlStateNormal];
    
    [self.navigation.rightBtn addTarget:self action:@selector(rightNavBtnBeClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.oldPwdField becomeFirstResponder];
    
    CGRect frame = self.setPwdView.frame;
    frame.origin.x = 0;
    frame.origin.y = frame.size.height/2;
    frame.size.height = 1;
    UIView * view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor colorWithRed:234/255.0f green:234/255.0f blue:234/255.0f alpha:1];
    [self.setPwdView addSubview:view];
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
        NSString *oldPwd = self.has_usable_password==YES?self.oldPwdField.text:@"";
        NSMutableDictionary *dic  = [NSMutableDictionary dictionaryWithObjectsAndKeys:oldPwd,@"oldpassword",self.pwdField.text,@"newpassword",nil];
        [settingsModel updateUserPwd:dic andCallback:^(NSInteger error) {
            
            [indi stopAnimating];
            [indi removeFromSuperview];
            if (error == -1)
            {
                NSString *message = self.has_usable_password==YES?@"Change Password Failed.":@"Set Password Failed.";
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
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
    if (self.has_usable_password)
    {
        if (self.oldPwdField.text.length == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Old Password is nil." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            return NO;
        }
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
