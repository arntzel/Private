
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

@interface AddEventInviteViewController ()<UITableViewDelegate,
                                           UITableViewDataSource,
                                           JSTokenFieldDelegate,
                                           NavgationBarDelegate>
{
    JSTokenField *searchBar;
    NSArray * selectedUsers;
    
    NSMutableArray * calvinUsers;
    NSMutableArray * calvinSearchedUsers;
    
    NSMutableArray * contactUsers;
    NSMutableArray * contactSearchedUsers;
    
}

@end

@implementation AddEventInviteViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [selectedUsers release];
    [calvinUsers release];
    [calvinSearchedUsers release];
    
    [contactUsers release];
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
    
    calvinUsers = [[NSMutableArray alloc] init];
    calvinSearchedUsers = [[NSMutableArray alloc] init];
    
    contactUsers = [[NSMutableArray alloc] init];
    contactSearchedUsers = [[NSMutableArray alloc] init];
    
    self.tableView.delegate = self;
    self.tableView.dataSource =  self;

    
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleTokenFieldFrameDidChange:)
												 name:JSTokenFieldFrameDidChangeNotification
											   object:nil];
    
    if (self.type == AddInviteeTypeAll) {
        [self getAllInvitePeople];
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

- (void)getAllInvitePeople
{
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        
//        [[UserModel getInstance] insertAddressBookContactsToDB:^(NSInteger error, NSMutableArray *contact) {
//            
//            LOG_D(@"getInvitePeopleData");
            CoreDataModel * model = [CoreDataModel getInstance];
            NSArray * contacts = [model getAllContactEntity];
            
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
                    [self addOjbToTokenFieldName:[people.user getReadableUsername] Obj:people];
                }
                
                if(people.user.calvinUser) {
                    [calvinUsers addObject:people];
                } else {
                    [contactUsers addObject:people];
                }
                
                [people release];
            }
            [self refreshTableView];
          
            
            
//        }];
//    });
    
    
}

-(void) setSelectedUser:(NSArray *) _selectedUsers
{
    selectedUsers = [_selectedUsers retain];
}


-(void) updateCalvinUser:(NSArray *) userArray
{
    [calvinUsers removeAllObjects];
    User * me = [[UserModel getInstance] getLoginUser];

    for (Contact *user in userArray) {

        if(user.id == me.id) {
            //exclude creator in the event
            continue;
        }
        AddEventInvitePeople *people = [[AddEventInvitePeople alloc] init];
        
        people.user = user;
        people.selected = [self isUserSelected:user];
        if (people.selected) {
             [self addOjbToTokenFieldName:[people.user getReadableUsername] Obj:people];
        }
        
        [calvinUsers addObject:people];
        [people release];
    }

    [self refreshTableView];
}

-(void) updateContactUser:(NSArray *) userArray
{
    //TODO:
}

- (BOOL)isUserSelected:(Contact *)user
{
    for (Contact* selectedUser in selectedUsers) {
        if (selectedUser.id == user.id) {
            return YES;
        }
    }
    return NO;
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
        [calvinSearchedUsers addObjectsFromArray:calvinUsers];
        [contactSearchedUsers addObjectsFromArray:contactUsers];
        return;
    }
    
    searchText = [searchText lowercaseString];
    
    for(AddEventInvitePeople * people in calvinUsers) {
        NSString * username = [people.user.email lowercaseString];
        if( [username hasPrefix:searchText]) {
            [calvinSearchedUsers addObject:people];
        }
    }
    
    for(AddEventInvitePeople * people in contactUsers) {
        NSString * username = [people.user.email lowercaseString];
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

        if(people.user.email != nil && people.user.email.length>0) {
            [self addOjbToTokenFieldName:people.user.email Obj:people];
        } else if(people.user.phone != nil && people.user.phone.length>0) {
            [self addOjbToTokenFieldName:people.user.phone Obj:people];
        }
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
    AddEventInvitePeopleCell *cell = (AddEventInvitePeopleCell *)[ViewUtils createView:@"AddEventInvitePeopleCell"];
    AddEventInvitePeople *people = [self getPeople:indexPath];
    [cell refreshView:people];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [searchBar endEditing:YES];
    [self addSearchBarObj];
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

- (void)addOjbToTokenFieldName:(NSString *)string Obj:(id)obj
{
    AddEventInvitePeople *people = nil;
    
    if (!obj) {
        people = [[[AddEventInvitePeople alloc] init] autorelease];;
        people.user = [[[Contact alloc] init] autorelease];
        people.user.email = string;
    }
    else
    {
        people = (AddEventInvitePeople *)obj;
    }
    
    if ([string length])
	{
		[searchBar addTokenWithTitle:string representedObject:people];
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
        [self addOjbToTokenFieldName:searchBar.textField.text Obj:nil];
    }
}

- (void)tokenFieldDidEndEditing:(JSTokenField *)tokenField
{
    
}

@end
