//
//  ColorPillar.m
//  ColorPillar
//
//  Created by JaryPan on 15/10/12.
//  Copyright © 2015年 JaryPan. All rights reserved.
//

#import "JPColorPillar.h"
#import "JPColorfulLabel.h"

@interface JPColorPillar ()

@property (assign, nonatomic) CGFloat pillarWidth;
@property (strong, nonatomic) UIImage *backgroundImage;
@property (assign, nonatomic) PillarSpacingStyle pillarSpacingStyle;
@property (assign ,nonatomic) PillarWaveStyle pillarWaveStyle;
@property (assign, nonatomic) PillarColorStyle pillarColorStyle;
@property (assign, nonatomic) PillarModelStyle pillarModelStyle;
@property (strong, nonatomic) UIImage *coatImage;
@property (assign, nonatomic) float coatImageAlpha;

@property (strong, nonatomic) NSTimer *changeColorTimer; // 改变颜色
@property (assign, nonatomic) NSTimeInterval interval; // 颜色改变间隔
@property (strong, nonatomic) UIColor *singleColourful; // 单一靓丽色

// 设计波浪滚动效果需要的参数
//@property (strong, nonatomic) NSTimer *moveWaveTimer; // 用于设计波浪滚动快慢时间间隔
@property (assign, nonatomic) int pillarCount; // 音柱个数
@property (assign, nonatomic) NSInteger labelTag; // 标记label的tag值
@property (copy, nonatomic) NSString *MoveDirection; // 标记心电图前进方向

@end

@implementation JPColorPillar

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
                coatImageAlpha:(CGFloat)coatImageAlpha // 也可以自己设置外套图片的透明度
{
    if (self = [super init]) {
        self.frame = frame;
        self.backgroundColor = backgroundColor;
        self.backgroundImage = backgroundImage;
        self.pillarWidth = pillarWidth;
        self.pillarSpacingStyle = pillarSpacingStyle;
        self.pillarWaveStyle = pillarWaveStyle;
        self.pillarColorStyle = pillarColorStyle;
        self.pillarModelStyle = pillarModelStyle;
        self.coatImage = coatImage;
        self.coatImageAlpha = coatImageAlpha;
        
        self.labelTag = 999;
        
        [self addSubviews];
    }
    
    return self;
}
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
                           coatImageAlpha:(CGFloat)coatImageAlpha
{
    return [[JPColorPillar alloc]initWithFrame:frame backgroundColor:backgroundColor backgroundImage:backgroundImage pillarWidth:pillarWidth pillarModelStyle:pillarModelStyle pillarSpacingStyle:pillarSpacingStyle pillarWaveStyle:pillarWaveStyle pillarColorStyle:pillarColorStyle coatImage:coatImage coatImageAlpha:coatImageAlpha];
}

