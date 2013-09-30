//
//  ViewController.m
//  test
//
//  Created by zyax86 on 13-7-7.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import "AddEventViewController.h"

#import "NavgationBar.h"


#import "Model.h"
#import "AddEventViewController.h"
#import "AddLocationViewController.h"
#import "AddEventDateViewController.h"
#import "AddEventInviteViewController.h"
#import "DeviceInfo.h"


#import "AddEventInviteView.h"
#import "AddEventPlaceView.h"
#import "AddEventTimesView.h"
#import "AddEventSettingView.h"


#import "ViewUtils.h"
#import "ATMHud.h"
#import "ATMHudDelegate.h"


#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>

#import "Model.h"
#import "CoreDataModel.h"

#import "Utils.h"
#import "ViewUtils.h"

@interface AddEventViewController ()<UINavigationControllerDelegate,
                                     UIImagePickerControllerDelegate,
                                     UIActionSheetDelegate ,
                                     UIScrollViewDelegate,
                                     AddEventInviteViewControllerDelegate,
                                     AddLocationViewControllerDelegate,
                                     AddEventDateViewControllerDelegate,
                                     NavgationBarDelegate,
                                     UploadImageDelegate,
                                     ATMHudDelegate>
{
    NavgationBar *navBar;
    UIScrollView *scrollView;
    
    UIImageView *imagePickerView;
    UIButton *imagePickerbtn;
    UITextField *txtFieldTitle;

    AddEventTimesView * timesView;
    AddEventSettingView *settingView;
    
    ATMHud *hud;
    
    AddEventInviteView * inviteView;
    AddEventPlaceView * placeView;
    
    
    //For preupload Image
    ASIFormDataRequest * request;
    NSString * imageUrl;
    
    UIActivityIndicatorView * imageUploadingIndicator;
}

@property(nonatomic, retain) NSArray *invitedPeoples;
@property(nonatomic, retain) Location *locationPlace;
@end

@implementation AddEventViewController

@synthesize invitedPeoples;
@synthesize locationPlace;


- (void)dealloc
{
    hud.delegate = nil;
    [hud release];
    
    [navBar release];
    [scrollView release];
    
    [imagePickerView release];
    [imagePickerbtn release];
    [txtFieldTitle release];
    
    
    [inviteView release];
    [placeView release];

    [timesView release];
    [settingView release];
    
    [imageUrl release];
    
    [imageUploadingIndicator release];
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
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, 320, [DeviceInfo fullScreenHeight] - 44)];
    scrollView.autoresizesSubviews = NO;
    [self.view addSubview:scrollView];
    scrollView.delegate = self;
    
    navBar = [[NavgationBar alloc] init];
    [self.view addSubview:navBar];
    navBar.delegate = self;
    
    [self initImagePickerView];
    [self initInviteAndPlaceView];
    [self initAddDateView];
    [self initSettingView];

    [self layOutSubViews];


    hud = [[ATMHud alloc] initWithDelegate:self];
	[self.view addSubview:hud.view];
    
    [ViewUtils resetUILabelFont:self.view];
}

- (void)layOutSubViews
{
    CGFloat offsetY = 0;

    for(UIView * subView in scrollView.subviews) {
        CGRect frame = subView.frame;
        frame.origin = CGPointMake(0, offsetY);
        subView.frame = frame;
        offsetY += frame.size.height;
    }

    offsetY += 10;

    [scrollView setContentSize:CGSizeMake(320, offsetY)];
}

- (void)initImagePickerView
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 165)];
    [scrollView addSubview:view];
    [view release];
    
    imagePickerView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"imagePicker_bg.jpg"]];
    [imagePickerView setUserInteractionEnabled:YES];
    [imagePickerView setFrame:view.bounds];
    [view addSubview:imagePickerView];

    [imagePickerView setContentMode:UIViewContentModeScaleAspectFill];
    [imagePickerView setClipsToBounds:YES];
    
    UIImageView *maskImageView = [[UIImageView alloc] initWithFrame:imagePickerView.bounds];
    maskImageView.image = [UIImage imageNamed:@"shadow_ovlerlay_asset.png"];
    [view addSubview:maskImageView];
    [maskImageView release];
    
    
    UIImageView *imagePickerIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"imagePickerIcon.png"]];
    [imagePickerIcon setFrame:CGRectMake((320 - 36) / 2 , 47, 36, 31)];
    [view addSubview:imagePickerIcon];
    
    imagePickerbtn = [[UIButton alloc] initWithFrame:imagePickerView.frame];
    [view addSubview:imagePickerbtn];
    CGRect frame = imagePickerView.frame;
    frame.size.height -= (frame.size.height - 110);
    [imagePickerbtn setFrame:frame];
    [imagePickerbtn addTarget:self action:@selector(addEventPhoto:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIImageView *imageTitleBgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"imagePickerTitleBg.png"]];
    [imageTitleBgView setFrame:CGRectMake(6, 110, 308, 46)];
    [view addSubview:imageTitleBgView];
    
    txtFieldTitle = [[UITextField alloc] initWithFrame:CGRectMake(imageTitleBgView.frame.origin.x, imageTitleBgView.frame.origin.y + 10, imageTitleBgView.frame.size.width, 36)];
    [view addSubview:txtFieldTitle];
    [txtFieldTitle setPlaceholder:@"Add event title..."];
    [txtFieldTitle setFont:[UIFont systemFontOfSize:18]];
    [txtFieldTitle setTextColor:[UIColor whiteColor]];
    [txtFieldTitle setTextAlignment:NSTextAlignmentCenter];
    [txtFieldTitle setEnabled:YES];
    [txtFieldTitle addTarget:self action:@selector(txtDidEnd) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    
    imageUploadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    imageUploadingIndicator.hidesWhenStopped = YES;
    imageUploadingIndicator.center = CGPointMake(20, 20);
    [view addSubview:imageUploadingIndicator];
}

