//
//  FilledColorButton.m
//  SymptomChecker
//
//  Created by suning on 14-8-29.
//
//

#import "FilledColorButton.h"
#import "Configurations.h"

static const CGFloat kBtnTitleFontSize = 17;

@implementation FilledColorButton

- (id) initWithFrame:(CGRect)frame type:(FilledColorTyle)type title:(NSString *)title
            fontSize:(NSInteger) size isBold:(BOOL) isbold {
    _fontSize = size;
    _isBold = isbold;
    self = [self initWithFrame: frame type:type title:title ];
    if (self) {
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame type:(FilledColorTyle) type title:(NSString*) title {
    
    // 字体大小 和 自己加粗设定缺省
    if (_fontSize == 0) {
        _isBold = YES;
        _fontSize = kBtnTitleFontSize;
    }
    
    [self setBtnStyleWithType: type];
    
    self = [self initWithFrame: frame
                         color: _backGroundColor
                   borderColor: _borderColor
                     textClolr: _textColor
                         title: title
                      fontSize: _fontSize
                        isBold: _isBold];
    if (self) {
        
    }
    return self;
    
}

- (id) initWithFrame:(CGRect)frame color:(UIColor*)color borderColor:(UIColor*)borderColor textClolr:(UIColor*)textColor title:(NSString *)title fontSize:(NSInteger) size isBold:(BOOL) isbold {
    self = [super initWithFrame: frame];
    if (self) {
        
        _backGroundColor = color;
        _borderColor = borderColor;
        _textColor = textColor;
        _fontSize = size;
        _isBold = isbold;
        
        _titleLabel = [UILabel labelWithFrame: CGRectMake(0, (CGRectGetHeight(frame) - kBtnTitleFontSize-1)/2, CGRectGetWidth(frame), kBtnTitleFontSize+1)
                                 boldFontSize: _fontSize
                                    fontColor: _textColor
                                         text: title];
        if (!_isBold) {
            _titleLabel.font = [UIFont systemFontOfSize: _fontSize];
        }
        
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview: _titleLabel];
        
        
        self.layer.borderWidth = 0.5;
        self.layer.cornerRadius = 2.5;
        self.layer.borderColor = _borderColor.CGColor;
        self.backgroundColor = _backGroundColor;
    }
    return self;
}
- (void)setTitleLabelFrame:(CGRect)frame
{
    _titleLabel.frame = frame;
}


//
// 设置一些颜色
//
- (void) setBtnStyleWithType:(FilledColorTyle) type {
    switch (type) {
        case kFilledBtnGeeen: {
            _backGroundColor = RGBCOLOR_HEX(0x65ce0f);
            _borderColor = RGBCOLOR_HEX(0x5cb712);
            _textColor = [UIColor whiteColor];
        }
            
            break;
        case kFilledBtnWhite: {
            
            _backGroundColor = [UIColor whiteColor];
            _borderColor = RGBCOLOR_HEX(0xcfcfcf);
            _textColor = [UIColor blackColor];
        }
            break;
        case kFilledBtnBlue: {
            
            _backGroundColor = RGBCOLOR_HEX(0x78b4f8);
            _borderColor = RGBCOLOR_HEX(0x4f91db);
            _textColor = [UIColor whiteColor];
        }
            break;
        case kFilledBtnGray: {
            _backGroundColor = RGBCOLOR_HEX(0xcacaca);
            _borderColor = RGBCOLOR_HEX(0xa5a5a5);
            _textColor = RGBCOLOR_HEX(0x323232);
        }
            break;
            
        case kFilledBtnRed: {
            _backGroundColor = RGBCOLOR_HEX(0xf0533e);
            _borderColor = RGBCOLOR_HEX(0xe54f3c);
            _textColor = [UIColor whiteColor];
            
        }
            break;
            
        case kFilledBtnOrange: {
            _backGroundColor = RGBCOLOR_HEX(0xff6000);
            _borderColor = RGBCOLOR_HEX(0xe65303);
            _textColor = [UIColor whiteColor];
        }
            break;
            
        case kFilledBtnClear: {
            _backGroundColor = [UIColor clearColor];
            _borderColor = RGBACOLOR(0xff, 0xff, 0xff, 0.5);
            _textColor = [UIColor whiteColor];
        }
            break;
            
        case kFilledBtnCustomColor: {
            _backGroundColor = SCHEMOCOLOR;
            _borderColor = SCHEMOCOLORSELECT;
            _textColor = [UIColor whiteColor];
        }
            break;

        case kFilledBtnNone: {
            break;
        }
        case KFilledBtnDelegate:{
            _backGroundColor = [UIColor whiteColor];
            _borderColor = SCHEMOCOLOR;
            _textColor = SCHEMOCOLOR;

        }
            
        default:
            break;
    }
}

- (void) setHighlighted:(BOOL)highlighted {
    [super setHighlighted: highlighted];
    
    self.backgroundColor = highlighted ? _borderColor : _backGroundColor;
}

- (void)setTitle:(NSString *)title {
    _titleLabel.text = title;
}

- (void) bindType:(FilledColorTyle) type title:(NSString*) title {
    [self setBtnStyleWithType: type];
    [self updateDisplay];
    [self setTitle: title];
    
}

- (void) bindColor:(UIColor*)color borderColor:(UIColor*)borderColor textClolr:(UIColor*)textColor title:(NSString *)title fontSize:(NSInteger) size isBold:(BOOL) isbold {
    
    _backGroundColor = color;
    _borderColor = borderColor;
    _textColor = textColor;
    _fontSize = size;
    _isBold = isbold;
    
    [self updateDisplay];
    [self setTitle: title];
}

//
// 重绘颜色
//
- (void) updateDisplay {
    _titleLabel.textColor = _textColor;
    _titleLabel.font = _isBold ? [UIFont boldSystemFontOfSize: _fontSize] : [UIFont systemFontOfSize: _fontSize];
    _titleLabel.textColor = _textColor;
    
    self.layer.borderColor = _borderColor.CGColor;
    self.backgroundColor = _backGroundColor;
}

- (NSString *)getCurrentTitle
{
    return _titleLabel.text;
}

@end
