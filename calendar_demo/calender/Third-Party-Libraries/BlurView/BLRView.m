//
// Copyright (c) 2013 Justin M Fischer
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of
// this software and associated documentation files (the "Software"), to deal in
// the Software without restriction, including without limitation the rights to
// use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
// the Software, and to permit persons to whom the Software is furnished to do so,
// subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
// FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
// IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
//  UBLRView.m
//  7blur
//
//  Created by JUSTIN M FISCHER on 9/02/13.
//  Copyright (c) 2013 Justin M Fischer. All rights reserved.
//

#import "BLRView.h"
#import "UIImage+REFrostedViewController.h"
#import "UIImage+ImageEffects.h"
#import "UIStopWatch.h"

static BLRView *_sharedInstance = nil;

@interface BLRView ()
{
    CGContextRef 	_captureBitmapContext;
    void 			*_capturePixelBuffer;
}

@property(nonatomic, assign) BlurType blurType;
@property(nonatomic, strong) BLRColorComponents *colorComponents;
@property(nonatomic, strong) UIImageView *backgroundImageView;
@property(nonatomic, strong) dispatch_source_t timer;

@end

@implementation BLRView

- (id)init
{
    self = [super init];
    if(self){
        self.backgroundImageView = [[UIImageView alloc] initWithFrame:self.frame];
        self.backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:self.backgroundImageView];
    }
    
    return self;
}

- (id) initWithCoder:(NSCoder *) aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.backgroundImageView = [[UIImageView alloc] initWithFrame:self.frame];
        self.backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:self.backgroundImageView];
    }
    
    return self;
}

- (void) awakeFromNib {

}

- (void) unload {
    if(self.timer != nil) {
        
        dispatch_source_cancel(self.timer);
        self.timer = nil;
    }
    
    if (_captureBitmapContext)
        CGContextRelease(_captureBitmapContext);
	_captureBitmapContext = nil;
    
    if (_capturePixelBuffer)
		free(_capturePixelBuffer);
	_capturePixelBuffer = NULL;
    
    [self removeFromSuperview];
}

#pragma capture data
- (UIImage *)screenshot4iOS7
{
    // Create a graphics context with the target size
    // On iOS 4 and later, use UIGraphicsBeginImageContextWithOptions to take the scale into consideration
    // On iOS prior to 4, fall back to use UIGraphicsBeginImageContext
    BOOL os7Later = [[UIDevice currentDevice].systemVersion floatValue] >= 7.0;
    CGSize imageSize = [[UIScreen mainScreen] bounds].size;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if( orientation == UIInterfaceOrientationPortraitUpsideDown )
    {
    }
    else if( orientation == UIInterfaceOrientationLandscapeLeft )
    {
        imageSize = CGSizeMake(imageSize.height, imageSize.width);
    }
    else if( orientation == UIInterfaceOrientationLandscapeRight )
    {
        imageSize = CGSizeMake(imageSize.height, imageSize.width);
    }
    
    if (NULL != UIGraphicsBeginImageContextWithOptions)
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    else
        UIGraphicsBeginImageContext(imageSize);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    if( orientation == UIInterfaceOrientationPortraitUpsideDown )
    {
        CGContextRotateCTM(context, M_PI);
        CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
    }
    else if( orientation == UIInterfaceOrientationLandscapeLeft )
    {
        CGContextTranslateCTM(context, imageSize.width / 2, imageSize.height / 2);
        CGContextRotateCTM(context, M_PI/2);
        CGContextTranslateCTM(context, -imageSize.height / 2, -imageSize.width / 2);
    }
    else if( orientation == UIInterfaceOrientationLandscapeRight )
    {
        CGContextTranslateCTM(context, imageSize.width / 2, imageSize.height / 2);
        CGContextRotateCTM(context, -M_PI/2);
        CGContextTranslateCTM(context, -imageSize.height / 2, -imageSize.width / 2);
    }
    
    
    // Iterate over every window from back to front
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen])
        {
            // -renderInContext: renders in the coordinate space of the layer,
            // so we must first apply the layer's geometry to the graphics context
            CGContextSaveGState(context);
            // Center the context around the window's anchor point
            CGContextTranslateCTM(context, [window center].x, [window center].y);
            // Apply the window's transform about the anchor point
            CGContextConcatCTM(context, [window transform]);
            // Offset by the portion of the bounds left of and above the anchor point
            CGContextTranslateCTM(context,
                                  -[window bounds].size.width * [[window layer] anchorPoint].x,
                                  -[window bounds].size.height * [[window layer] anchorPoint].y);
            
            // Render the layer hierarchy to the current context
            if( !os7Later )
                [[window layer] renderInContext:context];
            else
                [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:NO];
            
            // Restore the context
            CGContextRestoreGState(context);
        }
    }
    
    // Retrieve the screenshot image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

