//
//  LocationChangedViewController.m
//  Calvin
//
//  Created by tu on 13-11-29.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "LocationChangedViewController.h"
#import "SelectCountryViewController.h"
#import "UserModel.h"

@interface LocationChangedViewController ()
@property (weak, nonatomic) IBOutlet UITextField *countryField;
@property (weak, nonatomic) IBOutlet UITextField *zipCodeField;

@end

@implementation LocationChangedViewController

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
    [self requestCountryInfo];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Layout.
- (void)setupViews
{
    self.navigation.titleLable.text = @"Location";
    self.navigation.leftBtn.frame = CGRectMake(8, 29, 67, 26);
    [self.navigation.leftBtn setBackgroundImage:[UIImage imageNamed:@"settings_detail_cancel_btn"] forState:UIControlStateNormal];
    [self.navigation.leftBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    self.navigation.rightBtn.frame = CGRectMake(245, 29, 67, 26);
    [self.navigation.rightBtn setBackgroundImage:[UIImage imageNamed:@"settings_detail_cancel_btn"] forState:UIControlStateNormal];
    [self.navigation.rightBtn setTitle:@"Save" forState:UIControlStateNormal];
    [self.navigation.rightBtn addTarget:self action:@selector(rightNavBtnBeClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
}
#pragma mark - Data Request
- (void)requestCountryInfo
{
    NSDictionary *location = [[UserModel getInstance] getLoginUser].locationDic;
    if ([[location objectForKey:@"country_code"] isKindOfClass:[NSNull class]])
    {
        self.countryInfo = @{
                          @"country_name": @"United States",
                          @"country_code": @"US"
                          };
    }
    else
    {
        NSString *dataPath = [[NSBundle mainBundle]pathForResource:@"country" ofType:@"txt"];
        NSString *allCountriesStr = [NSString stringWithContentsOfFile:dataPath encoding:4 error:nil];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        NSArray *lines = [allCountriesStr componentsSeparatedByString:@"\n"];
        for (NSString *line in lines)
        {
            if ([[line componentsSeparatedByString:@"\t"] count]>1)
            {
                NSString *country_code = [[line componentsSeparatedByString:@"\t"] objectAtIndex:0];
                NSString *country_name = [[line componentsSeparatedByString:@"\t"] objectAtIndex:1];
                [dic setObject:country_name forKey:country_code];
            }
            
        }

        self.countryInfo = @{
                             @"country_name": dic[[location objectForKey:@"country_code"]],
                             @"country_code": [location objectForKey:@"country_code"]
                             };
    }
    
    if (![[location objectForKey:@"postal_code"] isKindOfClass:[NSNull class]])
    {
        self.zipCode = [location objectForKey:@"postal_code"];
        self.zipCodeField.text = self.zipCode;
    }
}

#pragma mark - User Interaction
- (void)leftNavBtnClicked:(UIButton *)btn
{
    [super  leftNavBtnClicked:btn];
}

- (void)rightNavBtnBeClicked:(UIButton *)btn
{
    self.zipCode = self.zipCodeField.text;
    if ([self zipCodeIsLegal])
    {
        self.locationInfoChanged(self.countryInfo[@"country_code"],self.zipCode);
        [self leftNavBtnClicked:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"zip code in the format XXXXX or XXXXX-XXXX." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    
}
- (IBAction)selectCountry:(UITapGestureRecognizer *)sender
{
    SelectCountryViewController *svVC = [[SelectCountryViewController alloc]initWithNibName:@"SelectCountryViewController" bundle:nil];
    svVC.getCountryInfo = ^(NSDictionary *dic)
    {
        self.countryInfo = dic;
    };
    [self.navigationController pushViewController:svVC animated:YES];
}

- (void)setCountryInfo:(NSDictionary *)countryInfo
{
    _countryInfo = countryInfo;
    self.countryField.text = [_countryInfo objectForKey:@"country_name"];
}

#pragma mark - Other Helper
- (BOOL)zipCodeIsLegal
{
    if ([self.countryInfo[@"country_code"] isEqualToString:@"US"])
    {
        NSString *regex = @"^\\d{5}(?:[-\\s]\\d{4})?$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        return  [pred evaluateWithObject:self.zipCode];
    }
    return YES;
}
@end
