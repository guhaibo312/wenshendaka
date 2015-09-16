

#import "UILabel+sunny.h"

@implementation UILabel (sunny)

///////////////////////////////////////////////////////////////////////////////////////////////////

+ (UILabel*) labelWithFontSize: (CGFloat)fontSize fontColor:(UIColor *)color text: (NSString *)text {
    UILabel *label = [UILabel new];
    label.textColor = color;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:fontSize];
    label.text = text;
    return label;
}

+ (UILabel*) labelWithFrame: (CGRect) frame
                   fontSize: (int) fontsize
                       text: (NSString*) text {

    UILabel* label = [[UILabel alloc] initWithFrame: frame];

    label.text = text;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize: fontsize];

    return label;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (UILabel*) labelWithFrame: (CGRect) frame
                   fontSize: (int) fontsize
                  fontColor: (UIColor*) color
                       text: (NSString*) text {

    UILabel* label = [[UILabel alloc] initWithFrame: frame];

    label.text = text;
    label.textColor = color;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize: fontsize];

    return label;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (UILabel*) labelWithFrame: (CGRect) frame
               boldFontSize: (int) fontsize
                  fontColor: (UIColor*) color
                       text: (NSString*) text {

    UILabel* label = [[UILabel alloc] initWithFrame: frame];

    label.text = text;
    label.textColor = color;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize: fontsize];

    return label;
}

@end
