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
- (void)updateUserEmail:(NSString *)email andCallback:(void (^)(NSInteger error))callback
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
            callback(ERROCODE_OK);
        }
        else
        {
            NSLog(@"change email error :%@",error);
            callback(-1);
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
            NSLog(@"change pwd error :%@",error);
            callback(-1);
        }
    }];
    
}

- (void)updateConnect:(ConnectType )connectType tokenVale:(NSString *)token IsConnectOrNot:(BOOL)isConnect andCallback:(void (^)(NSInteger error))callback
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
            callback(ERROCODE_OK);
        }
        else
        {
            
            callback(-1);
        }
        NSLog(@"url:%@ \nconnectType:%d token:%@ IsConnectOrNot:%d",url,connectType,token,isConnect);
        NSLog(@"connect data :%@",[[NSString alloc] initWithData:data encoding:4]);
    }];
    
}

- (void) updateUserProfile:(User *)user andCallback:(void (^)(NSInteger error))callback
{
    NSString * url = [NSString stringWithFormat:@"%s/api/v1/userprofile/%d", HOST,user.id];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"PUT"];
    [self setAuthHeader:request];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
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
- (void) setAuthHeader:(NSMutableURLRequest *) request
{
    NSString * authHeader = [NSString stringWithFormat:@"ApiKey %@:%@", [[UserModel getInstance] getLoginUser].username, [[UserModel getInstance] getLoginUser].apikey];
    LOG_D(@"authHeader:%@", authHeader);
    [request addValue:authHeader forHTTPHeaderField:@"AUTHORIZATION"];
}
@end
