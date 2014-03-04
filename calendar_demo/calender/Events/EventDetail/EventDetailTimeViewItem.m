//
//  EventDetailTimeView.m
//  Calvin
//
//  Created by fangxiang on 14-3-2.
//  Copyright (c) 2014年 Pencil Me, Inc. All rights reserved.
//

#import "EventDetailTimeViewItem.h"
#import "UIColor+Hex.h"

#import "UserModel.h"

#import "Utils.h"
#import "OHASBasicHTMLParser.h"
#import "UIView+FrameResize.h"

static CGFloat const getstureDistance = 160;

@implementation EventDetailTimeViewItem
{
    Event * eventInfo;
    ProposeStart * propseStart;
    
    CGFloat dragStart;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(void) awakeFromNib
{
    CALayer *bottomBorder = [CALayer layer];
    float height=self.frame.size.height-1.0f;
    float width=self.frame.size.width;
    bottomBorder.frame = CGRectMake(0.0f, height, width, 1.0f);
    bottomBorder.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.1f].CGColor;
    //UIColor *color = [UIColor generateUIColorByHexString:@"#a2a5a3"];
    //self.finalizedLabel.textColor = color;
    [self.layer addSublayer:bottomBorder];

    //[self setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.2]];
    
    self.buttonConform.hidden = YES;
    
    self.clipsToBounds = YES;
}

- (void)gestureHappened:(UIPanGestureRecognizer *)sender
{
	CGPoint translatedPoint = [sender translationInView:self];
	switch (sender.state)
	{
		case UIGestureRecognizerStatePossible:
			
			break;
		case UIGestureRecognizerStateBegan:
			dragStart = sender.view.center.x;
			break;
		case UIGestureRecognizerStateChanged:
            if (translatedPoint.x >= 0) {
                self.center = CGPointMake(dragStart, self.center.y);
                break;
            }
            else
            {
                self.center = CGPointMake(dragStart + translatedPoint.x, self.center.y);
				if (-translatedPoint.x <= getstureDistance)
				{
                    //[self setToFinalizeViewMode];
				}
				else
				{
                    //[self setToRemoveViewMode];
				}
			}
			break;
		case UIGestureRecognizerStateEnded:
		case UIGestureRecognizerStateCancelled:
			if (translatedPoint.x < 0) {
                if (translatedPoint.x >= 0) {
                    self.center = CGPointMake(dragStart, self.center.y);
                }
                else
                {
                    if (-translatedPoint.x <= getstureDistance)
                    {
                        [self doResetPostionAnimation];
                    }
                    else
                    {
                        [self doDismissAnimation];
                    }
                }
            }
			break;
		case UIGestureRecognizerStateFailed:
			
			break;
	}
}




- (void)doResetPostionAnimation
{
    CGPoint resetCenterPoint = CGPointMake(dragStart, self.center.y);
    [self animationToCenterPoint:resetCenterPoint];
}

- (void)doDismissAnimation
{
    CGPoint dismissCenterPoint = CGPointMake(dragStart - 320, self.center.y);
    [self animationToCenterPoint:dismissCenterPoint];
    [self.delegate onRemovePropseStart:propseStart];
}

- (void)animationToCenterPoint:(CGPoint)centerPoint
{
    //[self setUserInteractionEnabled:NO];
	[UIView animateWithDuration:0.25 delay:0
						options:UIViewAnimationOptionCurveLinear
					 animations:^{
                         self.center = centerPoint;
					 } completion:^(BOOL finished) {
                         //[self setUserInteractionEnabled:YES];
					 }];
}


-(IBAction) buttonVoteClicked:(id)sender
{
    LOG_D(@"buttonVoteClicked");
    
    if(self.delegate) {
        [self.delegate onVoteBtnClicked:propseStart];
    }
}

-(IBAction) buttonConformClicked:(id)sender
{
    LOG_D(@"buttonConformClicked");
    
    if(self.delegate) {
        [self.delegate onConformBtnClicked:propseStart];
    }
}

-(IBAction) timeLabelClicked:(id)sender
{
    LOG_D(@"timeLabelClicked");
    
    if(self.delegate) {
        [self.delegate onTimeLabelClicked:propseStart];
    }
}

