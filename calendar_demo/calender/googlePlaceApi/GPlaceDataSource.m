//
//  GPlaceDataSource.m
//  calender
//
//  Created by zyax86 on 13-5-28.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "GPlaceDataSource.h"


@interface GPlaceDataSource()
@property(nonatomic,strong) NSArray *arrayData;

@end

@implementation GPlaceDataSource
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
    static NSString *CellIdentifier = @"GPlaceDataSourceCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Location * location = [self.arrayData objectAtIndex:indexPath.row];
    cell.textLabel.text = location.location;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Location * location = [self.arrayData objectAtIndex:indexPath.row];
    [self.delegate didSelectPlace:location GPlaceDataSource:self];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.delegate tableViewDidScroll:self];
}
@end
