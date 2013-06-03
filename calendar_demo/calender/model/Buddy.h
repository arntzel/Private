

#import <Foundation/Foundation.h>

@interface Buddy : NSObject

@property int id;

@property NSString * first_name;
@property NSString * last_name;
@property NSString * username;
@property NSString * email;

@property NSDate * date_joined;
@property NSDate * last_login;


/*
 Parse Buddy object from json data.
 */
+(Buddy*) parseBuddy:(NSDictionary *) json;

@end
