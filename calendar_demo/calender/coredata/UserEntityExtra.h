//
//  UserEntityExtra.h
//  calender
//
//  Created by xiangfang on 13-8-4.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserEntity.h"
#import "User.h"

@interface UserEntity (UserEntityExtra)


-(void) convertFromUser:(User*) user;


@end
