//
//  AddEventDateViewControllerV2.m
//  Calvin
//
//  Created by fangxiang on 14-3-4.
//  Copyright (c) 2014年 Pencil Me, Inc. All rights reserved.
//

#import "AddEventDateViewControllerV2.h"
#import "NSDateAdditions.h"
#import "Utils.h"
#import "CoreDataModel.h"
#import "ViewUtils.h"
#import "FeedEventTableView.h"
#import "UIView+FrameResize.h"

@interface AddEventDateViewControllerV2 () <UIPickerViewDelegate, UIPickerViewDataSource>

@end

@implementation AddEventDateViewControllerV2 {
    
    NSDate * startDate;
    
    NSDate * selectedStartTime;
    
    NSDate * selectedEndTime;
    
    
    int allDaySelectedStartTimeRow1;
    int allDaySelectedStartTimeRow2;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithEventDate:(ProposeStart *)arrangedDate
{
    self = [super init];
    //TODO
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    
    [self.navigationSegment setSelectedSegmentIndex:0];
    
    [self.allDaySwitch setOn:NO animated:YES];
    [self.allDaySwitch addTarget:self action:@selector(allDaySwtichAction:) forControlEvents:UIControlEventValueChanged];
    
    self.allDayPricker.hidden = YES;
    self.datePricker.hidden = NO;
    self.datePricker.minuteInterval = 15;
    self.datePricker.backgroundColor = [UIColor whiteColor];
    
    self.allDayPricker.delegate = self;
    self.allDayPricker.dataSource = self;
    self.allDayPricker.backgroundColor = [UIColor whiteColor];
        
    startDate = [NSDate date];
    
    if(self.proposeStart == nil) {
        selectedStartTime = startDate;
    } else {
        selectedStartTime = self.proposeStart.start;
    }
    
    [self.datePricker setDate:selectedStartTime];
    
    allDaySelectedStartTimeRow1 = 365;
    allDaySelectedStartTimeRow2 = 500*10;
    
    
    [self.allDayPricker selectRow:allDaySelectedStartTimeRow1 inComponent:0 animated:NO];
    [self.allDayPricker selectRow:allDaySelectedStartTimeRow2 inComponent:1 animated:NO];
    
    [self.datePricker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    
    
    CGRect frame = CGRectMake(0, 64, 320, [self.datePricker getTop] - 45);
    self.tableView = [[FeedEventTableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    //self.tableView = UITableViewCellSeparatorStyleNone;
    self.tableView.eventTypeFilters = FILTER_IMCOMPLETE | FILTER_GOOGLE | FILTER_FB | FILTER_GOOGLE | FILTER_IOS;
    
    UIView * bgview = [[UIView alloc] initWithFrame:frame];
    bgview.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"feed_background_image.png"]];
    self.tableView.backgroundView = bgview;
    
    
    [self.view addSubview:self.tableView];
   
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, [self.tableView getMaxY], 320, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:167/255.0f green:167/255.0f blue:167/255.0f alpha:1];
    [self.view addSubview:lineView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*0.1), dispatch_get_main_queue(),  ^(void) {
         [self.tableView reloadFeedEventEntitys:startDate];
    });
}

-(void)segmentAction:(UISegmentedControl *)seg{
    
    NSInteger index = seg.selectedSegmentIndex;
   
    if(index == 0) {
        
        [self.datePricker setDate:selectedStartTime animated:YES];
        
        NSTimeInterval interval = [selectedStartTime timeIntervalSinceDate:startDate];
        int row = 365 + interval/(24*3600);
        [self.allDayPricker selectRow:row inComponent:0 animated:YES];
        

    } else {
        
        if(selectedEndTime == nil) {
            selectedEndTime = [NSDate dateWithTimeInterval:3600 sinceDate:selectedStartTime];
        }
        
        [self.datePricker setDate:selectedEndTime animated:YES];
        
        NSTimeInterval interval = [selectedEndTime timeIntervalSinceDate:startDate];
        int row = 365 + interval/(24*3600);
        [self.allDayPricker selectRow:row inComponent:0 animated:YES];
        
    }
}


