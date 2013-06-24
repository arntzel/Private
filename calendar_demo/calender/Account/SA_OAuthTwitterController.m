//
//  SA_OAuthTwitterController.m
//
//  Created by Ben Gottlieb on 24 July 2009.
//  Copyright 2009 Stand Alone, Inc.
//
//  Some code and concepts taken from examples provided by 
//  Matt Gemmell, Chris Kimpton, and Isaiah Carew
//  See ReadMe for further attributions, copyrights and license info.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "SA_OAuthTwitterEngine.h"

#import "SA_OAuthTwitterController.h"
#import "MGTwitterEngineDelegate.h"

// Constants
static NSString* const kGGTwitterLoadingBackgroundImage = @"twitter_load.png";

@interface SA_OAuthTwitterController ()
{
    UINavigationBar *navbar;
}
@property (nonatomic, readonly) UIToolbar *pinCopyPromptBar;
@property (nonatomic, readwrite) UIInterfaceOrientation orientation;
@property (nonatomic, assign) BOOL AuthResult;


- (id) initWithEngine: (SA_OAuthTwitterEngine *) engine andOrientation:(UIInterfaceOrientation)theOrientation;
//- (void) performInjection;
- (NSString *) locateAuthPinInWebView: (UIWebView *) webView;

- (void) showPinCopyPrompt;
- (void) gotPin: (NSString *) pin;
@end


@interface DummyClassForProvidingSetDataDetectorTypesMethod
- (void) setDataDetectorTypes: (int) types;
- (void) setDetectsPhoneNumbers: (BOOL) detects;
@end

@interface NSString (TwitterOAuth)
- (BOOL) oauthtwitter_isNumeric;
@end

@implementation NSString (TwitterOAuth)
- (BOOL) oauthtwitter_isNumeric {
	const char				*raw = (const char *) [self UTF8String];
	
	for (int i = 0; i < strlen(raw); i++) {
		if (raw[i] < '0' || raw[i] > '9') return NO;
	}
	return YES;
}
@end


@implementation SA_OAuthTwitterController
@synthesize engine = _engine, delegate = _delegate, orientation = _orientation;
@synthesize indicator;


- (void) dealloc {
    if(self.AuthResult)
        if ([_delegate respondsToSelector: @selector(OAuthTwitterController:authenticatedWithUsername:)])
            [_delegate OAuthTwitterController: self authenticatedWithUsername: _engine.username];
    
    
	[[NSNotificationCenter defaultCenter] removeObserver: self];
	_webView.delegate = nil;
	[_webView loadRequest: [NSURLRequest requestWithURL: [NSURL URLWithString: @""]]];
	[_webView release];
	
	self.view = nil;
	self.engine = nil;
    [navbar release];
    [indicator release];
	[super dealloc];
}

+ (SA_OAuthTwitterController *) controllerToEnterCredentialsWithTwitterEngine: (SA_OAuthTwitterEngine *) engine delegate: (id <SA_OAuthTwitterControllerDelegate>) delegate forOrientation: (UIInterfaceOrientation)theOrientation {

//	if (![self credentialEntryRequiredWithTwitterEngine: engine]) return nil;			//not needed
	
	SA_OAuthTwitterController					*controller = [[[SA_OAuthTwitterController alloc] initWithEngine: engine andOrientation: theOrientation] autorelease];
	
	controller.delegate = delegate;
	return controller;
}

+ (SA_OAuthTwitterController *) controllerToEnterCredentialsWithDelegate: (id <SA_OAuthTwitterControllerDelegate>) delegate {
    SA_OAuthTwitterEngine *engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate: nil];

	return [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine: engine delegate: delegate forOrientation: UIInterfaceOrientationPortrait];
}


+ (BOOL) credentialEntryRequiredWithTwitterEngine: (SA_OAuthTwitterEngine *) engine {
	return ![engine isAuthorized];
}

- (id) initWithEngine: (SA_OAuthTwitterEngine *) engine andOrientation:(UIInterfaceOrientation)theOrientation {
    
	if ((self = [super init])) {
        self.engine = engine;
        self.engine.saveDelegate = self;
        self.AuthResult = NO;
		self.orientation = theOrientation;
		_firstLoad = YES;
        
		[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(pasteboardChanged:) name: UIPasteboardChangedNotification object: nil];
	}
	return self;
}

//=============================================================================================================================
#pragma mark Actions
- (void) denied {
	if ([_delegate respondsToSelector: @selector(OAuthTwitterControllerFailed:)])
        [_delegate OAuthTwitterControllerFailed: self];
//	[self performSelector: @selector(dismissModalViewControllerAnimated:) withObject: (id) kCFBooleanTrue afterDelay: 1.0];
    [self cancelView];
}

- (void) gotPin: (NSString *) pin {

	[indicator startAnimating];
	_engine.pin = pin;
	[_engine requestAccessToken];
}

