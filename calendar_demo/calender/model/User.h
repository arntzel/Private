
#import <Foundation/Foundation.h>

@interface User : NSObject 

@property int id;

@property(strong) NSString * username;

@property(strong) NSString * email;

@property(strong) NSString * avatar_url;

@property(strong) NSString * apikey;

@property(strong) NSString * timezone;

@property(strong) NSString * first_name;

@property(strong) NSString * last_name;
@property (nonatomic, strong) NSString *profileUrl;

-(NSString *) getReadableUsername;

-(NSDictionary*)convent2Dic;

/*
 Parse User object from json data.
 */
+(User *) parseUser:(NSDictionary *) jsonData;

+(NSDictionary*)convent2Dic:(User*) user;

@end
