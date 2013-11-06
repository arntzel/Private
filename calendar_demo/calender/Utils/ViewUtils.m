
#import "ViewUtils.h"
#import "Utils.h"

@implementation ViewUtils


+(UIView *) createView:(NSString *) xibFileName
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:xibFileName owner:self options:nil];
    return [nibView objectAtIndex:0];
}

+(int) getEventTypeColor:(int) eventType
{
    int color;

    switch (eventType) {
        case 0:
            color = 0xFFF44258;
            break;

        case 1:
            color = 0xFFD5AD3E;
            break;

        case 2:
            color = 0xFFAAA9AE;
            break;

        case 3:
            color = 0xFF477DBD;
            break;

        case 4:
            color = 0xFF71A189;
            break;

        case 5:
            color = 0xFFB34BAC;
            break;

        default:
            color = 0x00000000;
            break;
    }

    return color;
}

/*
 Calvin: 0
 Google Personal: 1
 Google work: 2
 Fackbook: 3
 Birthdays: 4
 iOSCalendar: 5
 */

+(NSString *) getEventTypeName:(int) eventType
{
    switch (eventType) {
        case 0:
            return  @"Calvin Events";
            
        case 1:
            return @"Google Events";
            
        case 2:
            return @"Google Personal";
            
        case 3:
            return @"Facebook Events";
            
        case 4:
            return @"Birthdays";
            
        case 5:
            return @"iCal Events";
            
        default:
            return @"Unknow Events";
    }
}

+(UIColor *) getUIColor:(int) argbColor
{
    float r = COLOR_R(argbColor)/255.0;
    float g = COLOR_G(argbColor)/255.0;
    float b = COLOR_B(argbColor)/255.0;
    float a = COLOR_A(argbColor)/255.0;

    return [UIColor colorWithRed:r green:g blue:b alpha:a];
}

+ (UIImage*) imageByScalingAndCroppingForSize:(CGSize)targetSize andUIImage:(UIImage *)sourceImage
{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}  

+(void) resetUILabelFont:(UIView *)view
{
    for(UIView * subView in [view subviews]) {
        
        if([subView isKindOfClass: [UILabel class]] ) {
            UILabel * label = (UILabel*) subView;
            UIFont * font = [label font];
            
            UIFont * newFont;
            if([font.fontName isEqualToString:@"Helvetica-Bold"]) {
                newFont = [UIFont boldSystemFontOfSize:font.ascender];
                [label setFont:newFont];
            } else if([font.fontName isEqualToString:@"Helvetica"]) {
                newFont = [UIFont systemFontOfSize:font.ascender];
                [label setFont:newFont];
            }
            
        } else {
            [ViewUtils resetUILabelFont:subView];
        }
    }
}

@end