-(void)prepareCapture
{
    CGRect captureViewBounds = [[UIScreen mainScreen] bounds];
    BOOL os7Later = [[UIDevice currentDevice].systemVersion floatValue] >= 7.0;
    if( !os7Later )
        UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation ) ? (captureViewBounds.size.width -= 20) : (captureViewBounds.size.height -= 20);
    if( UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation) )
        captureViewBounds.size = CGSizeMake(captureViewBounds.size.height, captureViewBounds.size.width);
    
    float screenRetinaScale = 1.0f;//(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone?[UIScreen mainScreen].scale:1.0);
    CGSize captureBufferSize = CGSizeMake((int)(captureViewBounds.size.width*screenRetinaScale), (int)(captureViewBounds.size.height*screenRetinaScale));
	
	if (captureBufferSize.width*captureBufferSize.height<1)
	{
		return;
	}
	
    size_t dataLength =  captureBufferSize.width *  captureBufferSize.height * 4;
	_capturePixelBuffer = malloc(dataLength);
	if (_capturePixelBuffer==NULL)
	{
		return;
	}

    
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    
    // Create a CGBitmapContext to draw an image into
    size_t bytesPerPixel = 4;
    size_t bytesPerRow = bytesPerPixel * captureBufferSize.width;
    size_t bitsPerComponent = 8;
    _captureBitmapContext = CGBitmapContextCreate(_capturePixelBuffer, (int)captureBufferSize.width, (int)captureBufferSize.height,
                                                  bitsPerComponent, bytesPerRow, colorSpaceRef,
                                                  kCGImageAlphaPremultipliedLast | kCGBitmapByteOrderDefault);
    CGColorSpaceRelease(colorSpaceRef);
}

- (void)renderScreenShotInContext:(CGContextRef)context
{
    CGSize imageSize = [[UIScreen mainScreen] bounds].size;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if( orientation == UIInterfaceOrientationPortraitUpsideDown )
    {
    }
    else if( orientation == UIInterfaceOrientationLandscapeLeft )
    {
        imageSize = CGSizeMake(imageSize.height, imageSize.width);
    }
    else if( orientation == UIInterfaceOrientationLandscapeRight )
    {
        imageSize = CGSizeMake(imageSize.height, imageSize.width);
    }
    
    CGContextSaveGState(context);
    BOOL os7Later = ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0);
    if( orientation == UIInterfaceOrientationPortraitUpsideDown )
    {
        CGContextRotateCTM(context, M_PI);
        CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
        
    }
    else if( orientation == UIInterfaceOrientationLandscapeLeft )
    {
        CGContextTranslateCTM(context, imageSize.width / 2, imageSize.height / 2);
        CGContextRotateCTM(context, M_PI/2);
        CGContextTranslateCTM(context, -imageSize.height / 2, -imageSize.width / 2);
        if (!os7Later )
        {
            //skip the status bar.
            CGContextTranslateCTM(_captureBitmapContext, -20, 0);
        }
    }
    else if( orientation == UIInterfaceOrientationLandscapeRight )
    {
        CGContextTranslateCTM(context, imageSize.width / 2, imageSize.height / 2);
        CGContextRotateCTM(context, -M_PI/2);
        CGContextTranslateCTM(context, -imageSize.height / 2, -imageSize.width / 2);
        if (!os7Later )
        {
            //skip the status bar.
            CGContextTranslateCTM(_captureBitmapContext, 20, 0);
        }
    }
    else
    {
        if (!os7Later )
        {
            //skip the status bar.
            CGContextTranslateCTM(_captureBitmapContext, 0, -20);
        }
    }
    // Iterate over every window from back to front
    NSArray *windows = [[[UIApplication sharedApplication] windows] copy];
    
    for (UIWindow *window in windows)
    {
        if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen])
        {
            // -renderInContext: renders in the coordinate space of the layer,
            // so we must first apply the layer's geometry to the graphics context
            CGContextSaveGState(context);
            // Center the context around the window's anchor point
            CGContextTranslateCTM(context, [window center].x, [window center].y);
            // Apply the window's transform about the anchor point
            CGContextConcatCTM(context, [window transform]);
            // Offset by the portion of the bounds left of and above the anchor point
            CGContextTranslateCTM(context,
                                  -[window bounds].size.width * [[window layer] anchorPoint].x,
                                  -[window bounds].size.height * [[window layer] anchorPoint].y);
            
            // Render the layer hierarchy to the current context
            //if( !os7Later )
                [[window layer] renderInContext:context];
            //else
                //[window drawViewHierarchyInRect:window.bounds afterScreenUpdates:NO];
            
            // Restore the context
            CGContextRestoreGState(context);
        }
    }
    
    CGContextRestoreGState(context);
}

