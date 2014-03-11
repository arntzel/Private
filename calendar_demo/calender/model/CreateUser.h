

#import <Foundation/Foundation.h>

@interface CreateUser : NSObject

@property(strong) NSString * username;

@property(strong) NSString * email;

@property(strong) NSString * password;

@property(strong) NSString * avatar_url;

@property(strong) NSString * first_name;

@property(strong) NSString * last_name;

@property(strong) NSString * zip_code;


-(NSDictionary*)convent2Dic;

@end
