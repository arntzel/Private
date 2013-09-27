//
//  ConnectAccountViewController.m
//  Calvin
//
//  Created by tu changwei on 13-9-27.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "ConnectAccountViewController.h"

@interface ConnectAccountViewController ()

@end

@implementation ConnectAccountViewController

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
    NSString *title = @"";
    switch (self.type)
    {
        case ConnectFacebook:
            title = @"Facebook";
            break;
        case ConnectGoogle:
            title = @"Google";
            break;
        default:
            break;
    }
    self.navigation.titleLable.text = title;
    self.navigation.leftBtn.frame = CGRectMake(8, 9, 67, 26);
    [self.navigation.leftBtn setBackgroundImage:[UIImage imageNamed:@"settings_detail_cancel_btn"] forState:UIControlStateNormal];
    [self.navigation.leftBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    self.navigation.rightBtn.hidden = YES;
}

@end
