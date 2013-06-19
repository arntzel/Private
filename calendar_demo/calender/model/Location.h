

#import <Foundation/Foundation.h>

@interface Location : NSObject

@property int id;
@property(strong) NSString * location;
@property(strong) NSString * photo;

/*
 Parse Location object from json data.
 */
+(Location *) parseLocation:(NSDictionary *) json;

@end
