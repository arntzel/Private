

#import <Foundation/Foundation.h>
#import "Contact.h"

@interface EventTimeVote : NSObject

@property int id;

@property (strong) NSString * email;


/*
默认值是0，表示没有做过操作
-1表示reject
1表示accept
*/
@property int status;


-(NSDictionary*) convent2Dic;

+(EventTimeVote *) parse:(NSDictionary *) json;


@end
