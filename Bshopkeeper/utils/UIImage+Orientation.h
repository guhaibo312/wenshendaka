//
//  UIImage+Orientation.h
//  SymptomChecker
//
//  Created by LeiZhang on 13-11-12.
//
//

#import <UIKit/UIKit.h>

@interface UIImage (Orientation)

- (UIImage*) fixOrientation;

+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;

+ (UIImage *)resizeImage:(NSString *)imageName;

@end