- (void) storeTwitterSuccess;
{
	[indicator stopAnimating];
    self.AuthResult = YES;

    [self performSelectorOnMainThread:@selector(cancelView) withObject:self waitUntilDone:NO];
}

- (void) storeTwitterFailed
{
	[indicator startAnimating];
	if ([_delegate respondsToSelector: @selector(OAuthTwitterControllerFailed:)])
        [_delegate OAuthTwitterControllerFailed: self];
    
    [self performSelectorOnMainThread:@selector(cancelView) withObject:self waitUntilDone:NO];
}

- (void) cancel: (id) sender {

	if ([_delegate respondsToSelector: @selector(OAuthTwitterControllerCanceled:)])
        [_delegate OAuthTwitterControllerCanceled: self];
//	[self performSelector: @selector(dismissModalViewControllerAnimated:) withObject: (id) kCFBooleanTrue afterDelay: 0.0];
    [self cancelView];
}

//=============================================================================================================================
#pragma mark View Controller Stuff
- (void) loadView {
	[super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    int height = [[UIScreen mainScreen] bounds].size.height;
    self.view = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];

    
    
    
    
    
    
    
    navbar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    
    UIBarButtonItem * leftBarButtonItem = [[UIBarButtonItem alloc]
                                            initWithTitle: @"Cancel"
                                            style: UIBarButtonItemStyleDone
                                            target: self
                                            action: @selector(cancel:)];
    
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:nil];
    [navigationItem setTitle:@"Twitter"];
    
    [navbar pushNavigationItem:navigationItem animated:NO];
    [navigationItem release];
    [navigationItem setLeftBarButtonItem:leftBarButtonItem];
    [leftBarButtonItem release];
    
    [self.view addSubview:navbar];
    
    _webView = [[UIWebView alloc] initWithFrame: CGRectMake(0, navbar.frame.size.height, 320, height - navbar.frame.size.height)];
    _webView.delegate = self;
    _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    if ([_webView respondsToSelector: @selector(setDetectsPhoneNumbers:)])
        [(id) _webView setDetectsPhoneNumbers: NO];
    if ([_webView respondsToSelector: @selector(setDataDetectorTypes:)])
        [(id) _webView setDataDetectorTypes: 0];
	[self.view addSubview: _webView];
    
    self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [indicator setCenter:CGPointMake(CGRectGetMidX(_webView.bounds), CGRectGetMidY(_webView.bounds))];
    [_webView addSubview:indicator];
    
    [indicator startAnimating];
    
    [self performSelector:@selector(beginLoadData) withObject:self afterDelay:0];
}