#pragma mark - addSubviews 添加子控件
- (void)addSubviews
{
    // 是否有背景图
    if (self.backgroundImage) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.image = self.backgroundImage;
        [self addSubview:imageView];
    }
    
    // 创建音柱
    // 判断音柱模型
    if (self.pillarModelStyle == PillarModelStyleSevenColorVerticalEquallySpaced) {
        // 1、七彩色竖直等间隔
        int count = self.frame.size.width/self.pillarWidth;
        // 判断各竖直音柱之间是否水平紧挨
        if (self.pillarSpacingStyle == PillarSpacingStyleNext) {
            // 创建一个大的label
            JPColorfulLabel *colorfulLabel = [JPColorfulLabel jpColorfulLabelWithFrame:CGRectMake(0, 0, self.frame.size.width, 0) labelSpacingStyle:LabelSpacingStyleNext];
            colorfulLabel.tag = 1000;
            colorfulLabel.elementHeight = self.pillarWidth/3;
            [self addSubview:colorfulLabel];
        } else {
            if (count%2 == 1) {
                // 如果是奇数，要加1变为偶数
                count++;
            }
            for (int i = 0; i < count/2; i++) {
                JPColorfulLabel *colorfulLabel = [JPColorfulLabel jpColorfulLabelWithFrame:CGRectMake(i*2*self.pillarWidth, 0, self.pillarWidth, 0) labelSpacingStyle:LabelSpacingStyleEquallySpaced];
                colorfulLabel.tag = 1000 + i;
                [self addSubview:colorfulLabel];
            }
        }
    } else if (self.pillarModelStyle == PillarModelStyleSevenColorVerticalNext) {
        // 2、七彩色竖直紧挨
        int count = self.frame.size.width/self.pillarWidth;
        // 判断各竖直音柱之间是否水平紧挨
        if (self.pillarSpacingStyle == PillarSpacingStyleNext) {
            // 创建一个大的label
            JPColorfulLabel *colorfulLabel = [JPColorfulLabel jpColorfulLabelWithFrame:CGRectMake(0, 0, self.frame.size.width, 0) labelSpacingStyle:LabelSpacingStyleNext];
            colorfulLabel.tag = 1000;
            colorfulLabel.elementHeight = self.pillarWidth/3;
            [self addSubview:colorfulLabel];
        } else {
            if (count%2 == 1) {
                // 如果是奇数，要加1变为偶数
                count++;
            }
            for (int i = 0; i < count/2; i++) {
                JPColorfulLabel *colorfulLabel = [JPColorfulLabel jpColorfulLabelWithFrame:CGRectMake(i*2*self.pillarWidth, 0, self.pillarWidth, 0) labelSpacingStyle:LabelSpacingStyleNext];
                colorfulLabel.tag = 1000 + i;
                [self addSubview:colorfulLabel];
            }
        }
    } else {
        // 3、一般音柱
        int count = self.frame.size.width/self.pillarWidth;
        
        if (self.pillarSpacingStyle == PillarSpacingStyleNext) {
            for (int i = 0; i < count; i++) {
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(i*self.pillarWidth, 0, self.pillarWidth, 0)];
                label.tag = 1000 + i;
                [self addSubview:label];
            }
        } else {
            if (count%2 == 1) {
                // 如果是奇数，要加一变为偶数
                count++;
            }
            for (int i = 0; i < count/2; i++) {
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(i*2*self.pillarWidth, 0, self.pillarWidth, 0)];
                label.tag = 1000 + i;
                [self addSubview:label];
            }
        }
    }
    
    // 是否添加外套图片（有了就添加）
    if (self.coatImage) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        imageView.image = self.coatImage;
        imageView.alpha = self.coatImageAlpha;
        [self addSubview:imageView];
    }
}


