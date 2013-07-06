//
//  AddEventInviteViewController.m
//  calender
//
//  Created by zyax86 on 13-7-6.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "AddEventInviteViewController.h"
#import "AddEventInviteDataSource.h"
#import "UserModel.h"

@interface AddEventInviteViewController ()<UITableViewDelegate>
{
    AddEventInviteDataSource *dataSource;
}

@end

@implementation AddEventInviteViewController
@synthesize delegate;

- (void)dealloc
{
    [dataSource release];
    self.tableView = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    dataSource = [[AddEventInviteDataSource alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource =  dataSource;
    [self getInvitePeopleData];
}

- (void)getInvitePeopleData
{
    UserModel *model = [UserModel getInstance];
    [model getUsers:0 andCallback:^(NSInteger error, NSArray *users) {
        [dataSource reloadData:users];
        [self.tableView reloadData];
    }];
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [dataSource setSelectedAtIndex:indexPath.row];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [dataSource setDeselectedAtIndex:indexPath.row];
}

- (IBAction)Cancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)create:(id)sender {
    [self.delegate setInVitePeopleArray:[dataSource getSelectedUsers]];
    [self.navigationController popViewControllerAnimated:YES];
}


@end
