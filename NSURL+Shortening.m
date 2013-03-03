//
//  NSURL+Shortening.m
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


#import "NSURL+Shortening.h"

@implementation NSURL (Shortening)

- (BOOL)isShortUrl
{
    NSString *longUrlHost = [self host];
    NSArray *shortenerEngines = [NSArray arrayWithObjects:@"is.gd", @"tinyurl.com", @"tr.im", @"bit.ly", @"goo.gl", @"ow.ly", nil];
    for (NSString *engine in shortenerEngines) {
        NSRange is = [longUrlHost rangeOfString:engine options:NSCaseInsensitiveSearch];
        if (is.location != NSNotFound && is.location == 0) {
            return YES;
        }
    }
    return NO;
}

- (void)shortenWithTinyUrlCompletionHandler:(void (^)(NSString *result, NSError *error))handler
{
    if ([self isShortUrl]) {
        handler([self absoluteString], nil);
    }
    
    NSString *queryUrlAsString = [NSString stringWithFormat:@"http://tinyurl.com/api-create.php?url=%@", [self absoluteString]];
    NSURL *queryUrl = [NSURL URLWithString:queryUrlAsString];
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:queryUrl
												cachePolicy:NSURLRequestUseProtocolCachePolicy
											timeoutInterval:10.0];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:theRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSString *receivedDataAsString = nil;
        if ([data length] > 0 && error == nil) {
#if __has_feature(objc_arc)
            receivedDataAsString = [[NSString alloc] initWithData:data  encoding:NSASCIIStringEncoding];
#else
            receivedDataAsString = [[[NSString alloc] initWithData:data  encoding:NSASCIIStringEncoding] autorelease];
#endif
            handler(receivedDataAsString, error);
        } else {
            handler(nil, error);
        }
    }];
}

@end
