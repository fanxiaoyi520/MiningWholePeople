//
//  ZZPhotoDatas.h
//  ZZFramework
//
//  Created by Yuan on 15/12/17.
//  Copyright © 2015年 zzl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZResourceConfig.h"
@interface ZZPhotoDatas : NSObject
/**
 获取全部相册

 @return array 集合
 */
- (void) fetchPhotoListDatasCompletion:(void(^)(NSArray *data))completion;

/**
 获取某个相册的全部照片实体

 @param collection 相册集合

 @return 相册中全部实体
 */
- (PHFetchResult *) GetFetchResult:(PHAssetCollection *)collection;

/**
 获取图片实体，并把图片结果存放到数组中，返回值数组

 @param fetchResult

 @return array 集合<PHAsset>
 */
- (void)fetchPhotoAssets:(PHFetchResult *)fetchResult completion:(void(^)(NSArray *data))completion;

/**
 获取相机胶卷中的结果集

 @return 集合
 */
- (PHFetchResult *) fetchCameraRollFetchResult;

/**
 回调方法使用数组

 @param asset       照片实体
 @param complection 回调方法
 */
- (void) fetchImageObject:(id)asset complection:(void (^)(UIImage *,NSURL *))complection;

/**
 检测是否为iCloud资源

 @param asset 照片实体

 @return 是否
 */
- (BOOL) CheckIsiCloudAsset:(PHAsset *)asset;

@end
