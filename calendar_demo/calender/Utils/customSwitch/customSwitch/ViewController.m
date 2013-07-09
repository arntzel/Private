//
//  ViewController.m
//  customSwitch
//
//  Created by zyax86 on 13-7-9.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import "ViewController.h"
#import "CustomSwitch.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.view setBackgroundColor:[UIColor colorWithRed:245.0/255.0f green:245.0/255.0f blue:245.0/255.0f alpha:1.0f]];
    CustomSwitch *custom = [[CustomSwitch alloc] initWithFrame:CGRectMake(6, 200, 308, 40) segmentCount:3];
    [custom setSegTitle:@"exactly at" AtIndex:0];
    [custom setSegTitle:@"within an hour" AtIndex:1];
    [custom setSegTitle:@"anytime after" AtIndex:2];
    [self.view addSubview:custom];
    
    [custom addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
}

-(void)sliderValueChanged:(CustomSwitch *) sender{
    NSLog(@"%d",sender.selectedIndex);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
