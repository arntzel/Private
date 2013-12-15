//
//  GPlaceDataSource.m
//  calender
//
//  Created by zyax86 on 13-5-28.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "GPlaceAutoCompleteSource.h"


@interface GPlaceAutoCompleteSource()
@property(nonatomic,strong) NSArray *arrayData;

@end

@implementation GPlaceAutoCompleteSource
@synthesize delegate;



- (void)setData:(NSArray *)data
{
    self.arrayData = data;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrayData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"GPlaceAutoCompleteSourceCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSString *location = [self.arrayData objectAtIndex:indexPath.row];
    cell.textLabel.text = location;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * location = [self.arrayData objectAtIndex:indexPath.row];
    [self.delegate didSelectPlaceWithName:location GPlaceDataSource:self];
}
@end
