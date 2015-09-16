
#import <UIKit/UIKit.h>

@interface AdvertisingScrollView : UIView<UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    BOOL _isAutoPlay; //是不是自动滚动
}

@property (nonatomic, strong) UIViewController *ownerController;

- (id)initWithFrame:(CGRect)frame ownerController:(UIViewController *)controller isAuto:(BOOL)isAuto array:(NSArray *)data;

- (void)start;

- (void)stop;

- (void)deleteAll;

@end
