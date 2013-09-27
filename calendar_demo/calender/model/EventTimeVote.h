//
//  EventTimeVote.h
//  Calvin
//
//  Created by xiangfang on 13-9-15.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

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
