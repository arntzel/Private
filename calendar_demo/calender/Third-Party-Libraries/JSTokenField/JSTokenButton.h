

#import <UIKit/UIKit.h>
@class JSTokenField;

@interface JSTokenButton : UIButton <UIKeyInput> {

	BOOL _toggled;
	
	UIImage *_normalBg;
	UIImage *_highlightedBg;
	
	id _representedObject;
	
}

@property (nonatomic, getter=isToggled) BOOL toggled;

@property (nonatomic, retain) UIImage *normalBg;
@property (nonatomic, retain) UIImage *highlightedBg;

@property (nonatomic, retain) id representedObject;

@property (nonatomic, assign) JSTokenField *parentField;

+ (JSTokenButton *)tokenWithString:(NSString *)string representedObject:(id)obj;

@end
