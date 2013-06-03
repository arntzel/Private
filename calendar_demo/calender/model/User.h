
#import <Foundation/Foundation.h>

@interface User : NSObject


@property int id;

@property NSString * username;

@property NSString * email;

@property NSString * avatar_url;

@property NSString * apikey;


/*
 Parse User object from json data.
 */
+(User *) parseUser:(NSDictionary *) jsonData;


@end
