//
//  LegalViewController.m
//  Calvin
//
//  Created by tu changwei on 13-9-27.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "LegalViewController.h"

@interface LegalViewController ()

@end

@implementation LegalViewController

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
        case TermsOfUs:
            title = @"Terms and Conditions";
            break;
        case PrivacyPolicy:
            title = @"Privacy Policy";
            break;
        case AboutUs:
            title = @"About Us";
            break;
        default:
            break;
    }
    self.navigation.titleLable.text = title;
    self.navigation.leftBtn.frame = CGRectMake(8, 9, 26, 26);
    [self.navigation.leftBtn setBackgroundImage:[UIImage imageNamed:@"settings_detail_noti_back"] forState:UIControlStateNormal];
    [self.navigation.leftBtn setTitle:nil forState:UIControlStateNormal];
    self.navigation.rightBtn.hidden = YES;
}
@end