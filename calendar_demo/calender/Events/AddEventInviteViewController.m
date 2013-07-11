
#import "AddEventInviteViewController.h"
#import "AddEventInvitePeopleHeaderView.h"
#import "AddEventInvitePeopleCell.h"

#import "UserModel.h"

#import "ViewUtils.h"
#import "Utils.h"


@interface AddEventInviteViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray * recentInvitePeople;
    NSMutableDictionary * recentInvitePeopleDic;
    
    NSMutableArray * users;
    NSMutableDictionary * selectedUsersDic;
}

@end

@implementation AddEventInviteViewController

- (void)dealloc
{
        
    [recentInvitePeople release];
    [recentInvitePeopleDic release];
    
    [users release];
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
    
    recentInvitePeople = [[NSMutableArray alloc] init];
    recentInvitePeopleDic = [[NSMutableDictionary alloc] init];

    NSArray * recentUsers = [self readRecentUsers];
    for (User *user in recentUsers) {
        
        AddEventInvitePeople *people = [[AddEventInvitePeople alloc] init];
        people.user = user;
        if([selectedUsersDic objectForKey:user.username] != nil) {
            people.selected = YES;
        } else {
            people.selected = NO;
        }
        
        [recentInvitePeople addObject:people];
        [recentInvitePeopleDic setObject:people forKey:people.user.username ];
        [people release];
    }

    
    users = [[NSMutableArray alloc] init];
        
    self.tableView.delegate = self;
    self.tableView.dataSource =  self;
    [self getInvitePeopleData];
}

- (void)getInvitePeopleData
{
    UserModel *model = [UserModel getInstance];
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
    
    for (User *user in userArray) {
        
        if([recentInvitePeopleDic objectForKey:user.username] != nil) {
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
        header.label.text = @"RECENT";
    } else {
        header.label.text = @"CONTACTS";
    }
    
    return header;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0) {
        int count = [recentInvitePeople count];
        return count > 0 ? count : 1;
    } else {
        return [users count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddEventInvitePeopleCell *cell = (AddEventInvitePeopleCell *)[ViewUtils createView:@"AddEventInvitePeopleCell"];
    AddEventInvitePeople *people = [self getPeople:indexPath];
    [cell refreshView:people];
    return cell;
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
        
        if(recentInvitePeople.count==0) {
            return nil;
        }
        
        people = [recentInvitePeople objectAtIndex:indexPath.row];
    } else {
        people = [users objectAtIndex:indexPath.row];
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
    
    for (AddEventInvitePeople *people in recentInvitePeople) {
        if (people.selected) {
            [selectedArray addObject:people.user];
        }
    }
    
    return [selectedArray autorelease];
}


- (IBAction)Cancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)create:(id)sender {
    
    NSArray * selectUsers = [self getSelectedUsers];
    
    [self saveRecentUsers:selectUsers];
    
    [self.delegate setInVitePeopleArray:selectUsers];
    [self.navigationController popViewControllerAnimated:YES];
}


-(NSArray *) readRecentUsers
{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    
    NSString * json = [defaults objectForKey:@"readRecentUsers"];
    if(json == nil) {
        return nil;
    }

    NSMutableArray * recentUsers = [[NSMutableArray alloc] init];
    
    NSError * err;
    NSArray * array = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&err];
    
    for(NSDictionary * dic in array) {
        User * user = [User parseUser:dic];
        [recentUsers addObject:user];
    }
        
    return [recentUsers autorelease];
}


-(void) saveRecentUsers:(NSArray *) recentUsers
{
    
    
    NSMutableString * saveData = [[NSMutableString alloc] init];
    
    [saveData appendString:@"["];
    
    for(int i=0;i<recentUsers.count;i++) {
        User * user = [recentUsers objectAtIndex:i];
        
        NSDictionary * dic = [User convent2Dic:user];
        NSString * json = [Utils dictionary2String:dic];
        [saveData appendString:json];
        
        if(i<recentUsers.count-1) {
            [saveData appendString:@",\n"];
        }
    }
    
    [saveData appendString:@"]"];
       
    NSLog(@"saveRecentUsers: json:%@", saveData);
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    [defaults setObject:saveData forKey:@"readRecentUsers"];
    [defaults synchronize];
    
    [saveData release];
}

@end
