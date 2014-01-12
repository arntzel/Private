//
//  EventTimeVoteEntityExtra.h
//  Calvin
//
//  Created by fangxiang on 14-1-12.
//  Copyright (c) 2014年 Pencil Me, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventTimeVoteEntity.h"
#import "EventTimeVote.h"

@interface EventTimeVoteEntity (EventTimeVoteEntityExtra)


-(void) convert2Entity:(EventTimeVote *) vote;


@end
