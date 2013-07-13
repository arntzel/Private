//
//  GPlaceApi.m
//  calender
//
//  Created by zyax86 on 13-5-28.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "GPlaceApi.h"
#import "Location.h"

@interface GPlaceApi()
{
    NSURLConnection *queryConnect;
    NSMutableData *responseData;
}

@end

@implementation GPlaceApi
@synthesize delegate;

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)startRequestWithTxtSearchQuery:(NSString *)query
{
    [queryConnect cancel];
    
    NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/textsearch/json?query=%@&sensor=true&key=%@",query,googleAPIKey];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    queryConnect = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)startRequestWithNearBySearchQuery:(CGPoint)place Radius:(NSInteger)radius
{
    [queryConnect cancel];
    
    NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&radius=%d&sensor=false&key=%@",place.x,place.y,radius,googleAPIKey];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    queryConnect = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSError *err;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&err];
    NSString *result = [json objectForKey:@"status"];
    if ([result isEqualToString:@"OVER_QUERY_LIMIT"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"QUERY OVER GOOGLE API LIMIT" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    if (![result isEqualToString:@"OK"]) {
        return;
    }
    NSArray *resultArray = [json objectForKey:@"results"];

    NSMutableArray *arrayData = [[NSMutableArray alloc] init];
    for (NSDictionary *json in resultArray) {
        [arrayData addObject:[GPlaceApi parseLocation:json]];
    }
    

    [self.delegate upDateWithArray:arrayData GPlaceApi:self];
}

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

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {    
}

- (void)disconnect
{
    [queryConnect cancel];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
}



@end




//
