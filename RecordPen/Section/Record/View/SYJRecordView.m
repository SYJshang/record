//
//  SYJRecordView.m
//  RecordPen
//
//  Created by 尚勇杰 on 2017/7/28.
//  Copyright © 2017年 尚勇杰. All rights reserved.
//

#import "SYJRecordView.h"

@implementation SYJRecordView

//画图:
-(void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.3);//线的宽度
    UIColor* aColor = [UIColor whiteColor];//白色
    
    CGContextSetStrokeColorWithColor(context, aColor.CGColor);//线框颜色
    float x = 10;
    for (NSNumber *number in self.array) {
        float y = [number intValue];
        y  = y+30;
        if(y<=1) y = 0.3;
        
        CGPoint aPoints[2];//坐标点
        if(y<=1) y = 1;
        aPoints[0] = CGPointMake(x,(self.frame.size.height+32)/2.0- self.frame.size.height * y * 3/160);//坐标1
        aPoints[1] =CGPointMake(x, (self.frame.size.height+32)/2.0+self.frame.size.height*y*3/160);//坐标2
        CGContextAddLines(context, aPoints, 2);//添加线
        if (IS_IPHONE_6) {
            x += 375.0/600.0;
        }
        if (IS_IPHONE_6P) {
            x+= 414.0/600.0;
        }
        if (IS_IPHONE_5) {
            x+=320.0 /600.0;
        }
    }
    CGPoint line[2];
    line[0]= CGPointMake(0, (self.frame.size.height+32)/2);
    line[1]= CGPointMake(self.frame.size.width, (self.frame.size.height+32)/2);
    CGContextAddLines(context, line, 2);//中间添加线
    //根据坐标绘制路径
    CGContextDrawPath(context, kCGPathStroke);
    
    CGContextRef context2 = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context2, 1);//线的宽度
    
    CGContextSetStrokeColorWithColor(context2, aColor.CGColor);//线框颜色
    CGPoint lline[2];
    lline[0]= CGPointMake(0, 32);
    lline[1]= CGPointMake(self.frame.size.width, 32);
    CGContextAddLines(context2, lline, 2);//上边添加线
    CGContextDrawPath(context2, kCGPathStroke);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
