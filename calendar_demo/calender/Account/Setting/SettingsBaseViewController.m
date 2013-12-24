//
//  SettingsBaseViewController.m
//  Calvin
//
//  Created by tu changwei on 13-9-26.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "SettingsBaseViewController.h"

@interface SettingsBaseViewController ()

@end

@implementation SettingsBaseViewController

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
    self.view.frame = [DeviceInfo fullScreenFrame];
	self.navigation = [Navigation createNavigationView];
    self.navigation.titleLable.hidden = NO;
    //[self.navigation setUpMainNavigationButtons];
    [self.navigation.leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.navigation.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.navigation.leftBtn addTarget:self action:@selector(leftNavBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.navigation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - User Interaction
- (void)leftNavBtnClicked:(UIButton *)btn
{
    [self.navigationController   popViewControllerAnimated:YES];
}
@end
