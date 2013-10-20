//
//  EventDetailCommentContentView.m
//  detail
//
//  Created by zyax86 on 13-8-4.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import "EventDetailCommentContentView.h"

#import "EventDetailCommentView.h"
#import "EventDetailCommentTextView.h"
#import "EventDetailCommentConformedView.h"
#import "EventDetailCommentLoadMoreView.h"

#import "Model.h"
#import "UserModel.h"
#import "Utils.h"

@interface EventDetailCommentContentView()<UITableViewDataSource,UITableViewDelegate,EventDetailCommentLoadMoreViewDelegate>
{
    EventDetailCommentTextView *commentTextView;
    EventDetailCommentLoadMoreView *loadMoreView;
    
    BOOL _declined;
    
    UITableView *tableView;
    NSInteger page;
    NSInteger pageCount;
    
    BOOL needLoadingMore;
}

@property(nonatomic,retain) NSMutableArray *commentArray;
@end

#define DETAIL_COMMENT_CELL_HEIGHT 56

@implementation EventDetailCommentContentView
@synthesize commentArray;

- (void)dealloc
{
    self.commentArray = nil;
    
    [commentTextView release];
    
    tableView.delegate = nil;
    tableView.dataSource = nil;
    [tableView release];
    
    [super dealloc];
}

- (id)init
{
    return [self initWithFrame:CGRectMake(0, 0, 320, DETAIL_COMMENT_CELL_HEIGHT * 2)];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        commentTextView = [[EventDetailCommentTextView creatView] retain];
        [self addSubview:commentTextView];
        
        tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [tableView setBackgroundColor: [UIColor clearColor]];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView setDelegate:self];
        [tableView setDataSource:self];
        [self addSubview:tableView];
        
        loadMoreView = [[EventDetailCommentLoadMoreView alloc] initWithFrame:CGRectMake(0, DETAIL_COMMENT_CELL_HEIGHT, 320, DETAIL_COMMENT_CELL_HEIGHT)];
        [self addSubview:loadMoreView];
        loadMoreView.delegate = self;
        
        page = 0;
        pageCount = 10;
        needLoadingMore = YES;
        
        self.commentArray = [NSMutableArray array];
    }
    return self;
}

-(void) setDecliend:(BOOL) declined
{
    _declined = declined;
    if(declined) {
        commentTextView.hidden = YES;
    } else {
        commentTextView.hidden = NO;
    }
    
    [self refreshViewAnimation:NO];
}

-(void) updateView:(User *) me andComments:(NSArray *) comments
{
    [self updateCommentTextView:me];
    NSMutableArray *array = [NSMutableArray array];
    [array addObjectsFromArray:comments];
    [array addObjectsFromArray:self.commentArray];
    self.commentArray = array;
    
    [self refreshViewAnimation:YES];
}

- (void)refreshViewAnimation:(BOOL)animation
{
    if (animation) {
        [UIView animateWithDuration:1.0f animations:^{
            [self refreshView];
        }];
    }
    else
    {
        [self refreshView];
    }
}

- (void)refreshView
{
    [tableView reloadData];
    [self updateFrame];
    if(self.delegate != nil) {
        [self.delegate onEventDetailCommentContentViewFrameChanged];
    }
}

-(void) updateFrame
{
    CGRect frame = self.frame;
    frame.size.width = commentTextView.frame.size.width;
    frame.size.height = 0;
    if (!commentTextView.hidden) {
        frame.size.height = commentTextView.frame.size.height;
    }
    CGFloat tableHeight = [self.commentArray count] * DETAIL_COMMENT_CELL_HEIGHT;
    [tableView setFrame:CGRectMake(0, frame.size.height, frame.size.width, tableHeight)];
    frame.size.height = tableView.frame.origin.y + tableView.frame.size.height;
    
    if (needLoadingMore) {
        [loadMoreView setHidden:NO];
        [loadMoreView setFrame:CGRectMake(0, frame.size.height, frame.size.width, DETAIL_COMMENT_CELL_HEIGHT)];
        frame.size.height += loadMoreView.frame.size.height;
    }
    else
    {
        [loadMoreView setHidden:YES];
    }
    
    self.frame = frame;
}

-(void) addComment:(Comment *) comment
{
    if(comment.commentor == nil) {
        [self addConformedView:comment];
    } else {
        [self addCommentView:comment];
    }
}

- (void)updateCommentTextView:(User *)user
{
    [commentTextView setHeaderPhotoUrl:user.avatar_url];
    [commentTextView.messageField addTarget:self action:@selector(keySend) forControlEvents:UIControlEventEditingDidEnd];
    
    if(_declined) {
        commentTextView.hidden = YES;
    } else {
        commentTextView.hidden = NO;
    }
}

- (EventDetailCommentView *)addCommentView :(Comment *) cmt
{
    EventDetailCommentView * commentView = [EventDetailCommentView creatView];
    [commentView updateView:cmt];
    
    return commentView;
}

- (EventDetailCommentConformedView *)addConformedView:(Comment *) cmt
{
    EventDetailCommentConformedView * conformedView = [EventDetailCommentConformedView creatView];
    conformedView.labMsg.text = cmt.msg;
    conformedView.labConformTime.text = [Utils getTimeText:cmt.createTime];
    
    return conformedView;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [commentTextView endEditing:YES];
}

-(void) keySend
{
    NSString * msg = [commentTextView.messageField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(msg.length > 0) {
        Comment * cmt = [[Comment alloc] init];
        cmt.commentor = [[UserModel getInstance] getLoginUser];
        cmt.createTime = [NSDate date];
        cmt.msg = msg;
        cmt.eventID = self.eventID;
        [commentTextView showSending:YES];
        
        [[Model getInstance] createComment:cmt andCallback:^(NSInteger error, Comment *comment)
        {
            [commentTextView showSending:NO];
            if(error ==0) {
                commentTextView.messageField.text = @"";
                [self.commentArray addObject:cmt];
                [cmt release];
                [self refreshViewAnimation:YES];
            } else {
                //TODO::
            }
        }];
    }    
}


- (void)loadMoreComment
{
    [self loadComments];
}

- (void)startLoadComment
{
    [loadMoreView startLoading];
    [self loadComments];
}

-(void)loadComments
{
    UIActivityIndicatorView * indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [indicatorView startAnimating];
    indicatorView.center = self.center;
    [self addSubview:indicatorView];
    [indicatorView release];

    [[Model getInstance] getEventComment:self.eventID Offset:page * pageCount Limit:pageCount andCallback:^(NSInteger error, NSArray *comments) {
        [indicatorView stopAnimating];
        if(error == 0) {
            page++;
            self.loaded = YES;
            User * me = [[UserModel getInstance] getLoginUser];
            
            if ([comments count] == pageCount) {
                needLoadingMore = YES;
            }
            else
            {
                needLoadingMore = NO;
            }
            
            [loadMoreView stopLoading];
            [self updateView:me andComments:comments];
        } else {
            //TODO::
        }
    }];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.commentArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    UITableViewCell *cell = nil;

    Comment * comment = [self.commentArray objectAtIndex:[self.commentArray count] - row - 1];
    if(comment.commentor == nil) {
        cell = [self addConformedView:comment];
    } else {
        cell = [self addCommentView:comment];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return DETAIL_COMMENT_CELL_HEIGHT;
}
@end
