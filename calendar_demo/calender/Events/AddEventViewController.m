//
//  ViewController.m
//  test
//
//  Created by zyax86 on 13-7-7.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import "AddEventViewController.h"

#import "NavgationBar.h"
#import "AddDateEntryView.h"
#import "AddEventSettingView.h"

#import "Model.h"
#import "AddEventViewController.h"
#import "AddLocationViewController.h"
#import "AddEventDateViewController.h"
#import "AddEventInviteViewController.h"

@interface AddEventViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate ,UIScrollViewDelegate,AddEventInviteViewControllerDelegate, AddLocationViewControllerDelegate,NavgationBarDelegate>
{
    NavgationBar *navBar;
    UIScrollView *scrollView;
    
    UIImageView *imagePickerView;
    UIButton *imagePickerbtn;
    UITextField *txtFieldTitle;
    
    UIView *inviteAndPlaceView;
    UIButton *invitePeoplebtn;
    UIButton *addLocationbtn;
    
    AddDateEntryView *addDateView;
    AddEventSettingView *settingView;
    
    UIActivityIndicatorView *indicatorView;
}

@property(nonatomic, retain) NSArray *invitedPeoples;
@property(nonatomic, retain) Location *locationPlace;

@end

@implementation AddEventViewController
@synthesize invitedPeoples;
@synthesize locationPlace;

- (void)dealloc
{
    [navBar release];
    [scrollView release];
    
    [imagePickerView release];
    [imagePickerbtn release];
    [txtFieldTitle release];
    
    [inviteAndPlaceView release];
    [invitePeoplebtn release];
    [addLocationbtn release];
    
    [addDateView release];
    [settingView release];
    
    [indicatorView release];
    
    [super dealloc];
}

#pragma mark initUI
- (id)init
{
    self = [super init];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.view setBackgroundColor:[UIColor colorWithRed:237.0f/255.0f green:237.0f/255.0f blue:237.0f/255.0f alpha:1.0f]];
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, 320, 568 - 44)];
    [self.view addSubview:scrollView];
    scrollView.delegate = self;
    
    navBar = [[NavgationBar alloc] init];
    [self.view addSubview:navBar];
    navBar.delegate = self;
    
    [self initImagePickerView];
    [self initInviteAndPlaceView];
    [self initAddDateView];
    [self initSettingView];
    
    [scrollView setContentSize:CGSizeMake(320, settingView.frame.size.height + settingView.frame.origin.y + 10)];
    
    indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.view addSubview:indicatorView];
    [indicatorView setCenter:CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 2)];
    
}

- (void)initImagePickerView
{
    imagePickerView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"imagePicker_bg.jpg"]];
    [imagePickerView setUserInteractionEnabled:YES];
    [imagePickerView setFrame:CGRectMake(0, 0, 320, 165)];
    [scrollView addSubview:imagePickerView];
    [imagePickerView setContentMode:UIViewContentModeScaleAspectFill];
    [imagePickerView setClipsToBounds:YES];
    
    UIImageView *imagePickerIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"imagePickerIcon.png"]];
    [imagePickerIcon setFrame:CGRectMake((320 - 36) / 2 , 47, 36, 31)];
    [imagePickerView addSubview:imagePickerIcon];
    
    imagePickerbtn = [[UIButton alloc] initWithFrame:imagePickerView.frame];
    [scrollView addSubview:imagePickerbtn];
    CGRect frame = imagePickerView.frame;
    frame.size.height -= (frame.size.height - 110);
    [imagePickerbtn setFrame:frame];
    [imagePickerbtn addTarget:self action:@selector(addEventPhoto:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIImageView *imageTitleBgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"imagePickerTitleBg.png"]];
    [imageTitleBgView setFrame:CGRectMake(6, 110, 308, 46)];
    [imagePickerView addSubview:imageTitleBgView];
    
    txtFieldTitle = [[UITextField alloc] initWithFrame:CGRectMake(imageTitleBgView.frame.origin.x, imageTitleBgView.frame.origin.y + 10, imageTitleBgView.frame.size.width, 36)];
    [imagePickerView addSubview:txtFieldTitle];
    [txtFieldTitle setPlaceholder:@"add event title..."];
    [txtFieldTitle setFont:[UIFont systemFontOfSize:18]];
    [txtFieldTitle setTextColor:[UIColor whiteColor]];
    [txtFieldTitle setTextAlignment:NSTextAlignmentCenter];
    [txtFieldTitle setEnabled:YES];
}