-(void)dateChanged:(id)sender {
    
    UIDatePicker * control = (UIDatePicker*)sender;
    NSDate * date = control.date;

    LOG_D(@"dateChanged=%@", date);
    
    if(self.navigationSegment.selectedSegmentIndex == 0) {
        selectedStartTime = date;
    } else {
        selectedEndTime = date;
    }
    
    [self scrollFeedTableView:date];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleBlackTranslucent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction) btnCancelClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction) btnSaveClicked:(id)sender
{
    if(self.allDaySwitch.on == NO) {
        
        NSDate * now = [NSDate date];
        
        if( [now compare:selectedStartTime] >=0 ) {
            [Utils showUIAlertView:@"Warning" andMessage:@"The start time of the event can't be past time"];
            return;
        }
        
        if(selectedEndTime != nil &&  [selectedStartTime compare:selectedEndTime] >=0) {
            [Utils showUIAlertView:@"Warning" andMessage:@"The end time must be larger than the start time"];
            return;
        }
    }
    
    
    if(self.delegate != nil) {
        
        ProposeStart * time = [[ProposeStart alloc] init];
        time.start_type = START_TYPEEXACTLYAT;
        
        if(self.allDaySwitch.on == NO) {
            
            time.is_all_day = NO;
            time.start = selectedStartTime;
            
            if(selectedEndTime == nil) {
                
                time.duration_days = 0;
                time.duration_hours = 1;
                time.duration_minutes = 0;
                
            } else {
                int seconds = [selectedEndTime timeIntervalSinceDate:selectedStartTime];
                int mins = seconds/60;
                
                time.duration_minutes = (mins % 60);
                int hours = mins/60;
                
                time.duration_hours  = hours %  24;
                
                int days = hours/24;
                time.duration_days = days;
                
            }
            
        } else {
            
            time.is_all_day = YES;
           
            int row = allDaySelectedStartTimeRow1 % 365;
            NSDate * date = [[startDate cc_dateByMovingToTheFollowingDayCout:row] cc_dateByMovingToBeginningOfDay];
            time.start = date;
            time.duration_days = allDaySelectedStartTimeRow2%10 + 1;
        }
        
        [self.delegate setEventDate:time];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}



-(void) allDaySwtichAction:(id)sender
{
    if(self.allDaySwitch.on) {
        
        self.allDayPricker.hidden = NO;
        self.datePricker.hidden = YES;
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2];
        self.navigationSegment.alpha = 0;
        [UIView commitAnimations];

    } else {
        
        self.allDayPricker.hidden = YES;
        self.datePricker.hidden = NO;
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2];
        self.navigationSegment.alpha = 1;
        [UIView commitAnimations];
    }
}

-(void) scrollFeedTableView:(NSDate *) date
{
    NSString * day = [Utils formateDay:date];
    NSString * day2 = [Utils formateDay:[self.tableView getFirstVisibleDay]];
    
    if(![day isEqualToString:day2])
    {
        [self.tableView scroll2Date:day animated:YES];
    }
}

#pragma mark -

#pragma mark pickViewDelete

//个数
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}



//行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    if(component == 0) {
        return 365*2;
    } else {
        return 10 * 1000;
    }
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view;
{
    NSString * text;
    if(component == 0) {
        
        row = row%365;
        
        if(row == 0) {
            text = @"Today";
        } else {
            NSDate * day = [startDate cc_dateByMovingToTheFollowingDayCout:row];
            text = [Utils formateDay4:day];
        }
        
    } else {
        int day = (row%10)+1;
        if(day>1) {
            text = [NSString stringWithFormat:@"%d Days", day];
        } else {
            text = @"1 Day";
        }
        
        text = [NSString stringWithFormat:@"        %@", text];
    }

    UILabel * label;
    if(view == nil) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 35)];
        label.font = [UIFont fontWithName:@"Helvetica" size:22];
    } else {
        label = (UILabel *)view;
    }
    
    
    if(component == 0) {
        label.textAlignment = NSTextAlignmentRight;
    } else {
        label.textAlignment = NSTextAlignmentLeft;
    }
    
    label.text = text;
    return label;
}


- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 35;
}


-(void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(component == 0) {
        
        allDaySelectedStartTimeRow1 = row;
        
        row = row % 365;
        
        NSDate * date = [startDate cc_dateByMovingToTheFollowingDayCout:row];
        [self scrollFeedTableView:date];
        
        LOG_D(@"pickerView:didSelectRow, selecte day:%@", date);
        
    } else {
        allDaySelectedStartTimeRow2 = row;
    }
    
    LOG_D(@"pickerView:didSelectRow:%d, %d", allDaySelectedStartTimeRow1, allDaySelectedStartTimeRow2);
    
}

@end




