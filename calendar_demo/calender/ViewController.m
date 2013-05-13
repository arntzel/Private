//
//  ViewController.m
//  calender
//
//  Created by fang xiang on 13-5-4.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "ViewController.h"
#import "Navigation.h"

#import "PlanView.h"

#import "Location.h"

#import "KalView.h"
#import "KalLogic.h"
#import "KalDate.h"
#import "NSDateAdditions.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate,KalViewDelegate>
{
    KalLogic *logic;
    KalView *calendarView;
    
    Navigation* navigation;
    
    UITableView * tableView;
    
    NSMutableArray * sections;
    NSMutableDictionary * sectionDict;
}

@property (nonatomic, retain, readwrite) NSDate *initialDate;
@property (nonatomic, retain, readwrite) NSDate *selectedDate;
@property (nonatomic, retain) KalView *calendarView;
@end

@implementation ViewController
@synthesize initialDate,selectedDate;
@synthesize calendarView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    sections = [[NSMutableArray alloc] init];
    [sections addObject:@"Later Today"];
    [sections addObject:@"2013-05-06"];
    [sections addObject:@"2013-05-05"];
    [sections addObject:@"2013-05-04"];

    sectionDict = [[NSMutableDictionary alloc] init];
    
    NSMutableArray * plans = [self createPlan];
    [sectionDict setObject:plans forKey:@"Later Today"];
    
    plans = [self createPlan];
    [sectionDict setObject:plans forKey:@"2013-05-06"];
    
    plans = [self createPlan];
    [sectionDict setObject:plans forKey:@"2013-05-05"];
    
    plans = [self createPlan];
    [sectionDict setObject:plans forKey:@"2013-05-04"];


    navigation = [Navigation createNavigationView];
    [self.view addSubview:navigation];

    int y = navigation.frame.size.height;

    CGRect frame = self.view.bounds;
    frame.origin.y = y;
    frame.size.height -=y;
    
    
    tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tableView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    
    [tableView setAllowsSelection:NO];

    tableView.dataSource = self;
    tableView.delegate = self;
    
    [self.view addSubview:tableView];
    
    
    
    
    
    NSDate *date = [NSDate date];
    
    logic = [[KalLogic alloc] initForDate:date];
    self.initialDate = date;
    self.selectedDate = date;
    
    
    if (!self.title)
        self.title = @"Calendar";
    KalView *kalView = [[KalView alloc] initWithFrame:[self.view bounds] delegate:self logic:logic];
    [kalView setUserInteractionEnabled:YES];
    [kalView setMultipleTouchEnabled:YES];
    [self.view addSubview:kalView];
    self.calendarView = kalView;
    
    [kalView selectDate:[KalDate dateFromNSDate:self.initialDate]];

    
}

-(NSMutableArray *) createPlan {
    NSMutableArray * array = [[NSMutableArray alloc] init];
    
    User * user = [[User alloc] init];
    user.username = @"Peter";
    
    for(int i=0;i<4;i++) {
        Plan * plan = [[Plan alloc] init];
        plan.host = user;
        plan.title = @"Dinner with peter, Dave";
        plan.attenedees = @"Peter, Peter2, Dave, Jerry";
        plan.location = [[Location alloc] init];
        plan.location.locationName = @"Venmo Headquartes";

        if(i%2 == 0) {
            plan.status = 0;
        } else {
            plan.status = 1;
        }
        
        plan.time = [NSDate date];
        [array addObject:plan];
    }
        
    return array;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSString * key = [sections objectAtIndex:section];
    NSArray * array = [sectionDict objectForKey:key];
    
    NSLog(@"section=%d, count=%d/%d, key=%@", section, array.count, sections.count, key);
    
    
    return array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = indexPath.section;
    int row = indexPath.row;
    
    NSLog(@"cellForRowAtIndexPath: %d, %d", section, row);
    
    NSString * key = [sections objectAtIndex:section];
    NSArray * array = [sectionDict objectForKey:key];
    
    Plan * plan = [array objectAtIndex:row];
    PlanView * view = [PlanView createPlanView];
    
    [view refreshView:plan];
    
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"planview"];
    [cell addSubview:view];
    return cell;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    NSString * sectionName = [sections objectAtIndex:section];

    CGRect frame = CGRectMake(0, 0, 320, 24);

    UIView * view = [[UIView alloc] initWithFrame:frame];
    UIImageView * bg = [[UIImageView alloc] initWithFrame:frame];
    bg.image = [UIImage imageNamed:@"bg_section_header"];
    [view addSubview:bg];

    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(58, 0, 1, 24)];
    float colorVal = 227.0/255.0;
    line.backgroundColor = [UIColor colorWithRed:colorVal green:colorVal blue:colorVal alpha:1];
    [view addSubview:line];

    UIImageView * dotView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"dot"]];
    dotView.frame = CGRectMake(54, 7, 10, 10);
    [view addSubview:dotView];

    float fontColor = 172.0/255.0;

    UILabel * dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(68, 5, 320-68, 16)];
    dayLabel.text = sectionName;
    dayLabel.textColor = [UIColor colorWithRed:fontColor green:fontColor blue:fontColor alpha:1];
    dayLabel.font = [UIFont fontWithName:@"Arial" size:12];
    dayLabel.textAlignment = UITextAlignmentLeft;
    dayLabel.backgroundColor = [UIColor clearColor];
    
    [view addSubview:dayLabel];

    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int count = [sectionDict count];
    
    NSLog(@"numberOfSectionsInTableView:%d", count);
    return count;
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 24;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return PlanView_HEIGHT;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark kalViewDelegate

- (void)didSelectDate:(KalDate *)date
{
    self.selectedDate = [date NSDate];
}

- (void)showPreviousMonth
{
    [logic retreatToPreviousMonth];
    [[self calendarView] slideDown];
}

- (void)showFollowingMonth
{
    [logic advanceToFollowingMonth];
    [[self calendarView] slideUp];
}

- (void)showPreviousWeek
{
    [logic retreatToPreviousWeek];
    [[self calendarView] slideUp];
}

- (void)showFollowingWeek
{
    [logic advanceToFollowingWeek];
    [[self calendarView] slideDown];
}


@end
