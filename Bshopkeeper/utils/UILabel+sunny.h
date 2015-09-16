

#import <UIKit/UIKit.h>

@interface UILabel (sunny)

+ (UILabel*) labelWithFrame: (CGRect) frame fontSize: (int) fontsize text: (NSString*) text;
+ (UILabel*) labelWithFrame: (CGRect) frame fontSize: (int) fontsize fontColor: (UIColor*) color text: (NSString*) text;

+ (UILabel*) labelWithFontSize: (CGFloat)fontSize fontColor:(UIColor *)color text: (NSString *)text;

+ (UILabel*) labelWithFrame: (CGRect) frame
               boldFontSize: (int) fontsize
                  fontColor: (UIColor*) color
                       text: (NSString*) text;


@end
