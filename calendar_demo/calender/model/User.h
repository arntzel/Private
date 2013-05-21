//
//  User.h
//  calender
//
//  Created by fang xiang on 13-5-4.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property int id;

@property NSString * username;

@property NSString * email;

@property NSString * avatar_url;

@property NSString * apikey;



+(User *) parseUser:(NSDictionary *) jsonData;


@end
