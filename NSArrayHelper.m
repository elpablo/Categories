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


#import "NSArrayHelper.h"

@implementation NSArray (Helper)

/// Check if the array is empty.
- (BOOL)isEmpty {
    return [self count] == 0 ? YES : NO;
}


/// Return an array with a shuffled elements of input array
- (NSArray *)shuffle {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[self count]];
    NSMutableArray *copy = [self mutableCopy];
	
    while ([copy count] > 0) {
        int index = arc4random() % [copy count];
        id objectToMove = [copy objectAtIndex:index];
        [array addObject:objectToMove];
        [copy removeObjectAtIndex:index];
    }
#if __has_feature(objc_arc)
#else
    [copy release];
#endif

    return array;
}


/// Return a NSArray with A-Z and # (useful in UITableView)
+ (NSArray*)arrayWithCapitalLetters {
	return [NSArray arrayWithObjects:
            @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", 
            @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", 
            @"W", @"X", @"Y", @"Z", @"#", nil];
}


/// Return a NSArray with A-Z, # and search (useful in UITableView)
+ (NSArray*)arrayWithCapitalLettersAndSearch {
    return [NSArray arrayWithObjects: @"{search}",
            @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", 
            @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", 
            @"W", @"X", @"Y", @"Z", @"#", nil];
}


/// Return the array with elements in reversed order
- (NSArray *)reverse {
	return [[self reverseObjectEnumerator] allObjects];
}

/// Access in a safe manner to the elements of the array.
- (id)objectAtIndexSafe:(NSUInteger)index {
    return (index >= [self count]) ? nil : [self objectAtIndex:index];
}

@end
