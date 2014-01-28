//
//  ContactViewCell.m
//  Calvin
//
//  Created by fangxiang on 14-1-18.
//  Copyright (c) 2014年 Pencil Me, Inc. All rights reserved.
//

#import "ContactViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>
#import "pinyin.h"

//@implementation AddEventInvitePeople
//
//
//-(NSComparisonResult)comparePerson:(AddEventInvitePeople *)people{
//    NSComparisonResult result = [[self.user getReadableUsername] compare:[people.user getReadableUsername]];
//    return result;
//}
//
//+ (NSArray *)resortListByName:(NSArray *)contacts
//{
//    NSArray *sortedArray = [contacts sortedArrayUsingSelector:@selector(comparePerson:)];
//    return sortedArray;
//}

/*
 + (NSString *)getSectionName:(NSString *)text
 {
 if (text == nil || text.length == 0) {
 return @"#";
 }
 NSString *sectionName;
 char firstLetter = pinyinFirstLetter([text characterAtIndex:0]);
 
 if ((firstLetter >='a' && firstLetter <= 'z') || (firstLetter >= 'A' && firstLetter <= 'Z')){
 sectionName = [[NSString stringWithFormat:@"%c", firstLetter] uppercaseString];
 }else{
 sectionName = [@"#" uppercaseString];
 }
 
 return sectionName;
 }
 
 + (NSArray *)resortListByName:(NSArray *)contacts
 {
 LOG_METHOD;
 NSMutableDictionary *allDict = [NSMutableDictionary dictionary];
 
 for (int i = 0; i < 26; i++){
 [allDict setObject:[NSMutableArray array] forKey:[NSString stringWithFormat:@"%c",'A'+i]];
 }
 [allDict setObject:[NSMutableArray array] forKey:@"#"];
 
 for (int i = 0; i < contacts.count; i++) {
 AddEventInvitePeople *people = [contacts objectAtIndex:i];
 NSString *fullName = [people.user getReadableUsername];
 NSString *sectionName = [self getSectionName:fullName];
 [[allDict objectForKey:sectionName] addObject:people];
 }
 
 NSMutableArray *array = [NSMutableArray array];
 for (int i = 0; i < 26; i++){
 [array addObjectsFromArray:[allDict objectForKey:[NSString stringWithFormat:@"%c",'A'+i]]];
 }
 [array addObjectsFromArray:[allDict objectForKey:@"#"]];
 
 return array;
 }
 
 */

//@end


@implementation ContactViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib
{
    self.peopleHeader.layer.cornerRadius = self.peopleHeader.frame.size.width/2;
    self.peopleHeader.layer.masksToBounds = YES;
}

- (void) refreshView: (Contact*) iuser
{
    self.peopleHeader.hidden = NO;
    CGRect frame = self.peopleName.frame;
    frame.origin.x = self.peopleHeader.frame.origin.x + self.peopleHeader.frame.size.width + 10;
    self.peopleName.frame = frame;
    
    frame = self.peopleEmail.frame;
    frame.origin.x = self.peopleHeader.frame.origin.x + self.peopleHeader.frame.size.width + 10;
    self.peopleEmail.frame = frame;
    
    
//    [self setSelectionStyle:UITableViewCellSelectionStyleDefault];
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 48)];
//    self.selectedBackgroundView = view;
//    [view setBackgroundColor:[UIColor clearColor]];
    
    Contact * user = iuser;
    
    NSString *fullName = [user getReadableUsername];
    self.peopleName.text = fullName;
    
    if(user.email == nil) {
        self.peopleEmail.hidden = YES;
    } else {
        self.peopleEmail.hidden = NO;
        self.peopleEmail.text = user.email;
    }
    
    NSString * headerUrl = user.avatar_url;
    
    if(!user.calvinUser) {
        
        //CGRect frame = self.peopleName.frame;
        //frame.origin.x = self.peopleHeader.frame.origin.x;
        //self.peopleName.frame = frame;
        //self.peopleHeader.hidden = YES;
        
    } else {
        //CGRect frame = self.peopleName.frame;
        //frame.origin.x = 49;
        //self.peopleName.frame = frame;
        //self.peopleHeader.hidden = NO;
        //if(headerUrl == nil) {
        //    self.peopleHeader.image = [UIImage imageNamed:@"header.png"];
        //} else {
        //    [self.peopleHeader setImageWithURL:[NSURL URLWithString:headerUrl]
        //                      placeholderImage:[UIImage imageNamed:@"header.png"]];
        //}
    }
    
    if(headerUrl == nil) {
        self.peopleHeader.image = [UIImage imageNamed:@"header.png"];
    } else {
        [self.peopleHeader setImageWithURL:[NSURL URLWithString:headerUrl]
                          placeholderImage:[UIImage imageNamed:@"header.png"]];
    }
}

- (void) refreshView: (NSString *) name andEmal:(NSString *)  email
{
    self.peopleHeader.hidden = YES;
    
    self.peopleName.text = name;
    self.peopleEmail.text = email;
    
    CGRect frame = self.peopleName.frame;
    frame.origin.x = self.peopleHeader.frame.origin.x;
    self.peopleName.frame = frame;
    
    frame = self.peopleEmail.frame;
    frame.origin.x = self.peopleHeader.frame.origin.x;
    self.peopleEmail.frame = frame;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:NO];
}

- (void)setHeaderImageUrl:(NSString *)url
{
    [self.peopleHeader setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"header.png"]];
}

@end