//
//  ColorPillar.h
//  ColorPillar
//
//  Created by JaryPan on 15/10/12.
//  Copyright © 2015年 JaryPan. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - typedef enum 定义枚举类型
typedef enum : NSUInteger {
    PillarModelStyleSevenColorVerticalNext, // 七彩色竖直紧挨
    PillarModelStyleSevenColorVerticalEquallySpaced, // 七彩色竖直等间隔
    PillarModelStyleNomal, // 一般音柱
} PillarModelStyle; // 音柱模型风格（如果不是一般音柱，颜色变化不起作用）

typedef enum : NSUInteger {
    PillarSpacingStyleNext, // 紧挨 （此风格下七彩音柱本质上是一个大的label，一些效果不能实现）
    PillarSpacingStyleEquallySpaced, // 等间距分隔
} PillarSpacingStyle; // 音柱分隔风格

typedef enum : NSUInteger {
    PillarWaveStyleLevel, // 平整
    PillarWaveStyleBoiling, // 沸腾
    PillarWaveStyleMiddleLevelWavecrest, // 中心平整波峰
    PillarWaveStyleMiddleBoilingWavecrest, // 中心沸腾波峰
    PillarWaveStyleIncreasingSmoothlyToRight, // 向右平稳递增
    PillarWaveStyleIncreasingBoilinglyToRight, // 向右沸腾递增
    PillarWaveStyleIncreasingSmoothlyToLeft, // 向左平稳递增
    PillarWaveStyleIncreasingBoilinglyToLeft, // 向左沸腾递增
    PillarWaveStyleElectrocardiographyToRight, // 心电图向右
    PillarWaveStyleElectrocardiographyToLeft, // 心电图向左
} PillarWaveStyle; // 音柱波浪风格

typedef enum : NSUInteger {
    PillarColorStyleSingleWhiteblackChanging, // 单一黑白色渐变
    PillarColorStyleVariousRandomColor, // 多种随机色
    PillarColorStyleSingleColourfulChanging, // 单一靓丽颜色渐变
    PillarColorStyleVariousColourfulChanging, // 多种靓丽颜色交替渐变
    PillarColorStyleSevenColorHorizontalChanging, // 七彩色水平渐变
} PillarColorStyle; // 音柱颜色变化风格 （只对一般音柱有效）

#pragma mark - @interface ColorPillar : UIView
@interface JPColorPillar : UIView

@property (assign, nonatomic) BOOL hasColorTransitionEffect; // 颜色变化过渡效果（默认为NO）
@property (assign, nonatomic) NSInteger boilingLevel; // 沸腾效果的程度（随机跳跃高度上限，默认为5）

// 初始化方法
- (JPColorPillar *)initWithFrame:(CGRect)frame
                 backgroundColor:(UIColor *)backgroundColor
                 backgroundImage:(UIImage *)backgroundImage
                     pillarWidth:(CGFloat)pillarWidth
                pillarModelStyle:(PillarModelStyle)pillarModelStyle
              pillarSpacingStyle:(PillarSpacingStyle)pillarSpacingStyle
                 pillarWaveStyle:(PillarWaveStyle)pillarWaveStyle
                pillarColorStyle:(PillarColorStyle)pillarColorStyle
                       coatImage:(UIImage *)coatImage // 外套图片（必须为镂空或者透明图片，可以为nil，用来罩住音柱）
                coatImageAlpha:(CGFloat)coatImageAlpha; // 也可以自己设置外套图片的透明度
// 类方法
+ (JPColorPillar *)jpColorPillarWithFrame:(CGRect)frame
                          backgroundColor:(UIColor *)backgroundColor
                          backgroundImage:(UIImage *)backgroundImage
                              pillarWidth:(CGFloat)pillarWidth
                         pillarModelStyle:(PillarModelStyle)pillarModelStyle
                       pillarSpacingStyle:(PillarSpacingStyle)pillarSpacingStyle
                          pillarWaveStyle:(PillarWaveStyle)pillarWaveStyle
                         pillarColorStyle:(PillarColorStyle)pillarColorStyle
                                coatImage:(UIImage *)coatImage
                           coatImageAlpha:(CGFloat)coatImageAlpha;

- (void)startChangeColorWithInterval:(NSTimeInterval)interval;
- (void)stopChangeColor;

- (void)startChangeHeightWithVerticalHeight:(float)verticalHeight andTimeInterval:(NSTimeInterval)timeInterval;
- (void)stopChangeHeight;

@end
