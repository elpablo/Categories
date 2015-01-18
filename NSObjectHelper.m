/***************************************************************************
 Copyright [2015] [Paolo Quadrani]
 
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

#import "NSObjectHelper.h"


@implementation NSObject (Helper)

- (NSString *)jsonPrettyString
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = !error ? [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] : @"";
    return jsonString;
}

- (NSString *)jsonString
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
    NSString *jsonString = !error ? [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] : @"";
    return jsonString;
}

+ (id)objectFromJSONString:(NSString *)json
{
    NSError *error;
    NSData *data = [[NSData alloc] initWithBytes:[json UTF8String] length:[json length]];
    id obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    return obj;
}

@end
