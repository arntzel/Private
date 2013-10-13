

#import <Foundation/Foundation.h>
#import "Event.h"


@protocol EventModelDelegate <NSObject>

-(void) onEventModelChanged:(BOOL) isSynchronizingData;

@end


////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface EventModel : NSObject


-(void) addDelegate:(id<EventModelDelegate>) delegate;

-(void) removeDelegate:(id<EventModelDelegate>) delegate;


-(BOOL) isSynchronizeData;

-(void) setSynchronizeData:(BOOL) loading;


-(void) synchronizedFromServer;

-(void) checkContactUpdate;

@end
