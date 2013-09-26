//
//  EmailChangeViewController.m
//  Calvin
//
//  Created by tu changwei on 13-9-26.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "EmailChangeViewController.h"
#import "DeviceInfo.h"
@interface EmailChangeViewController ()

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
}

#pragma mark - User Interaction
- (void)rightNavBtnBeClicked:(UIButton *)btn
{
    [super  leftNavBtnClicked:btn];
}

@end
