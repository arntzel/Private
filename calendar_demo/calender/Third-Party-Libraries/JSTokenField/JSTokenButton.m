
#import "JSTokenButton.h"
#import "JSTokenField.h"
#import <QuartzCore/QuartzCore.h>

@implementation JSTokenButton

@synthesize toggled = _toggled;
@synthesize normalBg = _normalBg;
@synthesize highlightedBg = _highlightedBg;
@synthesize representedObject = _representedObject;
@synthesize parentField = _parentField;


+ (JSTokenButton *)tokenWithString:(NSString *)string representedObject:(id)obj isValid:(BOOL)valid
{
	JSTokenButton *button = (JSTokenButton *)[self buttonWithType:UIButtonTypeCustom];
	//[button setNormalBg:[[UIImage imageNamed:@"tokenNormal.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:14]];
    //[button setHighlightedBg:[[UIImage imageNamed:@"tokenHighlighted.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:14]];
	
    [button setAdjustsImageWhenHighlighted:NO];
	[button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [[button titleLabel] setFont:[UIFont fontWithName:@"Helvetica Neue" size:13]];
	[[button titleLabel] setLineBreakMode:NSLineBreakByTruncatingTail];
	//[button setTitleEdgeInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
	
	[button setTitle:string forState:UIControlStateNormal];
    button.valid = valid;
    button.layer.cornerRadius = 2;
    button.layer.masksToBounds = YES;
    
	[button sizeToFit];
	CGRect frame = [button frame];
	frame.size.width += 4;
	frame.size.height = 18;
    
	[button setFrame:frame];
	
	[button setToggled:NO];
	
	[button setRepresentedObject:obj];
	
	return button;
}

+ (JSTokenButton *)tokenWithString:(NSString *)string representedObject:(id)obj
{
    return [self tokenWithString:string representedObject:obj isValid:YES];
}

- (void)setToggled:(BOOL)toggled
{
	_toggled = toggled;
	
	if (_toggled)
	{
		//[self setBackgroundImage:self.highlightedBg forState:UIControlStateNormal];
        self.backgroundColor = [UIColor colorWithRed:45/255.0f green:172/255.0f blue:149/255.0f alpha:1.0f];
		[self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	}
	else
	{
		//[self setBackgroundImage:self.normalBg forState:UIControlStateNormal];
        self.backgroundColor = [UIColor clearColor];
		[self setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
	}

    if(!self.valid) {
        [self setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
}

- (void)dealloc
{
	self.representedObject = nil;
	self.highlightedBg = nil;
	self.normalBg = nil;
    [super dealloc];
}

- (BOOL)becomeFirstResponder {
    BOOL superReturn = [super becomeFirstResponder];
    if (superReturn) {
        self.toggled = YES;
    }
    return superReturn;
}

- (BOOL)resignFirstResponder {
    BOOL superReturn = [super resignFirstResponder];
    if (superReturn) {
        self.toggled = NO;
    }
    return superReturn;
}

#pragma mark - UIKeyInput
- (void)deleteBackward {
    id <JSTokenFieldDelegate> delegate = _parentField.delegate;
    if ([delegate respondsToSelector:@selector(tokenField:shouldRemoveToken:representedObject:)]) {
        NSString *name = [self titleForState:UIControlStateNormal];
        BOOL shouldRemove = [delegate tokenField:_parentField shouldRemoveToken:name representedObject:self.representedObject];
        if (!shouldRemove) {
            return;
        }
    }
    [_parentField removeTokenForString:[self titleForState:UIControlStateNormal]];
}

- (BOOL)hasText {
    return NO;
}
- (void)insertText:(NSString *)text {
    return;
}


- (BOOL)canBecomeFirstResponder {
    return YES;
}

@end
