#import "SharePhotoFacebook.h"
#import <UIKit/UIKit.h>


@implementation SharePhotoFacebook
@synthesize connect;


- (NSString *)socialType
{
    return @"CalvinFacebook";
}

- (void) performPublishAction:(void (^)(void)) action {    
    LOG_METHOD;
    if([FBSession.activeSession isOpen])
    {
        action();
    }
    else
    {
        [FBSession.activeSession openWithCompletionHandler:^(FBSession *session,
                                                             FBSessionState status,
                                                             NSError *error) {
            action();
        }];
    }
}

- (void) publishWeiboWithImage:(SharePhotoMsgWithImage *)msgWithImage
{
    LOG_METHOD;        
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mycam://"]];
    
    UIImage *img = msgWithImage.image;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   img, @"picture",
                                   msgWithImage.txtContent, @"message",
                                   nil];
    
    [self performPublishAction:^{
        connect = [FBRequestConnection startWithGraphPath:@"/me/photos" parameters:params HTTPMethod:@"POST" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if(error.code != 0)
            {
                [self performSelectorOnMainThread:@selector(sendfaildWithErrorNo:) withObject:error waitUntilDone:NO];
            }
            else
            {
                [self performSelectorOnMainThread:@selector(sendSuccess) withObject:self waitUntilDone:NO];
            }
        }];
    }];

}

- (void)sharePhotoWithImageDictionary:(NSMutableDictionary *)dict
{
    LOG_METHOD;
    [self sharePhotoWithImageUrl:dict];
}

- (void)sharePhotoWithImageUrl:(NSMutableDictionary *)msgWithImageUrl
{
    LOG_METHOD;
    NSString *url = [msgWithImageUrl objectForKey:@"url"];
    NSString *text = [msgWithImageUrl objectForKey:@"text"];

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   url, @"url",
                                   text, @"message",
                                   nil];
    
    [self performPublishAction:^{
        connect = [FBRequestConnection startWithGraphPath:@"/me/photos" parameters:params HTTPMethod:@"POST" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if(error.code != 0)
            {
                [self performSelectorOnMainThread:@selector(sendfaildWithErrorNo:) withObject:error waitUntilDone:NO];
            }
            else
            {
                [self performSelectorOnMainThread:@selector(sendSuccess) withObject:self waitUntilDone:NO];
            }
        }];
    }];
}

- (void)updateStatuses:(NSMutableDictionary *)statuses
{
    NSString *text = [statuses objectForKey:@"text"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   text, @"message",
                                   nil];
    [self performPublishAction:^{
        connect = [FBRequestConnection startWithGraphPath:@"/me/feed" parameters:params HTTPMethod:@"POST" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if(error.code != 0)
            {
                [self performSelectorOnMainThread:@selector(sendfaildWithErrorNo:) withObject:error waitUntilDone:NO];
            }
            else
            {
                [self performSelectorOnMainThread:@selector(sendSuccess) withObject:self waitUntilDone:NO];
            }
        }];
    }];
}

- (void)sendfaildWithErrorNo:(NSError* )error
{
	LOG_METHOD;
    connect = nil;
    if([self.delegate respondsToSelector:@selector(sharePhotoFailed:withErrorNo:)])
        [self.delegate sharePhotoFailed:self withErrorNo:error.code];
}

- (void)sendSuccess
{
	LOG_METHOD;
    connect = nil;
    if([self.delegate respondsToSelector:@selector(sharePhotoSuccess:)])
        [self.delegate sharePhotoSuccess:self];
}

- (void)stopSharePhoto
{
	LOG_METHOD;
    [connect cancel];
    connect = nil;
}
@end
