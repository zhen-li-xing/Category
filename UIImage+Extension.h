//
//  UIImage+Extension.h
//  SomeFunction
//
//  Created by 李震 on 16/8/7.
//  Copyright © 2016年 lizhen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

/**
 *  返回拉伸图片
 */
+ (UIImage *)resizedImage:(NSString *)name;
/**
 *  用颜色返回一张图片
 */
+ (UIImage *)createImageWithColor:(UIColor*) color;
/**
 *  带边框的图片
 *
 *  @param name        图片名字
 *  @param borderWidth 边框宽度
 *  @param borderColor 边框颜色
 */
+ (instancetype)circleImageWithName:(NSString *)name borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

/**
 *  带边框的图片
 *
 *  @param name        图片
 *  @param borderWidth 边框宽度
 *  @param borderColor 边框颜色
 */
+ (instancetype)circleImageWithImage:(UIImage *)image borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;


/**
 *  使用图像名创建图像视图
 *
 *  @param imageName 图像名称
 *
 *  @return UIImageView
 */
+ (instancetype)imageViewWithImageName:(NSString *)imageName;


/**
 *  获取屏幕截图
 *
 *  @return 屏幕截图图像
 */
+ (UIImage *)screenShot;

/**
 *  根据url获取图片的尺寸(像素分辨率)
 *
 *  @param imageURL url地址
 *
 *  @return CGSize
 */
+ (CGSize)getImageSizeWithURL:(id)imageURL;

@end
