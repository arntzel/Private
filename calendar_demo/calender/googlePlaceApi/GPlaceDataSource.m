//
//  GPlaceDataSource.m
//  calender
//
//  Created by zyax86 on 13-5-28.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "GPlaceDataSource.h"


@interface GPlaceDataSource()
@property(nonatomic,strong) NSMutableArray *arrayData;

@end

@implementation GPlaceDataSource
@synthesize delegate;

+(Location *)parseLocation:(NSDictionary *)json
{
    Location * location = [[Location alloc] init];
    location.location = [json objectForKey:@"name"];
    location.photo = [json objectForKey:@"icon"];
    
    NSDictionary *geometryDict = [json objectForKey:@"geometry"];
    NSDictionary *locationDict = [geometryDict objectForKey:@"location"];
    
    if([json objectForKey:@"lat"] != [NSNull null]) {
        location.lat = [[locationDict objectForKey:@"lat"] floatValue];
    }
    if([json objectForKey:@"lng"] != [NSNull null]) {
        location.lng = [[locationDict objectForKey:@"lng"] floatValue];
    }
    
    return location;
}

- (void)setData:(NSArray *)data
{
    self.arrayData = [[NSMutableArray alloc] init];
    for (NSDictionary *json in data) {
        [self.arrayData addObject:[GPlaceDataSource parseLocation:json]];
    }
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
