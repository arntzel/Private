#import "SharePhotoFacebook.h"
#import <UIKit/UIKit.h>


@implementation SharePhotoFacebook
@synthesize connect;


- (NSString *)socialType
{
    return @"CalvinFacebook";
}

- (void) performPublishAction:(void (^)(void)) action {
    // we defer request for permission to post to the moment of post, then we check for the permission
    if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
        // if we don't already have the permission, then we request it now
        [FBSession.activeSession requestNewPublishPermissions:@[@"publish_actions"]
                                              defaultAudience:FBSessionDefaultAudienceFriends
                                            completionHandler:^(FBSession *session, NSError *error) {
                                                if (!error) {
                                                    action();
                                                } else if (error.fberrorCategory != FBErrorCategoryUserCancelled){
                                                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Permission denied"
                                                                                                        message:@"Unable to get permission to post"
                                                                                                       delegate:nil
                                                                                              cancelButtonTitle:@"OK"
                                                                                              otherButtonTitles:nil];
                                                    [alertView show];
                                                }
                                            }];
    } else {
        action();
    }
    
}


//- (void) performPublishAction:(void (^)(void)) action {    
//    LOG_METHOD;
//    if([FBSession.activeSession isOpen])
//    {
//        action();
//    }
//    else
//    {
//        [FBSession.activeSession openWithCompletionHandler:^(FBSession *session,
//                                                             FBSessionState status,
//                                                             NSError *error) {
//            action();
//        }];
//    }
//}

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
    /*
    NSURL *urlToShare = [NSURL URLWithString:@"http://developers.facebook.com/ios"];
   FBAppCall *appCall = [FBDialogs presentShareDialogWithLink:urlToShare
                                                         name:@"Hello Facebook"
                                                      caption:nil
                                                  description:@"The 'Hello Facebook' sample application showcases simple Facebook integration."
                                                      picture:nil
                                                  clientState:nil
                                                      handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                                          if (error) {
                                                              NSLog(@"Error: %@", error.description);
                                                          } else {
                                                              NSLog(@"Success!");
                                                          }
                                                      }];
   
   if (!appCall) {
     
       // Next try to post using Facebook's iOS6 integration
       BOOL displayedNativeDialog = [FBDialogs presentOSIntegratedShareDialogModallyFrom:self
                                                                             initialText:nil
                                                                                   image:nil
                                                                                     url:urlToShare
                                                                                 handler:nil];
       
       if (!displayedNativeDialog) {
           // Lastly, fall back on a request for permissions and a direct post using the Graph API
     
     */
    
    
           [self performPublishAction:^{
               NSString *message = [statuses objectForKey:@"text"];
               
               FBRequestConnection *connection = [[FBRequestConnection alloc] init];
               
               connection.errorBehavior = FBRequestConnectionErrorBehaviorReconnectSession
               | FBRequestConnectionErrorBehaviorAlertUser
               | FBRequestConnectionErrorBehaviorRetry;
               
               [connection addRequest:[FBRequest requestForPostStatusUpdate:message]
                    completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                        if(error.code != 0)
                        {
                            [self performSelectorOnMainThread:@selector(sendfaildWithErrorNo:) withObject:error waitUntilDone:NO];
                        }
                        else
                        {
                            [self performSelectorOnMainThread:@selector(sendSuccess) withObject:self waitUntilDone:NO];
                        }
                    }];
               [connection start];
           }];
//       }
//   }
}

/*
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
 */

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
