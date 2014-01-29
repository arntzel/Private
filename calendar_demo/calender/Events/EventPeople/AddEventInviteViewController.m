
#import "AddEventInviteViewController.h"
#import "AddEventInvitePeopleHeaderView.h"
#import "AddEventInvitePeopleCell.h"

#import "UserModel.h"
#import "CoreDataModel.h"

#import "ViewUtils.h"
#import "Utils.h"

#import "NavgationBar.h"
#import "JSTokenButton.h"
#import "JSTokenField.h"

static NSString *const CellIdentifier = @"AddEventInvitePeopleCell";

@interface AddEventInviteViewController ()<UITableViewDelegate,
                                           UITableViewDataSource,
                                           JSTokenFieldDelegate,
                                           NavgationBarDelegate>
{
    UIView * searchView;
    UIView * line;
    JSTokenField *searchBar;
    
    NSMutableArray * selectedUsers;
    NSMutableArray * calvinSearchedUsers;
    int offset;
    
    //NSOperationQueue * queue;
}

@end

@implementation AddEventInviteViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [selectedUsers release];
    [calvinSearchedUsers release];
    
    
    self.tableView = nil;
    self.indicatorView = nil;
    
    searchBar.delegate = nil;
    [searchBar release];
    [line release];
    [searchView release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    NavgationBar * navBar = [[NavgationBar alloc] init];
    [navBar setTitle:@""];
    [navBar setLeftBtnText:@""];
    [navBar setRightBtnText:@"Done"];
    
    [self.view addSubview:navBar];
    navBar.delegate = self;
    [navBar release];
    
    
    CGRect searchViewFrame;
    searchViewFrame.origin.x = 0;
    searchViewFrame.origin.y = navBar.frame.origin.y + navBar.frame.size.height;
    searchViewFrame.size.width = 320;
    searchViewFrame.size.height = 59;
    
    searchView = [[UIView alloc] initWithFrame:searchViewFrame];
    searchView.backgroundColor = [UIColor colorWithRed:249/255.0f green:251/255.0f blue:245/255.0f alpha:1.0f];
    
    [self.view addSubview:searchView];
    
    
    UIImageView * imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"invitee_people_header"]];
    CGRect headerFrame = imgView.frame;
    headerFrame.origin.x = 8;
    headerFrame.origin.y = 15;
    headerFrame.size.width = 35;
    headerFrame.size.height = 35;
    imgView.frame = headerFrame;
    [searchView addSubview:imgView];
    
    searchBar = [[JSTokenField alloc] initWithFrame:CGRectMake(53, 0, 320-53, 58)];
    searchBar.backgroundColor = [UIColor clearColor];
    [searchView addSubview:searchBar];
    
    line = [[UIView alloc] initWithFrame:CGRectMake(0, 58, 320, 1)];
    line.backgroundColor = [UIColor colorWithRed:220/255.0f green:224/255.0f blue:216/255.0f alpha:1.0f];
    [searchView addSubview:line];
    
    searchBar.delegate = self;
    
    calvinSearchedUsers = [[NSMutableArray alloc] init];
    
    CGRect tableViewFrame = self.tableView.frame;
    tableViewFrame.origin.y = searchViewFrame.origin.x + searchViewFrame.size.height;
    tableViewFrame.size.height = self.view.frame.size.height - tableViewFrame.origin.y;
    self.tableView.frame = tableViewFrame;
    self.tableView.clipsToBounds = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource =  self;

    UINib *myCustomCellNib = [UINib nibWithNibName:CellIdentifier bundle:nil];
    [self.tableView registerNib:myCustomCellNib forCellReuseIdentifier:CellIdentifier];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleTokenFieldFrameDidChange:)
												 name:JSTokenFieldFrameDidChangeNotification
											   object:nil];
    offset = 0;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[UserModel getInstance] insertAddressBookContactsToDBWithOffset:offset CallBack:^(NSInteger error, NSMutableArray *contact, BOOL finish) {
            
            LOG_D(@"getInvitePeopleData");
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                 [self refreshTableView];
                
            });
        }];
    });
    
    [self handleTokenFieldFrameDidChange:nil];
    
    
    for(Contact * contact in selectedUsers)
    {
        AddEventInvitePeople * people = [[[AddEventInvitePeople alloc] init] autorelease];
        people.user = contact;
        [self addOjbToTokenFieldName:[contact getReadableUsername] Obj:people isValid:YES];
    }
    
    [self refreshTableView];
}


