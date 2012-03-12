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

@interface UIImage (Helper)

/** Produce a UIImage by scaling self to the given size without taking in account at the proporsions.*/
- (UIImage*)scaleToSize:(CGSize)size;

/** Produce a UIImage by scaling self proportionally to fit the given size.*/
- (UIImage *)imageByScalingProportionallyToFitSize:(CGSize)targetSize;

/** Produce a UIImage by scaling self proportionally to fill the given size.*/
- (UIImage *)imageByScalingProportionallyToFillSize:(CGSize)targetSize borderWidth:(int)border andShadow:(BOOL)shadow;

/** Produce a UIImage with round corners starting from the given source image. */
+ (UIImage *)imageWithRoundCornersOfImage:(UIImage *)source;

/** Produce a UIImage pixel colored with given color. */
+ (UIImage *)imagePixelWithColor:(UIColor *)color;

/** Produce a UIImage gradient. */
+ (UIImage *)imageGradientWithStartColor:(UIColor *)startColor endColor:(UIColor *)endColor ofSize:(CGSize)imageSize;

@end
