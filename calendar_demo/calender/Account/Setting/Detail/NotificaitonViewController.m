//
//  NotificaitonViewController.m
//  Calvin
//
//  Created by tu changwei on 13-9-27.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "NotificaitonViewController.h"
#import "UserModel.h"
#import "UserSetting.h"
@interface NotificaitonViewController ()
@property (nonatomic, strong) NSMutableDictionary *dic;
@property (nonatomic, strong) NSMutableArray *arr;
@property (nonatomic, assign) BOOL hasClicked;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indi;
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
    self.dic = [NSMutableDictionary dictionary];
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
    CGRect frame = self.indi.frame;
    frame.origin = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    self.indi.frame = frame;
    self.indi.hidden = YES;
}

#pragma mark - User Interaction
- (void)leftNavBtnClicked:(UIButton *)btn
{
    if ([self hasChanged])
    {
        self.indi.hidden = NO;
        [self.indi startAnimating];
        [[UserModel getInstance]updateSetting:self.dic andCallBack:^(NSInteger error) {
            
            if (error==0)
            {
                NSMutableString * strNotiTypes = [[NSMutableString alloc] init];
                
                for(int i=0 ; i<self.arr.count; i++) {
                    [strNotiTypes appendString:[NSString stringWithFormat:@"%@",[self.arr objectAtIndex:i]]];
                    
                    if(i<self.arr.count-1) {
                        [strNotiTypes appendString:@","];
                    }
                }
                
                NSString * Notistr = [[UserSetting getInstance] getStringValue:KEY_SHOW_NOTIFICATION_TYPES];
                
                if(Notistr == nil || ![Notistr isEqualToString:strNotiTypes]) {
                    [[UserSetting getInstance] saveKey:KEY_SHOW_NOTIFICATION_TYPES andStringValue:strNotiTypes];
                    LOG_I(@"saveKey: %@=%@", KEY_SHOW_NOTIFICATION_TYPES, strNotiTypes);
                }
            }
            
            [self.indi stopAnimating];
            self.indi.hidden = YES;
            [super leftNavBtnClicked:btn];
            
        }];
    }
    else
    {
        [super leftNavBtnClicked:btn];
    }
    
    
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
            if (btn.selected)
            {
                BOOL isContain = NO;
                for (NSNumber *num in self.arr)
                {
                    if ([num intValue] ==  sender.view.tag)
                    {
                        isContain = YES;
                    }
                }
                if (isContain == NO)
                {
                    [self.arr addObject:@(sender.view.tag)];
                }
            }
            if (!btn.selected)
            {
        
                for (int i=0;i<[self.arr count];i++)
                {
                    NSNumber *num = [self.arr objectAtIndex:i];
                    if ([num intValue]==sender.view.tag)
                    {
                        [self.arr removeObject:num];
                    }
                }
                
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
    
    NSString * notiStr = [[UserSetting getInstance] getStringValue:KEY_SHOW_NOTIFICATION_TYPES];
    if (notiStr.length > 0)
    {
        NSArray *show_notification_types = [notiStr componentsSeparatedByString:@","];
        [self.dic setObject:show_notification_types forKey:@"show_notification_types"];
        [self.arr addObjectsFromArray:show_notification_types];
    }
    
    NSString * str = [[UserSetting getInstance] getStringValue:KEY_SHOW_EVENT_TYPES];
    if (str.length > 0)
    {
        NSArray *show_event_types = [str componentsSeparatedByString:@","];
        [self.dic setObject:show_event_types forKey:@"show_event_types"];
    }
    [self layoutNoticationView:self.arr];
    
}

#pragma mark - Helper

-(BOOL)hasChanged
{
    if (!self.hasClicked)
    {
        return NO;
    }
    NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:[self.dic objectForKey:@"show_notification_types"]];
    if ([tmpArr count] != [self.arr count])
    {
        [self.dic setObject:self.arr forKey:@"show_notification_types"];
        return YES;
    }
    else
    {
        
        [tmpArr sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            
            NSNumber *num1 = obj1;
            NSNumber *num2 = obj2;
            if ([num1 intValue] > [num2 intValue])
            {
                return NSOrderedDescending;
            }
            else if ([num1 intValue] < [num2 intValue])
            {
                return NSOrderedAscending;
            }
            else
            {
                return NSOrderedSame;
            }
            
        }];
        [self.arr sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            
            NSNumber *num1 = obj1;
            NSNumber *num2 = obj2;
            if ([num1 intValue] > [num2 intValue])
            {
                return NSOrderedDescending;
            }
            else if ([num1 intValue] < [num2 intValue])
            {
                return NSOrderedAscending;
            }
            else
            {
                return NSOrderedSame;
            }
            
        }];
        
        for (int i=0; i<[self.arr count]; i++)
        {
            NSNumber *numb1 = [self.arr objectAtIndex:i];
            NSNumber *numb2 = [tmpArr objectAtIndex:i];
            if ([numb1 intValue] != [numb2 intValue])
            {
                [self.dic setObject:self.arr forKey:@"show_notification_types"];
                return YES;
            }
        }
        return NO;
    }
    
}
@end
