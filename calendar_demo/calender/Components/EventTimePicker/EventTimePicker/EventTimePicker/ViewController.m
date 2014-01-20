//
//  ViewController.m
//  EventTimePicker
//
//  Created by zyax86 on 1/9/14.
//  Copyright (c) 2014 zyax86. All rights reserved.
//

#import "ViewController.h"
#import "EventTimePicker.h"
#import "AELocalEntry.h"
#import "AEInviteesEntry.h"
#import "AETimeEntry.h"

@interface ViewController ()
{
    EventTimePicker *pick;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    
    pick = [[EventTimePicker alloc] init];
    [self.view addSubview:pick];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 400, 50, 50)];
    [btn setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
//    EndTimePicker *epick = [[EndTimePicker alloc] init];
//    CGRect frame = epick.frame;
//    frame.origin.y = 250;
//    epick.frame = frame;
//    [self.view addSubview:epick];
    
    AEInviteesEntry *inviteEntry = [AEInviteesEntry createView];
    AELocalEntry *localEntry = [AELocalEntry createView];
    AETimeEntry *timeEntry = [AETimeEntry createView];
    [self.view addSubview:inviteEntry];
    [self.view addSubview:localEntry];
    [self.view addSubview:timeEntry];
    
    CGRect frame = inviteEntry.frame;
    frame.origin.y = 300;
    inviteEntry.frame = frame;
    
    frame = timeEntry.frame;
    frame.origin.y = 400;
    timeEntry.frame = frame;

}

- (void)btnClick
{
    [pick loseFocus];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
