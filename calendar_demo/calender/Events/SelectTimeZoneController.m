
#import "SelectTimeZoneController.h"
#import "NavgationBar.h"

@interface SelectTimeZoneController () <NavgationBarDelegate, UITableViewDataSource, UITableViewDelegate>
{
    NavgationBar * navBar;

    NSArray * timezonenames;
}

@end

@implementation SelectTimeZoneController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



-(void) dealloc
{
       
    [navBar release];
    [timezonenames release];
    
    self.tableView = nil;

    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    navBar = [[NavgationBar alloc] init];
    [self.view addSubview:navBar];
    navBar.delegate = self;
    [navBar setRightBtnHidden:YES];
    [navBar setLeftBtnText:@"Cancel"];
    [navBar setTitle:@"Select Timezone"];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    timezonenames = [NSTimeZone knownTimeZoneNames];
    [timezonenames retain];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return timezonenames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"timezonecell"];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 320, 44)];
    [cell addSubview:label];
    int row = indexPath.row;
    label.text = [timezonenames objectAtIndex:row];
    [label release];
    
    return [cell autorelease];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    NSString * timezone = [timezonenames objectAtIndex:row];
    LOG_D(@"Selected timezone:%@", timezone);
    
    [self.delegate onSelectedTimezone:timezone];
    
    [self leftNavBtnClick];
}

- (void)leftNavBtnClick
{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }
}

- (void)rightNavBtnClick
{
    
}
@end
