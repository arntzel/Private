//
//  ViewController.m
//  AddDate
//
//  Created by zyax86 on 13-6-22.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import "ViewController.h"
#import "PickerView.h"

@interface ViewController ()<PickerViewDataSource,PickerViewDelegate>
@property (nonatomic,strong) PickerView *selectorHorizontal;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    self.selectorHorizontal = [[PickerView alloc] initWithFrame:CGRectMake(0, 250, 160, 160) Delegate:self];
    [self.view addSubview:self.selectorHorizontal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma IZValueSelector dataSource
- (NSInteger)numberOfRowsInSelector:(PickerView *)valueSelector {
    return 65536;
}

#pragma IZValueSelector delegate
- (void)selector:(PickerView *)valueSelector didSelectRowAtIndex:(NSInteger)index {
    NSLog(@"Selected index %d",index);
}

@end
