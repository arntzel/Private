

#import "AddLocationViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "GPlaceApi.h"
#import "GPlaceDataSource.h"
#import "GPlaceAutoCompleteSource.h"
#import "NavgationBar.h"
#import "CSqlite.h"
#import "AddLocationTextView.h"
#import "EventLocationCell.h"

//#define NearBySearchRadius 5000
#define NearBySearchRadius 300

@interface AddLocationViewController ()< NavgationBarDelegate,
                                         GPlaceApiDelegate,
                                         UITableViewDataSource,
                                         UITableViewDelegate,
                                         UITextFieldDelegate >
{
    
    GPlaceApi * GPTxtSearchApi;
    
    UITextField * textField;
    
    
    Location * customLocation;
    
    //Location objects list
    NSMutableArray * locations;
    
    UIActivityIndicatorView * indicatiorView;
}

@end

@implementation AddLocationViewController
@synthesize delegate;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        GPTxtSearchApi = [[GPlaceApi alloc] init];
        GPTxtSearchApi.delegate = self;
        
        locations = [[NSMutableArray alloc] init];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    NavgationBar * navBar = [[NavgationBar alloc] init];
    [navBar setTitle:@""];
    [navBar setLeftBtnText:@""];
    [navBar setRightBtnText:@"Done"];
    
    [self.view addSubview:navBar];
    navBar.delegate = self;
    //[navBar setRightBtnHidden:YES];
    
    
    CGRect searchViewFrame;
    searchViewFrame.origin.x = 0;
    searchViewFrame.origin.y = navBar.frame.origin.y + navBar.frame.size.height;
    searchViewFrame.size.width = 320;
    searchViewFrame.size.height = 59;
    
    UIView * searchView = [[UIView alloc] initWithFrame:searchViewFrame];
    searchView.backgroundColor = [UIColor colorWithRed:249/255.0f green:251/255.0f blue:245/255.0f alpha:1.0f];
    [self.view addSubview:searchView];
    
    
    indicatiorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicatiorView.hidesWhenStopped = YES;
    indicatiorView.center = CGPointMake(300, 30);
    [searchView addSubview:indicatiorView];
    
    UIImageView * imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"location"]];
    CGRect headerFrame = imgView.frame;
    headerFrame.origin.x = 8;
    headerFrame.origin.y = 15;
    headerFrame.size.width = 35;
    headerFrame.size.height = 35;
    imgView.frame = headerFrame;
    [searchView addSubview:imgView];
    
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 58, 320, 1)];
    line.backgroundColor = [UIColor colorWithRed:220/255.0f green:224/255.0f blue:216/255.0f alpha:1.0f];
    [searchView addSubview:line];
    
    
    CGRect bgFrame = self.view.frame;
    bgFrame.origin.y = searchView.frame.origin.y + searchView.frame.size.height;
    UIImageView * backgroundView = [[UIImageView alloc] initWithFrame:bgFrame];
    backgroundView.image = [UIImage imageNamed:@"invitee_people_bg"];
    [self.view addSubview:backgroundView];
    
    
    
    CGRect textFieldFrame = searchViewFrame;
    textFieldFrame.origin.x = 52;
    textFieldFrame.origin.y = 5;
    textFieldFrame.size.width -= 52;
    
    textField = [[UITextField alloc] initWithFrame:textFieldFrame];
    textField.backgroundColor = [UIColor redColor];
    [textField setDelegate:self];
    [textField setBorderStyle:UITextBorderStyleNone];
    [textField setBackground:nil];
    [textField setBackgroundColor:[UIColor clearColor]];
    [textField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [textField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [textField setTextColor: [UIColor colorWithRed:45/255.0f green:172/255.0f blue:149/255.0f alpha:1.0f]];
    [textField setFont:[UIFont fontWithName:@"Helvetica Neue" size:13.0]];
    textField.returnKeyType = UIReturnKeySearch;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.placeholder = @"Search location...";
    [searchView addSubview:textField];
    
    
    self.txtSearchTabView.dataSource = self;
    self.txtSearchTabView.delegate = self;
    self.txtSearchTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.txtSearchTabView.hidden = NO;
    
    
    CGRect tableViewFrame = self.view.frame;
    tableViewFrame.origin.y = searchView.frame.origin.y + searchView.frame.size.height;
    tableViewFrame.size.height -= tableViewFrame.origin.y;
    self.txtSearchTabView.frame = tableViewFrame;
    
    if(self.location != nil) {
        
        textField.text = self.location.location;
        textField.hidden = NO;
        [textField becomeFirstResponder];
       
    }
}
#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(customLocation == nil) {
        return locations.count;
    } else {
        return locations.count + 1;
    }
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EventLocationCell * cell =  [EventLocationCell creatView];
    
    int row = indexPath.row;
    
    if(customLocation != nil) {
       
        if(row == 0) {
            cell.name.text = customLocation.location;
            cell.address.text = @"Custom Location";
        } else {
            Location * location = [locations objectAtIndex:row-1];
            cell.name.text = location.location;
            cell.address.text = location.formatted_address;
        }
        
    } else {
        Location * location = [locations objectAtIndex:row];
        cell.name.text = location.location;
        cell.address.text = location.formatted_address;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 53;
}

