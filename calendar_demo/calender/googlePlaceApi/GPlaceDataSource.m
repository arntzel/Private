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
    //config the cell
    
    NSDictionary *placeDict = [self.arrayData objectAtIndex:indexPath.row];
    cell.textLabel.text = [placeDict objectForKey:@"name"];
//    cell.imageView.image = @"http://maps.gstatic.com/mapfiles/place_api/icons/generic_business-71.png";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *placeDict = [self.arrayData objectAtIndex:indexPath.row];
    NSDictionary *geometry = [placeDict objectForKey:@"geometry"];
    NSDictionary *location = [geometry objectForKey:@"location"];
    NSNumber *lat = [location objectForKey:@"lat"];
    NSNumber *lng = [location objectForKey:@"lng"];
    
    [self.delegate didSelectPlace:CGPointMake([lat floatValue], [lng floatValue]) GPlaceDataSource:self];
}
@end
