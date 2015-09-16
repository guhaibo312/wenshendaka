

#import <Foundation/Foundation.h>


#pragma mark - Preprocessor Macros

#define __NI_DEPRECATED_METHOD __attribute__((deprecated))

#define NI_FIX_CATEGORY_BUG(name) @interface NI_FIX_CATEGORY_BUG_##name : NSObject @end \
@implementation NI_FIX_CATEGORY_BUG_##name @end

/**
 * Creates an opaque UIColor object from a byte-value color definition.
 */
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

/**
 * Creates a UIColor object from a byte-value color definition and alpha transparency.
 */
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

// ARC, WEAK等
#if defined(__has_feature) && __has_feature(objc_arc_weak)
#define NI_WEAK weak
#define strong strong
#elif defined(__has_feature)  && __has_feature(objc_arc)
#define NI_WEAK unsafe_unretained
#define strong retain
#else
#define NI_WEAK assign
#define strong retain
#endif

/**@}*/// End of Preprocessor Macros //////////////////////////////////////////////////////////////
