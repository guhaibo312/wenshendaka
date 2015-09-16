//
//  AddImageViews.m
//  Bshopkeeper
//
//  Created by jinwei on 15/3/24.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "AddImageViews.h"
#import "UIImageView+WebCache.h"
#import "UIImage+Orientation.h"
#import "JWPreviewPhotoController.h"
#import "TJWAssetPickerController.h"


#define ImageSizeWidth (SCREENWIDTH-65)/4

@interface AddImageViews()<UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,TJWAssetPickerControllerDelegate>
{
    UIButton *addImageBtn;          //添加
    UIScrollView *imageScrollView;  //滑动的图
    NSMutableArray *removeButtons;
}
@end
@implementation AddImageViews

- (instancetype)initWithFrame:(CGRect)frame withDelegate:(id<AddImageViewsDelegate>)fromDelegate listArray:(NSArray *)listArray controller:(UIViewController *)supController
{
    self = [super initWithFrame:frame];
    if (self) {
        self.supViewController = supController;
        self.delegate = fromDelegate;
        _imageViewList = [NSMutableArray array];
        if (listArray) {
            _urlList = [NSMutableArray arrayWithArray:listArray];
        }else{
            _urlList = [NSMutableArray array];
        }
        removeButtons = [[NSMutableArray alloc]init];
        
        [self initwithSubViews];
    }
    return self;
}

