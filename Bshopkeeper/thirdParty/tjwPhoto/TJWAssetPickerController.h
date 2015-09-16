//
//  TJWAssetPickerController.m
//  TJWAssetPickerControllerDemo
//
//  Created by jinwei on 15-04-18.
//  Copyright (c) 2015年 weimi. All rights reserved.
//



#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

#pragma mark - TJWAssetPickerController

@protocol TJWAssetPickerControllerDelegate;

@interface TJWAssetPickerController : UINavigationController

@property (nonatomic, weak) id <UINavigationControllerDelegate, TJWAssetPickerControllerDelegate> TJWdelegate;



@property (nonatomic, strong) ALAssetsFilter *assetsFilter;

@property (nonatomic, copy, readonly) NSArray *indexPathsForSelectedItems;

@property (nonatomic, assign) NSInteger maximumNumberOfSelection;
@property (nonatomic, assign) NSInteger minimumNumberOfSelection;

@property (nonatomic, strong) NSPredicate *selectionFilter;

@property (nonatomic, assign) BOOL showCancelButton;

@property (nonatomic, assign) BOOL showEmptyGroups;

@property (nonatomic, assign) BOOL isFinishDismissViewController;



@end

@protocol TJWAssetPickerControllerDelegate <NSObject>

-(void)assetPickerController:(TJWAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets;

@optional

-(void)assetPickerControllerDidCancel:(TJWAssetPickerController *)picker;

-(void)assetPickerController:(TJWAssetPickerController *)picker didSelectAsset:(ALAsset*)asset;

-(void)assetPickerController:(TJWAssetPickerController *)picker didDeselectAsset:(ALAsset*)asset;


@end

#pragma mark - TJWAssetViewController

@interface TJWAssetViewController : UITableViewController

@property (nonatomic, strong) ALAssetsGroup *assetsGroup;
@property (nonatomic, strong) NSMutableArray *indexPathsForSelectedItems;

@property (nonatomic,assign) NSInteger number;     //新加的，选中的张数

@end


#pragma mark - TJWTapAssetView

@protocol TJWTapAssetViewDelegate <NSObject>

-(void)touchSelect:(BOOL)select;
-(BOOL)shouldTap;

@end

@interface TJWTapAssetView : UIView

@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) BOOL disabled;
@property (nonatomic, weak) id<TJWTapAssetViewDelegate> delegate;

@end

#pragma mark - TJWAssetView

@protocol TJWAssetViewDelegate <NSObject>

-(BOOL)shouldSelectAsset:(ALAsset*)asset;
-(void)tapSelectHandle:(BOOL)select asset:(ALAsset*)asset;

@end

@interface TJWAssetView : UIView

- (void)bind:(ALAsset *)asset selectionFilter:(NSPredicate*)selectionFilter isSeleced:(BOOL)isSeleced;

@end

#pragma mark - TJWAssetViewCell

@protocol TJWAssetViewCellDelegate;

@interface TJWAssetViewCell : UITableViewCell

@property(nonatomic,weak)id<TJWAssetViewCellDelegate> delegate;

- (void)bind:(NSArray *)assets selectionFilter:(NSPredicate*)selectionFilter minimumInteritemSpacing:(float)minimumInteritemSpacing minimumLineSpacing:(float)minimumLineSpacing columns:(int)columns assetViewX:(float)assetViewX;

@end

@protocol TJWAssetViewCellDelegate <NSObject>

- (BOOL)shouldSelectAsset:(ALAsset*)asset;
- (void)didSelectAsset:(ALAsset*)asset;
- (void)didDeselectAsset:(ALAsset*)asset;

@end

#pragma mark - TJWAssetGroupViewCell

@interface TJWAssetGroupViewCell : UITableViewCell

- (void)bind:(ALAssetsGroup *)assetsGroup;

@end

#pragma mark - TJWAssetGroupViewController

@interface TJWAssetGroupViewController : UITableViewController

@end

