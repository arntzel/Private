//
//  EventTimeVoteEntityExtra.m
//  Calvin
//
//  Created by fangxiang on 14-1-12.
//  Copyright (c) 2014年 Pencil Me, Inc. All rights reserved.
//

#import "EventTimeVoteEntityExtra.h"

@implementation EventTimeVoteEntity (EventTimeVoteEntityExtra)

-(void) convert2Entity:(EventTimeVote *) vote
{
    self.id = @(vote.id);
    self.status = @(vote.status);
    self.email = vote.email;
}

@end
