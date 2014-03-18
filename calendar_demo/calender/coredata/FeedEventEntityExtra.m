

#import "FeedEventEntityExtra.h"
#import "ProposeStartEntityExtra.h"
#import "CoreDataModel.h"
#import "Utils.h"
#import "UserEntityExtra.h"
#import "UserModel.h"

#import "CreatorEntityExtra.h"
#import "LocationEntityExtra.h"
#import "EventAttendeeEntityExtra.h"
#import "ProposeStartEntityExtra.h"
#import "EventTimeVoteEntity.h"

@implementation FeedEventEntity (FeedEventEntityExtra)


-(NSDate*) getLocalStart
{
    return self.start;
}



-(BOOL) isBirthdayEvent
{
    int eventType = [self.eventType intValue];
    return eventType == 4;
}

-(BOOL) isCalvinEvent
{
    int eventType = [self.eventType intValue];
    return eventType == 0;
}

-(BOOL) isHistory
{
    if(self.max_proposed_end_time == nil) {
        return NO;
    }
    
    NSDate * current = [NSDate date];
    //current = [Utils convertGMTDate:current andTimezone:[NSTimeZone systemTimeZone]];
    return [current compare:self.max_proposed_end_time] > 0;
}


-(BOOL) isMyCreate
{
    User * me = [[UserModel getInstance] getLoginUser];
    return  me.id = [self.creator.id intValue];
}

-(void) convertFromEvent:(Event*) event
{
    self.id = @(event.id);
    
    self.archived =  @(event.archived);
    self.confirmed =  @(event.confirmed);
    
    if(event.confirmed ==  YES) {
        
        BOOL accepted = NO;
        User * me = [[UserModel getInstance] getLoginUser];
        
        ProposeStart * finalTime = [event getFinalEventTime];
        
        for(ProposeStart * ps in event.propose_starts) {
            if([finalTime isEqual:ps]) {
                for (EventTimeVote * vote in ps.votes) {
                    if([me.email caseInsensitiveCompare:vote.email] == NSOrderedSame && vote.status == 1) {
                        accepted = YES;
                        break;
                    }
                }
            }
            
            ps.finalized = 1;
        }
        
        
        if(accepted) {
            self.vote = @(0);
        } else {
            self.vote = @(1);
        }
    }
    
    NSDate * maxStartTime = nil;
    NSDate * endTime = nil;
    for(ProposeStart * ps in event.propose_starts) {
        
        endTime = [ps getEndTime];
        if(maxStartTime == nil || [endTime compare:maxStartTime] > 0)
        {
            maxStartTime = endTime;
        }
    }
    self.max_proposed_end_time = maxStartTime;
    
    
    self.created_on = event.created_on;
    self.title = event.title;
    self.descript = event.description;

    self.duration = event.duration;
    self.duration_days = @(event.duration_days);
    self.duration_hours = @(event.duration_hours);
    self.duration_minutes = @(event.duration_minutes);

    if(event.eventType!=0) {
        self.confirmed = @(YES);
    }
    
    self.eventType = @(event.eventType);
    self.is_all_day = @(event.is_all_day);

    self.start = event.start;
    self.end = [event getEndTime];
    self.start_type = event.start_type;
    self.thumbnail_url = event.thumbnail_url;
    self.timezone = event.timezone;
    //self.userstatus = event.userstatus;
    self.locationName = event.location.location;


    self.creatorID = @(event.creator.id);
    self.creatoremail = event.creator.email;
    
    
    self.ext_event_id = event.ext_event_id;
    self.hasModified = @(event.hasModified);
    self.last_modified = event.last_modified;
    self.modified_num = event.modified_num;
    
    int attendee_num = event.attendees.count;
    self.attendee_num = @(attendee_num);
    
    
    if(self.creator == nil) {
        
        self.creator = [[CoreDataModel getInstance] createEntity:@"CreatorEntity"];
    
        User * creator = event.creator;
        self.creator.id = @(creator.id);
        self.creator.email = creator.email;
        self.creator.first_name = creator.first_name;
        self.creator.last_name = creator.last_name;
        self.creator.avatar_url = creator.avatar_url;
    }
    

    if(event.location != nil) {
        if(self.location == nil) {
            self.location = [[CoreDataModel getInstance] createEntity:@"LocationEntity"];
        }
        
        self.location.lat = @(event.location.lat);
        self.location.lng = @(event.location.lng);
        self.locationName = event.location.location;
    } else {
        self.location = nil;
    }
    
    
    [self removeAllAttendee];
    for(EventAttendee * evtAtd in event.attendees)
    {
        EventAttendeeEntity * atd = [EventAttendeeEntity createEventAttendeeEntityByEventAttendee:evtAtd];
        [self addAttendeesObject:atd];
    }
    
//    if(self.propose_starts != nil) {
//        NSArray * array = [self.propose_starts allObjects];
//        
//        for(int i=0;i<array.count;i++) {
//            ProposeStartEntity * ps = [array objectAtIndex:i];
//            [self removePropose_startsObject:ps];
//        }
//    }
    
    [self removePropose_starts:self.propose_starts];
    
    NSArray * propose_starts = event.propose_starts;
    if(propose_starts != nil) {
        for(ProposeStart * ps in propose_starts) {
            ProposeStartEntity * psEntity = [[CoreDataModel getInstance] createEntity:@"ProposeStartEntity"];
            [psEntity convertFromProposeStart:ps];
            [self addPropose_startsObject:psEntity];
        }
    }
    
    
    [self resetVote];
}

