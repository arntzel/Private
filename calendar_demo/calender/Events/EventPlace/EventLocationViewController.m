//
//  EventLocationViewController.m
//  Calvin
//
//  Created by zyax86 on 10/5/13.
//  Copyright (c) 2013 fang xiang. All rights reserved.
//

#import "EventLocationViewController.h"
#import "EventDetailNavigationBar.h"

@interface EventLocationViewController ()<EventDetailNavigationBarDelegate>
{
    EventDetailNavigationBar *navBar;
}

@end

@implementation EventLocationViewController

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
    [self addNavBar];
    
}

- (void)addNavBar
{
    navBar = [EventDetailNavigationBar creatView];
    navBar.rightbtn.hidden = YES;
    navBar.delegate = self;
    [self.view addSubview:navBar];
}

- (void)leftBtnPress:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBtnPress:(id)sender
{
    
}

@end
