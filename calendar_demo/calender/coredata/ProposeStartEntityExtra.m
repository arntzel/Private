//
//  ProposeStartEntityExtra.m
//  Calvin
//
//  Created by fangxiang on 14-1-12.
//  Copyright (c) 2014年 Pencil Me, Inc. All rights reserved.
//

#import "ProposeStartEntityExtra.h"
#import "EventTimeVoteEntityExtra.h"
#import "CoreDataModel.h"

@implementation ProposeStartEntity (ProposeStartEntityExtra)


-(void) convertFromProposeStart:(ProposeStart *) ps
{
    self.id = @(ps.id);
    self.start = ps.start;
    self.start_type = ps.start_type;
    
    self.is_all_day = @(ps.is_all_day);
    self.finalized = @(ps.finalized);
    self.duration_days = @(ps.duration_days);
    self.duration_hours = @(ps.duration_hours);
    self.duration_minutes = @(ps.duration_minutes);
    
    for(EventTimeVote * vote in ps.votes) {
        
        EventTimeVoteEntity * entity = [[CoreDataModel getInstance] createEntity:@"EventTimeVoteEntity"];
        [entity convert2Entity:vote];
        [self addVotesObject:entity];
    }
    
}

@end
