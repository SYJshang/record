
//
//  SYJTagertModel.m
//  RecordPen
//
//  Created by 尚勇杰 on 2017/8/3.
//  Copyright © 2017年 尚勇杰. All rights reserved.
//

#import "SYJTagertModel.h"

@implementation SYJTagertModel

+ (NSTimer *) scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                      target:(id)aTarget
                                    selector:(SEL)aSelector
                                    userInfo:(id)userInfo
                                     repeats:(BOOL)repeats{
    
    SYJTagertModel * timer = [SYJTagertModel new];
    timer.target = aTarget;
    timer.selector = aSelector;
    //-------------------------------------------------------------此处的target已经被换掉了不是原来的VIewController而是TimerWeakTarget类的对象timer
    timer.timer = [NSTimer scheduledTimerWithTimeInterval:interval target:timer selector:@selector(fire:) userInfo:userInfo repeats:repeats];
    return timer.timer;
}



-(void)fire:(NSTimer *)timer{
    
    if (self.target) {
        [self.target performSelector:self.selector withObject:timer.userInfo];
    } else {
        
        [self.timer invalidate];
    }
}

@end
