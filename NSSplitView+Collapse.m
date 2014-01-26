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


#import "NSView+Layer.h"

@implementation NSSplitView (Collapse)

- (void)toggleVisibilityForSubviewAtIndex:(NSUInteger)index
{
    NSView *subview = [self ]
    if ([self.viewSidebar isHidden]) {
        // Expand it
        [self.viewSidebar setFrame:rectPhotoLibraryBeforeCollapse];
        // toggle the library view visibility
        [self.viewSidebar setHidden:NO];
        // Adjust the split view.
        [self.splitView setPosition:NSMaxX([self.viewSidebar frame]) ofDividerAtIndex:0]; // adjust splitview to fit constraints
        [self.splitView adjustSubviews];
    } else {
        // Save the last frame of the library view
        rectPhotoLibraryBeforeCollapse = self.viewSidebar.frame;
        // toggle the library view visibility
        [self.viewSidebar setHidden:YES];
        // Adjust the split view.
        [self.splitView adjustSubviews];
    }
}

@end
