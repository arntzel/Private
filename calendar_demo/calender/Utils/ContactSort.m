
#import "ContactSort.h"
#import "pinyin.h"
#import "Contact.h"

@implementation ContactSort


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
        Contact *contact = [contacts objectAtIndex:i];
        NSString *sectionName = [self getSectionName:[contact getReadableUsername]];
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
