//
//  iCalEventShowSettingsViewController.m
//  Calvin
//
//  Created by tu on 13-12-22.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "iCalEventShowSettingsViewController.h"

#import "iCalEventShowSettingsCell.h"

@implementation iCalendar
@end

static NSString *const cellID = @"CellID";
@interface iCalEventShowSettingsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableSet *sourceSet;
@end

@implementation iCalEventShowSettingsViewController

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
    self.dataSource = [[NSMutableArray alloc] init];
    self.sourceSet = [[NSMutableSet alloc]init];
    [self.tableView registerNib:[UINib nibWithNibName:@"iCalEventShowSettingsCell" bundle:nil] forCellReuseIdentifier:cellID];
    [self requestData];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupViews
{
    
    CGRect frame = self.navigation.frame;
    frame.size.height = 64;
    self.navigation.frame = frame;
    self.navigation.clipsToBounds = YES;
    
    UIColor * greenColor = [UIColor colorWithRed:61/255.0f green:173/255.0f blue:145/255.0f alpha:1];
    self.navigation.titleLable.textColor = greenColor;
    
    
    self.navigation.titleLable.text = @"iCal calendars";
    self.navigation.leftBtn.frame = CGRectMake(8, 29, 67, 26);
    //[self.navigation.leftBtn setBackgroundImage:[UIImage imageNamed:@"settings_detail_cancel_btn"] forState:UIControlStateNormal];
    [self.navigation.leftBtn setTitle:@"Back" forState:UIControlStateNormal];
    [self.navigation.leftBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self.navigation.leftBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [self.navigation.leftBtn setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [self.navigation.leftBtn setTitleColor:greenColor forState:UIControlStateNormal];
    
    self.navigation.rightBtn.hidden = YES;
    
    
    
}

#pragma mark - Request data
- (void)requestData
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        EKEventStore *store = [[EKEventStore alloc] init];
        if ([store respondsToSelector:@selector(requestAccessToEntityType:completion:)])
        {
            [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
                if (granted)
                {
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    NSMutableArray *iCalTypes = [userDefaults objectForKey:@"iCalTypes"];
                    NSArray *iCals = [store calendarsForEntityType:EKEntityTypeEvent];
                    for (EKCalendar *tmp in iCals)
                    {
                        iCalendar *iCal = [[iCalendar alloc] init];
                        iCal.title = tmp.title;
                        iCal.iCalID = tmp.calendarIdentifier;
                        iCal.belongToSource = tmp.source.title;
                        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self=%@",iCal.iCalID];
                        NSArray *result = [iCalTypes filteredArrayUsingPredicate:predicate];
                        NSLog(@"title:%@ sourceTitle:%@",tmp.title,tmp.source.title);
                        if ([result count]>0)
                        {
                            iCal.isSelect = YES;
                        }
                        [self.dataSource addObject:iCal];
                        [self.sourceSet addObject:iCal.belongToSource];
                    }
                    
                }
               
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
                
            }];
        }
        
    });
    
}

#pragma mark - User action
- (void)leftNavBtnClicked:(UIButton *)btn;
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *iCalTypes = [[NSMutableArray alloc] init];
    for (iCalendar *iCal in self.dataSource)
    {
        if (iCal.isSelect)
        {
            [iCalTypes addObject:iCal.iCalID];
        }
    }
    [userDefaults setObject:iCalTypes forKey:@"iCalTypes"];
    [userDefaults synchronize];
    if (self.dismissBlock)
    {
        self.dismissBlock(iCalTypes);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -  UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sourceSet count];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    return [self.sourceSet allObjects][section];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *sourceName = [self.sourceSet allObjects][section];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.belongToSource=%@",sourceName];
    
    return [[self.dataSource filteredArrayUsingPredicate:predicate] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    iCalEventShowSettingsCell *cell = (iCalEventShowSettingsCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    
    NSString *sourceName = [self.sourceSet allObjects][indexPath.section];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.belongToSource=%@",sourceName];
    iCalendar *iCal = [[self.dataSource filteredArrayUsingPredicate:predicate] objectAtIndex:indexPath.row];
    cell.titleLabel.text = iCal.title;
    cell.isSelectBtn.selected = iCal.isSelect;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *sourceName = [self.sourceSet allObjects][indexPath.section];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.belongToSource=%@",sourceName];
    iCalendar *iCal = [[self.dataSource filteredArrayUsingPredicate:predicate] objectAtIndex:indexPath.row];
    iCal.isSelect = !iCal.isSelect;
    [self.tableView reloadData];
}
@end
