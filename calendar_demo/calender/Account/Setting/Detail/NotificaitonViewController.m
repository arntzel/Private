//
//  NotificaitonViewController.m
//  Calvin
//
//  Created by tu changwei on 13-9-27.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "NotificaitonViewController.h"
#import "UserModel.h"
@interface NotificaitonViewController ()
@property (nonatomic, strong) NSMutableDictionary *dic;
@property (nonatomic, strong) NSMutableArray *arr;
@property (nonatomic, assign) BOOL hasClicked;
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
    self.arr = [NSMutableArray array];
    [self setupViews];
    [self requestNotis];
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
- (void)leftNavBtnClicked:(UIButton *)btn
{
    if ([self hasChanged])
    {
        [[UserModel getInstance]updateSetting:self.dic andCallBack:^(NSInteger error) {
            
        }];
    }
    [super leftNavBtnClicked:btn];
    
}

- (IBAction)viewBeClicked:(UITapGestureRecognizer *)sender
{
    self.hasClicked = YES;
    for (UIView *subview in [sender.view subviews])
    {
        if ([subview isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)subview;
            btn.selected = !btn.selected;
            if (btn.selected&&![self.arr containsObject:@(sender.view.tag)])
            {
                [self.arr addObject:@(sender.view.tag)];
            }
            if (!btn.selected&&[self.arr containsObject:@(sender.view.tag)])
            {
                [self.arr removeObject:@(sender.view.tag)];
            }
        }
    }
    
}

- (void)layoutNoticationView:(NSArray *)notificationArray
{
    for (NSNumber *num in notificationArray)
    {
        UIView *rowView = [self.notificationBgView viewWithTag:[num intValue]];
        for (UIView *subview in [rowView subviews])
        {
            if ([subview isKindOfClass:[UIButton class]])
            {
                UIButton *btn = (UIButton *)subview;
                btn.selected = YES;
            }
        }
    }
}

#pragma mark - Data Request
- (void)requestNotis
{
    [[UserModel getInstance] getSetting:^(NSInteger error, NSDictionary *settings) {
        
        if(error == 0)
        {
            self.dic = [NSMutableDictionary dictionaryWithDictionary:settings];
            NSArray *tmpArr = [self.dic objectForKey:@"show_notification_types"];
            [self layoutNoticationView:tmpArr];
        }
    }];
}

#pragma mark - Helper

-(BOOL)hasChanged
{
    if (!self.hasClicked)
    {
        return NO;
    }
    NSArray *tmpArr = [self.dic objectForKey:@"show_notification_types"];
    if ([tmpArr count] != [self.arr count])
    {
        [self.dic setObject:self.arr forKey:@"show_notification_types"];
        return YES;
    }
    else
    {
        for (NSNumber *num in self.arr)
        {
            if (![tmpArr containsObject:num])
            {
                [self.dic setObject:self.arr forKey:@"show_notification_types"];
                return YES;
            }
        }
        return NO;
    }
    
}
@end
