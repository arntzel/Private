//
//  ViewController.m
//  calender
//
//  Created by zyax86 on 13-5-26.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "AddEventViewController.h"
#import <UIKit/UIImagePickerController.h>

@interface AddEventViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *eventPhotoView;

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
    [self.eventPhotoView setContentMode:UIViewContentModeScaleAspectFill];
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
- (IBAction)btnAddEventPhoto:(id)sender {
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
    self.eventPhotoView.image = image;
    [picker dismissModalViewControllerAnimated:YES];
}

- (IBAction)btnInvitePeople:(id)sender {
}

- (IBAction)btnAddLocation:(id)sender {
}

- (IBAction)btnAddEventTitle:(id)sender {
}

- (IBAction)btnAddDayOrTime:(id)sender {
}


- (IBAction)Cancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidUnload {
    [self setEventPhotoView:nil];
    [super viewDidUnload];
}
@end
