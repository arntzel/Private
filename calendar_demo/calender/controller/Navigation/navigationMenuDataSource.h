
#import <Foundation/Foundation.h>

@interface navigationMenuDataSource : NSObject

- (NSString *)iconImageAtIndex:(NSInteger)index;
- (NSString *)detailImageAtIndex:(NSInteger)index;
- (NSString *)titleAtIndex:(NSInteger)index;

- (NSInteger )numberOfObjects;

- (NSInteger )heightForCellAtIndex:(NSInteger)index;
@end
