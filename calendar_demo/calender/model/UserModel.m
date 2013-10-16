
#import "UserModel.h"
#import "Utils.h"
#import "Model.h"
#import <AddressBook/AddressBook.h>
#import "CoreDataModel.h"
#import "UserSetting.h"
static UserModel * instance;

@implementation UserModel {
     User * mloginUser;
}


+(UserModel *) getInstance {

    if(instance == nil) {
        instance = [[UserModel alloc] init];
    }

    return instance;
}



-(void) createUser:(CreateUser *)user andCallback:(void (^)(NSInteger error, NSString * msg))callback
{
    NSString * url = [NSString stringWithFormat:@"%s/api/v1/createuser/", HOST];
    NSMutableURLRequest *request = [Utils createHttpRequest:url andMethod:@"POST"];

    
    LOG_D(@"url=%@", url);

    NSDictionary * dict = [user convent2Dic];
    NSString * postContent = [Utils dictionary2String:dict];
    
    LOG_D(@"postContent=%@", postContent);

    NSData * postData = [postContent dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:postData];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * resp, NSData * data, NSError * error) {

        NSHTTPURLResponse * httpResp = (NSHTTPURLResponse*) resp;
        int status = httpResp.statusCode;

        if(status == 201) {
            callback(ERROCODE_OK, nil);
        } else {
            
            if(data != nil) {
                NSError * err;
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
                
                LOG_D(@"error=%d, resp:%@", status, json);
                callback(-1, [json objectForKey:@"error"]);
            } else {
                callback(ERROCODE_SERVER, nil);
            }
        }
    }];
}


/**
 Login
 */
-(void) login:(NSString *) username withPassword:(NSString *) pwd andCallback: (void (^)(NSInteger error, User * user))callback
{
    NSString * url = [NSString stringWithFormat:@"%s/api/v1/user/login", HOST];
    NSMutableURLRequest *request = [Utils createHttpRequest:url andMethod:@"POST"];
    
    LOG_D(@"url=%@", url);


    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setObject:username forKey:@"username_or_email"];
    [dict setObject:pwd forKey:@"password"];
    if(self.device_token != nil) {
        [dict setObject:self.device_token forKey:@"device_token"];
    }
    
    NSString * postContent = [Utils dictionary2String:dict];
    NSData * postData = [postContent dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:postData];

    [self doLogin:request andCallback:callback];
}

-(void) signinFacebook:(NSString *) accessToken andCallback:(void (^)(NSInteger error, User * user))callback
{   
    NSString * url = [NSString stringWithFormat:@"%s/api/v1/facebook/connect/", HOST];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:30];
    
    
    LOG_D(@"url=%@", url);

    NSMutableString * postContent = [NSMutableString stringWithFormat:@"access_token=%@&", accessToken];
    if(self.device_token != nil) {
        [postContent appendString:[NSString stringWithFormat:@"device_token=%@", self.device_token]];
    }

    LOG_D(@"postContent=%@", postContent);
    NSData * postData = [postContent dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody:postData];
    
    [self doLogin:request andCallback:callback];
}

-(void) signinGooglePlus:(NSString *)accessToken andCallback:(void (^)(NSInteger, User *))callback
{
    NSString * url = [NSString stringWithFormat:@"%s/api/v1/google/connect/", HOST];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:30];
    
    LOG_D(@"url=%@", url);
    
    NSMutableString * postContent = [NSMutableString stringWithFormat:@"access_token=%@&", accessToken];
    if(self.device_token != nil) {
        [postContent appendString:[NSString stringWithFormat:@"device_token=%@", self.device_token]];
    }

    LOG_D(@"signinGooglePlus, postContent=%@", postContent);
    NSData * postData = [postContent dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody:postData];

    [self doLogin:request andCallback:callback];
}

-(void) doLogin:(NSMutableURLRequest *) request andCallback:(void (^)(NSInteger error, User * user))callback
{
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * resp, NSData * data, NSError * error) {
        
        NSHTTPURLResponse * httpResp = (NSHTTPURLResponse*) resp;
        
        int status = httpResp.statusCode;
        
        if(status == 200) {
            NSError * err;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
            LOG_D(@"Login resp:%@", json);
            User * user = [User parseUser:json];
            mloginUser = user;
            callback(0, user);
        } else {
            
            NSString* aStr = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            LOG_D(@"error=%d, resp:%@", status, aStr);
            
            //TODO:: parse error type
            //401: UNAUTHORIZED
            //Other: net work error
            callback(-1, nil);
        }
    }];
}

