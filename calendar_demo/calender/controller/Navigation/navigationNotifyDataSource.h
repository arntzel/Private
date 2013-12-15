
#import <Foundation/Foundation.h>

@interface navigationNotifyDataSource : NSObject

- (NSString *)iconImageAtIndex:(NSInteger)index;
- (NSString *)titleAtIndex:(NSInteger)index;

- (NSInteger )numberOfObjects;

- (NSInteger )heightForCellAtIndex:(NSInteger)index;

- (NSMutableArray *)boldFontRange;
@end
