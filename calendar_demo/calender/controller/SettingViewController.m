//
//  SettingViewController.m
//  calender
//
//  Created by xiangfang on 13-8-4.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "SettingViewController.h"
#import "UserModel.h"
#import "SignupViewController.h"
#import "RootNavContrller.h"

@interface SettingViewController ()

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction) logout:(id)sender
{
    [[UserModel getInstance] setLoginUser:nil];

    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];

    [defaults removeObjectForKey:@"loginUser"];
    [defaults synchronize];

    RootNavContrller *navController = [RootNavContrller defaultInstance];

        
    [navController popToRootViewControllerAnimated:NO];

    SignupViewController* rootController = [[SignupViewController alloc] init];
    [navController pushViewController:rootController animated:NO];
}

@end