-(void) getUser:(int)userID andCallback: (void (^)(NSInteger error, User * user))callback
{
    NSString * url = [NSString stringWithFormat:@"%s/api/v1/user/%d", HOST, userID];
    NSMutableURLRequest *request = [Utils createHttpRequest:url andMethod:@"GET"];

    LOG_D(@"url=%@", url);

    [[UserModel getInstance] setAuthHeader:request];


    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * resp, NSData * data, NSError * error) {

        NSHTTPURLResponse * httpResp = (NSHTTPURLResponse*) resp;

        int status = httpResp.statusCode;

        if(status == 200) {
            NSError * err;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
            User * user = [User parseUser:json];
            callback(0, user);
        } else {
            //TODO:: parse error type
            //401: UNAUTHORIZED
            //Other: net work error
            callback(-1, nil);
        }
    }];
}

-(void) getUsers:(int)offset andCallback: (void (^)(NSInteger error, NSArray * users))callback
{

    NSString * url = [NSString stringWithFormat:@"%s/api/v1/user/?offset=%d&limit=100", HOST, offset];
    NSMutableURLRequest *request = [Utils createHttpRequest:url andMethod:@"GET"];

    LOG_D(@"url=%@", url);

    [[UserModel getInstance] setAuthHeader:request];


    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * resp, NSData * data, NSError * error) {

        NSHTTPURLResponse * httpResp = (NSHTTPURLResponse*) resp;

        int status = httpResp.statusCode;

        if(status == 200 && data != nil) {
            NSError * err;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
            NSArray * array = [json objectForKey:@"objects"];

            NSMutableArray * users =  [[NSMutableArray alloc] init];

            for(int i=0; i<array.count; i++) {
                NSDictionary * json = [array objectAtIndex:i];
                User * user = [User parseUser:json];
                [users addObject:user];
            }

            callback(0, users);
        } else {
            //TODO:: parse error type
            //401: UNAUTHORIZED
            //Other: net work error
            callback(-1, nil);
        }
    }];
}

-(void) getUserProfile:(int)prifleID andCallback: (void (^)(NSInteger error, UserProfile * profile))callback
{
    NSString * url = [NSString stringWithFormat:@"%s/api/v1/userprofile/%d", HOST, prifleID];
    NSMutableURLRequest *request = [Utils createHttpRequest:url andMethod:@"GET"];

    LOG_D(@"url=%@", url);

    [[UserModel getInstance] setAuthHeader:request];


    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * resp, NSData * data, NSError * error) {

        NSHTTPURLResponse * httpResp = (NSHTTPURLResponse*) resp;

        int status = httpResp.statusCode;

        if(status == 200) {
            NSError * err;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
            UserProfile * profile = [UserProfile paserUserProfile:json];
            callback(0, profile);
        } else {
            //TODO:: parse error type
            //401: UNAUTHORIZED
            //Other: net work error
            callback(-1, nil);
        }
    }];
}

-(void) updateUserProfile:(UserProfile *) profile andCallback:(void (^)(NSInteger error))callback
{
    NSString * url = [NSString stringWithFormat:@"%s/api/v1/userprofile/%d", HOST, profile.id];
    NSMutableURLRequest *request = [Utils createHttpRequest:url andMethod:@"PUT"];

    NSString * postContent = [Utils convertObj2Json:profile];
    NSData * postData = [postContent dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:postData];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * resp, NSData * data, NSError * error) {

        NSHTTPURLResponse * httpResp = (NSHTTPURLResponse*) resp;

        int status = httpResp.statusCode;

        if(status == 200) {
            callback(ERROCODE_OK);
        } else {
            //TODO:: parse error type
            //401: UNAUTHORIZED
            //Other: net work error
            callback(-1);
        }
    }];

}

