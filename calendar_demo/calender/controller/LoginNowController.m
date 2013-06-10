//
//  LoginNowController.m
//  calender
//
//  Created by xiangfang on 13-6-10.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "LoginNowController.h"
#import "UserModel.h"
#import "FeedViewController.h"


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
    self.tvPassword.text = @"fangxiang";
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

            FeedViewController * ctrl = [[FeedViewController alloc] init];
            //[self.navigationController popViewControllerAnimated:NO];
            [self.navigationController pushViewController:ctrl animated:YES];

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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
