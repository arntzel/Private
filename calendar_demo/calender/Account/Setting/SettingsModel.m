//
//  SettingsModel.m
//  Calvin
//
//  Created by tu on 13-9-30.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "SettingsModel.h"
#import "UserModel.h"
#import "Model.h"
#import "Utils.h"


@implementation SettingsModel

- (void)updateAvatar:(UIImage *)avatar andCallback:(void (^)(NSInteger error, NSString *url))callback1
{
    NSString * url = [NSString stringWithFormat:@"%s/api/v1/avatar/upload/", HOST];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [self setAuthHeader:request];
    
    
	NSString *stringBoundary = @"0xKhTmLbOuNdArY";
    
    NSString *charset = (NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; charset=%@; boundary=%@", charset, stringBoundary];
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    NSMutableString *body = [NSMutableString string];
    NSString *startBoundary = [NSString stringWithFormat:@"--%@\r\n",stringBoundary];
    //NSString *spliteBoundary = [NSString stringWithFormat:@"\r\n--%@\r\n",stringBoundary];
    NSString *endBoundary = [NSString stringWithFormat:@"\r\n--%@--\r\n",stringBoundary];
    [body appendString:startBoundary];
    
    [body appendString:@"Content-Disposition: form-data; name=\"file\"; filename=\"123.png\"\r\n"];
    [body appendString:@"Content-Type: image/png\r\n\r\n"];
    NSMutableData *postData = [NSMutableData data];
    [postData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:UIImagePNGRepresentation(avatar)];
    [postData appendData:[endBoundary dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postData];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * resp, NSData * data, NSError * error) {
        
        NSHTTPURLResponse * httpResp = (NSHTTPURLResponse*) resp;
        
        int status = httpResp.statusCode;
        
        if(status == 200)
        {
            NSError * err;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
            NSString *urlStr = [json objectForKey:@"thumbnail_url"];
            callback1(ERROCODE_OK,urlStr);
        }
        else
        {
            LOG_D(@"change avatar error :%@",error);
            callback1(-1,nil);
        }
    }];
}
- (void)updateUserEmail:(NSString *)email andCallback:(void (^)(NSInteger error,NSString *message))callback
{
    NSString * url = [NSString stringWithFormat:@"%s/api/v1/email/change/", HOST];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [self setAuthHeader:request];
    NSString * postContent = [NSString stringWithFormat:@"email=%@",email];
    NSData * postData = [postContent dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:postData];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * resp, NSData * data, NSError * error) {
        
        NSHTTPURLResponse * httpResp = (NSHTTPURLResponse*) resp;
        
        int status = httpResp.statusCode;
        
        if(status == 200)
        {
            callback(ERROCODE_OK,[self parsedJsonMessage:data]);
            
        }
        else
        {
            LOG_D(@"change email error :%@",error);
            callback(-1,nil);
        }
    }];
    
}

- (void)updateUserPwd:(NSMutableDictionary *)dic andCallback:(void (^)(NSInteger error))callback
{
    NSString * url = [NSString stringWithFormat:@"%s/api/v1/password/change/", HOST];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [request setHTTPMethod:@"POST"];
    [self setAuthHeader:request];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    NSString * postContent = [NSString stringWithFormat:@"oldpassword=%@&password1=%@&password2=%@",[dic objectForKey:@"oldpassword"],[dic objectForKey:@"newpassword"],[dic objectForKey:@"newpassword"]];
    NSData * postData = [postContent dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:postData];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * resp, NSData * data, NSError * error) {
        
        NSHTTPURLResponse * httpResp = (NSHTTPURLResponse*) resp;
        
        int status = httpResp.statusCode;
        
        if(status == 200)
        {
            callback(ERROCODE_OK);
        }
        else
        {
            LOG_D(@"change pwd error :%@",error);
            callback(-1);
        }
        LOG_D(@"change pwd receive data:%@",[[NSString alloc] initWithData:data encoding:4]);
    }];
    
}