-(void) getMyContacts:(void (^)(NSInteger error, NSArray * contact))callback
{

    NSString * url = [NSString stringWithFormat:@"%s/api/v1/contact?offset=0&limit=10000", HOST];
    NSMutableURLRequest *request = [Utils createHttpRequest:url andMethod:@"GET"];

    LOG_D(@"getMyContacts url=%@", url);

    [[UserModel getInstance] setAuthHeader:request];


    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * resp, NSData * data, NSError * error) {

        NSHTTPURLResponse * httpResp = (NSHTTPURLResponse*) resp;

        int status = httpResp.statusCode;

        if(status == 200 && data != nil) {
            NSError * err;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
            NSArray * array = [json objectForKey:@"objects"];

            NSMutableArray * contacts =  [[NSMutableArray alloc] init];

            for(int i=0; i<array.count; i++) {
                NSDictionary * json = [array objectAtIndex:i];
                Contact * contact = [Contact parseContact:json];
                [contacts addObject:contact];
            }

            callback(0, contacts);

        } else {
            //TODO:: parse error type
            //401: UNAUTHORIZED
            //Other: net work error
            callback(-1, nil);
        }
    }];
}
- (void)requestContactsFromAddressBook:(void(^)(NSMutableArray *contactsArr))callback
{
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(nil, nil);
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error)
     {
         if (granted)
         {
             CFArrayRef cfarray = ABAddressBookCopyArrayOfAllPeople(addressBook);
             NSLog(@"granted suc,contacts:%@",(__bridge NSArray *)cfarray);
             NSArray *allPeopleArray = (__bridge NSArray *)cfarray;
             NSMutableArray *contactsArray = [NSMutableArray array];
             for (int i=0; i<[allPeopleArray count]; i++)
             {
                 ABRecordRef contactInfo = (__bridge ABRecordRef)([allPeopleArray objectAtIndex:i]);
                 NSString *firstName = (__bridge NSString *)(ABRecordCopyValue(contactInfo, kABPersonFirstNameProperty));
                 if (!firstName)
                 {
                     firstName = @"";
                 }
                 NSString *lastName = (__bridge NSString *)(ABRecordCopyValue(contactInfo, kABPersonLastNameProperty));
                 if (!lastName)
                 {
                     lastName = @"";
                 }
                 
                 ABMultiValueRef phoneNumberProperty = ABRecordCopyValue(contactInfo, kABPersonPhoneProperty);
                 NSArray* phoneNumberArray = (__bridge NSArray *)(ABMultiValueCopyArrayOfAllValues(phoneNumberProperty));
                 NSString *phoneNum = @"";
                 if ([phoneNumberArray count]>0&&[phoneNumberArray objectAtIndex:0])
                 {
                     phoneNum = [phoneNumberArray objectAtIndex:0];
                 }
                 LOG_D(@"phone:%@",phoneNum);
                 
                 ABMultiValueRef emailProperty = ABRecordCopyValue(contactInfo, kABPersonEmailProperty);
                 NSArray* emailArray = (__bridge NSArray *)(ABMultiValueCopyArrayOfAllValues(emailProperty));
                 NSString *email = @"";
                 if ([emailArray count]>0&&[emailArray objectAtIndex:0])
                 {
                     email = [emailArray objectAtIndex:0];
                 }
                 LOG_D(@"email:%@",email);
                 
                 //email and phone should not is empty at the same time.
                 if ([email isEqualToString:@""]&&[phoneNum isEqualToString:@""])
                 {
                     continue;
                 }
                 CoreDataModel * model = [CoreDataModel getInstance];
                 if ([model getContactEntityWith:phoneNum AndEmail:email])
                 {
                     continue;
                 }
                 
                 Contact *info = [[Contact alloc]init];
                 info.first_name = firstName;
                 info.last_name = lastName;
                 info.phone = phoneNum;
                 info.email = email;
                 info.avatar_url = @"";
                 info.calvinUser = NO;
                 info.id = -1;
                 
                 [contactsArray addObject:info];
             }
             callback(contactsArray);
         }
         else
         {
             NSLog(@"granted failed");
             callback(nil);
         }
    });
}
- (void)uploadAddressBookContacts:(void (^)(NSInteger error, NSArray * contact))callback
{
    
    [self requestContactsFromAddressBook:^(NSMutableArray *contactsArr)
     {
         if (contactsArr == nil||[contactsArr count]==0)
         {
             callback(-1, nil);
             return ;
         }
         NSString * url = [NSString stringWithFormat:@"%s/api/v1/contact", HOST];
         NSMutableURLRequest *request = [Utils createHttpRequest:url andMethod:@"PATCH"];
         
         LOG_D(@"upload addressbook contacts url=%@", url);
         
         [[UserModel getInstance] setAuthHeader:request];
         for (int i=0; i<[contactsArr count]; i++)
         {
             Contact * info = [contactsArr objectAtIndex:i];
             NSDictionary  *dic = @{
                                    @"email":info.email,
                                    @"phone":info.phone,
                                    @"first_name":info.first_name,
                                    @"last_name":info.last_name
                                    };
             [contactsArr replaceObjectAtIndex:i withObject:dic];
         }
         LOG_D(@"%@",contactsArr);
         NSDictionary *dic = @{@"objects": contactsArr};
         NSString *jsonStr = [Utils dictionary2String:dic];
         NSMutableData *postData = [NSMutableData dataWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]];
         
         [request setHTTPBody:postData];
         [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * resp, NSData * data, NSError * error) {
             
             NSHTTPURLResponse * httpResp = (NSHTTPURLResponse*) resp;
             
             int status = httpResp.statusCode;
             
             if(status == 202 && data != nil) {
                 NSError * err;
                 NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
                 LOG_D(@"upload addressbook contacts return data :%@",json);
                 NSArray * array = [json objectForKey:@"objects"];
                 
                 NSMutableArray * contacts =  [[NSMutableArray alloc] init];
                 
                 for(int i=0; i<array.count; i++) {
                     NSDictionary * json = [array objectAtIndex:i];
                     Contact * contact = [Contact parseContact:json];
                     [contacts addObject:contact];
                 }
                 
                 callback(0, contacts);
                 
             } else {
                 //TODO:: parse error type
                 //401: UNAUTHORIZED
                 //Other: net work error
                 NSString *errorData = [[NSString alloc] initWithData:data encoding:4];
                 NSLog(@"upload addressbook contacts error data:%@",errorData);
                 callback(-1, nil);
             }
         }];
         
    }];
}

