

#import <Foundation/Foundation.h>

@interface Buddy : NSObject

@property int id;

@property(strong) NSString * first_name;
@property(strong) NSString * last_name;
@property(strong) NSString * username;
@property(strong) NSString * email;

@property(strong) NSDate * date_joined;
@property(strong) NSDate * last_login;


/*
 Parse Buddy object from json data.
 */
+(Buddy*) parseBuddy:(NSDictionary *) json;

@end
