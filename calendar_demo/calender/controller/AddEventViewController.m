//
//  ViewController.m
//  calender
//
//  Created by zyax86 on 13-5-26.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "AddEventViewController.h"

@interface AddEventViewController ()

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

- (IBAction)btnAddEventPhoto:(id)sender {
}

- (IBAction)btnInvitePeople:(id)sender {
}

- (IBAction)btnAddLocation:(id)sender {
}

- (IBAction)btnAddEventTitle:(id)sender {
}

- (IBAction)btnAddDayOrTime:(id)sender {
}

@end
