/*
 
 @file CIFilter+Additions.m
 
 @abstract Adds additional functionality to CIFilter.
 
 @version 1.1
 
 ©  Copyright 2006-2009 Apple, Inc. All rights reserved.
 
 IMPORTANT: This Apple software is supplied to you by Apple Computer,
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms,
 and subject to these terms, Apple grants you a personal,
 non-exclusive license, under Apple's copyrights in this original
 Apple software (the "Apple Software"), to use, reproduce, modify and
 redistribute the Apple Software, with or without modifications, in
 source and/or binary forms; provided that if you redistribute the
 Apple Software in its entirety and without modifications, you must
 retain this notice and the following text and disclaimers in all such
 redistributions of the Apple Software.  Neither the name, trademarks,
 service marks or logos of Apple Computer, Inc. may be used to endorse
 or promote products derived from the Apple Software without specific
 prior written permission from Apple.  Except as expressly stated in
 this notice, no other rights or licenses, express or implied, are
 granted by Apple herein, including but not limited to any patent
 rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND
 FITNESS FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS
 USE AND OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT,
 INCIDENTAL OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 PROFITS; OR BUSINESS INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE,
 REPRODUCTION, MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE,
 HOWEVER CAUSED AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING
 NEGLIGENCE), STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN
 ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 */

#import "CIFilter+Additions.h"


@implementation CIFilter ( MinMaxBindings )

- (id)valueForKeyPath:(NSString *)keyPath
{
	if ((keyPath != nil) && ([keyPath length] > 1) && ([keyPath characterAtIndex:0] == (unichar) '@'))
	{
		NSRange const dotRange = [keyPath rangeOfString:@"."];
		NSString *operator = (dotRange.location == NSNotFound) ? keyPath : [keyPath substringToIndex:dotRange.location];
		NSString *remainderPath = ((dotRange.location == NSNotFound) || (dotRange.location == [keyPath length])) ? nil : [keyPath substringFromIndex:(dotRange.location + 1)];
		if ((remainderPath != nil) &&
			([operator isEqualToString:@"@minSlider"] || [operator isEqualToString:@"@maxSlider"]))
		{
			BOOL const minimum = [operator isEqualToString:@"@minSlider"];
			NSDictionary *attributes = [self attributes];
			NSDictionary *attributeDictionary = [attributes objectForKey:remainderPath];
			if (attributeDictionary != nil)
			{
				NSObject *value = [attributeDictionary objectForKey:(minimum ? kCIAttributeSliderMin : kCIAttributeSliderMax)];
				if (value == nil)
				{
					value = [attributeDictionary objectForKey:(minimum ? kCIAttributeMin : kCIAttributeMax)];
				}
				return value;
			}
		}
	}
	return [super valueForKeyPath:keyPath];
}

@end

@implementation CIFilter ( DisplayName )

- (NSString *)displayName
{
	NSString *displayName = [[self attributes] objectForKey:kCIAttributeFilterDisplayName];
	if (displayName == nil)
		displayName = [[self attributes] objectForKey:kCIAttributeFilterName];
	return displayName;
}

@end

@implementation CIFilter ( Stacking )

- (NSArray *)allImageInputKeys
{
    NSMutableArray *imageKeys = [NSMutableArray array];
    NSDictionary *attributes = [self attributes];
    for (NSString *name in [self inputKeys])
    {
        NSDictionary *attribteDescription = [attributes objectForKey:name];
		NSString *className = [attribteDescription objectForKey:kCIAttributeClass];
        if ([className isEqualToString:@"CIImage"])
            [imageKeys addObject:name];
    }
    return imageKeys;
}

- (void)bindImageInputsToFilter:(CIFilter *)inputFilter
{
	NSArray *inputs = [self allImageInputKeys];
	for (NSString *inputKey in inputs)
	{
		[self bind:inputKey toObject:inputFilter withKeyPath:kCIOutputImageKey options:nil];
	}
	
}

- (void)unbindImageInputs
{
	NSArray *inputs = [self allImageInputKeys];
	for (NSString *inputKey in inputs)
	{
		[self unbind:inputKey];
	}
}

@end
