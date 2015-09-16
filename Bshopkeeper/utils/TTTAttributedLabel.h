

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

typedef enum {
    TTTAttributedLabelVerticalAlignmentCenter   = 0,
    TTTAttributedLabelVerticalAlignmentTop      = 1,
    TTTAttributedLabelVerticalAlignmentBottom   = 2,
} TTTAttributedLabelVerticalAlignment;

extern NSString * const kTTTStrikeOutAttributeName;

@protocol TTTAttributedLabelDelegate;

@protocol TTTAttributedLabel <NSObject>
@property (nonatomic, copy) id text;
@end

@interface TTTAttributedLabel : UILabel <TTTAttributedLabel, UIGestureRecognizerDelegate> {
@private
    NSAttributedString *_attributedText;
    CTFramesetterRef _framesetter;
    BOOL _needsFramesetter;
    
    id _delegate;
    UIDataDetectorTypes _dataDetectorTypes;
    NSDataDetector *_dataDetector;
    NSArray *_links;
    NSDictionary *_linkAttributes;
    
    CGFloat _shadowRadius;
    
    CGFloat _leading;
    CGFloat _lineHeightMultiple;
    CGFloat _firstLineIndent;
    UIEdgeInsets _textInsets;
    TTTAttributedLabelVerticalAlignment _verticalAlignment;
    
    UITapGestureRecognizer *_tapGestureRecognizer;
}

@property (nonatomic, assign) id <TTTAttributedLabelDelegate> delegate;

@property (nonatomic, assign) UIDataDetectorTypes dataDetectorTypes;

@property (readonly, nonatomic, retain) NSArray *links;

@property (nonatomic, retain) NSDictionary *linkAttributes;

@property (nonatomic, assign) CGFloat shadowRadius;

@property (nonatomic, assign) CGFloat firstLineIndent;

@property (nonatomic, assign) CGFloat leading;

@property (nonatomic, assign) CGFloat lineHeightMultiple;

@property (nonatomic, assign) UIEdgeInsets textInsets;

@property (nonatomic, assign) TTTAttributedLabelVerticalAlignment verticalAlignment;

- (void)setText:(id)text;

- (void)setText:(id)text afterInheritingLabelAttributesAndConfiguringWithBlock:(NSMutableAttributedString *(^)(NSMutableAttributedString *mutableAttributedString))block;

- (void)addLinkWithTextCheckingResult:(NSTextCheckingResult *)result attributes:(NSDictionary *)attributes;

- (void)addLinkToURL:(NSURL *)url withRange:(NSRange)range;

- (void)addLinkToAddress:(NSDictionary *)addressComponents withRange:(NSRange)range;

- (void)addLinkToPhoneNumber:(NSString *)phoneNumber withRange:(NSRange)range;


- (void)addLinkToDate:(NSDate *)date withRange:(NSRange)range;

- (void)addLinkToDate:(NSDate *)date timeZone:(NSTimeZone *)timeZone duration:(NSTimeInterval)duration withRange:(NSRange)range;

@end

@protocol TTTAttributedLabelDelegate <NSObject>

@optional

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url;

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithAddress:(NSDictionary *)addressComponents;


- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithPhoneNumber:(NSString *)phoneNumber;

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithDate:(NSDate *)date;

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithDate:(NSDate *)date timeZone:(NSTimeZone *)timeZone duration:(NSTimeInterval)duration;
@end
