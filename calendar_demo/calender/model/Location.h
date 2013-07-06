

#import <Foundation/Foundation.h>

@interface Location : NSObject

@property int id;
@property(strong) NSString * location;
@property(strong) NSString * photo;

@property float lat; //维度
@property float lng; //经度


/*
 Parse Location object from json data.
 */
+(Location *) parseLocation:(NSDictionary *) json;

@end
