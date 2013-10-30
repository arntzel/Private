
#import <UIKit/UIKit.h>

@class JSTokenButton;
@protocol JSTokenFieldDelegate;

extern NSString *const JSTokenFieldFrameDidChangeNotification;
extern NSString *const JSTokenFieldNewFrameKey;
extern NSString *const JSTokenFieldOldFrameKey;
extern NSString *const JSDeletedTokenKey;

@interface JSTokenField : UIView <UITextFieldDelegate> {
	
	NSMutableArray *_tokens;
	
	UITextField *_textField;
	
	id <JSTokenFieldDelegate> _delegate;
	
	JSTokenButton *_deletedToken;
	
	UILabel *_label;
}

@property (nonatomic, readonly) UITextField *textField;
@property (nonatomic, retain) UILabel *label;
@property (nonatomic, readonly, copy) NSMutableArray *tokens;
@property (nonatomic, assign) id <JSTokenFieldDelegate> delegate;

- (void)addTokenWithTitle:(NSString *)string representedObject:(id)obj isValid:(BOOL)valid;
- (void)removeTokenForString:(NSString *)string;
- (void)removeTokenWithRepresentedObject:(id)representedObject;
- (void)removeAllTokens;

@end

@protocol JSTokenFieldDelegate <NSObject>

@optional

- (void)tokenField:(JSTokenField *)tokenField didAddToken:(NSString *)title representedObject:(id)obj;
- (void)tokenField:(JSTokenField *)tokenField didRemoveToken:(NSString *)title representedObject:(id)obj;
- (BOOL)tokenField:(JSTokenField *)tokenField shouldRemoveToken:(NSString *)title representedObject:(id)obj;


- (void)tokenFieldTextDidChange:(JSTokenField *)tokenField;

- (BOOL)tokenFieldShouldReturn:(JSTokenField *)tokenField;
- (void)tokenFieldDidEndEditing:(JSTokenField *)tokenField;

@end