-(void) convertFromCalendarEvent:(Event*) event
{
    
    self.id = [NSNumber numberWithInt:event.id];
    
    self.archived =  [NSNumber numberWithBool:event.archived];
    self.confirmed =  [NSNumber numberWithBool:event.confirmed];
    self.created_on = event.created_on;
    self.title = event.title;
    self.descript = event.description;
    
    self.duration = event.duration;
    self.duration_days = [NSNumber numberWithInt:event.duration_days];
    self.duration_hours = [NSNumber numberWithInt:event.duration_hours];
    self.duration_minutes = [NSNumber numberWithInt:event.duration_minutes];
    
    self.eventType = @(event.eventType);
    self.is_all_day =  [NSNumber numberWithBool:event.is_all_day];
    
    self.start = event.start;
    self.end = [event getEndTime];
    self.start_type = event.start_type;
    self.thumbnail_url = event.thumbnail_url;
    self.timezone = event.timezone;
    //self.userstatus = event.userstatus;
    self.locationName = event.location.location;
    
    CreatorEntity * creator = [[CoreDataModel getInstance] createEntity:@"CreatorEntity"];
    creator.id = @(event.creator.id);
    creator.email = event.creator.email;
    
    self.creator = creator;
    
    self.creatorID = [NSNumber numberWithInt:event.creator.id];
    self.creatoremail = event.creator.email;
    
 
    [self removeAllAttendee];
    
    for(EventAttendee * atd in event.attendees) {
        EventAttendeeEntity * entity = [EventAttendeeEntity createEventAttendeeEntityByEventAttendee:atd];
        [self addAttendeesObject:entity];
    }
    self.ext_event_id = event.ext_event_id;
    self.hasModified = @(event.hasModified);
    self.hasDeleted = @(event.hasDeleted);
    self.last_modified = event.last_modified;
    
    self.vote = @(0);
    self.attendee_num = @(1);
    //NSAssert([self.hasModified boolValue]==NO, @"I have modified...");
     
}


