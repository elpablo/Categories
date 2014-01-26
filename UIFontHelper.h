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

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

@interface UIFont (Helper)

/**
 * Register the font at the given file path and returns the Postscript font name on success, nil otherwise.
 * Then use the returned font name to create the UIFont instance.
 */
+ (NSString *)pqRegisterFontWithFilePath:(NSString *)name;

@end
