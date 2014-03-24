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
    NSString *htmlStr = @"";
    
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Legal" ofType:@"plist"]];
    switch (self.type)
    {
        case TermsOfUs:
            title = @"Terms and Conditions";
            htmlStr = [dic objectForKey:@"TermOfUse"];
            break;
        case PrivacyPolicy:
            title = @"Privacy Policy";
            htmlStr = [dic objectForKey:@"PrivacyPolicy"];
            break;
        case AboutUs:
            title = @"About Us";
            htmlStr = [dic objectForKey:@"AboutUs"];
            break;
        default:
            break;
    }
    self.navigation.titleLable.text = title;
    CGRect frame = self.navigation.frame;
    frame.size.height = 64;
    self.navigation.frame = frame;
    self.navigation.clipsToBounds = YES;
    
    UIColor * greenColor = [UIColor colorWithRed:61/255.0f green:173/255.0f blue:145/255.0f alpha:1];
    self.navigation.titleLable.textColor = greenColor;
    
    self.navigation.leftBtn.frame = CGRectMake(8, 33, 20, 20);
    [self.navigation.leftBtn setBackgroundImage:[UIImage imageNamed:@"back_button_asset"] forState:UIControlStateNormal];
    [self.navigation.leftBtn setTitle:nil forState:UIControlStateNormal];
    self.navigation.rightBtn.hidden = YES;
    
    self.webView.delegate = self;
    [self.Indi startAnimating];
    [self loadHtml:htmlStr];
}

- (void)loadHtml:(NSString *)htmlStr
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:htmlStr]];
    [self.webView loadRequest:request];
    
}
#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.Indi stopAnimating];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.Indi stopAnimating];
}
@end
