

#import "Message.h"
#import "Utils.h"

@implementation Message


+(Message *) parseMSeesage:(NSDictionary *) json
{
    Message * msg = [[Message alloc] init];

    msg.id = [[json objectForKey:@"id"] intValue];

    msg.subject = [json objectForKey:@"subject"];
    msg.email = [json objectForKey:@"email"];
    msg.body = [json objectForKey:@"body"];


    msg.moderation_date = [Utils parseNSDate:[json objectForKey:@"moderation_date"]];
    msg.moderation_reason = [json objectForKey:@"moderation_reason"];
    msg.moderation_status = [json objectForKey:@"moderation_status"];
    msg.read_at = [Utils parseNSDate:[json objectForKey:@"read_at"]];

    
    msg.recipient  = [User parseUser:[json objectForKey:@"recipient"]];
    msg.recipient_archived  = [[json objectForKey:@"recipient_archived"] boolValue];
    msg.replied_at = [Utils parseNSDate:[json objectForKey:@"replied_at"]];

    NSDictionary * jsonSender = [json objectForKey:@"sender"];
    if([Utils chekcNullClass:jsonSender])
    {
         msg.sender  = [User parseUser:jsonSender];
    }
    
    
   
    msg.sender_archived  = [[json objectForKey:@"sender_archived"] boolValue];
    msg.sender_deleted_at = [Utils parseNSDate:[json objectForKey:@"sender_deleted_at"]];
    msg.sent_at = [Utils parseNSDate:[json objectForKey:@"sent_at"]];
    
    msg.unread = (msg.read_at == nil);
    
    
    NSString * url = [json objectForKey:@"url"];
    
    if(![url isKindOfClass:[NSNull class]]) {
        NSString * prefix = @"/schedule/event/";
        NSRange range;
        range.location = [prefix length];
        range.length = [url length] -1 - range.location;
        
        NSString * strEventID = [url substringWithRange:range];
        msg.eventID = [strEventID intValue];
    }
    
    return msg;
}
@end
