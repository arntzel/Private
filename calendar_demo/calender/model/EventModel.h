

#import <Foundation/Foundation.h>
#import "Event.h"


@protocol EventModelDelegate <NSObject>

-(void) onEventModelChanged:(BOOL) isSynchronizingData;

-(void) onSynchronizeDataError:(int) errorCode;

-(void) onSynchronizeDataCompleted;


@optional

-(void) onUserAccountChanged;

-(void) onEventFiltersChanged;

@end


////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface EventModel : NSObject


-(void) addDelegate:(id<EventModelDelegate>) delegate;

-(void) removeDelegate:(id<EventModelDelegate>) delegate;

-(void) synchronizedFromServer;

-(void) checkContactUpdate;
-(void) checkSettingUpdate;

- (void)updateEventsFromCalendarApp;
- (void)deleteIcalEvent;
- (void)uploadCalendarEvents;
- (void)uploadContacts;

-(void) notifyUserAccountChanged;

-(void) notifyEventFiltersChanged;

@end
