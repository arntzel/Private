
#import <Foundation/Foundation.h>

#import "User.h"

@interface UserProfile : NSObject

@property int id;

@property(strong) NSString * gender;

@property(strong) NSString * self_description;

@property(strong) User * user;

+(UserProfile *) paserUserProfile:(NSDictionary *) json;

@end
