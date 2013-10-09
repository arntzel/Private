
#import "NavgationBar.h"
#import "DetailVoteViewController.h"

#import "AddEventInvitePeopleHeaderView.h"
#import "ViewUtils.h"

#import "DetailVoteCell.h"
#import "DetailVoteCreatorCell.h"

@interface respondedPeople:NSObject

@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) UIImage *headPhoto;
@property(nonatomic,assign) BOOL available;
@property(nonatomic,assign) BOOL isCreator;

@end

@implementation respondedPeople

@end


@interface DetailVoteViewController ()<UITableViewDelegate,
                                           UITableViewDataSource,
                                           NavgationBarDelegate>
{
    NSMutableArray *availablePeople;
    NSMutableArray *unAvailablePeople;
}

@end

@implementation DetailVoteViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    
    NavgationBar * navBar = [[NavgationBar alloc] init];
    [navBar setTitle:@"Vote"];
    [navBar setLeftBtnText:@"Cancel"];
    [navBar setRightBtnHidden:YES];
    
    [self.view addSubview:navBar];
    navBar.delegate = self;

    self.tableView.delegate = self;
    self.tableView.dataSource =  self;
    
    [self.tableView reloadData];
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}


- (void)initData
{
    availablePeople = [NSMutableArray array];
    unAvailablePeople = [NSMutableArray array];
    
    for (NSInteger index = 0; index < 5; index++) {

        respondedPeople *responded = [[respondedPeople alloc] init];
        if (index == 0) {
            responded.isCreator = YES;
        }
        responded.name = @"Dov Mamann";
        responded.headPhoto = [UIImage imageNamed:[NSString stringWithFormat: @"header%d.jpg", index + 1]];
        
        [availablePeople addObject:responded];
        [unAvailablePeople addObject:responded];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    AddEventInvitePeopleHeaderView * header = (AddEventInvitePeopleHeaderView *)[ViewUtils createView:@"AddEventInvitePeopleHeaderView"];
    
    if(section == 0) {
        header.label.text = @"AVAILABLE";
    } else if(section == 1){
        header.label.text = @"UNAVAILABLE";
    }
    return header;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0) {
        return [availablePeople count];
    }
    else
    {
        return [unAvailablePeople count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        respondedPeople *responded = [availablePeople objectAtIndex:row];
        if (responded.isCreator) {
            DetailDeclinedCell *cell = (DetailDeclinedCell *)[ViewUtils createView:@"DetailDeclinedCell"];
            [cell setName:responded.name];
            [cell setHeaderImage:responded.headPhoto];
            [cell setAvaliable:YES];
            cell.declinedTime.text = @"Event Creator";
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
        else
        {
            AddEventInvitePeopleCell *cell = (AddEventInvitePeopleCell *)[ViewUtils createView:@"AddEventInvitePeopleCell"];
            cell.peopleName.text = responded.name;
            cell.peopleHeader.image = responded.headPhoto;
            [cell setAvaliable:YES];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell.btnSelect setHidden:YES];
            return cell;
        }
    }
    else
    {
        respondedPeople *responded = [availablePeople objectAtIndex:row];
        AddEventInvitePeopleCell *cell = (AddEventInvitePeopleCell *)[ViewUtils createView:@"AddEventInvitePeopleCell"];
        cell.peopleName.text = responded.name;
        cell.peopleHeader.image = responded.headPhoto;
        [cell setAvaliable:NO];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.btnSelect setHidden:YES];
        return cell;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (void)leftNavBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightNavBtnClick
{

}

@end





