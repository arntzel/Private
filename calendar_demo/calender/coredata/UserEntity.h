
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FeedEventEntity;

@interface UserEntity : NSManagedObject

@property (nonatomic, retain) NSString * apikey;
@property (nonatomic, retain) NSString * avatar_url;
@property (nonatomic, retain) NSNumber * calvinUser;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * first_name;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * is_owner;
@property (nonatomic, retain) NSString * last_name;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSString * timezone;
@property (nonatomic, retain) FeedEventEntity *feedEvent;

@end
