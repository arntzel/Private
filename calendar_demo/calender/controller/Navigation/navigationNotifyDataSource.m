

#import "navigationNotifyDataSource.h"

@interface navigationNotifyDataSource()
{
    NSArray *iconImageArray;
    NSArray *titleArray;
    
    NSString *tempString;
}
@end

@implementation navigationNotifyDataSource

- (id)init
{
    self = [super init];
    if (self) {
        iconImageArray = [NSArray arrayWithObjects:@"manuNavCal.png", @"manuNavQuestion.png", @"manuNavSetting.png", nil];
        
        tempString = @"Nick invited you to Designer News NY Meet-up";
    }
    return self;
}

- (NSString *)iconImageAtIndex:(NSInteger)index
{
    return @"manuHeadImage.jpg";
    return [iconImageArray objectAtIndex:index];
}

- (NSString *)titleAtIndex:(NSInteger)index
{
    return tempString;
    return [titleArray objectAtIndex:index];
}

- (NSInteger )heightForCellAtIndex:(NSInteger)index
{
//    CGSize theStringSize = [tempString sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(200, 500) lineBreakMode:NSLineBreakByWordWrapping];
//    
//    return theStringSize.height + 35;
    
    return 80;
}

- (NSInteger )numberOfObjects
{
    return 10;
}

- (NSMutableArray *)boldFontRange
{
    NSRange range1 = NSMakeRange(0, 5);
    NSRange range2 = NSMakeRange(10, 5);
    NSMutableArray *array = [NSMutableArray array];
    [array retain];
    [array addObject:[NSValue valueWithRange:range1]];
    [array addObject:[NSValue valueWithRange:range2]];
    return [array autorelease];
}

@end