- (void)initwithSubViews
{
    for (int i = 0 ; i< _urlList.count; i++) {
        UIImageView *tempImage = (UIImageView *)[_imageViewList lastObject];
        if (tempImage) {
            
            float frame_x = tempImage.right+15;
            float frame_y = tempImage.top;
            if (frame_x + ImageSizeWidth+10 > SCREENWIDTH+2) {
                frame_x = 10;
                frame_y = tempImage.bottom+10;
            }
            UIImageView *oneImageView = [[UIImageView alloc]initWithFrame:CGRectMake(frame_x, frame_y, ImageSizeWidth, ImageSizeWidth)];
            oneImageView.backgroundColor = [UIColor whiteColor];
            oneImageView.tag = i+1;
            oneImageView.clipsToBounds = YES;
            oneImageView.contentMode = UIViewContentModeScaleAspectFill;
            oneImageView.autoresizingMask= UIViewAutoresizingFlexibleWidth;
            [oneImageView sd_setImageWithURL:[NSURL URLWithString:_urlList[i]]];
            [self addSubview:oneImageView];
            TitleImageButton *removeBtn = [[TitleImageButton alloc]initWithFrame:CGRectMake(oneImageView.right-15, oneImageView.top-15, 30, 30) title:nil fontSize:14 ImageName:@"icon_remove.png" SelectedImage:@"icon_remove.png"];
            removeBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
            removeBtn.tag = oneImageView.tag+100;
            [removeBtn addTarget:self action:@selector(removeImageFromSelf:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:removeBtn];
            UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
            [oneImageView addGestureRecognizer:tap];
            oneImageView.userInteractionEnabled = YES;
            [_imageViewList addObject:oneImageView];
            [removeButtons addObject:removeBtn];

        }else{
            UIImageView *oneImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, ImageSizeWidth, ImageSizeWidth)];
            oneImageView.backgroundColor = [UIColor whiteColor];
            oneImageView.tag = i+1;
            oneImageView.clipsToBounds = YES;
            oneImageView.contentMode = UIViewContentModeScaleAspectFill;
            oneImageView.autoresizingMask= UIViewAutoresizingFlexibleWidth;
            [oneImageView sd_setImageWithURL:[NSURL URLWithString:_urlList[i]]];
            [self addSubview:oneImageView];
            TitleImageButton *removeBtn = [[TitleImageButton alloc]initWithFrame:CGRectMake(oneImageView.right-15, oneImageView.top-15, 30, 30) title:nil fontSize:14 ImageName:@"icon_remove.png" SelectedImage:@"icon_remove.png"];
            removeBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
            removeBtn.tag = oneImageView.tag+100;
            [removeBtn addTarget:self action:@selector(removeImageFromSelf:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:removeBtn];
            [removeButtons addObject:removeBtn];

            UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
            [oneImageView addGestureRecognizer:tap];
            oneImageView.userInteractionEnabled = YES;
            [_imageViewList addObject:oneImageView];
        }
    }
    UIImageView *lastImage = [_imageViewList lastObject];
    
    float addBtn_frame_x = 10;
    float addBtn_frame_y = 10;
    if (lastImage) {
        if (lastImage.right+ 15+ ImageSizeWidth+10 > SCREENWIDTH+2) {
            addBtn_frame_x = 10;
            addBtn_frame_y = lastImage.bottom + 10;
        }else{
            addBtn_frame_x = lastImage.right+ 15;
            addBtn_frame_y = lastImage.top;
        }
    }
    addImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addImageBtn.frame = CGRectMake(addBtn_frame_x, addBtn_frame_y, ImageSizeWidth, ImageSizeWidth);
    [addImageBtn setBackgroundImage:[UIImage imageNamed:@"icon_add_picture.png"] forState:UIControlStateNormal];
    [addImageBtn setBackgroundImage:[UIImage imageNamed:@"icon_add_picture_hover.png"] forState:UIControlStateHighlighted];
    addImageBtn.tag = 500;
    [addImageBtn addTarget:self action:@selector(clickAddImageBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:addImageBtn];
    
    self.frame = CGRectMake(0, self.frame.origin.y, SCREENWIDTH, addImageBtn.bottom);
    
}

#pragma mark -------------------------- 图片调整

- (void)imageViewInitFromeImageView:(UIImageView *)tempImage withImage:(UIImage *)image
{
    if (tempImage) {
        
        float frame_x = tempImage.right+15;
        float frame_y = tempImage.top;
        if (frame_x + ImageSizeWidth+10 > SCREENWIDTH+2) {
            frame_x = 10;
            frame_y = tempImage.bottom+10;
        }
        UIImageView *oneImageView = [[UIImageView alloc]initWithFrame:CGRectMake(frame_x, frame_y, ImageSizeWidth, ImageSizeWidth)];
        oneImageView.backgroundColor = [UIColor whiteColor];
        oneImageView.tag = tempImage.tag+1;
        oneImageView.image = image;
        oneImageView.clipsToBounds = YES;
        oneImageView.contentMode = UIViewContentModeScaleAspectFill;
        oneImageView.autoresizingMask= UIViewAutoresizingFlexibleWidth;
        TitleImageButton *removeBtn = [[TitleImageButton alloc]initWithFrame:CGRectMake(oneImageView.right-15, oneImageView.top-15, 30, 30) title:nil fontSize:14 ImageName:@"icon_remove.png" SelectedImage:@"icon_remove.png"];
        removeBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        [removeBtn addTarget:self action:@selector(removeImageFromSelf:) forControlEvents:UIControlEventTouchUpInside];
        removeBtn.tag = oneImageView.tag+100;
        [self addSubview:oneImageView];
        [self addSubview:removeBtn];
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [oneImageView addGestureRecognizer:tap];
        oneImageView.userInteractionEnabled = YES;
        [_imageViewList addObject:oneImageView];
        [removeButtons addObject:removeBtn];
        
    }else{
        UIImageView *oneImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, ImageSizeWidth, ImageSizeWidth)];
        oneImageView.backgroundColor = [UIColor whiteColor];
        oneImageView.clipsToBounds = YES;
        oneImageView.contentMode = UIViewContentModeScaleAspectFill;
        oneImageView.autoresizingMask= UIViewAutoresizingFlexibleWidth;
        oneImageView.tag = 1;
        TitleImageButton *removeBtn = [[TitleImageButton alloc]initWithFrame:CGRectMake(oneImageView.right-15, oneImageView.top-15, 30, 30) title:nil fontSize:14 ImageName:@"icon_remove.png" SelectedImage:@"icon_remove.png"];
        removeBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        [removeBtn addTarget:self action:@selector(removeImageFromSelf:) forControlEvents:UIControlEventTouchUpInside];
        removeBtn.tag = oneImageView.tag +100;
        [self addSubview:oneImageView];
        [self addSubview:removeBtn];
        oneImageView.image = image;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [oneImageView addGestureRecognizer:tap];
        oneImageView.userInteractionEnabled = YES;
        [_imageViewList addObject:oneImageView];
        [removeButtons addObject:removeBtn];

    }
    UIImageView *lastImg = (UIImageView *)[_imageViewList lastObject];
    float addBtn_frame_x = 10;
    float addBtn_frame_y = 10;
    if (lastImg) {
        if (lastImg.right +15 + ImageSizeWidth+10 > SCREENWIDTH+2) {
            addBtn_frame_x = 10;
            addBtn_frame_y = lastImg.bottom +10;
        }else{
            addBtn_frame_x = lastImg.right+15;
            addBtn_frame_y = lastImg.top;
        }
    }
    addImageBtn.frame = CGRectMake(addBtn_frame_x, addBtn_frame_y, ImageSizeWidth, ImageSizeWidth);
    self.frame = CGRectMake(0, self.frame.origin.y, SCREENWIDTH, addImageBtn.bottom);

    if (_delegate && [_delegate respondsToSelector:@selector(onImageViewFrameChaned)] && _supViewController) {
        [_delegate onImageViewFrameChaned];
    }

}

