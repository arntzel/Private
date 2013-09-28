//
//  EventDetailInviteeView.m
//  detail
//
//  Created by zyax86 on 13-8-1.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import "EventDetailInviteeView.h"
#import <QuartzCore/QuartzCore.h>
#import "EventDetailHeaderListView.h"

@interface EventDetailInviteeView()
{
    EventDetailHeaderListView *headerListView;
    
    
}

+(EventDetailInviteeView *) creatView;

@end

@implementation EventDetailInviteeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)updateUI
{
    [self.contentView.layer setCornerRadius:5.0f];
    [self.contentView.layer setShadowRadius:1.0f];
    [self.contentView.layer setBorderColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.1f].CGColor];
    [self.contentView.layer setBorderWidth:1.0f];
    
    [self.bgView.layer setShadowColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.20f].CGColor];
    [self.bgView.layer setShadowOffset:CGSizeMake(0, 1.0f)];
    [self.bgView.layer setShadowRadius:1.0f];
    
    [self.layer setCornerRadius:5.0f];
    [self.layer setShadowColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.16f].CGColor];
    [self.layer setShadowRadius:3.0f];
    [self.layer setShadowOffset:CGSizeMake(0, 1.0f)];
    [self.layer setBorderColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.1f].CGColor];
    [self.layer setBorderWidth:1.0f];
}

- (void)updateInvitee:(NSArray *) users
{
    self.inviteeLabel.text = [NSString stringWithFormat:@"%d Invitees", users.count];
    self.inviteeNamesLabel.text = [self getNames:users];
    
    [self addInviteePhotos:users];
}

-(NSString *) getNames: (NSArray *) users
{
    NSMutableString * names = [[NSMutableString alloc] init];
    
    
    for(int i=0;i<users.count;i++) {
        
        EventAttendee * attendee = [users objectAtIndex:i];
        Contact * user = attendee.contact;
        
        if(i== users.count-1) {
            [names appendString:@"and "];
            [names appendString: [user getReadableUsername]];
        } else {
            [names appendString:[user getReadableUsername]];
            [names appendString:@", "];
        }
    }
    
    return [names autorelease];
}

- (void)addInviteePhotos:(NSArray *)users
{
    NSMutableArray * urls = [[NSMutableArray alloc] init];
    
    for(int i=0;i<users.count;i++) {
        
        EventAttendee * attendee = [users objectAtIndex:i];
        Contact * user = attendee.contact;

        if(user.avatar_url == nil) {
            [urls addObject:@""];
        } else {
            [urls addObject:user.avatar_url];
        }
    }

    headerListView = [[EventDetailHeaderListView alloc] initWithHeaderArray:urls andStatusArray:nil andCountLimit:3 ShowArraw:NO];
    [headerListView setCenter:CGPointMake(self.frame.size.width / 2, 38)];
    [self addSubview:headerListView];
    
    [urls release];
}

+(EventDetailInviteeView *) creatView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"EventDetailInviteeView" owner:self options:nil];
    EventDetailInviteeView * view = (EventDetailInviteeView*)[nibView objectAtIndex:0];
    [view updateUI];
    return view;
}

- (void)dealloc {
    [headerListView release];
    [_inviteeLabel release];
    [_contentView release];
    [_bgView release];
    [_inviteeNamesLabel release];
    
    [super dealloc];
}
@end