- (void)insertAddressBookContactsToDB:(void (^)(NSInteger error, NSArray * contact))callback
{

    [self uploadAddressBookContacts:^(NSInteger error, NSArray *contacts)
    {
        if (contacts)
        {
            
            CoreDataModel * model = [CoreDataModel getInstance];
            for(Contact * contact in contacts) {
                
                ContactEntity * enity = [model getContactEntity:contact.id];
                if(enity == nil)
                {
                    enity = [model createEntity:@"ContactEntity"];
                }
                
                [enity convertContact:contact];
            }
            
            [model saveData];
            
            NSString * updateTime = [Utils formateDate:[NSDate date]];
            [model saveSetting:KEY_CONTACTUPDATETIME andValue:updateTime];
        }
        callback(0,nil);
    }];
}
/*
 Get the current login user, return nil if not login
 */
-(User *) getLoginUser
{
    return mloginUser;
}

-(void) setLoginUser:(User *) user
{
    mloginUser = user;
}

-(BOOL) isLogined
{
    return mloginUser != nil;
}

-(void) setAuthHeader:(NSMutableURLRequest *) request
{
    NSString * authHeader = [NSString stringWithFormat:@"ApiKey %@:%@", mloginUser.username, mloginUser.apikey];
    LOG_D(@"authHeader:%@", authHeader);
    [request addValue:authHeader forHTTPHeaderField:@"AUTHORIZATION"];
}



-(void) resetpassword:(NSString *) email andCallback:(void (^)(NSInteger error))callback
{

    NSString * url = [NSString stringWithFormat:@"%s/api/v1/password/reset/", HOST];
    NSMutableURLRequest *request = [Utils createHttpRequest:url andMethod:@"POST"];

    NSString * postContent = [NSString stringWithFormat:@"email=%@", email];
    NSData * postData = [postContent dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:postData];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * resp, NSData * data, NSError * error) {
        NSHTTPURLResponse * httpResp = (NSHTTPURLResponse*) resp;
        int status = httpResp.statusCode;
        if(status == 200) {
            callback(ERROCODE_OK);
        } else {
            callback(-1);
        }
    }];
}
@end
