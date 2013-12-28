//
//  Comment.h
//  calender
//
//  Created by fang xiang on 13-9-10.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Contact.h"

@interface Comment : NSObject

@property int id;

@property int eventID;

@property int commentType;

@property(strong) Contact * commentor;

@property(strong) NSString * msg;

@property(strong) NSDate * createTime;


- (NSComparisonResult) compare:(Comment *) cmt;


-(NSDictionary*)convent2Dic;

+(Comment *) parseComment:(NSDictionary *) json;

@end
