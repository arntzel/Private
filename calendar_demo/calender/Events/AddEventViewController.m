
#import "Model.h"
#import "AddEventViewController.h"
#import "AddEventView.h"
#import "AddLocationViewController.h"
#import "AddEventDateViewController.h"
#import "AddEventInviteViewController.h"

@interface AddEventViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate ,UIScrollViewDelegate,
AddEventInviteViewControllerDelegate, AddLocationViewControllerDelegate>
{
    AddEventView *addEventView;
}
@property(nonatomic, retain) NSArray *invitedPeoples;
@property(nonatomic, retain) Location *locationPlace;
@end

@implementation AddEventViewController
@synthesize invitedPeoples;
@synthesize locationPlace;

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
    // Do any additional setup after loading the view from its nib.
    
    self.scrollView.delegate = self;
    
    
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"AddEventView" owner:self options:nil];
    
    addEventView = (AddEventView*)[nibView objectAtIndex:0];
    [addEventView initAppearenceAfterLoad];
    [self.scrollView addSubview:addEventView];
    [self.scrollView setContentSize:addEventView.frame.size];
    
    [addEventView.btnAddDate addTarget:self action:@selector(addDate:) forControlEvents:UIControlEventTouchUpInside];
    [addEventView.btnAddEventPhoto addTarget:self action:@selector(addEventPhoto:) forControlEvents:UIControlEventTouchUpInside];
    [addEventView.btnAddLocation addTarget:self action:@selector(addLocation:) forControlEvents:UIControlEventTouchUpInside];
    [addEventView.btnInvitePeople addTarget:self action:@selector(invitePeople:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addDate:(id)sender
{
    AddEventDateViewController *addDate = [[AddEventDateViewController alloc] initWithNibName:@"AddEventDateViewController" bundle:nil];
    [self.navigationController pushViewController:addDate animated:YES];
}

- (void)addEventPhoto:(id)sender
{
    UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Picker Photo From Album" otherButtonTitles:@"Picker Photo From Camera", nil];
    [menu showInView:self.view];
}


- (void)invitePeople:(id)sender
{
    AddEventInviteViewController *invitePeople = [[AddEventInviteViewController alloc] initWithNibName:@"AddEventInviteViewController" bundle:nil];
    invitePeople.delegate = self;
    [self.navigationController pushViewController:invitePeople animated:YES];
}

#pragma mark -
#pragma mark AddEventPhoto

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self getImageFrom:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    else if(buttonIndex == 1)
    {
        [self getImageFrom:UIImagePickerControllerSourceTypeCamera];
    }
}

- (void)getImageFrom:(UIImagePickerControllerSourceType)type
{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = type;
    ipc.delegate = self;
    [self presentModalViewController:ipc animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    addEventView.viewEventPhoto.image = image;
    [picker dismissModalViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark AddLocation

- (void)addLocation:(id)sender
{
    AddLocationViewController *addLocation = [[AddLocationViewController alloc] initWithNibName:@"AddLocationViewController" bundle:nil];
    addLocation.delegate = self;
    [self.navigationController pushViewController:addLocation animated:YES];
}

#pragma mark -
#pragma mark ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [addEventView.txtAddEventTitle resignFirstResponder];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setScrollView:nil];
    [super viewDidUnload];
}

- (IBAction)Cancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)Create:(id)sender {
    [self createEvent];
//    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createEvent
{
    NSString *title = addEventView.txtAddEventTitle.text;
    
    Event *event = [[Event alloc] init];
    event.description = @"test";

    NSMutableArray * attentees = [[NSMutableArray alloc] init];
    for(User * user in self.invitedPeoples) {
        EventAttendee * atd = [[EventAttendee alloc] init];
        atd.user = user;
        [attentees addObject:atd];
    }
    event.attendees = attentees;
    
    event.duration_days = 1;
    event.duration_hours = 5;
    event.duration_minutes = 10;
    event.eventType = 0;
    event.is_all_day = NO;
    event.location = self.locationPlace;
    event.start = [NSDate date];
    event.published = YES;
    event.start_type = START_TYPEAFTER;
    event.thumbnail_url = @"test";
    event.timezone = @"America/New_York",
    event.title = title;
    
    Model *model = [Model getInstance];

    [self.indicatorView startAnimating];
    [model createEvent:event andCallback:^(NSInteger error) {

        [self.indicatorView stopAnimating];
        
        if (error == 0) {

            [self.navigationController popViewControllerAnimated:YES];

        } else {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Error"
                                                            message:@"Create Event failed"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];

            [alert show];
        }
    }];
}


#pragma mark recall

- (void)setInVitePeopleArray:(NSArray *)inviteArray
{
    self.invitedPeoples = inviteArray;
}

- (void)setLocation:(Location *)location_
{
    self.locationPlace = location_;
}
@end
