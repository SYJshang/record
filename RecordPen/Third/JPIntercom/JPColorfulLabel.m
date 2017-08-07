//
//  JPColorfulLabel.m
//  demo
//
//  Created by JaryPan on 15/10/13.
//  Copyright © 2015年 JaryPan. All rights reserved.
//

#import "JPColorfulLabel.h"

@interface JPColorfulLabel ()

@property (assign, nonatomic) LabelSpacingStyle labelSpacingStyle;

@end

@implementation JPColorfulLabel

@synthesize elementHeight = _elementHeight;

- (JPColorfulLabel *)initWithFrame:(CGRect)frame labelSpacingStyle:(LabelSpacingStyle)labelSpacingStyle
{
    if (self = [super initWithFrame:frame]) {
        self.labelSpacingStyle = labelSpacingStyle;
        
        // 添加子控件
        [self addSubviews];
    }
    return self;
}

+ (JPColorfulLabel *)jpColorfulLabelWithFrame:(CGRect)frame labelSpacingStyle:(LabelSpacingStyle)labelSpacingStyle
{
    return [[JPColorfulLabel alloc]initWithFrame:frame labelSpacingStyle:labelSpacingStyle];
}


// 添加子控件
- (void)addSubviews
{
    [self setupLabels];
}

// 重写frame的set方法
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [self setupLabels];
}

- (void)setupLabels
{
    for (UILabel *label in [self subviews]) {
        if ([label isKindOfClass:[UILabel class]]) {
            [label removeFromSuperview];
        }
    }
    
    CGFloat height = self.frame.size.height;
    CGFloat width = self.frame.size.width;
    
    CGFloat intervalHeight = 0;
    if (self.elementHeight != 0) {
        intervalHeight = self.elementHeight;
    } else {
        intervalHeight = width * 2/3;
    }
    
    if (self.labelSpacingStyle == LabelSpacingStyleNext) {
        int count = height/intervalHeight;
        
        for (int i = 0; i < count; i++) {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height - (i+1) * intervalHeight, width, intervalHeight)];
            [self addSubview:label];
            
            // 设计颜色
            if (i < count/7) {
                label.backgroundColor = [UIColor purpleColor];
            } else if (i < count * 2/7) {
                label.backgroundColor = [UIColor blueColor];
            } else if (i < count * 3/7) {
                label.backgroundColor = [UIColor cyanColor];
            } else if (i < count * 4/7) {
                label.backgroundColor = [UIColor greenColor];
            } else if (i < count * 5/7) {
                label.backgroundColor = [UIColor yellowColor];
            } else if (i < count * 6/7) {
                label.backgroundColor = [UIColor orangeColor];
            } else {
                label.backgroundColor = [UIColor redColor];
            }
        }
    } else {
        
        int count = height/intervalHeight/2;
        
        if (count%2 == 1) {
            count++;
        }
        
        for (int i = 0; i < count; i++) {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height - intervalHeight - i * intervalHeight * 2, width, intervalHeight)];
            [self addSubview:label];
            
            // 设计颜色
            if (i < count/7) {
                label.backgroundColor = [UIColor purpleColor];
            } else if (i < count * 2/7) {
                label.backgroundColor = [UIColor blueColor];
            } else if (i < count * 3/7) {
                label.backgroundColor = [UIColor cyanColor];
            } else if (i < count * 4/7) {
                label.backgroundColor = [UIColor greenColor];
            } else if (i < count * 5/7) {
                label.backgroundColor = [UIColor yellowColor];
            } else if (i < count * 6/7) {
                label.backgroundColor = [UIColor orangeColor];
            } else {
                label.backgroundColor = [UIColor redColor];
            }
        }
    }
}


// 重写set、get方法
- (void)setElementHeight:(CGFloat)elementHeight
{
    if (_elementHeight != elementHeight) {
        _elementHeight = elementHeight;
    }
    
    [self setupLabels];
}
- (CGFloat)elementHeight
{
    return _elementHeight;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
