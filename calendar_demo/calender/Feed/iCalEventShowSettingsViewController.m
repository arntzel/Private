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
    self.dataSource = [[NSMutableArray alloc] init];
    [self.tableView registerNib:[UINib nibWithNibName:@"iCalEventShowSettingsCell" bundle:nil] forCellReuseIdentifier:cellID];
    [self requestData];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
                        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self=%@",iCal.iCalID];
                        NSArray *result = [iCalTypes filteredArrayUsingPredicate:predicate];
                        if ([result count]>0)
                        {
                            iCal.isSelect = YES;
                        }
                        [self.dataSource addObject:iCal];
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
- (IBAction)dismissMe:(UIButton *)sender
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    iCalEventShowSettingsCell *cell = (iCalEventShowSettingsCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    
    iCalendar *iCal = [self.dataSource objectAtIndex:indexPath.row];
    cell.titleLabel.text = iCal.title;
    cell.isSelectBtn.selected = iCal.isSelect;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    iCalendar *iCal = [self.dataSource objectAtIndex:indexPath.row];
    iCal.isSelect = !iCal.isSelect;
    [self.tableView reloadData];
}
@end