- (void)beginLoadData
{
    if (!self.engine.OAuthSetup)
        [self.engine requestRequestToken];
    
    NSURLRequest *request = self.engine.authorizeURLRequest;
    [_webView loadRequest: request];
    
	[self locateAuthPinInWebView: nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate
{
    return NO;
}
//=============================================================================================================================
#pragma mark Notifications
- (void) pasteboardChanged: (NSNotification *) note {
	UIPasteboard					*pb = [UIPasteboard generalPasteboard];
	
	if ([note.userInfo objectForKey: UIPasteboardChangedTypesAddedKey] == nil) return;		//no meaningful change
	
	NSString *copied = pb.string;
	
	if (copied.length != 7 || !copied.oauthtwitter_isNumeric) return;
	
	[self gotPin: copied];
}

//=============================================================================================================================
#pragma mark Webview Delegate stuff
- (void) webViewDidFinishLoad: (UIWebView *) webView {
    [indicator stopAnimating];
	_loading = NO;
	//[self performInjection];
	if (_firstLoad) {
		[_webView performSelector: @selector(stringByEvaluatingJavaScriptFromString:) withObject: @"window.scrollBy(0,200)" afterDelay: 0];
		_firstLoad = NO;
	} else {
		NSString					*authPin = [self locateAuthPinInWebView: webView];

		if (authPin.length) {
			[self gotPin: authPin];
			return;
		}
		
		NSString *formCount = [webView stringByEvaluatingJavaScriptFromString: @"document.forms.length"];
		
		if ([formCount isEqualToString: @"0"]) {
//			[self showPinCopyPrompt];
		}
	}
}

- (void) showPinCopyPrompt {

	if (self.pinCopyPromptBar.superview) return;		//already shown
	self.pinCopyPromptBar.center = CGPointMake(self.pinCopyPromptBar.bounds.size.width / 2, self.pinCopyPromptBar.bounds.size.height / 2);
	[self.view insertSubview: self.pinCopyPromptBar belowSubview: self.navigationBar];
	
	[UIView beginAnimations: nil context: nil];
	self.pinCopyPromptBar.center = CGPointMake(self.pinCopyPromptBar.bounds.size.width / 2, self.navigationBar.bounds.size.height + self.pinCopyPromptBar.bounds.size.height / 2);
	[UIView commitAnimations];
}

/*********************************************************************************************************
 I am fully aware that this code is chock full 'o flunk. That said:
 
 - first we check, using standard DOM-diving, for the pin, looking at both the old and new tags for it.
 - if not found, we try a regex for it. This did not work for me (though it did work in test web pages).
 - if STILL not found, we iterate the entire HTML and look for an all-numeric 'word', 7 characters in length

Ugly. I apologize for its inelegance. Bleah.

*********************************************************************************************************/

- (NSString *) locateAuthPinInWebView: (UIWebView *) webView {
	// Look for either 'oauth-pin' or 'oauth_pin' in the raw HTML
	NSString			*js = @"var d = document.getElementById('oauth-pin'); if (d == null) d = document.getElementById('oauth_pin'); if (d) d = d.innerHTML; d;";
	NSString			*pin = [[webView stringByEvaluatingJavaScriptFromString: js] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
	if (pin.length == 7) {
		return pin;
	} else {
		// New version of Twitter PIN page
		js = @"var d = document.getElementById('oauth-pin'); if (d == null) d = document.getElementById('oauth_pin'); " \
		"if (d) { var d2 = d.getElementsByTagName('code'); if (d2.length > 0) d2[0].innerHTML; }";
		pin = [[webView stringByEvaluatingJavaScriptFromString: js] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
		
		if (pin.length == 7) {
			return pin;
		}
	}
	
	return nil;
}

- (UIToolbar *) pinCopyPromptBar {
	if (_pinCopyPromptBar == nil){
		CGRect					bounds = self.view.bounds;
		
		_pinCopyPromptBar = [[[UIToolbar alloc] initWithFrame:CGRectMake(0, 44, bounds.size.width, 44)] autorelease];
		_pinCopyPromptBar.barStyle = UIBarStyleBlackTranslucent;
		_pinCopyPromptBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;

		_pinCopyPromptBar.items = [NSArray arrayWithObjects: 
							  [[[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target: nil action: nil] autorelease],
							  [[[UIBarButtonItem alloc] initWithTitle: NSLocalizedString(@"Select and Copy the PIN", @"Select and Copy the PIN") style: UIBarButtonItemStylePlain target: nil action: nil] autorelease], 
							  [[[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target: nil action: nil] autorelease], 
							nil];
	}
	
	return _pinCopyPromptBar;
}

- (void) webViewDidStartLoad: (UIWebView *) webView {
	[indicator startAnimating];
	//[_activityIndicator startAnimating];
	_loading = YES;
//	[UIView beginAnimations: nil context: nil];
//	_blockerView.alpha = 1.0;
//	[UIView commitAnimations];
}


- (BOOL) webView: (UIWebView *) webView shouldStartLoadWithRequest: (NSURLRequest *) request navigationType: (UIWebViewNavigationType) navigationType {

	[indicator startAnimating];
    
	NSData				*data = [request HTTPBody];
	char				*raw = data ? (char *) [data bytes] : "";
	
	if (raw && (strstr(raw, "cancel=") || strstr(raw, "deny="))) {
		[self denied];
		return NO;
	}
//	if (navigationType != UIWebViewNavigationTypeOther) _webView.alpha = 0.1;
	return YES;
}

- (void)webView:(UIWebView *)aWebView didFailLoadWithError:(NSError *)error
{
    [indicator stopAnimating];
    
    if([error.domain isEqualToString:@"NSURLErrorDomain"] && error.code == NSURLErrorCancelled)
        return;
    
    if([error.domain isEqualToString:@"NSURLErrorDomain"] && error.code == -1009)
    {
        [indicator stopAnimating];
        if ([_delegate respondsToSelector: @selector(OAuthTwitterControllerNetNotWork:)])
            [_delegate OAuthTwitterControllerNetNotWork: self];

        [self cancelView];
	}
    else if([error.domain isEqualToString:@"NSURLErrorDomain"] && error.code == -1001)
    {//超时
        [self WebViewNetCanntReach];
	}
    else if([error.domain isEqualToString:@"NSURLErrorDomain"] && error.code == -1003)
    {//找不到服务器
        [self WebViewNetCanntReach];
	}
}

- (void)cancelView
{
//    MRNavigationAnimation * animation = [MRNavigationAnimation animationWithNavigation:[[MRRootScrollViewController defaultMRRootScrollView] navigationController]];
//    animation.type = MRNavAnimationType_Reveal;
//    animation.direction = MRNavAnimation_FromTop;
//    [animation popViewController:nil];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)WebViewNetCanntReach
{
    [indicator stopAnimating];
    if ([_delegate respondsToSelector: @selector(OAuthTwitterControllerNetCanntReach:)])
        [_delegate OAuthTwitterControllerNetCanntReach: self];
    [self cancelView];
}
@end
