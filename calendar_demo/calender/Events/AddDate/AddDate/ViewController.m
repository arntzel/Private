//
//  ViewController.m
//  AddDate
//
//  Created by zyax86 on 13-6-22.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import "ViewController.h"
#import "DuringTimePicker.h"
#import "TimePicker.h"

@interface ViewController ()
{
    DuringTimePicker *duringTimePicker;
    TimePicker *timePicker;
}
@end

@implementation ViewController

- (void)dealloc
{
    [duringTimePicker release];
    [timePicker release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    duringTimePicker = [[DuringTimePicker alloc] init];
//    [self.view addSubview:duringTimePicker];
    
    timePicker = [[TimePicker alloc] init];
    [self.view addSubview:timePicker];
}
@end