- (UIImage *)screenshot
{
    float screenRetinaScale = 1.0;//(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone?[UIScreen mainScreen].scale:1.0);
    [self prepareCapture];
    CGContextSaveGState(_captureBitmapContext);
    CGContextTranslateCTM(_captureBitmapContext, 0, CGBitmapContextGetHeight(_captureBitmapContext));
    CGContextScaleCTM(_captureBitmapContext, 1.0, -1.0);
    CGContextScaleCTM(_captureBitmapContext, screenRetinaScale, screenRetinaScale);
    [self renderScreenShotInContext:_captureBitmapContext];
    CGContextRestoreGState(_captureBitmapContext);
    
    CGImageRef imgRef = CGBitmapContextCreateImage(_captureBitmapContext);
    UIImage* img = [UIImage imageWithCGImage:imgRef];
    CGImageRelease(imgRef);
    
    if (_captureBitmapContext)
        CGContextRelease(_captureBitmapContext);
	_captureBitmapContext = nil;
    
    if (_capturePixelBuffer)
		free(_capturePixelBuffer);
	_capturePixelBuffer = NULL;
    
    return img;
}

- (void) blurBackground {
    
    __block UIImage *snapshot = nil;
    
    //UIStopWatch *watch = [[UIStopWatch alloc] init];

    //if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
     //   snapshot = [self screenshot4iOS7];
    //else
        snapshot = [self screenshot];
    
    //DEBUG_INFO(@"screenshot = [%.05f]", [watch getDelta]);

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
       
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            //UIStopWatch *watch1 = [[UIStopWatch alloc] init];

//            UIImage *blurShnapShotImage = [snapshot applyBlurWithCrop:CGRectMake(0.0, 0.0f, snapshot.size.width, snapshot.size.height)
//                                                               resize:snapshot.size
//                                                           blurRadius:5.0f
//                                                            tintColor:[UIColor colorWithRed:0.0/255.0 green:27.0/255.0 blue:45.0/255.0 alpha:0.5] saturationDeltaFactor:1.8
//                                                            maskImage:nil];
            
            //DEBUG_INFO(@"applyBlurWithCrop = [%.05f]", [watch1 getDelta]);
            UIImage *blurShnapShotImage = [snapshot re_applyBlurWithRadius:self.colorComponents.radius tintColor:self.colorComponents.tintColor saturationDeltaFactor:self.colorComponents.saturationDeltaFactor maskImage:self.colorComponents.maskImage];
            self.backgroundImageView.image = blurShnapShotImage;
            
        });
    });
}

- (void) blurBackgroundImage:(UIImage *) snapshot {
    
    //__block UIImage *snapshot = nil;
    
    //UIStopWatch *watch = [[UIStopWatch alloc] init];
    
    //if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
    //   snapshot = [self screenshot4iOS7];
    //else
    snapshot = [self screenshot];
    
    //DEBUG_INFO(@"screenshot = [%.05f]", [watch getDelta]);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            //UIStopWatch *watch1 = [[UIStopWatch alloc] init];
            
            //            UIImage *blurShnapShotImage = [snapshot applyBlurWithCrop:CGRectMake(0.0, 0.0f, snapshot.size.width, snapshot.size.height)
            //                                                               resize:snapshot.size
            //                                                           blurRadius:5.0f
            //                                                            tintColor:[UIColor colorWithRed:0.0/255.0 green:27.0/255.0 blue:45.0/255.0 alpha:0.5] saturationDeltaFactor:1.8
            //                                                            maskImage:nil];
            
            //DEBUG_INFO(@"applyBlurWithCrop = [%.05f]", [watch1 getDelta]);
            UIImage *blurShnapShotImage = [snapshot re_applyBlurWithRadius:self.colorComponents.radius tintColor:self.colorComponents.tintColor saturationDeltaFactor:self.colorComponents.saturationDeltaFactor maskImage:self.colorComponents.maskImage];
            self.backgroundImageView.image = blurShnapShotImage;
            
        });
    });
}