- (void)updateConnect:(ConnectType )connectType tokenVale:(NSString *)token IsConnectOrNot:(BOOL)isConnect andCallback:(void (^)(NSInteger error, NSString *message))callback
{
    NSString * url = @"";
    if (connectType == ConnectFacebook)
    {
        if (isConnect)
        {
            url = [NSString stringWithFormat:@"%s/api/v1/social/connect/facebook/", HOST];
        }
        else
        {
            url = [NSString stringWithFormat:@"%s/api/v1/social/disconnect/facebook/", HOST];
        }
    }
    else if (connectType == ConnectGoogle)
    {
        if (isConnect)
        {
            url = [NSString stringWithFormat:@"%s/api/v1/social/connect/google/", HOST];
        }
        else
        {
            url = [NSString stringWithFormat:@"%s/api/v1/social/disconnect/google/", HOST];
        }
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [request setHTTPMethod:@"POST"];
    [self setAuthHeader:request];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    NSString * postContent = [NSString stringWithFormat:@"access_token=%@",token];
    NSData * postData = [postContent dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:postData];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * resp, NSData * data, NSError * error) {
        
        NSHTTPURLResponse * httpResp = (NSHTTPURLResponse*) resp;
        
        int status = httpResp.statusCode;
        
        if(status == 200)
        {
            callback(ERROCODE_OK,[self parsedJsonMessage:data]);
        }
        else
        {
            
            callback(-1,nil);
        }
        LOG_D(@"url:%@ \nconnectType:%d token:%@ IsConnectOrNot:%d",url,connectType,token,isConnect);
        LOG_D(@"connect data :%@",[[NSString alloc] initWithData:data encoding:4]);
    }];
    
}

- (void) updateUserProfile:(User *)user andCallback:(void (^)(NSInteger error))callback
{
    NSString * url = [NSString stringWithFormat:@"%s%@", HOST,user.profileUrl];
    LOG_D(@"update user profile url:%@",url);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"PUT"];
    [self setAuthHeader:request];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSDictionary *dic;
    if (user.avatar_url == nil)
    {
        dic = @{@"first_name":user.first_name,@"last_name":user.last_name};
    }
    else
    {
        dic = @{@"avatar_url": user.avatar_url,@"first_name":user.first_name,@"last_name":user.last_name};
        
    }
    NSString *jsonStr = [Utils dictionary2String:dic];
    NSData * postData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:postData];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * resp, NSData * data, NSError * error) {
        
        NSHTTPURLResponse * httpResp = (NSHTTPURLResponse*) resp;
        
        int status = httpResp.statusCode;
        
        if(status == 202)
        {
            callback(ERROCODE_OK);
        }
        else
        {
            
            callback(-1);
        }
        LOG_D(@"update userprofile : %@",[[NSString alloc] initWithData:data encoding:4]);
    }];

    
}
- (void)deleteAccount:(void (^)(NSInteger error))callback
{
    NSString * url = [NSString stringWithFormat:@"%s/api/v1/account/delete/", HOST];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [request setHTTPMethod:@"DELETE"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [self setAuthHeader:request];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * resp, NSData * data, NSError * error) {
        
        NSHTTPURLResponse * httpResp = (NSHTTPURLResponse*) resp;
        
        int status = httpResp.statusCode;
        
        if(status == 200)
        {
            if (![self parsedJsonMessage:data])
            {
                callback(ERROCODE_OK);
            }
            else
            {
                callback(-1);
            }
        }
        else
        {
            
            callback(-1);
        }
        
        LOG_D(@"delete account return data:%@",[[NSString alloc] initWithData:data encoding:4]);
    }];
}
- (void) setAuthHeader:(NSMutableURLRequest *) request
{
    NSString * authHeader = [NSString stringWithFormat:@"ApiKey %@:%@", [[UserModel getInstance] getLoginUser].username, [[UserModel getInstance] getLoginUser].apikey];
    LOG_D(@"authHeader:%@", authHeader);
    [request addValue:authHeader forHTTPHeaderField:@"AUTHORIZATION"];
}

- (NSString *)parsedJsonMessage:(NSData *)respData
{
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableContainers error:nil];
    NSString  *status = [dic  objectForKey:@"status"];
    if ([status isEqualToString:@"success"])
    {
        return nil;
    }
    else
    {
        NSString *message = [dic objectForKey:@"message"];
        return message;
    }
}



@end
