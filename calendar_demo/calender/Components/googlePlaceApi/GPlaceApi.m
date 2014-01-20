//
//  GPlaceApi.m
//  calender
//
//  Created by zyax86 on 13-5-28.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "GPlaceApi.h"
#import "Location.h"

typedef enum {
    GPlaceApiTypeTextQuery,
    GPlaceApiTypeAutoComplition,
    GPlaceApiTypeTextNearBySearch
}GPlaceApiType;

@interface GPlaceApi()
{
    NSURLConnection *queryConnect;
    NSMutableData *responseData;
    GPlaceApiType connectionType;
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
    connectionType = GPlaceApiTypeTextQuery;
}

- (void)startAutoComplitionWithTxtSearchQuery:(NSString *)query
{
    [queryConnect cancel];
    
    NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/queryautocomplete/json?input=%@&sensor=true&key=%@",query,googleAPIKey];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    queryConnect = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    connectionType = GPlaceApiTypeAutoComplition;
}

- (void)startRequestWithNearBySearchQuery:(CGPoint)place Radius:(NSInteger)radius
{
    [queryConnect cancel];
    
    NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&radius=%d&sensor=false&key=%@",place.x,place.y,radius,googleAPIKey];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    queryConnect = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    connectionType = GPlaceApiTypeTextNearBySearch;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSError *err;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&err];
    
    NSLog(@"google api, json:%@", json);
    
    switch (connectionType) {
        case GPlaceApiTypeTextQuery:
        case GPlaceApiTypeTextNearBySearch:
            [self TextQueryResult:json];
            break;
        case GPlaceApiTypeAutoComplition:
            [self AutoCompleteResult:json];
            break;
        default:
            break;
    }

}

- (void)TextQueryResult:(NSDictionary *)json
{
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

- (void)AutoCompleteResult:(NSDictionary *)json
{
    NSString *result = [json objectForKey:@"status"];
    if ([result isEqualToString:@"OVER_QUERY_LIMIT"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"QUERY OVER GOOGLE API LIMIT" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    if (![result isEqualToString:@"OK"]) {
        return;
    }
    NSArray *resultArray = [json objectForKey:@"predictions"];
    
    NSMutableArray *arrayData = [[NSMutableArray alloc] init];
    for (NSDictionary *json in resultArray) {
        NSString *placeDes = [json objectForKey:@"description"];
        [arrayData addObject:placeDes];
    }

    [self.delegate upDateWithArray:arrayData GPlaceApi:self];
}

+(Location *)parseLocation:(NSDictionary *)json
{
    Location * location = [[Location alloc] init];
    location.location = [json objectForKey:@"name"];
    location.photo = [json objectForKey:@"icon"];
    location.formatted_address = [json objectForKey:@"formatted_address"];
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

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"google api, connection:didFailWithError:%@", error);
}

- (void)disconnect
{
    [queryConnect cancel];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"google api, didReceiveResponse");

    responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"google api, didReceiveData");

    [responseData appendData:data];
}



@end




//