#pragma mark - 开始、停止改变颜色
- (void)startChangeColorWithInterval:(NSTimeInterval)interval
{
    // 只对一般音柱有效
    if (self.pillarModelStyle == PillarModelStyleNomal) {
        // 随机生成一种靓丽色
        self.singleColourful = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:arc4random()%41/100 + 0.6];
        self.interval = interval; // 记住颜色改变的间隔
        
        if (self.changeColorTimer) {
            [self.changeColorTimer invalidate];
            self.changeColorTimer = nil;
        }
        self.changeColorTimer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(changeColor) userInfo:nil repeats:YES];
        [self.changeColorTimer fire]; // 该方法可以立即开始changeColor方法，不用等待 interval 时间间隔之后
    }
}
- (void)stopChangeColor
{
    for (UILabel *label in [self subviews]) {
        if ([label isKindOfClass:[UILabel class]]) {
            label.backgroundColor = [UIColor clearColor];
        }
    }
    
    [self.changeColorTimer invalidate];
    self.changeColorTimer = nil;
}
- (void)changeColor
{
    if (self.pillarColorStyle == PillarColorStyleSingleWhiteblackChanging) {
        // 单一黑白色渐变
        float random = arc4random()%256/255.0;
        if (random>0.5) {
            for (UILabel *label in [self subviews]) {
                if ([label isKindOfClass:[UILabel class]]) {
                    label.backgroundColor = [UIColor colorWithRed:random green:random blue:random alpha:1.0];
                }
                random = random - 0.01;
            }
        } else {
            for (UILabel *label in [self subviews]) {
                if ([label isKindOfClass:[UILabel class]]) {
                    label.backgroundColor = [UIColor colorWithRed:random green:random blue:random alpha:1.0];
                }
                random = random + 0.01;
            }
        }
    } else if (self.pillarColorStyle == PillarColorStyleVariousRandomColor) {
        // 多种随机色
        for (UILabel *label in [self subviews]) {
            if ([label isKindOfClass:[UILabel class]]) {
                label.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1.0];
            }
        }
    } else if (self.pillarColorStyle == PillarColorStyleSingleColourfulChanging) {
        // 单一靓丽颜色
        for (UILabel *label in [self subviews]) {
            if ([label isKindOfClass:[UILabel class]]) {
                label.backgroundColor = self.singleColourful;
            }
        }
    }  else if (self.pillarColorStyle == PillarColorStyleVariousColourfulChanging) {
        // 多种靓丽颜色交替渐变
        float random = arc4random()%256/255.0;
        if (random>0.5) {
            // 随机选择渐变颜色
            // 制造出六种随机渲染颜色
            int randomColor = arc4random()%6;
            if (randomColor == 0) {
                for (UILabel *label in [self subviews]) {
                    if ([label isKindOfClass:[UILabel class]]) {
                        label.backgroundColor = [UIColor colorWithRed:random green:random/4 blue:random/4 alpha:1.0];
                    }
                    random = random - 0.01;
                }
            } else if (randomColor == 1) {
                for (UILabel *label in [self subviews]) {
                    if ([label isKindOfClass:[UILabel class]]) {
                        label.backgroundColor = [UIColor colorWithRed:random/4 green:random blue:random/4 alpha:1.0];
                    }
                    random = random - 0.01;
                }
            } else if (randomColor == 2) {
                for (UILabel *label in [self subviews]) {
                    if ([label isKindOfClass:[UILabel class]]) {
                        label.backgroundColor = [UIColor colorWithRed:random/4 green:random/4 blue:random alpha:1.0];
                    }
                    random = random - 0.01;
                }
            }  else if (randomColor == 3) {
                for (UILabel *label in [self subviews]) {
                    if ([label isKindOfClass:[UILabel class]]) {
                        label.backgroundColor = [UIColor colorWithRed:random/4 green:random blue:random alpha:1.0];
                    }
                    random = random - 0.01;
                }
            } else if (randomColor == 4) {
                for (UILabel *label in [self subviews]) {
                    if ([label isKindOfClass:[UILabel class]]) {
                        label.backgroundColor = [UIColor colorWithRed:random green:random/4 blue:random alpha:1.0];
                    }
                    random = random - 0.01;
                }
            } else if (randomColor == 5) {
                for (UILabel *label in [self subviews]) {
                    if ([label isKindOfClass:[UILabel class]]) {
                        label.backgroundColor = [UIColor colorWithRed:random green:random blue:random/4 alpha:1.0];
                    }
                    random = random - 0.01;
                }
            }
        } else {
            // 随机选择渐变颜色
            // 制造出六种随机渲染颜色
            int randomColor = arc4random()%6;
            if (randomColor == 0) {
                for (UILabel *label in [self subviews]) {
                    if ([label isKindOfClass:[UILabel class]]) {
                        label.backgroundColor = [UIColor colorWithRed:random green:random/4 blue:random/4 alpha:1.0];
                    }
                    random = random + 0.01;
                }
            } else if (randomColor == 1) {
                for (UILabel *label in [self subviews]) {
                    if ([label isKindOfClass:[UILabel class]]) {
                        label.backgroundColor = [UIColor colorWithRed:random/4 green:random blue:random/4 alpha:1.0];
                    }
                    random = random + 0.01;
                }
            } else if (randomColor == 2) {
                for (UILabel *label in [self subviews]) {
                    if ([label isKindOfClass:[UILabel class]]) {
                        label.backgroundColor = [UIColor colorWithRed:random/4 green:random/4 blue:random alpha:1.0];
                    }
                    random = random + 0.01;
                }
            } else if (randomColor == 3) {
                for (UILabel *label in [self subviews]) {
                    if ([label isKindOfClass:[UILabel class]]) {
                        label.backgroundColor = [UIColor colorWithRed:random/4 green:random blue:random alpha:1.0];
                    }
                    random = random + 0.01;
                }
            } else if (randomColor == 4) {
                for (UILabel *label in [self subviews]) {
                    if ([label isKindOfClass:[UILabel class]]) {
                        label.backgroundColor = [UIColor colorWithRed:random green:random/4 blue:random alpha:1.0];
                    }
                    random = random + 0.01;
                }
            } else if (randomColor == 5) {
                for (UILabel *label in [self subviews]) {
                    if ([label isKindOfClass:[UILabel class]]) {
                        label.backgroundColor = [UIColor colorWithRed:random green:random blue:random/4 alpha:1.0];
                    }
                    random = random + 0.01;
                }
            }
        }
    } else {
        // 七彩色水平渐变
        int count = 0;
        int i = 0;
        int _temp = 0;
        if (self.pillarSpacingStyle == PillarSpacingStyleNext) {
            count = self.frame.size.width/self.pillarWidth;
            _temp = 10;
        } else {
            count = self.frame.size.width/self.pillarWidth/2;
            _temp = 20;
        }
        float temp = 0;
        
        while (count%7 != 0) {
            count++;
        }
        
        for (UILabel *label in [self subviews]) {
            if ([label isKindOfClass:[UILabel class]]) {
                if (i < count/7) {
                    // 红-橙
                    temp = temp*2 <= 165 ? temp : (165.0/2);
                    label.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:temp*2/255.0 blue:0/255.0 alpha:1.0];
                } else if (i < count * 2/7) {
                    // 橙-黄
                    temp = temp < (255 - 165) ? temp : (255 - 165);
                    label.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:(165.0 + temp)/255.0 blue:0/255.0 alpha:1.0];
                } else if (i < count * 3/7) {
                    // 黄-绿
                    temp = (255.0-2*temp) >= 0 ? temp : (255.0/2);
                    label.backgroundColor = [UIColor colorWithRed:(255.0-2*temp)/255.0 green:255.0/255.0 blue:0/255.0 alpha:1.0];
                } else if (i < count * 4/7) {
                    // 绿-青
                    temp = temp <= 255.0/2 ? temp : 255.0/2;
                    label.backgroundColor = [UIColor colorWithRed:0/255.0 green:255.0/255.0 blue:2*temp/255.0 alpha:1.0];
                } else if (i < count * 5/7) {
                    // 青-蓝
                    temp = (255.0-2*temp) >= 0 ? temp : (255.0/2);
                    label.backgroundColor = [UIColor colorWithRed:0/255.0 green:(255.0-2*temp)/255.0 blue:255.0/255.0 alpha:1.0];
                } else if (i < count * 6/7) {
                    // 蓝-紫
                    temp = temp <= 255.0/2 ? temp : 255.0/2;
                    label.backgroundColor = [UIColor colorWithRed:2*temp/255.0 green:0/255.0 blue:255.0/255.0 alpha:1.0];
                } else {
                    // 紫-黑
                    temp = (255.0-2*temp) >= 0 ? temp : (255.0/2);
                    label.backgroundColor = [UIColor colorWithRed:(255.0-2*temp)/255.0 green:0/255.0 blue:(255.0-2*temp)/255.0 alpha:1.0];
                }
                
                i++;
                temp += _temp;
                if (i % (count/7) == 0) {
                    temp = 0;
                }
            }
        }
    }
    
    // 是否渐变label透明度
    if (self.hasColorTransitionEffect) {
        [self changeLabelAlpha];
    }
}
#pragma mark - changeLabelAlpha 改变label透明度
- (void)changeLabelAlpha
{
    for (UILabel *label in [self subviews]) {
        if ([label isKindOfClass:[UILabel class]]) {
            label.alpha = 0.5;
        }
    }
    [UIView animateWithDuration:self.interval/2 animations:^{
        for (UILabel *label in [self subviews]) {
            if ([label isKindOfClass:[UILabel class]]) {
                label.alpha = 1.0;
            }
        }
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:self.interval/2 animations:^{
            for (UILabel *label in [self subviews]) {
                if ([label isKindOfClass:[UILabel class]]) {
                    label.alpha = 0.5;
                }
            }
        }];
    }];
}


