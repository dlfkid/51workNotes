//
//  MyTools.h
//  MyTools
//
//  Created by Ivan_deng on 2016/12/12.
//  Copyright © 2016年 Ivan_deng. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//! Project version number for MyTools.
FOUNDATION_EXPORT double MyToolsVersionNumber;

//! Project version string for MyTools.
FOUNDATION_EXPORT const unsigned char MyToolsVersionString[];


// In this header, you should import all the public headers of your framework using statements like #import <MyTools/PublicHeader.h>
@interface MyTools : NSObject
/**
 *  UIColor 转UIImage
 *
 *  @param color <#color description#>
 *
 *  @return <#return value description#>
 */
+(UIImage*)ChangeUIColorToUIImage: (UIColor*) color;

/**
 *  UIImage转UIColor
 *
 *  @param pngName <#pngName description#>
 *
 *  @return <#return value description#>
 */
+(UIColor *)ChangeUIImageToUIColor:(NSString *)pngName;

/**
 *  UIView转UIImage
 *
 *  @param v <#v description#>
 *
 *  @return <#return value description#>
 */
+(UIImage*)convertViewToImage:(UIView*)v;

/**
 *  根据给定的图片，从其指定区域截取一张新的图片
 *
 *  @param img <#img description#>
 *
 *  @return <#return value description#>
 */
+(UIImage *)getImageFromImage:(UIImage *)img;

/**
 *  十六进制转换为普通字符串的。
 *
 *  @param hexString <#hexString description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)stringFromHexString:(NSString *)hexString;

/**
 *  普通字符串转换为十六进制的。
 *
 *  @param string <#string description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)hexStringFromString:(NSString *)string;

/**
 *  颜色转换 IOS中十六进制的颜色转换为UIColor
 *
 *  @param color <#color description#>
 *
 *  @return <#return value description#>
 */
+ (UIColor *) colorWithHexString: (NSString *)color;

/**
 *  绘图
 *
 *  @param colorName <#colorName description#>
 *
 *  @return <#return value description#>
 */
+(UIImage *)drawcolorInImage:(NSString *)colorName;

/**
 *  图片缩放到指定大小尺寸
 *
 *  @param img  <#img description#>
 *  @param size <#size description#>
 *
 *  @return <#return value description#>
 */
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;

@end



