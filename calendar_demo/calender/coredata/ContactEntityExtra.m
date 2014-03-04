
#import "ContactEntityExtra.h"
#import "pinyin.h"

@implementation ContactEntity (ContactEntityExtra)




-(NSString *) getReadableUsername
{
//    if(self.first_name.length > 0 || self.last_name.length >0) {
//        return [NSString stringWithFormat:@"%@ %@", self.first_name, self.last_name];
//    } else {
//        return self.email;
//    }
    
    if( self.fullname != nil) {
        return self.fullname;
    } else if(self.email != nil) {
        return self.email;
    } else if(self.phone != nil) {
        return self.phone;
    } else {
        return @"Unknown contact";
    }
}


-(void) convertContact:(Contact *) user
{
    self.id            = [NSNumber numberWithInt:user.id];

    self.avatar_url    = user.avatar_url;
    self.email         = user.email;
    self.first_name    = user.first_name;
    self.last_name     = user.last_name;
    self.phone         = user.phone;
    self.calvinuser    = [NSNumber numberWithBool:user.calvinUser];
    self.fullname      = user.fullname;
    //self.lastest_timestamp = @(0);
}

-(Contact *) getContact
{

    Contact * contact = [[Contact alloc] init];

    contact.id           = [self.id intValue];
    contact.avatar_url   = self.avatar_url;
    contact.email        = self.email;
    contact.first_name   = self.first_name;
    contact.last_name    = self.last_name;
    contact.phone        = self.phone;
    contact.calvinUser   = [self.calvinuser boolValue];
    contact.fullname     = self.fullname;
    return contact;
}

+ (NSString *)getSectionName:(NSString *)text
{
    if (text == nil || text.length == 0) {
        return @"#";
    }
    NSString *sectionName;
    char firstLetter = pinyinFirstLetter([text characterAtIndex:0]);
    
    if ((firstLetter >='a' && firstLetter <= 'z') || (firstLetter >= 'A' && firstLetter <= 'Z')){
        sectionName = [[NSString stringWithFormat:@"%c", firstLetter] uppercaseString];
    }else{
        sectionName = [@"#" uppercaseString];
    }
    
    return sectionName;
}

+ (NSArray *)resortListByName:(NSArray *)contacts
{
    LOG_METHOD;
    NSMutableDictionary *allDict = [NSMutableDictionary dictionary];
    
    for (int i = 0; i < 26; i++){
        [allDict setObject:[NSMutableArray array] forKey:[NSString stringWithFormat:@"%c",'A'+i]];
    }
    [allDict setObject:[NSMutableArray array] forKey:@"#"];
    
    for (int i = 0; i < contacts.count; i++) {
        ContactEntity *contact = [contacts objectAtIndex:i];
        
        LOG_D(@"\n\nfirst name:%@  last name:%@",contact.first_name, contact.last_name);
        LOG_D(@"email:%@",contact.email);
        LOG_D(@"Phoe:%@",contact.phone);
        
        NSString *fullName = [contact getReadableUsername];
        LOG_D(@"fulll name: %@",fullName);
        NSString *sectionName = [self getSectionName:fullName];
        [[allDict objectForKey:sectionName] addObject:contact];
    }
    
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < 26; i++){
        [array addObjectsFromArray:[allDict objectForKey:[NSString stringWithFormat:@"%c",'A'+i]]];
    }
    [array addObjectsFromArray:[allDict objectForKey:@"#"]];
    
    return array;
}

@end
