//
//  BoxBlur.m
//  Bshopkeeper
//
//  Created by jinwei on 15/6/16.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "UIImage+BoxBlur.h"
#import <QuartzCore/QuartzCore.h>
#import <Accelerate/Accelerate.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreImage/CoreImage.h>

@implementation UIImage (BoxBlur)

- (UIImage*)gaussBlur:(CGFloat)blurLevel

{
    
    blurLevel = MIN(1.0,MAX(0.0, blurLevel));
    
    
    int boxSize = 50;//模糊度。
    
    boxSize = boxSize - (boxSize % 2) + 1;
    
    NSData *imageData = UIImageJPEGRepresentation(self, 1);
    
    UIImage *tmpImage = [UIImageimageWithData:imageData];
    
    
    CGImageRef img = tmpImage.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    
    vImage_Error error;
    
    void *pixelBuffer;
    
    
    //create vImage_Buffer with data from CGImageRef
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    
    inBuffer.width = CGImageGetWidth(img);
    
    inBuffer.height = CGImageGetHeight(img);
    
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    
    //create vImage_Buffer for output
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) *CGImageGetHeight(img));
    
    
    outBuffer.data = pixelBuffer;
    
    outBuffer.width = CGImageGetWidth(img);
    
    outBuffer.height = CGImageGetHeight(img);
    
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    
    NSInteger windowR = boxSize/2;
    
    CGFloat sig2 = windowR / 3.0;
    
    if(windowR>0){ sig2 = -1/(2*sig2*sig2); }
    
    
    int16_t *kernel = (int16_t*)malloc(boxSize*sizeof(int16_t));
    
    int32_t sum = 0;
    
    for(NSInteger i=0; i
        
        kernel[i] = 255*exp(sig2*(i-windowR)*(i-windowR));
        
        sum += kernel[i];
        
        }
        
        free(kernel);
        
        // convolution
        error = vImageConvolve_ARGB8888(&inBuffer, &setbuffer,NULL, 0, 0, kernel, boxSize, 1, sum, NULL, kvImageEdgeExtend);
        
        error = vImageConvolve_ARGB8888(&setbuffer, &inBuffer,NULL, 0, 0, kernel, 1, boxSize, sum, NULL, kvImageEdgeExtend);
        
        outBuffer = inBuffer;
        
        
        if (error) {
            
            //NSLog(@"error from convolution %ld", error);
            
        }
        
        
        CGColorSpaceRef colorSpace =CGColorSpaceCreateDeviceRGB();
        
        CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
                                                 
                                                 outBuffer.width,
                                                 
                                                 outBuffer.height,
                                                 
                                                 8,
                                                 
                                                 outBuffer.rowBytes,
                                                 
                                                 colorSpace,
                                                 
                                                 kCGBitmapAlphaInfoMask &kCGImageAlphaNoneSkipLast);
        
        CGImageRef imageRef =CGBitmapContextCreateImage(ctx);
        
        UIImage *returnImage = [UIImageimageWithCGImage:imageRef];
        
        
        //clean up
        
        CGContextRelease(ctx);
        
        CGColorSpaceRelease(colorSpace);
        
        free(pixelBuffer);
        
        CFRelease(inBitmapData);
        
        CGImageRelease(imageRef);
        
        return returnImage;
@end
