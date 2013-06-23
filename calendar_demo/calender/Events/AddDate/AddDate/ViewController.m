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
    
    
    self.selectorHorizontal = [[CustomPickerView alloc] initWithDelegate:self];
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



//ONLY ONE OF THESE WILL GET CALLED (DEPENDING ON the horizontalScrolling property Value)
- (CGFloat)rowHeightInSelector:(CustomPickerView *)valueSelector {
    return 70.0;
}


- (UIView *)selector:(CustomPickerView *)valueSelector viewForRowAtIndex:(NSInteger)index {
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, self.selectorHorizontal.frame.size.height)];

    label.text = [NSString stringWithFormat:@"day :%d",index + 1];
    label.textAlignment =  NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    return label;
}

- (CGRect)rectForSelectionInSelector:(CustomPickerView *)valueSelector {

    return CGRectMake(self.selectorHorizontal.frame.size.width/2 - 35.0, 0.0, 70.0, 90.0);
    
}

#pragma IZValueSelector delegate
- (void)selector:(CustomPickerView *)valueSelector didSelectRowAtIndex:(NSInteger)index {
    NSLog(@"Selected index %d",index);
}

@end
