
#import <Foundation/Foundation.h>
#import "SharePhotoMsgObject.h"
#import "LogUtil.h"

@class SharePhotoBase;
@protocol SharePhotoDelegate <NSObject>

- (void)sharePhotoSuccess:(SharePhotoBase* )sharePhotoBase;

- (void)sharePhotoNetDidNotWork:(SharePhotoBase* )sharePhotoBase;

- (void)sharePhotoFailed:(SharePhotoBase* )sharePhotoBase withErrorNo:(NSInteger) errorNO;
@end

@interface SharePhotoBase : NSObject

@property(nonatomic,assign) id<SharePhotoDelegate> delegate;

- (void)publishWeiboWithImage:(SharePhotoMsgWithImage *)msgWithImage;
- (void)stopSharePhoto;
- (void)sharePhotoWithImageUrl:(NSMutableDictionary *)msgWithImageUrl;
- (void)sharePhotoWithImageDictionary:(NSMutableDictionary *)dict;
- (void)updateStatuses:(NSMutableDictionary *)statuses;
- (NSString *)socialType;
@end
