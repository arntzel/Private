
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
    JSTokenField *searchBar;
    NSMutableArray * selectedUsers;
    

    NSMutableArray * calvinSearchedUsers;
    NSMutableArray * contactSearchedUsers;
    int offset;
    
}

@property(nonatomic,retain) NSMutableArray *calvinUsers;
@property(nonatomic,retain) NSMutableArray *contactUsers;

@end

@implementation AddEventInviteViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [selectedUsers release];
    self.calvinUsers = nil;
    [calvinSearchedUsers release];
    
    self.contactUsers = nil;
    [contactSearchedUsers release];
    
    self.tableView = nil;
    self.indicatorView = nil;
    
    searchBar.delegate = nil;
    [searchBar release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    NavgationBar * navBar = [[NavgationBar alloc] init];
    [navBar setTitle:@"Invite People"];
    [navBar setLeftBtnText:@"Cancel"];
    [navBar setRightBtnText:@"Invite"];
    
    [self.view addSubview:navBar];
    navBar.delegate = self;
    [navBar release];
    
    searchBar = [[JSTokenField alloc] initWithFrame:CGRectMake(0, navBar.frame.size.height, 320, 44)];
    [self.view addSubview:searchBar];
    [searchBar setBackgroundColor:[UIColor whiteColor]];
    searchBar.delegate = self;
    
    self.calvinUsers = [NSMutableArray array];
    calvinSearchedUsers = [[NSMutableArray alloc] init];
    
    self.contactUsers = [NSMutableArray array];
    contactSearchedUsers = [[NSMutableArray alloc] init];
    
    self.tableView.delegate = self;
    self.tableView.dataSource =  self;

     UINib *myCustomCellNib = [UINib nibWithNibName:CellIdentifier bundle:nil];
    [self.tableView registerNib:myCustomCellNib forCellReuseIdentifier:CellIdentifier];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleTokenFieldFrameDidChange:)
												 name:JSTokenFieldFrameDidChangeNotification
											   object:nil];
    offset = 0;
    
    if (self.type == AddInviteeTypeAll)
    {
        
        [self insertAddressBookContacstToDB];
    }
    else if(self.type == AddInviteeTypeRest)
    {
        [self getRestInvitePeople];
    }
}

- (void)getRestInvitePeople
{
    //Todo://
}

- (void) insertAddressBookContacstToDB
{

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[UserModel getInstance] insertAddressBookContactsToDBWithOffset:offset CallBack:^(NSInteger error, NSMutableArray *contact, BOOL finish) {
            
            LOG_D(@"getInvitePeopleData");
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self getAllInvitePeople];
                
            });
            
            
        }];
    });

}
- (void)getAllInvitePeople
{
    CoreDataModel * model = [CoreDataModel getInstance];
    NSArray *contacts = [model getAllContactEntity];
    User * me = [[UserModel getInstance] getLoginUser];

    for(ContactEntity * entity in contacts) {
        
        if([me.email isEqualToString:entity.email]) {
            //exclude creator in the event
            continue;
        }
        
        AddEventInvitePeople *people = [[AddEventInvitePeople alloc] init];
        
        people.user = [entity getContact];
        people.selected = [self isUserSelected:people.user];
        if (people.selected) {
            [self addOjbToTokenFieldName:[people.user getReadableUsername] Obj:people isValid:YES];
        }
        
        if(people.user.calvinUser) {
            [self.calvinUsers addObject:people];
        } else {
            [self.contactUsers addObject:people];
        }
        
        [people release];
    }
    
    self.calvinUsers = [NSMutableArray arrayWithArray:[AddEventInvitePeople resortListByName:self.calvinUsers]];
    self.contactUsers = [NSMutableArray arrayWithArray:[AddEventInvitePeople resortListByName:self.contactUsers]];
    
    [self addLastManuInputContact];
    
    [self refreshTableView];
    
}
- (void)getLimitInvitePeople
{
    CoreDataModel * model = [CoreDataModel getInstance];
    NSArray * contacts = [model getLimitContactEntity:offset];
    User * me = [[UserModel getInstance] getLoginUser];
    
    for(ContactEntity * entity in contacts) {
        
        if([me.email isEqualToString:entity.email]) {
            //exclude creator in the event
            continue;
        }
        
        AddEventInvitePeople *people = [[AddEventInvitePeople alloc] init];
        
        people.user = [entity getContact];
        people.selected = [self isUserSelected:people.user];
        if (people.selected) {
           [self addOjbToTokenFieldName:[people.user getReadableUsername] Obj:people isValid:YES];
        }
        
        if(people.user.calvinUser) {
            [self.calvinUsers addObject:people];
        } else {
            [self.contactUsers addObject:people];
        }
        
        [people release];
    }
    
    self.calvinUsers = [NSMutableArray arrayWithArray:[AddEventInvitePeople resortListByName:self.calvinUsers]];
    self.contactUsers = [NSMutableArray arrayWithArray:[AddEventInvitePeople resortListByName:self.contactUsers]];
    
    [self addLastManuInputContact];
    
    [self refreshTableView];
    
}

