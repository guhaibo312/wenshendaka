//
//  PECropViewController.m
//  Bshopkeeper
//
//  Created by jinwei on 15/5/6.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "PEResizeControl.h"

@interface PEResizeControl ()

@property (nonatomic, readwrite) CGPoint translation;
@property (nonatomic) CGPoint startPoint;

@end

@implementation PEResizeControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, 44.0f, 44.0f)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
//        UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
//        [self addGestureRecognizer:gestureRecognizer];
    }
    
    return self;
}

- (void)handlePan:(UIPanGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint translationInView = [gestureRecognizer translationInView:self.superview];
        self.startPoint = CGPointMake(roundf(translationInView.x), translationInView.y);
        
        if ([self.delegate respondsToSelector:@selector(resizeConrolViewDidBeginResizing:)]) {
            [self.delegate resizeConrolViewDidBeginResizing:self];
        }
    } else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gestureRecognizer translationInView:self.superview];
        self.translation = CGPointMake(roundf(self.startPoint.x + translation.x),
                                       roundf(self.startPoint.y + translation.y));
        
        if ([self.delegate respondsToSelector:@selector(resizeConrolViewDidResize:)]) {
            [self.delegate resizeConrolViewDidResize:self];
        }
    } else if (gestureRecognizer.state == UIGestureRecognizerStateEnded || gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
        if ([self.delegate respondsToSelector:@selector(resizeConrolViewDidEndResizing:)]) {
            [self.delegate resizeConrolViewDidEndResizing:self];
        }
    }
}

@end
