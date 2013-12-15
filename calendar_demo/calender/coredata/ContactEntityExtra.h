
#import <Foundation/Foundation.h>
#import "ContactEntity.h"
#import "Contact.h"

@interface ContactEntity (ContactEntityExtra)



-(NSString *) getReadableUsername;

-(void) convertContact:(Contact *) user;

-(Contact *) getContact;

+ (NSArray *)resortListByName:(NSArray *)contacts;

@end
