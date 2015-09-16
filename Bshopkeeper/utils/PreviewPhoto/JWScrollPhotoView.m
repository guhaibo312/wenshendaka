//
//  JWScrollPhotoView.m
//  Bshopkeeper
//
//  Created by jinwei on 15/3/30.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "JWScrollPhotoView.h"
#import <CommonCrypto/CommonDigest.h>
#import "SDImageCache.h"
#import "NSString+BG.h"
#import "Configurations.h"

@interface JWScrollPhotoView ()
{
    NSString *diskCachePath;
}

@end

@implementation JWScrollPhotoView

@synthesize imageView;
@synthesize imageUrl;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setDelegate:self];
        [self setMaximumZoomScale:3.0];
        [self setShowsHorizontalScrollIndicator:NO];
        [self setShowsVerticalScrollIndicator:NO];
        self.imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        self.imageView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin| UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [self addSubview:self.imageView];
        
    }
    return self;
}

-(void)startLoadImage
{
    if (self.imageUrl) {
        return;
    }
    [self startLoadImageWithUrl:self.imageUrl];
}


-(void)setimageWith:(NSURL *)url
{
    [self startLoadImageWithUrl:url];
}


-(void)startLoadImageWithUrl:(NSURL*)url
{
    if (!url) {
        return ;
    }
    diskCachePath = [self getCachePath];
    NSString *pathString = [self cachePathForKey:[url absoluteString]];
    UIImage *cacheImage = SDScaledImageForKey([url absoluteString], [UIImage imageWithContentsOfFile:pathString]);
    if (cacheImage)
    {
        self.imageView.image = cacheImage;
        return;
    }
    
    
    NSURL *requestUrl = [NSURL URLWithString:[url absoluteString]];
    NSURLRequest* request = [NSURLRequest requestWithURL:requestUrl];
    connect = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    [connect start];
    
    if (!progressView) {
        progressView = [[JWCircleProgressView alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-53.5,10 , 50, 50) backColor:[UIColor blackColor] progressColor:[UIColor whiteColor] lineWidth:4];
        [progressView setProgressLabelHidden:NO];
        progressView.center = self.imageView.center;
        [self.imageView addSubview:progressView];
    }
}


-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.imageView.image = [UIImage imageNamed:@"icon_image_default.png"];
    if (self) {
        [SVProgressHUD showErrorWithStatus:@"加载大图失败"];
    }
}


-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    httpData = nil;
    httpData = [[NSMutableData alloc]initWithCapacity:0];
    dataLenth = response.expectedContentLength;
    
}


-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
    [httpData appendData:data];
    if (dataLenth >0) {
        float p = [httpData length]/dataLenth;
        [progressView setCurrentProgress:p];
    }
    
}


-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    UIImage* httpImage = [UIImage imageWithData:httpData];
    self.imageView.image = httpImage;
    [progressView removeFromSuperview];
    progressView = nil;
    if (httpData)
    {
        [[NSFileManager defaultManager] createFileAtPath:[self cachePathForKey:[self.imageUrl absoluteString]] contents:httpData attributes:nil];
    }
    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}


-(NSString*)getCachePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    
    NSString* path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"ImageCache"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:diskCachePath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:diskCachePath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:NULL];
    }
    return path;
}

- (NSString *)cachePathForKey:(NSString *)key
{
    if (!key) {
        return nil;
    }
    
    const char *str = [key UTF8String];
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    
    return [diskCachePath stringByAppendingPathComponent:filename];
}


@end
