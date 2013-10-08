//
//  NotificaitonViewController.m
//  Calvin
//
//  Created by tu changwei on 13-9-27.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "NotificaitonViewController.h"

@interface NotificaitonViewController ()

@end

@implementation NotificaitonViewController

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
    [self setupViews];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setup Views
- (void)setupViews
{
    self.navigation.titleLable.text = @"Notifications";
    self.navigation.leftBtn.frame = CGRectMake(8, 9, 26, 26);
    [self.navigation.leftBtn setBackgroundImage:[UIImage imageNamed:@"settings_detail_noti_back"] forState:UIControlStateNormal];
    self.navigation.rightBtn.hidden = YES;
}
#pragma mark - User Interaction
- (IBAction)viewBeClicked:(UITapGestureRecognizer *)sender
{
    for (UIView *subview in [sender.view subviews])
    {
        if ([subview isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)subview;
            btn.selected = !btn.selected;
        }
    }
    
}
@end