-(void) setSelectedUser:(NSArray *) _selectedUsers
{
    if(selectedUsers == nil) {
        selectedUsers = [[NSMutableArray alloc] init];
    }
    
    [selectedUsers removeAllObjects];
    [selectedUsers addObjectsFromArray:_selectedUsers];
}

- (BOOL)isUserExsit:(Contact *)user
{
    for (Contact* selectedUser in selectedUsers) {
        if (selectedUser.email != nil && [selectedUser.email length] > 0) {
            if ([selectedUser.email caseInsensitiveCompare:user.email] == NSOrderedSame) {
                return YES;
            }
        }
        if (selectedUser.phone != nil && [selectedUser.phone length] > 0) {
            if ([selectedUser.phone isEqualToString:user.phone]) {
                return YES;
            }
        }

    }
    return NO;
}

- (BOOL)isUserSelected:(Contact *)user
{
    for (Contact* selectedUser in selectedUsers) {
        if (selectedUser.email != nil && [selectedUser.email length] > 0) {
            if ([selectedUser.email caseInsensitiveCompare:user.email] == NSOrderedSame) {
                [selectedUsers removeObject:selectedUser];
                return YES;
            }
        }
        if (selectedUser.phone != nil && [selectedUser.phone length] > 0) {
            if ([selectedUser.phone isEqualToString:user.phone]) {
                [selectedUsers removeObject:selectedUser];
                return YES;
            }
        }
        
    }
    return NO;
}

- (void)addLastManuInputContact
{
    for (Contact* selectedUser in selectedUsers) {
        AddEventInvitePeople *people = [[[AddEventInvitePeople alloc] init] autorelease];;
        people.user = [[[Contact alloc] init] autorelease];
        people.user.email = [selectedUser.email copy];
        people.user.phone = [selectedUser.phone copy];
        NSString *text = [people.user getReadableUsername];

        [self addOjbToTokenFieldName:text Obj:people isValid:[self isValidText:text]];
    }
}

- (void)refreshTableView
{
    NSString * searchText = searchBar.textField.text;
    
    LOG_I(@"refreshTableView:%@", searchText);
    
    [self searchUser:searchText];
    [self.tableView reloadData];
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.tableView reloadData];
//    });
}

-(void) searchUser:(NSString *) searchText
{
    NSArray * contacts;
    if(searchText == nil || searchText.length == 0) {
       contacts = [[CoreDataModel getInstance] queryContactEntity:nil andOffset:0];
    } else {
        contacts = [[CoreDataModel getInstance] queryContactEntity:searchText andOffset:0];
    }
    
    [calvinSearchedUsers removeAllObjects];
    
    User * me = [[UserModel getInstance] getLoginUser];
    for(ContactEntity * contactEntity in contacts) {
        
        if([me.email isEqualToString:contactEntity.email]) {
            continue;
        }
        
        AddEventInvitePeople * people = [[AddEventInvitePeople alloc] init];
        people.user = [contactEntity getContact];
        [calvinSearchedUsers addObject:people];
    }
}


- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}