- (void)initInviteAndPlaceView
{

    UIView * subView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    [scrollView addSubview:subView];
    [subView release];


    inviteView = (AddEventInviteView*)[ViewUtils createView:@"AddEventInviteView"];
    [inviteView retain];
    CGRect frame = inviteView.frame;
    frame.origin.x = 8;
    frame.origin.y = 5;

    inviteView.frame = frame;

    [subView addSubview:inviteView];

    placeView = (AddEventPlaceView*)[ViewUtils createView:@"AddEventPlaceView"];
    [placeView retain];

    frame = placeView.frame;
    frame.origin.x = 162;
    frame.origin.y = 5;
    placeView.frame = frame;
    
    [subView addSubview:placeView];
    
    inviteView.layer.cornerRadius = 4;
    inviteView.layer.masksToBounds = YES;
    inviteView.layer.shadowOffset = CGSizeMake(2, 2);

    placeView.layer.cornerRadius = 4;
    placeView.layer.masksToBounds = YES;

    [inviteView.btnInvite addTarget:self action:@selector(invitePeople:) forControlEvents:UIControlEventTouchUpInside];
    [placeView.btnPick addTarget:self action:@selector(addLocation:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initAddDateView
{
    timesView = [[AddEventTimesView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
    [scrollView addSubview:timesView];

    [timesView addBtnTarget:self action:@selector(addDate:)];
    [timesView updateView:[NSArray array]];
}

- (void)initSettingView
{
    settingView = [[AddEventSettingView createEventSettingView] retain];
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
 
    CGSize targetSize = imagePickerView.frame.size;
    UIImage * newImage = [ViewUtils imageByScalingAndCroppingForSize:targetSize andUIImage:image];
    
    imagePickerView.image = newImage;
    [picker dismissModalViewControllerAnimated:YES];
    
    [self uploadImage];
}

#pragma mark Add Date
- (void)addDate:(id)sender
{
    ProposeStart *tempEventDate = [[ProposeStart alloc] init];
    tempEventDate.duration_hours = 1;
    tempEventDate.start = [NSDate dateWithTimeIntervalSinceNow:300];
    tempEventDate.start_type = START_TYPEEXACTLYAT;
    [tempEventDate convertMinToQuarterMode];
    
    AddEventDateViewController *addDate = [[AddEventDateViewController alloc] initWithEventDate:tempEventDate];
    addDate.delegate = self;
    [self.navigationController pushViewController:addDate animated:YES];

    [tempEventDate release];
}

//Add new EventDate
- (void)setEventDate:(ProposeStart *)eventDate_
{
    [timesView addEventDate:eventDate_];
    [self layOutSubViews];
}



- (void)viewWillAppear:(BOOL)animated
{

}

#pragma mark Add People
- (void)invitePeople:(id)sender
{
    AddEventInviteViewController *invitePeople = [[AddEventInviteViewController alloc] initWithNibName:@"AddEventInviteViewController" bundle:nil];
    invitePeople.delegate = self;
    
    [invitePeople setSelectedUser:invitedPeoples];
    [self.navigationController pushViewController:invitePeople animated:YES];
}

- (void)setInVitePeopleArray:(NSArray *)inviteArray
{
    self.invitedPeoples = inviteArray;
    inviteView.label.text = [NSString stringWithFormat:@"%d invitees", self.invitedPeoples.count];
}

#pragma mark AddLocation
- (void)addLocation:(id)sender
{
    AddLocationViewController *addLocation = [[AddLocationViewController alloc] initWithNibName:@"AddLocationViewController" bundle:nil];
    addLocation.delegate = self;
    addLocation.location = self.locationPlace;
    
    [self.navigationController pushViewController:addLocation animated:YES];
}

- (void)setLocation:(Location *)location_
{
    self.locationPlace = location_;
    [placeView setLocation:location_];
}

#pragma mark ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [txtFieldTitle resignFirstResponder];
}

- (void)txtDidEnd
{
    [txtFieldTitle resignFirstResponder];
}

#pragma mark NavBarDelegate
- (void)leftNavBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
    if(request  != nil) {
        [request cancel];
        request = nil;
    }
}

- (void)rightNavBtnClick
{
    if ([self canCreateEvent]) {
        if ([self timeIsInFuture]) {
            //[self uploadImage];
            if(request != nil) {
                return;
            } else {
                [self createEvent:imageUrl];
            }
        }
        else
        {
            [self showTimeErrorWarning];
        }
    }
    else
    {
        [self showEventContentWarning];
    }
}

- (void)showTimeErrorWarning
{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Warning"
                                                    message:@"Do not choose the past time please!"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    
    [alert show];
    [alert release];
}

- (void)showEventContentWarning
{
    NSString *alertString = @"need a title !!";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:alertString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

- (BOOL)timeIsInFuture
{
//    if ([arrangedDate.start timeIntervalSince1970] > [[NSDate date] timeIntervalSince1970]) {
//        return YES;
//    }
//    else
//    {
//        return NO;
//    }

    return YES;
}

- (BOOL)canCreateEvent
{
    if (txtFieldTitle.text == nil) {
        return NO;
    }
    return YES;
}

- (void)createEvent:(NSString *) imgUrl
{
   
    NSString *title = txtFieldTitle.text;
    
    Event *event = [[Event alloc] init];
    event.eventType = 0;
    event.description = @"";
    
    NSMutableArray * invitees = [[NSMutableArray alloc] init];
    for(User * user in self.invitedPeoples) {
        Invitee * invitee = [[Invitee alloc] init];
        invitee.email = user.email;
        [invitees addObject:invitee];
    }
    
    event.invitees = invitees;
    
    
//    event.duration_days = arrangedDate.duration_days;
//    event.duration_hours = arrangedDate.duration_hours;
//    event.duration_minutes = arrangedDate.duration_minutes;
//    event.is_all_day = arrangedDate.is_all_day;
//    event.start = arrangedDate.start;
//    event.start_type = arrangedDate.start_type;


    
    event.propose_starts = [timesView getEventDates];
    
    event.location = self.locationPlace;


    if(event.start == nil) {
        event.start = [NSDate date];
    }

    if(event.start_type == nil) {
        event.start_type = START_TYPEWITHIN;
    }

    event.published = YES;
    
    if(imgUrl == nil) {
        event.thumbnail_url = @"";
    } else {
        event.thumbnail_url = imgUrl;
    }
    
    event.timezone = settingView.timeZoneLabel.text;
    event.title = title;
    
    event.allow_new_dt = settingView.btnInvite1.selected;
    event.allow_attendee_invite = (settingView.canInvitePeopleSwitch.selectedIndex == 0);
    event.allow_new_location = (settingView.canChangeLocation.selectedIndex == 0);

    event.created_on = [Utils convertGMTDate:[NSDate date]];

    Model *model = [Model getInstance];

    [self startIndicator];
    [model createEvent:event andCallback:^(NSInteger error, Event * newEvent) {

        [self stopIndicator];
        
        if (error == 0) {

            CoreDataModel * model = [CoreDataModel getInstance];
            FeedEventEntity * entity = [model createEntity:@"FeedEventEntity"];
            [entity convertFromEvent:newEvent];
            [model addFeedEventEntity:entity];
            [model saveData];
            [model notifyModelChange];
            
            [self.navigationController popViewControllerAnimated:YES];

        } else {
            
            [Utils showUIAlertView:@"Error" andMessage:@"Create event failed"];
        }
    }];
}

- (void)startUploadIndicator
{
    [hud setCaption:@"Uploading Photo"];
    [hud setProgress:0.08];
    [hud show];
    [hud setBlockTouches:YES];
}

- (void)startIndicator
{
    [hud setCaption:@"Creating Event"];
    [hud setActivity:YES];
    [hud show];
    [hud setBlockTouches:YES];
}

- (void)stopIndicator
{
    [hud setProgress:0.0f];
    [hud setActivity:NO];
    [hud setBlockTouches:NO];
    [hud hide];
    [self.view setUserInteractionEnabled:YES];
}

-(void) uploadImage
{
    if(request != nil)
    {
        [request cancel];
        request = nil;
    }
    
    if(imageUrl != nil) {
        [imageUrl release];
        imageUrl = nil;
    }
    
    UIImage * img = imagePickerView.image;
    //[self startUploadIndicator];
    [imageUploadingIndicator startAnimating];
    request =[[Model getInstance] uploadImage:img andCallback:self];
    [request retain];
}

-(void) onUploadStart
{
    
}

-(void) onUploadProgress: (long long) progress andSize: (long long) Size
{
    LOG_D(@"onUploadProgress");
    float progressVal = (progress*1.0)/Size;
    
    if(progressVal>1) progressVal = 1;
    [hud setProgress:progressVal];
}

-(void) onUploadCompleted: (int) error andUrl:(NSString *) url
{
    LOG_D(@"onUploadCompleted");
    //[self stopIndicator];
    
    [imageUploadingIndicator stopAnimating];
    
    [request release];
    request = nil;
    
    if(error != 0) {
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Error"
                                                        message:@"Upload Image failed."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        
        [alert show];
        
        imagePickerView.image = nil;
        
    } else {
        LOG_D(@"onUploadCompleted:%@", url);
        //[self createEvent:url];
        imageUrl = [url retain];;
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
