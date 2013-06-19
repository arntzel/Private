//
//  AddEventViewController.m
//  calender
//
//  Created by zyax86 on 13-6-19.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "AddEventViewController.h"
#import "AddEventView.h"

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
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"AddEventView" owner:self options:nil];
    AddEventView *addEventView = (AddEventView*)[nibView objectAtIndex:0];
    [self.scrollView addSubview:addEventView];
    [self.scrollView setContentSize:addEventView.frame.size];
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
