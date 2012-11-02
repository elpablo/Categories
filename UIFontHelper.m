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

#import "UIFontHelper.h"


@implementation UIFont (Helper)

+ (UIFont *)fontWithFilePath:(NSString *)fpath pointSize:(CGFloat)size
{
    CGDataProviderRef fontDataProvider = CGDataProviderCreateWithFilename([fpath UTF8String]);
    CGFontRef customFont = CGFontCreateWithDataProvider(fontDataProvider);
    CGDataProviderRelease(fontDataProvider);
    NSString *fontName = (__bridge NSString *)CGFontCopyPostScriptName(customFont);
    CFErrorRef error;
    CTFontManagerRegisterGraphicsFont(customFont, &error);
    CGFontRelease(customFont);
    return [UIFont fontWithName:fontName size:size];
}

@end
