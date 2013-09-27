//
//  Contact.h
//  Calvin
//
//  Created by xiangfang on 13-9-23.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Contact : NSObject


@property int id;


@property(strong) NSString * email;

@property(strong) NSString * avatar_url;

@property(strong) NSString * phone;

@property(strong) NSString * first_name;

@property(strong) NSString * last_name;

@property BOOL calvinUser;




-(NSString *) getReadableUsername;

-(NSDictionary*)convent2Dic;

/*
 Parse User object from json data.
 */
+(Contact *) parseContact:(NSDictionary *) jsonData;

+(NSDictionary*)convent2Dic:(Contact*) user;


@end
