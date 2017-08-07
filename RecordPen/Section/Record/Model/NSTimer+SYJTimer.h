//
//  NSTimer+SYJTimer.h
//  RecordPen
//
//  Created by 尚勇杰 on 2017/8/3.
//  Copyright © 2017年 尚勇杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (SYJTimer)

+ (NSTimer *)xx_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                         block:(void(^)())block
                                       repeats:(BOOL)repeats;

@end
