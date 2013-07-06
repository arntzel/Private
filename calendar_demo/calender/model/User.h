
#import <Foundation/Foundation.h>

@interface User : NSObject


@property int id;

@property(strong) NSString * username;

@property(strong) NSString * email;

@property(strong) NSString * avatar_url;

@property(strong) NSString * apikey;

@property(strong) NSString * timezone;

/*
 Parse User object from json data.
 */
+(User *) parseUser:(NSDictionary *) jsonData;


@end
