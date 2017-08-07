//
//  JPColorfulLabel.h
//  demo
//
//  Created by JaryPan on 15/10/13.
//  Copyright © 2015年 JaryPan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    LabelSpacingStyleNext, // 紧挨
    LabelSpacingStyleEquallySpaced, // 等间隔
    LabelSpacingStyleDefault = LabelSpacingStyleEquallySpaced,
} LabelSpacingStyle;

@interface JPColorfulLabel : UILabel

@property (assign, nonatomic) CGFloat elementHeight; // 元素高度（不设定的话默认是宽度的2/3）

- (JPColorfulLabel *)initWithFrame:(CGRect)frame
                 labelSpacingStyle:(LabelSpacingStyle)labelSpacingStyle;

+ (JPColorfulLabel *)jpColorfulLabelWithFrame:(CGRect)frame
                            labelSpacingStyle:(LabelSpacingStyle)labelSpacingStyle;

@end
