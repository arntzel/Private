//
//  GPlaceApi.m
//  calender
//
//  Created by zyax86 on 13-5-28.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "GPlaceApi.h"
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

- (void)startRequestWithStringQuery:(NSString *)query
{
    [queryConnect cancel];
    
    NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/textsearch/json?query=%@&sensor=true&key=%@",query,googleAPIKey];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    queryConnect = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSError *err;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&err];
    NSString *result = [json objectForKey:@"status"];
    if (![result isEqualToString:@"OK"]) {
        return;
    }
    NSArray *resultArray = [json objectForKey:@"results"];

    [self.delegate upDateWithArray:resultArray];
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