- (void) blurWithColor:(BLRColorComponents *) components {
    if(self.blurType == KBlurUndefined) {
        
        self.blurType = KStaticBlur;
        self.colorComponents = components;
    }
    
    self.colorComponents = components;
    [self blurBackground];
}

- (void) blurWithColor:(BLRColorComponents *) components updateInterval:(float) interval {
    self.blurType = KLiveBlur;
    self.colorComponents = components;
    
    self.timer = CreateDispatchTimer(interval * NSEC_PER_SEC, 1ull * NSEC_PER_SEC, dispatch_get_main_queue(), ^{[self blurWithColor:components];});
}

dispatch_source_t CreateDispatchTimer(uint64_t interval, uint64_t leeway, dispatch_queue_t queue, dispatch_block_t block) {
    
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    if (timer) {
        dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), interval, leeway);
        dispatch_source_set_event_handler(timer, block);
        
        dispatch_resume(timer);
    }
    
    return timer;
}

- (void)setBlurBackgroundImageViewPosition:(CGPoint)point
{
    CGRect rect = self.backgroundImageView.frame;
    rect.origin = point;
    self.backgroundImageView.frame = rect;
}

@end

@interface BLRColorComponents()
@end

@implementation BLRColorComponents


+ (BLRColorComponents *) whiteEffect {
    BLRColorComponents *components = [[BLRColorComponents alloc] init];
    
    components.radius = 6;
    components.tintColor = [UIColor colorWithWhite:.8 alpha:.6f];
    components.saturationDeltaFactor = 1.8f;
    components.maskImage = nil;
    
    return components;
}

+ (BLRColorComponents *) blueEffect {
    BLRColorComponents *components = [[BLRColorComponents alloc] init];
    
    components.radius = 25;
    components.tintColor = [UIColor colorWithRed:0.0/255.0 green:27.0/255.0 blue:45.0/255.0 alpha:0.5];
    components.saturationDeltaFactor = 1.8f;
    components.maskImage = nil;
    
    return components;
}

+ (BLRColorComponents *) lightEffect {
    BLRColorComponents *components = [[BLRColorComponents alloc] init];
    
    components.radius = 6;
    components.tintColor = [UIColor colorWithWhite:.8f alpha:.2f];
    components.saturationDeltaFactor = 1.8f;
    components.maskImage = nil;
    
    return components;
}

+ (BLRColorComponents *) darkEffect {
    BLRColorComponents *components = [[BLRColorComponents alloc] init];
    
    components.radius = 10;
    components.tintColor = [UIColor colorWithRed:0.0f green:0.0 blue:0.0f alpha:0.56f];
    components.saturationDeltaFactor = 1.0f;
    components.maskImage = nil;
    
    return components;
}

+ (BLRColorComponents *) clearEffect {
    BLRColorComponents *components = [[BLRColorComponents alloc] init];
    
    components.radius = 20.0f;
    components.tintColor = [UIColor colorWithWhite:0.1f alpha:0.3f];
    components.saturationDeltaFactor = 1.0f;
    components.maskImage = nil;
    
    return components;
}

+ (BLRColorComponents *) coralEffect {
    BLRColorComponents *components = [[BLRColorComponents alloc] init];
    
    components.radius = 8;
    components.tintColor = [UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:.1f];
    components.saturationDeltaFactor = 3.0f;
    components.maskImage = nil;
    
    return components;
}

+ (BLRColorComponents *) neonEffect {
    BLRColorComponents *components = [[BLRColorComponents alloc] init];
    
    components.radius = 8;
    components.tintColor = [UIColor colorWithRed:0.0f green:1.0f blue:0.0f alpha:.1f];
    components.saturationDeltaFactor = 3.0f;
    components.maskImage = nil;
    
    return components;
}

+ (BLRColorComponents *) skyEffect {
    BLRColorComponents *components = [[BLRColorComponents alloc] init];
    
    components.radius = 8;
    components.tintColor = [UIColor colorWithRed:0.0f green:0.0f blue:1.0f alpha:.1f];
    components.saturationDeltaFactor = 3.0f;
    components.maskImage = nil;
    
    return components;
}

// ...

@end
