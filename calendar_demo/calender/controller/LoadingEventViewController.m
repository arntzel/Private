//
//  LoadingEventViewController.m
//  Calvin
//
//  Created by fangxiang on 14-2-28.
//  Copyright (c) 2014年 Pencil Me, Inc. All rights reserved.
//

#import "LoadingEventViewController.h"
#import "Model.h"
#import "UserSetting.h"
#import "Utils.h"
#import "MainViewController.h"
#import "RootNavContrller.h"
#import "UserModel.h"

@interface LoadingEventViewController ()<UIAlertViewDelegate>

@end

@implementation LoadingEventViewController
{
    int loadedEventCount;
    int allEventCount;
}

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
    
    User *me = [[UserModel getInstance] getLoginUser];
    [[CoreDataModel getInstance] initDBContext:me];

    NSData * gif = [NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"Calvin_loader" ofType:@"gif"]];
    
    self.webView.userInteractionEnabled = NO;//用户不可交互
    [self.webView loadData:gif MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
    
    //begin to loading data
    self.progressView.progress = 0;
    
    double delayInSeconds = 0.01;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self toLoadEventData];
    });
}

//load a batch event data from server
-(void) toLoadEventData
{
    NSLog(@"synchronizedFromServer begin");
    
    NSString * last_modify_num = [[UserSetting getInstance] getStringValue:KEY_LASTUPDATETIME];
    if (last_modify_num == nil) {
        last_modify_num = [Utils getSecondsFromEpoch];
    }
    
    LOG_D(@"synchronizedFromServer begin :%@", last_modify_num);
    NSDate * begin = [NSDate date];
    
    [[Model getInstance] getUpdatedEvents:last_modify_num andCallback:^(NSInteger error, NSInteger totalCount, NSArray *events) {
        
        int seconds = [[NSDate date] timeIntervalSinceDate:begin];
        
        LOG_D(@"SynchronizedFromServer end, time=%d, %@ , error=%d, count:%d, allcount:%d", seconds, last_modify_num, error, events.count, totalCount);
        
        if (error) {
            
            //something is wrong, maybe network or server.
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                             message:@"Synchronize data event data from server is error."
                                                            delegate:self
                                                   cancelButtonTitle:@"Ignore"
                                                   otherButtonTitles:@"Retry", nil];
            
            [alert show];
            return ;
            
        } else if (events.count == 0) {
            
            [self showMainViewController];
        }
        
        NSString * maxlastupdatetime = last_modify_num;
        
        //CoreDataModel * model = [CoreDataModel getInstance];
        NSLog(@"========before download=========");
        for (FeedEventEntity * entity in events) {
            if([entity.modified_num compare:maxlastupdatetime] > 0) {
                maxlastupdatetime = entity.modified_num;
            }
        }
        
        [[UserSetting getInstance] saveKey:KEY_LASTUPDATETIME andStringValue:maxlastupdatetime];
        
        NSLog(@"========after download=========");
    
        allEventCount = loadedEventCount + totalCount;
        loadedEventCount += events.count;
    
        float progress = (float)loadedEventCount / (float)allEventCount;
        self.progressView.progress = progress;
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), queue, ^{
            [self toLoadEventData];
        });
    }];
}

-(void) showMainViewController
{
    LOG_D(@"synchronizedFromServer is done, show the MainViewController");
    
    MainViewController * rootController = [[MainViewController alloc] init];
    
    [self.navigationController popToRootViewControllerAnimated:NO];
    [[RootNavContrller defaultInstance] pushViewController:rootController animated:YES];
    return;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
 
    LOG_D("alertView:clickedButtonAtIndex: %d", buttonIndex);
    
    switch (buttonIndex) {
        case 0: //ignore
            [self showMainViewController];
            break;
            
        case 1:  //retry
            [self toLoadEventData];
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
