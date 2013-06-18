

#import "AddEventViewController.h"
#import <UIKit/UIImagePickerController.h>
//#import "AddLocationViewController.h"
#import "AddEventView.h"

@interface AddEventViewController ()
//<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>

@end

@implementation AddEventViewController

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:scrollView];
    [scrollView release];
    
//    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"AddEventView" owner:self options:nil];
//    AddEventView *addEventView = (AddEventView*)[nibView objectAtIndex:0];
//    [scrollView addSubview:addEventView];
    
    
//    view.frame = CGRectMake(0, 0, 320, PlanView_HEIGHT);
//    AddEventView *eventView = [AddEventView alloc] ini
    
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark AddEventPhoto
//- (IBAction)btnAddEventPhoto:(id)sender {
//    UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Picker Photo From Album" otherButtonTitles:@"Picker Photo From Camera", nil];
//    [menu showInView:self.view];
//}

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
//    self.eventPhotoView.image = image;
    [picker dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark AddLocation

- (IBAction)btnAddLocation:(id)sender {
//    AddLocationViewController *addLocation = [[AddLocationViewController alloc] initWithNibName:@"AddLocationViewController" bundle:nil];
//    [self.navigationController pushViewController:addLocation animated:YES];
}

//- (IBAction)btnInvitePeople:(id)sender {
//}
//
//- (IBAction)btnAddEventTitle:(id)sender {
//}
//
//- (IBAction)btnAddDayOrTime:(id)sender {
//}


//- (IBAction)Cancel:(id)sender {
//    [self.navigationController popViewControllerAnimated:YES];
//}

- (void)dealloc
{
//    [self setEventPhotoView:nil];
}

@end