- (void)initInviteAndPlaceView
{
    inviteAndPlaceView = [[UIView alloc] initWithFrame:CGRectMake(0, imagePickerView.frame.size.height, 320, 143)];
    [scrollView addSubview:inviteAndPlaceView];
    
    UIImage *bgImage = [UIImage imageNamed:@"addEventBtnBg.png"];
    bgImage = [bgImage resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
    
    UIImageView *invitePeopleView = [[UIImageView alloc] initWithFrame:CGRectMake(7, 10, 150, 133)];
    [inviteAndPlaceView addSubview:invitePeopleView];
    [invitePeopleView setUserInteractionEnabled:YES];
    [invitePeopleView release];
    invitePeopleView.image = bgImage;
    
    UIImageView *invitePeopleIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [invitePeopleIcon setCenter:CGPointMake(75, 18)];
    invitePeopleIcon.image = [UIImage imageNamed:@"invitePeopleIcon.png"];
    [invitePeopleView addSubview:invitePeopleIcon];
    
    UILabel *labInvitePeople = [[UILabel alloc] initWithFrame:CGRectMake(42, 48, 66, 60)];
    [labInvitePeople setBackgroundColor:[UIColor clearColor]];
    [labInvitePeople setText:@"Invite People"];
    [labInvitePeople setTextColor:[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0f]];
    [labInvitePeople setFont:[UIFont boldSystemFontOfSize:15.0f]];
    [invitePeopleView addSubview:labInvitePeople];
    [labInvitePeople setMultipleTouchEnabled:YES];
    labInvitePeople.textAlignment = NSTextAlignmentCenter;
    labInvitePeople.lineBreakMode = NSLineBreakByWordWrapping;
    labInvitePeople.numberOfLines = 2;
    [labInvitePeople release];
    
    invitePeoplebtn = [[UIButton alloc] initWithFrame:invitePeopleView.frame];
    [inviteAndPlaceView addSubview:invitePeoplebtn];
    [invitePeoplebtn addTarget:self action:@selector(invitePeople:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIImageView *addLocationView = [[UIImageView alloc] initWithFrame:CGRectMake(164, 10, 150, 133)];
    [inviteAndPlaceView addSubview:addLocationView];
    [addLocationView setUserInteractionEnabled:YES];
    [addLocationView release];
    addLocationView.image = bgImage;
    
    UIImageView *addLocationIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [addLocationIcon setCenter:CGPointMake(75, 18)];
    addLocationIcon.image = [UIImage imageNamed:@"addLocationIcon"];
    [addLocationView addSubview:addLocationIcon];
    
    UILabel *labAddLocation = [[UILabel alloc] initWithFrame:CGRectMake(39, 48, 72, 60)];
    [labAddLocation setBackgroundColor:[UIColor clearColor]];
    [labAddLocation setText:@"Add Location"];
    [labAddLocation setTextColor:[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0f]];
    [labAddLocation setFont:[UIFont boldSystemFontOfSize:15.0f]];
    [addLocationView addSubview:labAddLocation];
    [labAddLocation setMultipleTouchEnabled:YES];
    labAddLocation.textAlignment = NSTextAlignmentCenter;
    labAddLocation.lineBreakMode = NSLineBreakByWordWrapping;
    labAddLocation.numberOfLines = 2;
    [labAddLocation release];
    
    addLocationbtn = [[UIButton alloc] initWithFrame:addLocationView.frame];
    [inviteAndPlaceView addSubview:addLocationbtn];
    [addLocationbtn addTarget:self action:@selector(addLocation:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initAddDateView
{
    addDateView = [[AddDateEntryView createDateEntryView] retain];
    CGRect frame = addDateView.frame;
    frame.origin.y = inviteAndPlaceView.frame.origin.y + inviteAndPlaceView.frame.size.height;
    addDateView.frame = frame;
    [scrollView addSubview:addDateView];
    [addDateView.btnAddDate addTarget:self action:@selector(addDate:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initSettingView
{
    settingView = [[AddEventSettingView createEventSettingView] retain];
    CGRect frame = settingView.frame;
    frame.origin.y = addDateView.frame.origin.y + addDateView.frame.size.height;
    settingView.frame = frame;
    [scrollView addSubview:settingView];
}

#pragma mark Add Photo
- (void)addEventPhoto:(id)sender
{
    UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Picker Photo From Album" otherButtonTitles:@"Picker Photo From Camera", nil];
    [menu showInView:self.view];
}

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
    imagePickerView.image = image;
    [picker dismissModalViewControllerAnimated:YES];
}

#pragma mark Add Date
- (void)addDate:(id)sender
{
    AddEventDateViewController *addDate = [[AddEventDateViewController alloc] initWithNibName:@"AddEventDateViewController" bundle:nil];
    [self.navigationController pushViewController:addDate animated:YES];
}

#pragma mark Add People
- (void)invitePeople:(id)sender
{
    AddEventInviteViewController *invitePeople = [[AddEventInviteViewController alloc] initWithNibName:@"AddEventInviteViewController" bundle:nil];
    invitePeople.delegate = self;
    [self.navigationController pushViewController:invitePeople animated:YES];
}

- (void)setInVitePeopleArray:(NSArray *)inviteArray
{
    self.invitedPeoples = inviteArray;
}

#pragma mark AddLocation
- (void)addLocation:(id)sender
{
    AddLocationViewController *addLocation = [[AddLocationViewController alloc] initWithNibName:@"AddLocationViewController" bundle:nil];
    addLocation.delegate = self;
    [self.navigationController pushViewController:addLocation animated:YES];
}

- (void)setLocation:(Location *)location_
{
    self.locationPlace = location_;
}

#pragma mark ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [txtFieldTitle resignFirstResponder];
}


#pragma mark NavBarDelegate
- (void)leftNavBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightNavBtnClick
{
    if ([self canCreateEvent]) {
        [self createEvent];
    }
}

- (BOOL)canCreateEvent
{
    if (self.invitedPeoples == nil || self.locationPlace == nil || txtFieldTitle.text == nil) {
        NSString *alertString = @"invitedPeoples , location or title need to be set !";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:alertString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return NO;
    }
    return YES;
}

- (void)createEvent
{
    NSString *title = txtFieldTitle.text;
    
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
    
    [indicatorView startAnimating];
    [model createEvent:event andCallback:^(NSInteger error) {
        
        [indicatorView stopAnimating];
        
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



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
