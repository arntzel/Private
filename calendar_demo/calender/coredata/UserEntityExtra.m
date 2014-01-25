

#import "UserEntityExtra.h"
#import "CoreDataModel.h"

@implementation UserEntity (UserEntityExtra)

-(NSString *) getReadableUsername
{
    if(self.contact.first_name.length > 0 || self.contact.last_name.length >0) {
        if (self.contact.first_name.length <= 0) {
            return self.contact.last_name;
        }
        if (self.contact.last_name.length <= 0) {
            return self.contact.first_name;
        }
        return [NSString stringWithFormat:@"%@ %@", self.contact.first_name, self.contact.last_name];
    } else {
        return self.contact.email;
    }
}


-(void) convertFromUser:(EventAttendee*) atd
{
    Contact * user = atd.contact;
    
    self.id   = [NSNumber numberWithInt:user.id];
    self.is_owner      = [NSNumber numberWithBool:atd.is_owner];
    self.status        = [NSNumber numberWithInt:atd.status];
    
    
    ContactEntity * contact;
    
    if(user.phone == nil) {
        contact = [[CoreDataModel getInstance] getContactEntityWithEmail:user.email];
    } else {
        contact = [[CoreDataModel getInstance] getContactEntityWith:user.phone AndEmail:user.email];
    }
    
    if(contact == nil) {
        contact = [[CoreDataModel getInstance] createEntity:@"ContactEntity"];
        contact.id            = [NSNumber numberWithInt:user.id];
        contact.avatar_url    = user.avatar_url;
        contact.email         = user.email;
        contact.first_name    = user.first_name;
        contact.last_name     = user.last_name;
        
        LOG_D(@"Create user entity: id=%d, email=%@", user.id, user.email);
    }
    
    self.contact = contact;
}

@end
