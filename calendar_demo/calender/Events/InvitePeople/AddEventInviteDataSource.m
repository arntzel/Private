//
//  AddEventInviteDataSource.m
//  calender
//
//  Created by zyax86 on 13-7-6.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "AddEventInviteDataSource.h"
#import "AddEventInvitePeopleCell.h"

@interface AddEventInvitePeople : NSObject <NSObject>

@property(nonatomic, copy) NSString *name;
@property(nonatomic, assign) BOOL selected;


@end

@implementation AddEventInvitePeople

- (void)dealloc
{
    self.name = nil;
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
        
        for (NSInteger index = 0; index < 100; index++) {
            AddEventInvitePeople *people = [[AddEventInvitePeople alloc] init];
            people.selected = index % 2;
            people.name = [NSString stringWithFormat:@"index at %d", index];
            [array addObject:people];
        }

    }
    return self;
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
    cell.peopleName.text = people.name;

    return cell;
}

@end