-(void) parserFromJsonData:(NSDictionary *) json
{
    
    self.id = [json objectForKey:@"id"];
    
    self.allow_attendee_invite   = [json objectForKey:@"allow_attendee_invite"];
    self.allow_new_dt            = [json objectForKey:@"allow_new_dt"];
    self.allow_new_location      = [json objectForKey:@"allow_new_location"];
    self.archived                = [json objectForKey:@"archived"];
    self.is_all_day              = [json objectForKey:@"is_all_day"];
    self.confirmed               = [json objectForKey:@"confirmed"];
    
    self.created_on              = [Utils parseNSDate:[json objectForKey:@"created_on"]];
    self.last_modified           = [Utils parseNSDate:[json objectForKey:@"last_modified"]];
    self.max_proposed_end_time   = [Utils parseNSDate:[json objectForKey:@"max_proposed_end_time"]];
    
    self.creator   = [CreatorEntity createCreatorEntity:[json objectForKey:@"creator"]];
    self.location  = [LocationEntity createLocationEntity:[json objectForKey:@"location"]];
    if(self.location) {
        self.locationName = self.location.location;
    }
    
    
    self.descript = [Utils chekcNullClass:[json objectForKey:@"description"]];
    
    
    self.duration = [json objectForKey:@"duration"];
    
    id obj = [json objectForKey:@"duration_days"];
    if(![obj isKindOfClass:[NSNull class]]) {
        self.duration_days = obj;
    }
    
    obj = [json objectForKey:@"duration_hours"];
    obj = [Utils chekcNullClass:obj];
    self.duration_hours = obj;
    
    
    obj = [json objectForKey:@"duration_minutes"];
    obj = [Utils chekcNullClass:obj];
    self.duration_minutes = obj;
    
    self.start_type = [json objectForKey:@"start_type"];
    
    NSDate * startDate = [Utils parseNSDate:[json objectForKey:@"start"]];
    self.start = startDate;
    
    
    if(self.start != nil) {
        int mins = self.duration_minutes.intValue + self.duration_hours.intValue*60 + self.duration_days.intValue*60*24;
        int durationSeconds =  mins*60;
        self.end = [self.start dateByAddingTimeInterval:durationSeconds];
    } else {
        self.end = nil;
    }
    
    
    self.thumbnail_url = [Utils chekcNullClass:[json objectForKey:@"thumbnail_url"]];
    
    self.title = [json objectForKey:@"title"];
    self.timezone = [json objectForKey:@"timezone"];
    
    self.all_responded         = [json objectForKey:@"all_responded"];
    self.allow_attendee_invite = [json objectForKey:@"allow_attendee_invite"];
    self.allow_new_dt          = [json objectForKey:@"allow_new_dt"];
    self.allow_new_location    = [json objectForKey:@"allow_new_location"];
    
    self.eventType = [json objectForKey:@"event_type"];
    
    self.modified_num = [NSString stringWithFormat:@"%@", [json objectForKey:@"modified_num"]];
    self.ext_event_id = [NSString stringWithFormat:@"%@", [json objectForKey:@"ext_event_id"]];
    
    
    [self removeAllAttendee];
    
    NSArray * attendees = [Utils chekcNullClass:[json objectForKey:@"attendees"]];
    if(attendees != nil) {
        for(NSDictionary * atendee in attendees) {
            EventAttendeeEntity * atd = [EventAttendeeEntity createEventAttendeeEntity:atendee];
            [self addAttendeesObject:atd];
        }
    }
    
    self.attendee_num = @(self.attendees.count);
    
   
    
//    if(self.propose_starts != nil) {
//        NSArray * array = [self.propose_starts allObjects];
//        
//        for(int i=0;i<array.count;i++) {
//            ProposeStartEntity * ps = [array objectAtIndex:i];
//            [self removePropose_startsObject:ps];
//        }
//    }
    
    [self removePropose_starts:self.propose_starts];
    
    NSArray * propose_starts = [Utils chekcNullClass:[json objectForKey:@"propose_starts"]];
    if(propose_starts != nil) {
        for(NSDictionary * psJson in propose_starts) {
            ProposeStartEntity * ps = [ProposeStartEntity createEntity:psJson];
            [self addPropose_startsObject:ps];
        }
    }
    
    [self resetVote];
}

-(void) removeAllAttendee
{
    if(self.attendees != nil) {
        NSArray * array = [self.attendees allObjects];
        
        for(int i=0;i<array.count;i++) {
            EventAttendeeEntity * atd = [array objectAtIndex:i];
            [[CoreDataModel getInstance] deleteEntity:atd];
            
            [self removeAttendeesObject:atd];
        }
    }
    
    [self removeAttendees:self.attendees];
}

-(void) resetVote
{
    if( [self.eventType intValue] !=0 ) {
        self.vote = @(0); //非CalvinEvent , 都投票
        return;
    }
    
    User * me = [[UserModel getInstance] getLoginUser];
    
    if([self.creator.email isEqualToString:me.email]) {
        
        self.vote = @(0); //创建者都是投票的
        
    } else {
        
        ProposeStartEntity * finalizeTime = nil;
        for(ProposeStartEntity * psEntity in self.propose_starts) {
            if([psEntity.finalized boolValue]) {
                finalizeTime = psEntity;
                break;
            }
        }
        
        self.vote = @(1); //表示未投票
        
        if(finalizeTime != nil) {
            for(EventTimeVoteEntity * voteEntity in finalizeTime.votes) {
                if([me.email isEqualToString:voteEntity.email]) {
                    
                    if([voteEntity.status intValue] == 1) {
                        self.vote = @(0); //已投票
                    }
                    break;
                }
            }
        }
    }
}
@end



