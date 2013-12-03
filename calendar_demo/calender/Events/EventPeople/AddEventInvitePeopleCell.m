

#import "AddEventInvitePeopleCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>
#import "pinyin.h"

@implementation AddEventInvitePeople
- (void)dealloc
{
    self.user = nil;
    [super dealloc];
}

-(NSComparisonResult)comparePerson:(AddEventInvitePeople *)people{
    NSComparisonResult result = [[self.user getReadableUsername] compare:[people.user getReadableUsername]];
    return result;
}

+ (NSArray *)resortListByName:(NSArray *)contacts
{
    NSArray *sortedArray = [contacts sortedArrayUsingSelector:@selector(comparePerson:)];
    return sortedArray;
}

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

@end


@implementation AddEventInvitePeopleCell

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

- (void) refreshView: (AddEventInvitePeople*) iuser
{
    if(iuser == nil) {
        self.labNoData.hidden = NO;
        return;
    } else {
        self.labNoData.hidden = YES;
    }
    
    [self setSelectionStyle:UITableViewCellSelectionStyleDefault];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 48)];
    self.selectedBackgroundView = view;
    [view setBackgroundColor:[UIColor clearColor]];
    
    Contact * user = iuser.user;
    
    NSString *fullName = [user getReadableUsername];
    self.peopleName.text = fullName;
    
    NSString * headerUrl = user.avatar_url;

    if(!user.calvinUser) {
        
        CGRect frame = self.peopleName.frame;
        frame.origin.x = self.peopleHeader.frame.origin.x;
        self.peopleName.frame = frame;
        self.peopleHeader.hidden = YES;

    } else {
        CGRect frame = self.peopleName.frame;
        frame.origin.x = 49;
        self.peopleName.frame = frame;
        self.peopleHeader.hidden = NO;
        if(headerUrl == nil) {
            self.peopleHeader.image = [UIImage imageNamed:@"header.png"];
        } else {
            [self.peopleHeader setImageWithURL:[NSURL URLWithString:headerUrl]
                              placeholderImage:[UIImage imageNamed:@"header.png"]];
        }
    }


    //self.btnSelect.selected = iuser.selected;
    
    if(iuser.selected) {
        self.btnSelect.image = [UIImage imageNamed:@"list_check_mark"];
    } else {
        self.btnSelect.image = [UIImage imageNamed:@"btn_ok"];
    }


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