-(AddEventInvitePeople *) getPeople:(NSIndexPath*)indexPath
{
    return [calvinSearchedUsers objectAtIndex:indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(calvinSearchedUsers.count == 0) {
        return;
    }
    
    AddEventInvitePeople * invitePeople = [self getPeople:indexPath];
    
    for (JSTokenButton *token in searchBar.tokens)
    {
        AddEventInvitePeople * people = [token representedObject];
        
        if( [invitePeople.user.email isEqualToString:people.user.email]) {
            return;
        }
    }
    
    [self addOjbToTokenFieldName:[invitePeople.user getReadableUsername]  Obj:invitePeople isValid:YES];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(calvinSearchedUsers.count == 0) {
 
        NSString * text = searchBar.textField.text;
    
        if(text.length > 0) {
            return 1;
        } else {
            return 0;
        }
        
    } else {
        return [calvinSearchedUsers count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(calvinSearchedUsers.count == 0) {
    
        AddEventInvitePeopleCell *cell = (AddEventInvitePeopleCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

         NSString * email = searchBar.textField.text;
        [cell refreshView:@"Not in Contacts" andEmal:email];

        return cell;
        
    } else  {
    
        AddEventInvitePeopleCell *cell = (AddEventInvitePeopleCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

        AddEventInvitePeople *people = [self getPeople:indexPath];
        [cell refreshView:people];
        return cell;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [searchBar endEditing:YES];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
//    if (decelerate)
//    {
//        NSLog(@"offset:%F scrollView.contentSize.height:%f", scrollView.contentOffset.y+scrollView.frame.size.height,scrollView.contentSize.height);
//        if (scrollView.contentOffset.y+scrollView.frame.size.height > scrollView.contentSize.height)
//        {
//            offset++;
//            [self insertAddressBookContacstToDB];
//        }
//    }
}
- (void)leftNavBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];

}

- (NSArray *)getSelectedUsers
{
    NSMutableArray *selectedArray = [NSMutableArray array];
    for (JSTokenButton *token in searchBar.tokens)
    {
        AddEventInvitePeople *people = [token representedObject];
        [selectedArray addObject:people.user];
    }
    
    return selectedArray;
}

- (void)rightNavBtnClick
{
    [self addSearchBarObj];
    NSArray * selectUsers = [self getSelectedUsers];
    
    [self.delegate setInVitePeopleArray:selectUsers];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --
#pragma mark JSTokenFieldDelegate

- (void)handleTokenFieldFrameDidChange:(NSNotification *)note
{
    
    int heigth = searchBar.frame.size.height;
    LOG_D(@"handleTokenFieldFrameDidChange:%d", heigth);

    CGRect frame = searchView.frame;
    frame.size.height = heigth;
    searchView.frame = frame;
    
    CGRect lineFrame = line.frame;
    lineFrame.origin.y = frame.size.height-1;
    line.frame = lineFrame;
    
    CGFloat top = frame.size.height + frame.origin.y;
    [self.tableView setFrame:CGRectMake(0, top, self.tableView.frame.size.width, self.view.frame.size.height - top)];
}

- (void)tokenField:(JSTokenField *)tokenField didAddToken:(NSString *)title representedObject:(id)obj
{
    LOG_D(@"didAddToken");
}

- (void)tokenField:(JSTokenField *)tokenField didRemoveToken:(NSString *)title representedObject:(id)obj
{
    LOG_D(@"didRemoveToken");
    
    AddEventInvitePeople * people = (AddEventInvitePeople *)obj;
    people.selected = NO;
    
    [self.tableView reloadData];
}

- (BOOL)tokenField:(JSTokenField *)tokenField shouldRemoveToken:(NSString *)title representedObject:(id)obj
{
    LOG_D(@"shouldRemoveToken");
    return YES;
}

- (void)tokenFieldTextDidChange:(JSTokenField *)tokenField
{
    LOG_D(@"tokenFieldTextDidChange:%@", tokenField.textField.text);
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(refreshTableView) withObject:self afterDelay:0.3f];
    
//    [queue cancelAllOperations];
//    [queue addOperationWithBlock:^{
//        [self refreshTableView];
//    }];
}

- (void)addOjbToTokenFieldName:(NSString *)string Obj:(id)obj isValid:(BOOL)isvalid
{
    AddEventInvitePeople *people = nil;
    
    if (!obj) {
        people = [[[AddEventInvitePeople alloc] init] autorelease];;
        people.user = [[[Contact alloc] init] autorelease];
        
        if([Utils isValidatePhoneNumber:string]) {
            people.user.phone = string;
        } else if( [Utils isValidateEmail:string]){
            people.user.email = string;
        }
        else
        {
            people.user.email = string;
        }
    }
    else
    {
        people = (AddEventInvitePeople *)obj;
    }
    
    if ([string length])
	{
		[searchBar addTokenWithTitle:string representedObject:people isValid:isvalid];
        searchBar.textField.text = @"";
        [self refreshTableView];
	}
}

- (void)removeObjFromTokenField:(id)obj
{
    if (obj)
	{
		[searchBar removeTokenWithRepresentedObject:obj];
        [self refreshTableView];
	}
}

- (void)removeStringFromTokenField:(NSString *)string
{
    if ([string length])
	{
		[searchBar removeTokenForString:string];
        [self refreshTableView];
	}
}

- (BOOL)tokenFieldShouldReturn:(JSTokenField *)tokenField
{
    [self addSearchBarObj];
    return NO;
}

- (void)addSearchBarObj
{
    if (searchBar.textField.text != nil && [searchBar.textField.text length] > 0) {
        NSString *text = searchBar.textField.text;
        [self addOjbToTokenFieldName:text Obj:nil isValid:[self isValidText:text]];
    }
}

- (BOOL)isValidText:(NSString *)text
{
    BOOL isValid;
    if([Utils isValidatePhoneNumber:text]) {
        isValid = YES;
    } else if( [Utils isValidateEmail:text]){
        isValid = YES;
    } else {
        isValid = NO;
    }
    return isValid;
}

- (void)tokenFieldDidEndEditing:(JSTokenField *)tokenField
{
    
}

@end