#pragma mark -
#pragma mark UITextFieldDelegate
- (BOOL)textField:(UITextField *)tf shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSMutableString * text = [[NSMutableString alloc] init];
    [text appendString:tf.text];
    [text replaceCharactersInRange:range withString:string];

     NSLog(@"shouldChangeCharactersInRange:%@", text);
    
    if(text.length == 0) {
        customLocation = nil;
    } else {
        if(customLocation == nil) {
            customLocation = [[Location alloc] init];
        }
        
        customLocation.location = text;
    }
    
    [self.txtSearchTabView reloadData];
    
//    
//    if([string isEqualToString:@" "])
//    {
//        NSString *textStr = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//        if(![textStr isEqualToString:@""])
//        {
//             NSLog(@"startAutoComplitionWithTxtSearchQuery:%@", textStr);
//            [GPTxtSearchApi startRequestWithTxtSearchQuery:textStr];
//        }
//    }
    
	return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField;
{
    [indicatiorView stopAnimating];
    
    customLocation = nil;
    [self.txtSearchTabView reloadData];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)tf
{
    NSLog(@"textFieldShouldReturn");

    
    NSString *textStr = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if(![textStr isEqualToString:@""])
    {
        NSLog(@"startRequestWithTxtSearchQuery:%@", textStr);
        
        [indicatiorView startAnimating];
        
        textStr = [textStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [GPTxtSearchApi startRequestWithTxtSearchQuery:textStr];
    }
    
    [textField resignFirstResponder];
    [self.txtSearchTabView reloadData];
	return YES;
}

- (NSString *)urlEncodeString:(NSString *)orgString
{
    NSString *result = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)orgString,NULL,NULL,kCFStringEncodingUTF8);
    return result;
}

- (void)upDateWithArray:(NSArray *)array GPlaceApi:(GPlaceApi *)api
{
    NSLog(@"upDateWithArray:%d", array.count);
     [indicatiorView stopAnimating];
    [locations removeAllObjects];
    [locations addObjectsFromArray:array];
    [self.txtSearchTabView reloadData];
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
    if(textField.text.length != 0) {
        Location * location = [[Location alloc] init];
        location.location = textField.text;
        [self.delegate setLocation:location];

    [self.navigationController popViewControllerAnimated:YES];
    }

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    
    Location * selectedLocation = nil;
    if(customLocation != nil) {
        if(row == 0) {
            selectedLocation = customLocation;
        } else {
            selectedLocation = [locations objectAtIndex:row-1];
        }
    } else {
        selectedLocation = [locations objectAtIndex:row];
    }
    
    [self.delegate setLocation:selectedLocation];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
