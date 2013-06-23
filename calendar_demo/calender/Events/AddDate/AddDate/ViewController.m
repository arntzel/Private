//
//  ViewController.m
//  AddDate
//
//  Created by zyax86 on 13-6-22.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import "ViewController.h"
#import "CustomPickerView.h"

@interface ViewController ()<CustomPickerViewDataSource,CustomPickerViewDelegate>
@property (nonatomic,strong) CustomPickerView *selectorHorizontal;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    self.selectorHorizontal = [[CustomPickerView alloc] initWithFrame:CGRectMake(0, 250, 160, 160) Delegate:self];
    [self.view addSubview:self.selectorHorizontal];
    
    self.selectorHorizontal.debugEnabled = NO;
    self.selectorHorizontal.debugEnabled = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma IZValueSelector dataSource
- (NSInteger)numberOfRowsInSelector:(CustomPickerView *)valueSelector {
    return 65536;
}

#pragma IZValueSelector delegate
- (void)selector:(CustomPickerView *)valueSelector didSelectRowAtIndex:(NSInteger)index {
    NSLog(@"Selected index %d",index);
}

@end