#pragma mark -------------------------- 点击添加图片
- (void)clickAddImageBtnAction:(UIButton *)sender
{
    if (_imageViewList.count>= 9) {
        [SVProgressHUD showErrorWithStatus:@"最多9张照片哦"];
        return;
    }
    
    UIActionSheet *actSheet = [[UIActionSheet alloc] initWithTitle: nil delegate: self cancelButtonTitle: @"取消" destructiveButtonTitle: nil otherButtonTitles: @"拍照", @"从手机相册选择" , nil];
    [actSheet showInView: self.supViewController.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == actionSheet.firstOtherButtonIndex) {
        
        // 拍照
        UIImagePickerController* controller = [[UIImagePickerController alloc] init];
        controller.delegate = self;
        // 拍照
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera] ) {
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            controller.showsCameraControls = YES;
        } else {
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        [self.supViewController.navigationController presentViewController: controller
                                                                 animated: YES
                                                               completion: NULL];
    } else if(buttonIndex == actionSheet.firstOtherButtonIndex + 1) {
        
       
        TJWAssetPickerController *zye = [[TJWAssetPickerController alloc]init];
        if([zye.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
        {
            [zye.navigationBar setBackgroundImage:[UIUtils imageFromColor:NAVIGATIONCOLOR] forBarMetrics:UIBarMetricsDefault];
            zye.navigationBar.tintColor = [UIColor whiteColor];
        }
        zye.maximumNumberOfSelection = 9 - _imageViewList.count;
        zye.assetsFilter = [ALAssetsFilter allPhotos];
        zye.showEmptyGroups = YES;
        zye.TJWdelegate = self;
        zye.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject,NSDictionary *bindings){
            if ([[(ALAsset *)evaluatedObject valueForProperty:ALAssetPropertyType]isEqual:ALAssetTypeVideo]) {
                NSTimeInterval duration = [[(ALAsset *)evaluatedObject valueForProperty:ALAssetPropertyDuration]doubleValue];
                return duration >= 5;
            }else{
                
                return  YES;
            }
        }];
        [self.supViewController presentViewController:zye animated:YES completion:nil];
    }
    
}

#pragma mark ----------------------------- UIImagePickerViewControllerDelegate

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage* image = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated: YES
                               completion: NULL];
    [self imageViewInitFromeImageView:[_imageViewList lastObject] withImage:image];
}

