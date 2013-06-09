#import "menuNavigation.h"
#import "DDMenuController.h"


@interface menuNavigation()

@end


@implementation menuNavigation

@synthesize tableView=_tableView;


- (UIViewController*)localAlbumController
{    
    return nil;
}
- (UIViewController*)cloudAlbumController
{
    return nil;
}

- (id)init {
    if ((self = [super init])) {
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        tableView.delegate = (id<UITableViewDelegate>)self;
        tableView.dataSource = (id<UITableViewDataSource>)self;
        [self.view addSubview:tableView];
        self.tableView = tableView;
    }
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.tableView = nil;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    /* 
     * Content in this cell should be inset the size of kMenuOverlayWidth
     */
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Calendar";
    }
    else if (indexPath.row == 1) {
        cell.textLabel.text = @"Pending";
    }
    else if (indexPath.row == 2) {
        cell.textLabel.text = @"Profile & Friends";
    }
    
    return cell;
    
}

- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section {
    return nil;
}



#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // set the root controller
    /*
    DDMenuController *menuController = (DDMenuController*)((SingleViewAppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;

    if ([indexPath row] == 0) {
        [menuController setRootController:[self localAlbumController] animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    else if ([indexPath row] == 1) {
        ShareLoginQQZone *sharelogin = [[ShareLoginQQZone alloc] init];
        if([sharelogin isShareLogin])
        {
            [self goToCloudAlbum];
        }
        else
        {
            ShareLoginQQZone *sharelogin = [[ShareLoginQQZone alloc] init];
            sharelogin.delegate = self;
            [sharelogin shareLogin];
        }
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    else if ([indexPath row] == 2) {
        ShareLoginQQZone *sharelogin = [[ShareLoginQQZone alloc] init];
        sharelogin.delegate = self;
        [sharelogin shareLoginOut];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }

     */
}

- (void)goToCloudAlbum
{
    /*
    DDMenuController *menuController = (DDMenuController*)((SingleViewAppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
    [menuController setRootController:[self cloudAlbumController] animated:YES];
     */
}

@end
