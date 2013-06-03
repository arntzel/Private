

#import <Foundation/Foundation.h>

@interface Location : NSObject

@property int id;
@property NSString * location;
@property NSString * photo;

/*
 Parse Location object from json data.
 */
+(Location *) parseLocation:(NSDictionary *) json;

@end