-(IBAction) attendeeLabelClicked:(id)sender
{
    LOG_D(@"attendeeLabelClicked");
    
    if(self.delegate) {
        [self.delegate onAttendeeLabelClicked:propseStart];
    }
}



-(void) refreshView:(Event *) event andTime:(ProposeStart *) time
{
    eventInfo = event;
    propseStart = time;
    
    User * me = [[UserModel getInstance] getLoginUser];
    
    if(!event.confirmed && (event.creator.id == me.id)) {
        
        UIPanGestureRecognizer * panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gestureHappened:)];
        panGesture.delegate = self;
        [self addGestureRecognizer:panGesture];
    }
    
    
    if(time.is_all_day) {
        self.labelTime.text = @"All Day";
    } else {
        NSString * label = [Utils getProposeStatLabel2:propseStart];
        self.labelTime.text = label;
        self.labelTime.attributedText = [OHASBasicHTMLParser attributedStringByProcessingMarkupInAttributedString:self.labelTime.attributedText];
    }
    
    [self.labelTime sizeToFit];
    
    int x = [self.labelTime getMaxX] + 5;
    
    LOG_D(@"arrowTime:x=%x", x);
    
    CGRect frame = self.arrowTime.frame;
    frame.origin.x = x;
    self.arrowTime.frame = frame;
    
    self.labelDate.text = [Utils formateDay2:propseStart.start];
    [self.labelDate sizeToFit];
    
    
    int count = 0;
    for(EventTimeVote * vote in time.votes)
    {
        if(vote.status == 1) {
            count++;
        }
    }
    
    self.labelAtdCount.text = [NSString stringWithFormat:@"%d", count];
    
    
    if(eventInfo.creator.id != me.id) {
        
        CGRect frame = self.attentCountView.frame;
        frame.origin.x = self.buttonVote.frame.origin.x - frame.size.width - 5;
        self.attentCountView.frame = frame;
        
        self.buttonConform.hidden = YES;
        self.buttonVote.hidden = NO;
        
        
        int myVoteStatus = 0;
        for(EventTimeVote * vote in propseStart.votes)
        {
            if([vote.email isEqualToString:me.email]) {
                myVoteStatus = vote.status;
                break;
            }
        }
        
        if(myVoteStatus == 1) {
            [self.buttonVote setImage:[UIImage imageNamed:@"icon_vote_yes"] forState:UIControlStateNormal];
        } else {
            [self.buttonVote setImage:[UIImage imageNamed:@"icon_vote_no"] forState:UIControlStateNormal];
        }
        
        NSDate * now = [NSDate date];
        if( [now compare:propseStart.start] > 0) {
            self.buttonVote.enabled = NO;
        } else {
            self.buttonVote.enabled = YES;
        }
        
    } else {
        
        CGRect frame = self.attentCountView.frame;
        frame.origin.x = self.buttonConform.frame.origin.x - frame.size.width - 5;
        self.attentCountView.frame = frame;
        
        self.buttonConform.hidden = NO;
        self.buttonVote.hidden = YES;
        
        if(event.confirmed) {
            
            [self.buttonConform setTitle:@"Confirmed" forState:UIControlStateNormal];
            
            //ProposeStart * proposeTime = [event getFinalEventTime];
            
            
            if(time.finalized) {
                
                self.buttonConform.enabled = YES;
                [self.buttonConform setBackgroundImage:[UIImage imageNamed:@"icon_confirmed_button"] forState:UIControlStateNormal];
                [self.buttonConform setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
            } else {
                
                self.buttonConform.enabled = NO;
                [self.buttonConform setBackgroundImage:[UIImage imageNamed:@"icon_conformbtn_disable"] forState:UIControlStateNormal];
                [self.buttonConform setTitleColor:[UIColor colorWithRed:159/255.0f green:159/255.0f blue:159/255.0f alpha:1] forState:UIControlStateNormal];
            }
            
        } else {
            [self.buttonConform setTitle:@"Confirm" forState:UIControlStateNormal];
        }
    }
}
@end