-(void) setSelectedUser:(NSArray *) _selectedUsers
{
    [selectedUsers release];
    selectedUsers = nil;
    selectedUsers = [[NSMutableArray alloc] init];
    [selectedUsers addObjectsFromArray:[_selectedUsers copy]];
}

- (BOOL)isUserSelected:(Contact *)user
{
    for (Contact* selectedUser in selectedUsers) {
        if (selectedUser.email != nil && [selectedUser.email length] > 0) {
            if ([selectedUser.email isEqualToString:user.email]) {
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
    [self searchUser:searchText];
    [self.tableView reloadData];
}

-(void) searchUser:(NSString *) searchText
{
    [calvinSearchedUsers removeAllObjects];
    [contactSearchedUsers removeAllObjects];
    
    if(searchText == nil || searchText.length == 0) {
        [calvinSearchedUsers addObjectsFromArray:self.calvinUsers];
        [contactSearchedUsers addObjectsFromArray:self.contactUsers];
        return;
    }
    
    searchText = [searchText lowercaseString];
    
    for(AddEventInvitePeople * people in self.calvinUsers) {
        NSString * username = [[people.user getReadableUsername] lowercaseString];
        if( [username hasPrefix:searchText]) {
            [calvinSearchedUsers addObject:people];
        }
    }
    
    for(AddEventInvitePeople * people in self.contactUsers) {
        NSString * username = [[people.user getReadableUsername] lowercaseString];
        if( [username hasPrefix:searchText]) {
            [contactSearchedUsers addObject:people];
        }
    }
}


- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

-(AddEventInvitePeople *) getPeople:(NSIndexPath*)indexPath
{
    AddEventInvitePeople *people = nil;
    
    int section = indexPath.section;
    
    if(section == 0) {
        people = [calvinSearchedUsers objectAtIndex:indexPath.row];
    } else {
        people = [contactSearchedUsers objectAtIndex:indexPath.row];
    }
    
    return people;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddEventInvitePeople * people = [self getPeople:indexPath];
    people.selected = !people.selected;
    
    if (people.selected) {
        [self addOjbToTokenFieldName:[people.user getReadableUsername]  Obj:people isValid:YES];
    }
    else
    {
        [self removeObjFromTokenField:people];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    AddEventInvitePeopleHeaderView * header = (AddEventInvitePeopleHeaderView *)[ViewUtils createView:@"AddEventInvitePeopleHeaderView"];
    
    if(section == 0) {
        header.label.text = @"CALVIN USER";
    } else {
        header.label.text = @"CONTACTS";
    }
    
    return header;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0) {
        return [calvinSearchedUsers count];
    } else {
        return [contactSearchedUsers count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddEventInvitePeopleCell *cell = (AddEventInvitePeopleCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    AddEventInvitePeople *people = [self getPeople:indexPath];
    [cell refreshView:people];
    return cell;
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
    [self.tableView setFrame:CGRectMake(0, searchBar.frame.size.height + searchBar.frame.origin.y, self.tableView.frame.size.width, self.view.frame.size.height - searchBar.frame.size.height - searchBar.frame.origin.y)];
}

- (void)tokenField:(JSTokenField *)tokenField didAddToken:(NSString *)title representedObject:(id)obj
{
    
}

- (void)tokenField:(JSTokenField *)tokenField didRemoveToken:(NSString *)title representedObject:(id)obj
{
    AddEventInvitePeople * people = (AddEventInvitePeople *)obj;
    people.selected = NO;
    
    [self.tableView reloadData];
}

- (BOOL)tokenField:(JSTokenField *)tokenField shouldRemoveToken:(NSString *)title representedObject:(id)obj
{
    return YES;
}

- (void)tokenFieldTextDidChange:(JSTokenField *)tokenField
{
    LOG_D(@"tokenFieldTextDidChange:%@", tokenField.textField.text);
    [self refreshTableView];
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
