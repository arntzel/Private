//
//  AddEventInviteDataSource.m
//  calender
//
//  Created by zyax86 on 13-7-6.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "AddEventInviteDataSource.h"
#import "AddEventInvitePeopleCell.h"
#import "UserModel.h"
#import "User.h"

@interface AddEventInvitePeople : NSObject <NSObject>

@property(nonatomic, retain) User *user;
@property(nonatomic, assign) BOOL selected;


@end

@implementation AddEventInvitePeople

- (void)dealloc
{
    self.user = nil;
    [super dealloc];
}

@end

@interface AddEventInviteDataSource()
{
    NSMutableArray *array;
}

@end

@implementation AddEventInviteDataSource

- (void)dealloc
{
    [array release];
    [super dealloc];
}

- (id)init
{
    if (self = [super init]) {
        array = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)reloadData:(NSArray *)users
{
    [array removeAllObjects];
    
    for (User *user in users) {
        AddEventInvitePeople *people = [[AddEventInvitePeople alloc] init];
        people.user = user;
        people.selected = NO;
        [array addObject:people];
    }
}

- (NSArray *)getSelectedUsers
{
    NSMutableArray *selectedArray = [[NSMutableArray alloc] init];
    for (AddEventInvitePeople *people in array) {
        if (people.selected) {
            [selectedArray addObject:people.user];
        }
    }
    return [selectedArray autorelease];
}

- (void)setSelectedAtIndex:(NSInteger)index
{
    AddEventInvitePeople *people = [array objectAtIndex:index];
    people.selected = YES;
}

- (void)setDeselectedAtIndex:(NSInteger)index
{
    AddEventInvitePeople *people = [array objectAtIndex:index];
    people.selected = NO;
}

- (NSString *)nameAtIndex:(NSInteger)index
{
    NSString *name = [array objectAtIndex:index];
    return name;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AddEventInvitePeopleCell" owner:self options:nil];
    AddEventInvitePeopleCell *cell = [nib objectAtIndex:0];
    [cell initUI];
    
    AddEventInvitePeople *people = [array objectAtIndex:indexPath.row];
    cell.selected = people.selected;
    cell.peopleName.text = people.user.username;

    return cell;
}

@end
