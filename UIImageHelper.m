/***************************************************************************
 Copyright [2011] [Paolo Quadrani]
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 ***************************************************************************/


#import "UIImageHelper.h"


////////////////////////////// Helper functions //////////////////////////////

void drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef  endColor);
CGRect rectFor1PxStroke(CGRect rect);
void draw1PxStroke(CGContextRef context, CGPoint startPoint, CGPoint endPoint, CGColorRef color);

void drawGlossAndGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor);

CGRect rectFor1PxStroke(CGRect rect) {
    return CGRectMake(rect.origin.x + 0.5, rect.origin.y + 0.5, rect.size.width - 1, rect.size.height - 1);
}

void drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef  endColor) {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = [NSArray arrayWithObjects:(__bridge id)startColor, (__bridge id)endColor, nil];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    CGColorSpaceRelease(colorSpace);
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    CGContextSaveGState(context);
    CGContextAddRect(context, rect);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
}

void draw1PxStroke(CGContextRef context, CGPoint startPoint, CGPoint endPoint, CGColorRef color) {
    
    CGContextSaveGState(context);
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetStrokeColorWithColor(context, color);
    CGContextSetLineWidth(context, 1.0);
    CGContextMoveToPoint(context, startPoint.x + 0.5, startPoint.y + 0.5);
    CGContextAddLineToPoint(context, endPoint.x + 0.5, endPoint.y + 0.5);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);        
    
}

void drawGlossAndGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor) {
    
    drawLinearGradient(context, rect, startColor, endColor);
    
    CGColorRef glossColor1 = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.35].CGColor;
    CGColorRef glossColor2 = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.1].CGColor;
    
    CGRect topHalf = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height/2);
    
    drawLinearGradient(context, topHalf, glossColor1, glossColor2);
    
}

///////////////////////////////////////////////////////////////////////////////


@implementation UIImage (Helper)

- (UIImage*)scaleToSize:(CGSize)size {
	UIGraphicsBeginImageContext(size);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextTranslateCTM(context, 0.0, size.height);
	CGContextScaleCTM(context, 1.0, -1.0);
	
	CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, size.width, size.height), self.CGImage);
	
	UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	return scaledImage;
}

- (UIImage *)imageByScalingProportionallyToFitSize:(CGSize)targetSize {
    UIImage *sourceImage = self;
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
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        scaleFactor = MIN(widthFactor, heightFactor);
//        if (widthFactor < heightFactor) 
//            scaleFactor = widthFactor;
//        else
//            scaleFactor = heightFactor;
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor < heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5; 
        } else if (widthFactor > heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;

	UIGraphicsBeginImageContext(targetSize);
    [sourceImage drawInRect:thumbnailRect];

    newImage = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();

    if(newImage == nil) NSLog(@"could not scale image");
    
    return newImage ;
}

- (UIImage *)imageByScalingProportionallyToFillSize:(CGSize)targetSize borderWidth:(int)border andShadow:(BOOL)shadow {
    UIImage *sourceImage = self;
    CGFloat scaleFactor = 1.0;
    
    CGRect frameRect = CGRectMake(0, 0, floor(self.size.width), floor(self.size.height));
    
    if (targetSize.width > targetSize.height) {
        scaleFactor = self.size.width / frameRect.size.width;
    } else {
        scaleFactor = self.size.height / frameRect.size.height;
    }
    
    CGSize scaledSize = CGSizeMake( floor(frameRect.size.width * scaleFactor), floor(frameRect.size.height * scaleFactor));

    UIGraphicsBeginImageContext(scaledSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIImage *result = nil;
    if (context != nil) {
        CGRect imgRect = CGRectZero;
        imgRect.size = scaledSize;
        // First fill the background with white.
        CGContextSetRGBFillColor(context, 0., 0., 0., 1.);
        CGContextFillRect(context, imgRect);
        CGContextSaveGState(context);
        // Scale the context so that the image is rendered 
        // at the correct size for the zoom level.
        CGContextScaleCTM(context, scaleFactor, scaleFactor);

        [sourceImage drawInRect:imgRect];
        
        CGContextRestoreGState(context);
        
        if (border > 0) {
            // Draw a border
            CGContextSetLineWidth(context, border);
            CGContextStrokeRect(context, imgRect);
        }

        CGImageRef image = CGBitmapContextCreateImage(context);        
        result = [[UIImage alloc] initWithCGImage:image];
        CGImageRelease(image);
        UIGraphicsEndImageContext();
        
    }
    UIGraphicsEndImageContext();

    if (context && shadow) {
        // Shadow
        UIGraphicsBeginImageContext(CGSizeMake(result.size.width + 10, result.size.height + 10));
        CGContextRef imageShadowContext = UIGraphicsGetCurrentContext();
        if (imageShadowContext != nil) {
            CGContextSetShadow(imageShadowContext, CGSizeMake(10, 10), 5);
            [result drawInRect:CGRectMake(5, 5, result.size.width, result.size.height)];
#if __has_feature(objc_arc)
#else
            [result release];
#endif
            result = UIGraphicsGetImageFromCurrentImageContext();
#if __has_feature(objc_arc)
#else
            [result retain];
#endif
            UIGraphicsEndImageContext();
        }
    }
    return result;
}

+ (UIImage *)imageWithRoundCornersOfImage:(UIImage *)source {
    CGRect rect = CGRectMake(0, 0, CGImageGetWidth([source CGImage]), CGImageGetHeight([source CGImage]));
	UIGraphicsBeginImageContext(rect.size);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(25, 25)];
    [path addClip];
    [source drawAtPoint:CGPointMake(0, 0)];
    
    UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return roundedImage;
}

+ (UIImage *)imagePixelWithColor:(UIColor *)color {
    CGRect pixelRect = CGRectMake(0., 0., 1., 1.);
	UIGraphicsBeginImageContext(pixelRect.size);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, pixelRect);
	
	UIImage *pixelImage = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
    
    return pixelImage;
}

+ (UIImage *)imageGradientWithStartColor:(UIColor *)startColor endColor:(UIColor *)endColor ofSize:(CGSize)imageSize
{
	UIGraphicsBeginImageContext(imageSize);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect rect = CGRectZero;
    rect.size = imageSize;
    drawGlossAndGradient(context, rect, [startColor CGColor], [endColor CGColor]);
    
	UIImage *gradientImage = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
    
    return gradientImage;
}

@end
