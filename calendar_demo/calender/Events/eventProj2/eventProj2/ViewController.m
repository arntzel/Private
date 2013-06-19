//
//  ViewController.m
//  eventProj2
//
//  Created by zyax86 on 13-6-18.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import "ViewController.h"
//#import "AddEventViewController.h"
#import "AddEventView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:scrollView];
    [scrollView release];
    scrollView.scrollEnabled = YES;
    
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"AddEventView" owner:self options:nil];
    AddEventView *addEventView = (AddEventView*)[nibView objectAtIndex:0];
    [scrollView addSubview:addEventView];
    [scrollView setContentSize:addEventView.frame.size];
    
    UIImageView *imageview;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
