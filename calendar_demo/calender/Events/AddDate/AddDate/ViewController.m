//
//  ViewController.m
//  AddDate
//
//  Created by zyax86 on 13-6-22.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import "ViewController.h"
#import "TimePickerView.h"

@interface ViewController ()
{
    TimePickerView *pickView;
}
@end

@implementation ViewController

- (void)dealloc
{
    [pickView release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    pickView = [[TimePickerView alloc] init];
    [self.view addSubview:pickView];
}
@end
