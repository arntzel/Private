//
//  SettingViewController.m
//  calender
//
//  Created by xiangfang on 13-8-4.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "SettingViewController.h"
#import "UserModel.h"
#import "LoginMainViewController.h"
#import "RootNavContrller.h"
#import "UserSetting.h"
#import "CoreDataModel.h"
#import "UIView+LoadFromNib.h"
#import "SettingsContentView.h"
#import "DeviceInfo.h"


@interface SettingViewController ()

//@property (nonatomic, strong) UIScrollView *scroller;
@property (nonatomic, strong) UITableView *tableView;
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
    self.view.frame = [DeviceInfo fullScreenFrame];
    
    self.navigation = [Navigation createNavigationView];
    self.navigation.rightBtn.hidden = YES;
    self.navigation.titleLable.text = @"Accounts & Settings";
    [self.navigation.leftBtn addTarget:self action:@selector(btnMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.navigation];
    float tableViewY = CGRectGetMaxY(self.navigation.frame);
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, tableViewY, self.view.frame.size.width, self.view.frame.size.height - tableViewY) style:UITableViewStyleGrouped];
    
    [self.view addSubview:self.tableView];
    
//    float scrollerY = CGRectGetMaxY(self.navigation.frame);
//    self.scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, scrollerY, self.view.frame.size.width, self.view.frame.size.height - scrollerY)];
//    self.scroller.backgroundColor = [UIColor clearColor];
//    
//    SettingsContentView *t_settingsContentView = [SettingsContentView tt_viewFromNibNamed:@"SettingsContentView" owner:self];
//    t_settingsContentView.backgroundColor = [UIColor clearColor];
//    self.scroller.contentSize = CGSizeMake(self.view.frame.size.width, t_settingsContentView.frame.size.height);
//    
//    [self.scroller addSubview:t_settingsContentView];
//    [self.view addSubview:self.scroller];
    
    
}

#pragma mark - User Interaction Helper
- (void)btnMenu:(id)sender
{
    if(self.delegate != nil) {
        [self.delegate onBtnMenuClick];
    }
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

@end
