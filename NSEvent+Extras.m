//
//  NSSplitView+Collapse.m
//  NSSplitView Helper
//
//  Created by Paolo Quadrani on 20/10/13.
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


#import "NSEvent+Extras.h"

@implementation NSEvent (EventExtras)

- (BOOL)isKeyEvent:(unichar)key
{
    NSInteger type = [self type];
    if (type != NSKeyDown && type != NSKeyUp)
        return NO;
    
    NSString *chars = [self charactersIgnoringModifiers];
    if ([chars length] != 1)
        return NO;
    
    unichar c = [chars characterAtIndex:0];
    if (c != key)
        return NO;
    
    return YES;
}

- (BOOL)isDeleteKeyEvent
{
    const unichar deleteKey = NSDeleteCharacter;
    const unichar deleteForwardKey = NSDeleteFunctionKey;
    return [self isKeyEvent:deleteKey] || [self isKeyEvent:deleteForwardKey];
}

- (BOOL)isReturnOrEnterKeyEvent
{
    const unichar enterKey = NSEnterCharacter;
    const unichar returnKey = NSCarriageReturnCharacter;
    return [self isKeyEvent:enterKey] || [self isKeyEvent:returnKey];
}

@end
