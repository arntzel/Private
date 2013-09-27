//
//  ProposeStart.h
//  Calvin
//
//  Created by xiangfang on 13-9-23.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventTimeVote.h"

@interface ProposeStart : NSObject

@property int id;

@property(strong) NSDate * start;

@property(strong) NSString * start_type;

//EventTimeVote list
@property(strong) NSArray * votes;


-(NSDictionary*) convent2Dic;

+(ProposeStart *) parse:(NSDictionary *) json;


@end
