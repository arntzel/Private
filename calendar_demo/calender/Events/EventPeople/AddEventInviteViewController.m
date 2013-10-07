
#import "AddEventInviteViewController.h"
#import "AddEventInvitePeopleHeaderView.h"
#import "AddEventInvitePeopleCell.h"

#import "UserModel.h"

#import "ViewUtils.h"
#import "Utils.h"

#import "NavgationBar.h"


@interface AddEventInviteViewController ()<UITableViewDelegate,
                                           UITableViewDataSource,
                                           JSTokenFieldDelegate,
                                           NavgationBarDelegate>
{
    NSMutableArray * users;
    NSMutableArray * searchUsers;

    NSMutableDictionary * selectedUsersDic;
}

@end

@implementation AddEventInviteViewController

- (void)dealloc
{
    [users release];
    [searchUsers release];
    [selectedUsersDic release];
    
    self.tableView = nil;
    self.indicatorView = nil;
    self.searchBar = nil;
    
    [super dealloc];
}

-(void) setSelectedUser:(NSArray *) selectedUsers
{
    [selectedUsersDic release];
    selectedUsersDic = [[NSMutableDictionary alloc] init];
    
    for(User * user in selectedUsers) {
        [selectedUsersDic setObject:user forKey:user.username];
    }
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
    
    users = [[NSMutableArray alloc] init];
    searchUsers = [[NSMutableArray alloc] init];
    
    self.tableView.delegate = self;
    self.tableView.dataSource =  self;

    self.searchBar.delegate = self;
    
    [self getInvitePeopleData];
}

- (void)getInvitePeopleData
{
    UserModel * model = [UserModel getInstance];
    [self.indicatorView startAnimating];
    [model getUsers:0 andCallback:^(NSInteger error, NSArray *userArray) {
        [self.indicatorView stopAnimating];
        [self resetData:userArray];
        [self.tableView reloadData];
    }];
}


-(void) resetData:(NSArray *) userArray
{
    [users removeAllObjects];

    User * me = [[UserModel getInstance] getLoginUser];

    for (User *user in userArray) {

        if(user.id == me.id) {
            //exclude creator in the event
            continue;
        }
        
        AddEventInvitePeople *people = [[AddEventInvitePeople alloc] init];
        
        if([selectedUsersDic objectForKey:user.username] != nil) {
            people.selected = YES;
        } else {
            people.selected = NO;
        }
        
        people.user = user;
        
        [users addObject:people];
        [people release];
    }

    NSString * searchText = self.searchBar.textField.text;
    [self searchUser:searchText];
}


- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddEventInvitePeople * people = [self getPeople:indexPath];
    people.selected = !people.selected;
    [tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddEventInvitePeople * people = [self getPeople:indexPath];
    people.selected = NO;
    [tableView reloadData];
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
        return [searchUsers count];
    } else {
        return [searchUsers count];
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
    [self.searchBar resignFirstResponder];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(AddEventInvitePeople *) getPeople:(NSIndexPath*)indexPath
{
    AddEventInvitePeople *people;
    
    int section = indexPath.section;
    
    if(section == 0) {
        people = [searchUsers objectAtIndex:indexPath.row];
    } else {
        people = [searchUsers objectAtIndex:indexPath.row];
    }
    
    return people;
}


- (NSArray *)getSelectedUsers
{
    NSMutableArray *selectedArray = [[NSMutableArray alloc] init];
    for (AddEventInvitePeople *people in users) {
        if (people.selected) {
            [selectedArray addObject:people.user];
        }
    }
    
    return [selectedArray autorelease];
}



- (void)leftNavBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)rightNavBtnClick
{    
    NSArray * selectUsers = [self getSelectedUsers];
    
    [self.delegate setInVitePeopleArray:selectUsers];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) searchUser:(NSString *) searchText
{
    [searchUsers removeAllObjects];

    if(searchText==nil || searchText.length == 0) {
        [searchUsers addObjectsFromArray:users];
        return;
    }

    searchText = [searchText lowercaseString];
    
    for(AddEventInvitePeople * people in users) {

        NSString * username = [people.user.username lowercaseString];
        
        if( [username hasPrefix:searchText]) {
            [searchUsers addObject:people];
        }
    }
}




#pragma mark --
#pragma mark JSTokenFieldDelegate

- (void)tokenField:(JSTokenField *)tokenField didAddToken:(NSString *)title representedObject:(id)obj
{
    
}

- (void)tokenField:(JSTokenField *)tokenField didRemoveToken:(NSString *)title representedObject:(id)obj
{
    
}
- (BOOL)tokenField:(JSTokenField *)tokenField shouldRemoveToken:(NSString *)title representedObject:(id)obj
{
    
}

- (void)tokenFieldTextDidChange:(JSTokenField *)tokenField
{
    [self searchUser:tokenField.textField.text];
    [self.tableView reloadData];
}

- (BOOL)tokenFieldShouldReturn:(JSTokenField *)tokenField
{
    
}
- (void)tokenFieldDidEndEditing:(JSTokenField *)tokenField
{
    
}

@end
