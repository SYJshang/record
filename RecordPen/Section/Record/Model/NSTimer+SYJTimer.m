//
//  NSTimer+SYJTimer.m
//  RecordPen
//
//  Created by 尚勇杰 on 2017/8/3.
//  Copyright © 2017年 尚勇杰. All rights reserved.
//

#import "NSTimer+SYJTimer.h"

@implementation NSTimer (SYJTimer)

+ (NSTimer *)xx_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                         block:(void(^)())block
                                       repeats:(BOOL)repeats
{
    return [self scheduledTimerWithTimeInterval:interval
                                         target:self
                                       selector:@selector(xx_blockInvoke:)
                                       userInfo:[block copy]
                                        repeats:repeats];
}

+ (void)xx_blockInvoke:(NSTimer *)timer {
    void (^block)() = timer.userInfo;
    if(block) {
        block();
    }
}



@end
