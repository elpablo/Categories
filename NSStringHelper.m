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

#import "NSStringHelper.h"


@implementation NSString (Helper)

- (UIColor *)RGBAStringToColor
{
    NSArray *rgba = [self componentsSeparatedByString:@" "];
    int num_comp = [rgba count];
    return (num_comp != 4) ? nil : [UIColor colorWithRed:[[rgba objectAtIndex:0] integerValue] / 255.
                                                   green:[[rgba objectAtIndex:1] integerValue] / 255.
                                                    blue:[[rgba objectAtIndex:2] integerValue] / 255.
                                                   alpha:[[rgba objectAtIndex:3] integerValue] / 255.];
}

- (BOOL)representsValidEmail
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

@end
