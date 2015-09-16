//
//  AddCollectionViewCell.h
//  Bshopkeeper
//
//  Created by jinwei on 15/6/15.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddCollectionViewCell : UICollectionViewCell
{
    UIImageView *addImageView;
    UILabel *addPromptLabel;
}

/**加载图片和标题
 */
- (void)loadWithTitle:(NSString *)title;



@end
