//
//  JPIntercom.h
//  JPIntercom
//
//  Created by JaryPan on 15/10/12.
//  Copyright © 2015年 JaryPan. All rights reserved.
//

/************** 按钮的两张图片来自LCVoiceHud，仅供演示参考 *************/

#import <UIKit/UIKit.h>
#import "JPColorPillar.h"

// 设置代理方法
@protocol JPIntercomViewDelegate <NSObject>

@optional
- (void)speakingBegan;
- (void)speakingWhileTouchMoving;
- (void)speakingEnded;
- (void)speakingCancelled;
- (void)speakingFailed;

@end

@interface JPIntercomView : UIView

@property (strong, nonatomic) JPColorPillar *colorPillar; // 音柱图
@property (strong, nonatomic) UIView *pillarBottomLine; // 音柱底部分隔线
@property (strong, nonatomic) UIView *speakingMarkView; // 对讲开始标志
@property (strong, nonatomic) UIImageView *speakingImageView; // 对讲按钮

@property (assign, nonatomic) NSTimeInterval colorChangeInterval; // 音柱颜色改变间隔
@property (assign, nonatomic) NSTimeInterval voiceCheckingInterval; // 声音检测间隔（越小精度越高，同时音柱高度变化越快，默认0.1）

@property (assign, nonatomic) id<JPIntercomViewDelegate>delegate; // 代理属性


- (JPIntercomView *)initWithFrame:(CGRect)frame
                   pillarViewSize:(CGSize)pillarViewSize // 音柱图的整体大小
        pillarViewBackgroundColor:(UIColor *)pillarViewBackgroundColor
        pillarViewBackgroundImage:(UIImage *)pillarViewBackgroundImage
                      pillarWidth:(CGFloat)pillarWidth
                 pillarModelStyle:(PillarModelStyle)pillarModelStyle
               pillarSpacingStyle:(PillarSpacingStyle)pillarSpacingStyle
                  pillarWaveStyle:(PillarWaveStyle)pillarWaveStyle
                 pillarColorStyle:(PillarColorStyle)pillarColorStyle
                        coatImage:(UIImage *)coatImage // 外套图片（必须为镂空或者透明图片，可以为nil，用来罩住音柱）
                   coatImageAlpha:(CGFloat)coatImageAlpha // 也可以自己设置外套图片的透明度
              colorChangeInterval:(NSTimeInterval)colorChangeInterval; // 颜色改变间隔
// 类方法
+ (JPIntercomView *)jpIntercomViewWithFrame:(CGRect)frame
                             pillarViewSize:(CGSize)pillarViewSize
                  pillarViewBackgroundColor:(UIColor *)pillarViewBackgroundColor
                  pillarViewBackgroundImage:(UIImage *)pillarViewBackgroundImage
                                pillarWidth:(CGFloat)pillarWidth
                           pillarModelStyle:(PillarModelStyle)pillarModelStyle
                         pillarSpacingStyle:(PillarSpacingStyle)pillarSpacingStyle
                            pillarWaveStyle:(PillarWaveStyle)pillarWaveStyle
                           pillarColorStyle:(PillarColorStyle)pillarColorStyle
                                  coatImage:(UIImage *)coatImage
                             coatImageAlpha:(CGFloat)coatImageAlpha
                        colorChangeInterval:(NSTimeInterval)colorChangeInterval;

@end
