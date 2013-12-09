//
//  SelectCountryViewController.m
//  Calvin
//
//  Created by tu on 13-11-29.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "SelectCountryViewController.h"

static NSString * const CellID = @"CountryCell";

@interface SelectCountryViewController ()
@property (weak, nonatomic) IBOutlet UITableView *countriesTableView;
@property (nonatomic, strong) NSMutableDictionary *dic;
@end

@implementation SelectCountryViewController

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
    self.dic = [NSMutableDictionary dictionary];
    [self setupViews];
    [self requestAllCountryData];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Layout

- (void)setupViews
{
    self.navigation.titleLable.text = @"Select Country";
    self.navigation.leftBtn.frame = CGRectMake(8, 29, 67, 26);
    [self.navigation.leftBtn setBackgroundImage:[UIImage imageNamed:@"settings_detail_cancel_btn"] forState:UIControlStateNormal];
    [self.navigation.leftBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    self.navigation.rightBtn.hidden = YES;
}

#pragma mark - User Interaction
- (void)leftNavBtnClicked:(UIButton *)btn
{
    [super  leftNavBtnClicked:btn];
}

#pragma mark - Data Request
- (void)requestAllCountryData
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSString *dataPath = [[NSBundle mainBundle]pathForResource:@"country" ofType:@"txt"];
        NSString *allCountriesStr = [NSString stringWithContentsOfFile:dataPath encoding:4 error:nil];
        NSArray *lines = [allCountriesStr componentsSeparatedByString:@"\n"];
        for (NSString *line in lines)
        {
            if ([[line componentsSeparatedByString:@"\t"] count]>1)
            {
                NSString *country_code = [[line componentsSeparatedByString:@"\t"] objectAtIndex:0];
                NSString *country_name = [[line componentsSeparatedByString:@"\t"] objectAtIndex:1];
                [self.dic setObject:country_name forKey:country_code];
            }
           
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.countriesTableView reloadData];
            
        });
    });
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dic count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
        
    }
    NSArray *sortedKeys = [self.dic keysSortedByValueUsingSelector:@selector(localizedStandardCompare:)];
    NSString *key = sortedKeys[indexPath.row];
    cell.textLabel.text = self.dic[key];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *sortedKeys = [self.dic keysSortedByValueUsingSelector:@selector(localizedStandardCompare:)];
    NSString *key = sortedKeys[indexPath.row];
    NSDictionary *countryInfo = @{
                                  @"country_name":self.dic[key],
                                  @"country_code":key
                                  };
    
    
    self.getCountryInfo(countryInfo);
    [self.navigationController popViewControllerAnimated:YES];
}
@end
