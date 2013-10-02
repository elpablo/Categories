//
//  NSURL+ImageCheck.m
//  URLImageCheck
//
//  Created by Paolo Quadrani on 02/10/13.
//

/***************************************************************************
 Copyright [2013] [Paolo Quadrani]
 
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


#import "NSURL+ImageCheck.h"

@implementation NSURL (ImageCheck)

- (BOOL)isImageFile
{
	BOOL				isImageFile = NO;
	LSItemInfoRecord	info;
	CFStringRef			uti = NULL;
	
	if (LSCopyItemInfoForURL((__bridge CFURLRef)(self), kLSRequestExtension | kLSRequestTypeCreator, &info) == noErr)
	{
		// Obtain the UTI using the file information.
		
		// If there is a file extension, get the UTI.
		if (info.extension != NULL)
		{
			uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, info.extension, kUTTypeData);
			CFRelease(info.extension);
		}
        
		// No UTI yet
		if (uti == NULL)
		{
			// If there is an OSType, get the UTI.
			CFStringRef typeString = UTCreateStringForOSType(info.filetype);
			if ( typeString != NULL)
			{
				uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassOSType, typeString, kUTTypeData);
				CFRelease(typeString);
			}
		}
		
		// Verify that this is a file that the ImageIO framework supports.
		if (uti != NULL)
		{
			CFArrayRef  supportedTypes = CGImageSourceCopyTypeIdentifiers();
			CFIndex		i, typeCount = CFArrayGetCount(supportedTypes);
            
			for (i = 0; i < typeCount; i++)
			{
				if (UTTypeConformsTo(uti, (CFStringRef)CFArrayGetValueAtIndex(supportedTypes, i)))
				{
					isImageFile = YES;
					break;
				}
			}
            
            CFRelease(supportedTypes);
            CFRelease(uti);
		}
	}
    
	return isImageFile;
}

@end
