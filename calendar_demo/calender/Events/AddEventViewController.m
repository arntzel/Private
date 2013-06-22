//
//  AddEventViewController.m
//  calender
//
//  Created by zyax86 on 13-6-19.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "AddEventViewController.h"
#import "AddEventView.h"
#import "AddLocationViewController.h"

@interface AddEventViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate ,UIScrollViewDelegate>
{
    AddEventView *addEventView;
}

@end

@implementation AddEventViewController

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
    
}

- (void)addEventPhoto:(id)sender
{
    UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Picker Photo From Album" otherButtonTitles:@"Picker Photo From Camera", nil];
    [menu showInView:self.view];
}


- (void)invitePeople:(id)sender
{
    
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
    [self.navigationController popViewControllerAnimated:YES];
}


@end
