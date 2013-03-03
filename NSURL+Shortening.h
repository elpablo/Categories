//
//  NSURL+Shortening.h
//  URLShortener
//
//  Created by Paolo Quadrani on 03/03/13.
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


#import <Foundation/Foundation.h>

@interface NSURL (Shortening)

/*
 * Use the free TinyUrl service to make NSURL shorten. Url as text is returned through the 
 * result variable of the completion block.
 */
- (void)shortenWithTinyUrlCompletionHandler:(void (^)(NSString *result, NSError *error))handler;

@end