#pragma mark --------------------------- tjwphonoDelegate
-(void)assetPickerController:(TJWAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    if (assets.count> 0) {
        NSArray *tempArray = [NSArray arrayWithArray:assets];
        for (int i = 0 ; i< tempArray.count; i++) {
            ALAsset *oneAsset=tempArray[i];
            UIImage *tempImg=[UIImage imageWithCGImage:oneAsset.defaultRepresentation.fullScreenImage];
            if (tempImg) {
                [self imageViewInitFromeImageView:[_imageViewList lastObject] withImage:tempImg];
            }
        }
        
    }
    
}


-(void)tapAction:(UITapGestureRecognizer*)tap
{
    
    //预览图片
   JWPreviewPhotoController *previewPhoto = [[JWPreviewPhotoController alloc] init];
    previewPhoto.thumbArray = _imageViewList;
    previewPhoto.imageUrlArr = _urlList;
    previewPhoto.liftedImageView = (UIImageView*)tap.view;
    [_supViewController presentViewController:previewPhoto animated:YES completion:nil];
    
}


/*
 *移除照片
 */

- (void)removeImageFromSelf:(UIButton *)sender
{
    //删除图片
    NSInteger clickCurrent = sender.tag -101;
    
    UIImageView *deleteImg = (UIImageView *)[self viewWithTag:clickCurrent+1];
    if (deleteImg ) {
        [deleteImg removeFromSuperview];
    }
    TitleImageButton *deleteBtn = (TitleImageButton *)[self viewWithTag:sender.tag];
    if (deleteBtn) {
        [deleteBtn removeFromSuperview];
    }
    if (clickCurrent < _urlList.count) {
        [_urlList removeObjectAtIndex:clickCurrent];
    }
    [_imageViewList removeObjectAtIndex:clickCurrent];
    [removeButtons removeObjectAtIndex:clickCurrent];
    
    
    for (int i = clickCurrent; i< _imageViewList.count; i++) {
        
        
        UIImageView *operationImg = [_imageViewList objectAtIndex:i];
        
        float frame_x = 10;
        float frame_y = 10;
        
        if (i != 0) {
            UIImageView *lastImg = [_imageViewList objectAtIndex:i-1];
            frame_x = lastImg.right+15;
            frame_y = lastImg.top;
            if (frame_x + ImageSizeWidth+10 > SCREENWIDTH+2) {
                frame_x = 10;
                frame_y = lastImg.bottom+10;
            }
        }
        
        operationImg.frame = CGRectMake(frame_x, frame_y, ImageSizeWidth, ImageSizeWidth);
        operationImg.tag = i+1;
        
        UIButton *tempRemoveBtn = [removeButtons objectAtIndex:i];
        tempRemoveBtn.frame = CGRectMake(operationImg.right-15, operationImg.top -15, 30, 30);
        tempRemoveBtn.tag = operationImg.tag +100;
        
    }
    UIImageView *lastImg = (UIImageView *)[_imageViewList lastObject];
    float addBtn_frame_x = 10;
    float addBtn_frame_y = 10;
    if (lastImg) {
        if (lastImg.right +15 + ImageSizeWidth+10 > SCREENWIDTH+2) {
            addBtn_frame_x = 10;
            addBtn_frame_y = lastImg.bottom +10;
        }else{
            addBtn_frame_x = lastImg.right+15;
            addBtn_frame_y = lastImg.top;
        }
    }
    addImageBtn.frame = CGRectMake(addBtn_frame_x, addBtn_frame_y, ImageSizeWidth, ImageSizeWidth);
    self.frame = CGRectMake(0, self.frame.origin.y, SCREENWIDTH, addImageBtn.bottom);
    
    if (_delegate && [_delegate respondsToSelector:@selector(onImageViewFrameChaned)] && _supViewController) {
        [_delegate onImageViewFrameChaned];
    }
}

- (void)dealloc
{
    _supViewController = nil;
    _imageViewList = nil;
    _urlList = nil;
    _delegate = nil;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
