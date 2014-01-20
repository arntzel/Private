

#import <Foundation/Foundation.h>

@interface Location : NSObject<NSCopying>

@property int id;
@property(strong) NSString * location;
@property(strong) NSString * photo;
@property(strong) NSString * formatted_address;

@property float lat; //维度
@property float lng; //经度

-(NSDictionary*)convent2Dic;


/*
 Parse Location object from json data.
 */
+(Location *) parseLocation:(NSDictionary *) json;

@end
