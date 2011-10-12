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
            [result release];
            result = UIGraphicsGetImageFromCurrentImageContext();
            [result retain];
            UIGraphicsEndImageContext();
        }
    }
    return result;
}

void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth, float ovalHeight);
void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth, float ovalHeight) {
	float fw, fh;
	if (ovalWidth == 0 || ovalHeight == 0) {
		CGContextAddRect(context, rect);
		return;
	}
	CGContextSaveGState(context);
	CGContextTranslateCTM (context, CGRectGetMinX(rect), CGRectGetMinY(rect));
	CGContextScaleCTM (context, ovalWidth, ovalHeight);
	fw = CGRectGetWidth (rect) / ovalWidth;
	fh = CGRectGetHeight (rect) / ovalHeight;
	CGContextMoveToPoint(context, fw, fh/2);
	CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
	CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
	CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
	CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
	CGContextClosePath(context);
	CGContextRestoreGState(context);
}

+ (UIImage *)imageWithRoundCornersOfImage:(UIImage *)source {
	int w = source.size.width;
	int h = source.size.height;
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
	
	CGContextBeginPath(context);
	CGRect rect = CGRectMake(0, 0, w, h);
	addRoundedRectToPath(context, rect, 5, 5);
	CGContextClosePath(context);
	CGContextClip(context);
	
	CGContextDrawImage(context, CGRectMake(0, 0, w, h), source.CGImage);
	
	CGImageRef imageMasked = CGBitmapContextCreateImage(context);
	CGContextRelease(context);
	CGColorSpaceRelease(colorSpace);
	
	return [UIImage imageWithCGImage:imageMasked];    
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

@end
