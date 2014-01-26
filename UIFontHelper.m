/***************************************************************************
 Copyright [2014] [Paolo Quadrani]
 
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

#import "UIFontHelper.h"


@implementation UIFont (Helper)

+ (NSString *)registerFontWithFilePath:(NSString *)name
{
    NSString *fontName = nil;
    CGDataProviderRef fontDataProvider = CGDataProviderCreateWithFilename([name UTF8String]);
    if (fontDataProvider == NULL) return fontName;
    CGFontRef customFont = CGFontCreateWithDataProvider(fontDataProvider);
    CGDataProviderRelease(fontDataProvider);
    if (customFont == NULL) return fontName;
    fontName = (__bridge NSString *)CGFontCopyPostScriptName(customFont);
    CFErrorRef error;
    bool result = CTFontManagerRegisterGraphicsFont(customFont, &error);
    CGFontRelease(customFont);
    return result ? fontName : nil;
}

@end
