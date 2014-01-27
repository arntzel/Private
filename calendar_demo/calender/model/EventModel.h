

#import <Foundation/Foundation.h>
#import "Event.h"


@protocol EventModelDelegate <NSObject>

-(void) onEventModelChanged:(BOOL) isSynchronizingData;

-(void) onSynchronizeDataError:(int) errorCode;


@optional

-(void) onUserAccountChanged;

-(void) onEventFiltersChanged;

@end


////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface EventModel : NSObject


-(void) addDelegate:(id<EventModelDelegate>) delegate;

-(void) removeDelegate:(id<EventModelDelegate>) delegate;

-(void) downloadServerEvents:(int) unused onComplete:(void(^)(NSInteger success, NSInteger totalCount))completion;

-(void) updateEventsFromLocalDevice:(int) unused onComplete:(void(^)(NSInteger success, NSInteger totalCount))completion;

-(void) checkContactUpdate;
-(void) checkSettingUpdate;

- (void)updateEventsFromCalendarApp;
- (void)deleteIcalEvent;
- (void)uploadCalendarEvents;
- (void)uploadContacts;

-(void) notifyUserAccountChanged;

-(void) notifyEventFiltersChanged;

@end
