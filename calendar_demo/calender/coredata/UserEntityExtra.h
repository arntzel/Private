
#import <Foundation/Foundation.h>
#import "UserEntity.h"
#import "EventAttendee.h"

@interface UserEntity (UserEntityExtra)

-(NSString *) getReadableUsername;

-(void) convertFromUser:(EventAttendee*) user;


@end