#pragma mark - 开始、停止改变高度
- (void)startChangeHeightWithVerticalHeight:(float)verticalHeight andTimeInterval:(NSTimeInterval)timeInterval
{
    if (self.pillarWaveStyle == PillarWaveStyleLevel) {
        // 平整
        for (UILabel *label in [self subviews]) {
            if ([label isKindOfClass:[UILabel class]]) {
                // 不允许超过父视图高度
                verticalHeight = verticalHeight < self.frame.size.height ? verticalHeight : self.frame.size.height;
                label.frame = CGRectMake(label.frame.origin.x, self.frame.size.height - verticalHeight, label.frame.size.width, verticalHeight);
            }
        }
    } else if (self.pillarWaveStyle == PillarWaveStyleBoiling) {
        // 沸腾
        for (UILabel *label in [self subviews]) {
            if ([label isKindOfClass:[UILabel class]]) {
                NSInteger randomHeight = 0;
                if (self.boilingLevel != 0) {
                    randomHeight = arc4random()%self.boilingLevel;
                } else {
                    randomHeight = arc4random()%5;
                }
                
                // 不允许超过父视图高度
                randomHeight = (randomHeight + verticalHeight) < self.frame.size.height ? randomHeight : (self.frame.size.height - verticalHeight);
                label.frame = CGRectMake(label.frame.origin.x, self.frame.size.height - verticalHeight - randomHeight, label.frame.size.width, verticalHeight + randomHeight);
            }
        }
    } else if (self.pillarWaveStyle == PillarWaveStyleMiddleLevelWavecrest) {
        // 中心平整波峰;
        int count = 0;
        // 对于不同的分隔风格，对应的音柱个数不同
        if (self.pillarSpacingStyle == PillarSpacingStyleNext) {
            count = self.frame.size.width/self.pillarWidth;
        } else {
            count = self.frame.size.width/self.pillarWidth/2;
        }
        int temp = 0;
        float temp1 = 0;
        float temp2 = 0;
        for (UILabel *label in [self subviews]) {
            if ([label isKindOfClass:[UILabel class]]) {
                if (temp < count/2) {
                    // 不允许超过父视图高度
                    float tempHeight = (temp1 + verticalHeight) < self.frame.size.height ? (temp1 + verticalHeight) : self.frame.size.height;
                    label.frame = CGRectMake(label.frame.origin.x, self.frame.size.height - tempHeight, label.frame.size.width, tempHeight);
                    
                    if (self.pillarSpacingStyle == PillarSpacingStyleNext) {
                        temp1 += 0.5; // 防止密集排布时中间过高
                    } else {
                        temp1 += 1;
                    }
                    
                    temp++;
                } else {
                    // 不允许超过父视图高度
                    float tempHeight = (verticalHeight + temp1 - temp2) < self.frame.size.height ? (verticalHeight + temp1 - temp2) : self.frame.size.height;
                    label.frame = CGRectMake(label.frame.origin.x, self.frame.size.height - tempHeight, label.frame.size.width, tempHeight);
                    
                    if (self.pillarSpacingStyle == PillarSpacingStyleNext) {
                        temp2 += 0.5;
                    } else {
                        temp2 += 1;
                    }
                }
            }
        }
    } else if (self.pillarWaveStyle == PillarWaveStyleMiddleBoilingWavecrest) {
        // 中心沸腾波峰
        int count = 0;
        // 对于不同的分隔风格，对应的音柱个数不同
        if (self.pillarSpacingStyle == PillarSpacingStyleNext) {
            count = self.frame.size.width/self.pillarWidth;
        } else {
            count = self.frame.size.width/self.pillarWidth/2;
        }
        int temp = 0;
        float temp1 = 0;
        float temp2 = 0;
        for (UILabel *label in [self subviews]) {
            if ([label isKindOfClass:[UILabel class]]) {
                NSInteger randomHeight = 0;
                if (self.boilingLevel != 0) {
                    randomHeight = arc4random()%self.boilingLevel;
                } else {
                    randomHeight = arc4random()%5;
                }
                
                if (temp < count/2) {
                    randomHeight += temp1;
                    // 不允许超过父视图高度
                    randomHeight = (randomHeight + verticalHeight) < self.frame.size.height ? randomHeight : (self.frame.size.height - verticalHeight);
                    label.frame = CGRectMake(label.frame.origin.x, self.frame.size.height - verticalHeight - randomHeight, label.frame.size.width, verticalHeight + randomHeight);
                    
                    if (self.pillarSpacingStyle == PillarSpacingStyleNext) {
                        temp1 += 0.5; // 防止密集排布时中间过高
                    } else {
                        temp1 += 1;
                    }
                    
                    temp++;
                } else {
                    randomHeight = randomHeight + temp1 - temp2;
                    // 不允许超过父视图高度
                    randomHeight = (randomHeight + verticalHeight) < self.frame.size.height ? randomHeight : (self.frame.size.height - verticalHeight);
                    label.frame = CGRectMake(label.frame.origin.x, self.frame.size.height - verticalHeight - randomHeight, label.frame.size.width, verticalHeight + randomHeight);
                    
                    if (self.pillarSpacingStyle == PillarSpacingStyleNext) {
                        temp2 += 0.5; // 防止密集排布时中间过高
                    } else {
                        temp2 += 1;
                    }
                    
                }
            }
        }
    } else if (self.pillarWaveStyle == PillarWaveStyleIncreasingSmoothlyToRight) {
        // 向右平稳递增
        float temp = 0;
        for (UILabel *label in [self subviews]) {
            if ([label isKindOfClass:[UILabel class]]) {
                // 不允许超过父视图高度
                float tempHeight = (temp + verticalHeight) < self.frame.size.height ? (temp + verticalHeight) : self.frame.size.height;
                label.frame = CGRectMake(label.frame.origin.x, self.frame.size.height - tempHeight, label.frame.size.width, tempHeight);
                
                if (self.pillarSpacingStyle == PillarSpacingStyleNext) {
                    if (self.pillarModelStyle != PillarModelStyleNomal) {
                        temp += 2;
                    } else {
                        temp += 0.5; // 防止密集排布时后面过高
                    }
                } else {
                    if (self.pillarModelStyle != PillarModelStyleNomal) {
                        temp += 4;
                    } else {
                        temp += 1; // 防止密集排布时后面过高
                    }
                }
            }
        }
    } else if (self.pillarWaveStyle == PillarWaveStyleIncreasingBoilinglyToRight) {
        // 向右沸腾递增
        float temp = 0;
        for (UILabel *label in [self subviews]) {
            if ([label isKindOfClass:[UILabel class]]) {
                NSInteger randomHeight = 0;
                if (self.boilingLevel != 0) {
                    randomHeight = arc4random()%self.boilingLevel;
                } else {
                    randomHeight = arc4random()%5;
                }
                
                randomHeight += temp;
                // 不允许超过父视图高度
                randomHeight = (randomHeight + verticalHeight) < self.frame.size.height ? randomHeight : (self.frame.size.height - verticalHeight);
                label.frame = CGRectMake(label.frame.origin.x, self.frame.size.height - verticalHeight - randomHeight, label.frame.size.width, verticalHeight + randomHeight);
                
                if (self.pillarSpacingStyle == PillarSpacingStyleNext) {
                    if (self.pillarModelStyle != PillarModelStyleNomal) {
                        temp += 2;
                    } else {
                        temp += 0.5; // 防止密集排布时后面过高
                    }
                } else {
                    if (self.pillarModelStyle != PillarModelStyleNomal) {
                        temp += 4;
                    } else {
                        temp += 1; // 防止密集排布时后面过高
                    }
                }
            }
        }
    } else if (self.pillarWaveStyle == PillarWaveStyleIncreasingSmoothlyToLeft) {
        // 向左平稳递增
        int count = 0;
        float temp = 0;
        // 对于不同的分隔风格，对应的音柱个数不同
        if (self.pillarSpacingStyle == PillarSpacingStyleNext) {
            count = self.frame.size.width/self.pillarWidth;
            if (self.pillarModelStyle != PillarModelStyleNomal) {
                temp = count * 2;
            } else {
                temp = count * 0.5; // 防止密集排布时后面过高
            }
        } else {
            count = self.frame.size.width/self.pillarWidth/2;
            if (self.pillarModelStyle != PillarModelStyleNomal) {
                temp = count * 4;
            } else {
                temp = count; // 防止密集排布时后面过高
            }
        }
        
        for (UILabel *label in [self subviews]) {
            if ([label isKindOfClass:[UILabel class]]) {
                // 不允许超过父视图高度
                float tempHeight = (temp + verticalHeight) < self.frame.size.height ? (temp + verticalHeight) : self.frame.size.height;
                label.frame = CGRectMake(label.frame.origin.x, self.frame.size.height - tempHeight, label.frame.size.width, tempHeight);
                
                if (self.pillarSpacingStyle == PillarSpacingStyleNext) {
                    if (self.pillarModelStyle != PillarModelStyleNomal) {
                        temp -= 2;
                    } else {
                        temp -= 0.5; // 防止密集排布时后面过高
                    }
                } else {
                    if (self.pillarModelStyle != PillarModelStyleNomal) {
                        temp -= 4;
                    } else {
                        temp -= 1; // 防止密集排布时后面过高
                    }
                }
            }
        }
    } else if (self.pillarWaveStyle == PillarWaveStyleIncreasingBoilinglyToLeft) {
        // 向左沸腾递增
        int count = 0;
        float temp = 0;
        // 对于不同的分隔风格，对应的音柱个数不同
        if (self.pillarSpacingStyle == PillarSpacingStyleNext) {
            count = self.frame.size.width/self.pillarWidth;
            if (self.pillarModelStyle != PillarModelStyleNomal) {
                temp = count * 2;
            } else {
                temp = count * 0.5; // 防止密集排布时后面过高
            }
        } else {
            count = self.frame.size.width/self.pillarWidth/2;
            if (self.pillarModelStyle != PillarModelStyleNomal) {
                temp = count * 4;
            } else {
                temp = count; // 防止密集排布时后面过高
            }
        }
        
        for (UILabel *label in [self subviews]) {
            if ([label isKindOfClass:[UILabel class]]) {
                NSInteger randomHeight = 0;
                if (self.boilingLevel != 0) {
                    randomHeight = arc4random()%self.boilingLevel;
                } else {
                    randomHeight = arc4random()%5;
                }
                
                randomHeight += temp;
                // 不允许超过父视图高度
                randomHeight = (randomHeight + verticalHeight) < self.frame.size.height ? randomHeight : (self.frame.size.height - verticalHeight);
                label.frame = CGRectMake(label.frame.origin.x, self.frame.size.height - verticalHeight - randomHeight, label.frame.size.width, verticalHeight + randomHeight);
                
                if (self.pillarSpacingStyle == PillarSpacingStyleNext) {
                    if (self.pillarModelStyle != PillarModelStyleNomal) {
                        temp -= 2;
                    } else {
                        temp -= 0.5; // 防止密集排布时后面过高
                    }
                } else {
                    if (self.pillarModelStyle != PillarModelStyleNomal) {
                        temp -= 4;
                    } else {
                        temp -= 1; // 防止密集排布时后面过高
                    }
                }
            }
        }
    } else if (self.pillarWaveStyle == PillarWaveStyleElectrocardiographyToRight) {
        // 心电图向右
        if (self.pillarSpacingStyle == PillarSpacingStyleNext) {
            self.pillarCount = self.frame.size.width/self.pillarWidth;
        } else {
            self.pillarCount = self.frame.size.width/self.pillarWidth;
            if (self.pillarCount%2 == 1) {
                self.pillarCount = (self.pillarCount+1)/2;
            } else {
                self.pillarCount = self.pillarCount/2;
            }
        }
        
        self.MoveDirection = @"right";
        [self waveMovingWithLabelHeightAndLabelTag:timeInterval andHeight:verticalHeight];
    } else if (self.pillarWaveStyle == PillarWaveStyleElectrocardiographyToLeft) {
        // 心电图向左
        if (self.pillarSpacingStyle == PillarSpacingStyleNext) {
            self.pillarCount = self.frame.size.width/self.pillarWidth;
        } else {
            self.pillarCount = self.frame.size.width/self.pillarWidth;
            if (self.pillarCount%2 == 1) {
                self.pillarCount = (self.pillarCount+1)/2;
            } else {
                self.pillarCount = self.pillarCount/2;
            }
        }
        
        self.MoveDirection = @"left";
        [self waveMovingWithLabelHeightAndLabelTag:timeInterval andHeight:verticalHeight];
    }
}
// 根据高度和tag值模拟波浪的动态前进
- (void)waveMovingWithLabelHeightAndLabelTag:(NSTimeInterval)timeInterval andHeight:(CGFloat)verticalHeight
{
    if ([self.MoveDirection isEqualToString:@"right"]) {
        self.labelTag++;
        
        if (self.labelTag <= self.pillarCount + 1000) {
            verticalHeight = verticalHeight + 5 < self.frame.size.height ? verticalHeight + 5 : self.frame.size.height;
            
            if (self.pillarModelStyle == PillarModelStyleNomal) {
                for (UILabel *label in [self subviews]) {
                    if ([label isKindOfClass:[UILabel class]] && label.tag == self.labelTag) {
                        label.frame = CGRectMake(label.frame.origin.x, self.frame.size.height - verticalHeight, label.frame.size.width, verticalHeight);
                    }
                }
            } else {
                for (JPColorfulLabel *colorfulLabel in [self subviews]) {
                    if ([colorfulLabel isKindOfClass:[JPColorfulLabel class]] && colorfulLabel.tag == self.labelTag) {
                        colorfulLabel.frame = CGRectMake(colorfulLabel.frame.origin.x, self.frame.size.height - verticalHeight, colorfulLabel.frame.size.width, verticalHeight);
                    }
                }
            }
        } else {
            self.labelTag = 999;
        }
    } else {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            self.labelTag = self.labelTag + 1 + self.pillarCount;
        });
        self.labelTag--;
        
        if (self.labelTag >= 1000) {
            verticalHeight = verticalHeight + 5 < self.frame.size.height ? verticalHeight + 5 : self.frame.size.height;
            
            if (self.pillarModelStyle == PillarModelStyleNomal) {
                for (UILabel *label in [self subviews]) {
                    if ([label isKindOfClass:[UILabel class]] && label.tag == self.labelTag) {
                        label.frame = CGRectMake(label.frame.origin.x, self.frame.size.height - verticalHeight, label.frame.size.width, verticalHeight);
                    }
                }
            } else {
                for (JPColorfulLabel *colorfulLabel in [self subviews]) {
                    if ([colorfulLabel isKindOfClass:[JPColorfulLabel class]] && colorfulLabel.tag == self.labelTag) {
                        colorfulLabel.frame = CGRectMake(colorfulLabel.frame.origin.x, self.frame.size.height - verticalHeight, colorfulLabel.frame.size.width, verticalHeight);
                    }
                }
            }
        } else {
            self.labelTag = 1000 + self.pillarCount;
        }
    }
    
}

- (void)stopChangeHeight
{
    if ([self.MoveDirection isEqualToString:@"right"]) {
        self.labelTag = 999;
    } else {
        self.labelTag = 1000 + self.pillarCount;
    }
    
    
    if (self.pillarModelStyle == PillarModelStyleNomal) {
        for (UILabel *label in [self subviews]) {
            if ([label isKindOfClass:[UILabel class]]) {
                label.frame = CGRectMake(label.frame.origin.x, 0, label.frame.size.width, 0);
            }
        }
    } else {
        for (JPColorfulLabel *colorfulLabel in [self subviews]) {
            if ([colorfulLabel isKindOfClass:[JPColorfulLabel class]]) {
                colorfulLabel.frame = CGRectMake(colorfulLabel.frame.origin.x, colorfulLabel.frame.origin.y, colorfulLabel.frame.size.width, 0);
            }
        }
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
