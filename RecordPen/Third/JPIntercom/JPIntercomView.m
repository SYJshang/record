//
//  JPIntercom.m
//  JPIntercom
//
//  Created by JaryPan on 15/10/12.
//  Copyright © 2015年 JaryPan. All rights reserved.
//

#import "JPIntercomView.h"
#import <AVFoundation/AVFoundation.h>

@interface JPIntercomView ()

@property (assign, nonatomic) float level; // 麦克风音量大小（0 ~~ 1）

@property (strong, nonatomic) AVAudioRecorder *recorder;
@property (strong, nonatomic) NSTimer *levelTimer;

@end

@implementation JPIntercomView

// 初始化方法
- (JPIntercomView *)initWithFrame:(CGRect)frame pillarViewSize:(CGSize)pillarViewSize pillarViewBackgroundColor:(UIColor *)pillarViewBackgroundColor pillarViewBackgroundImage:(UIImage *)pillarViewBackgroundImage pillarWidth:(CGFloat)pillarWidth pillarModelStyle:(PillarModelStyle)pillarModelStyle pillarSpacingStyle:(PillarSpacingStyle)pillarSpacingStyle pillarWaveStyle:(PillarWaveStyle)pillarWaveStyle pillarColorStyle:(PillarColorStyle)pillarColorStyle coatImage:(UIImage *)coatImage coatImageAlpha:(CGFloat)coatImageAlpha colorChangeInterval:(NSTimeInterval)colorChangeInterval
{
    if (self = [super init]) {
        self.frame = frame;
        self.colorChangeInterval = colorChangeInterval;
        
        // 音柱图
        self.colorPillar = [JPColorPillar jpColorPillarWithFrame:CGRectMake(self.frame.size.width/2 - pillarViewSize.width/2, 0, pillarViewSize.width, pillarViewSize.height) backgroundColor:pillarViewBackgroundColor backgroundImage:pillarViewBackgroundImage pillarWidth:pillarWidth pillarModelStyle:pillarModelStyle pillarSpacingStyle:pillarSpacingStyle pillarWaveStyle:pillarWaveStyle pillarColorStyle:pillarColorStyle coatImage:coatImage coatImageAlpha:coatImageAlpha];
        [self addSubview:self.colorPillar];
        
        self.pillarBottomLine = [[UIView alloc]initWithFrame:CGRectMake(self.colorPillar.frame.origin.x, self.colorPillar.frame.origin.y + self.colorPillar.frame.size.height, self.colorPillar.frame.size.width, 2)];
        self.pillarBottomLine.backgroundColor = [UIColor orangeColor];
        [self addSubview:self.pillarBottomLine];
        
        // 添加子控件
        [self addSubviews];
        // 录音(检测声音分贝的前提)
        [self recordVoice];
    }
    
    return self;
}

// 类方法
+ (JPIntercomView *)jpIntercomViewWithFrame:(CGRect)frame pillarViewSize:(CGSize)pillarViewSize pillarViewBackgroundColor:(UIColor *)pillarViewBackgroundColor pillarViewBackgroundImage:(UIImage *)pillarViewBackgroundImage pillarWidth:(CGFloat)pillarWidth pillarModelStyle:(PillarModelStyle)pillarModelStyle pillarSpacingStyle:(PillarSpacingStyle)pillarSpacingStyle pillarWaveStyle:(PillarWaveStyle)pillarWaveStyle pillarColorStyle:(PillarColorStyle)pillarColorStyle coatImage:(UIImage *)coatImage coatImageAlpha:(CGFloat)coatImageAlpha colorChangeInterval:(NSTimeInterval)colorChangeInterval
{
    return [[JPIntercomView alloc]initWithFrame:frame pillarViewSize:pillarViewSize pillarViewBackgroundColor:pillarViewBackgroundColor pillarViewBackgroundImage:pillarViewBackgroundImage pillarWidth:pillarWidth pillarModelStyle:pillarModelStyle pillarSpacingStyle:pillarSpacingStyle pillarWaveStyle:pillarWaveStyle pillarColorStyle:pillarColorStyle coatImage:coatImage coatImageAlpha:coatImageAlpha colorChangeInterval:colorChangeInterval];
}

#pragma mark - 添加子控件
- (void)addSubviews
{
    // 开始对讲标志
    self.speakingMarkView = [[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width - 50, self.colorPillar.frame.origin.y + self.colorPillar.frame.size.height + 20, 10, 10)];
    self.speakingMarkView.backgroundColor = [UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:0.8];
    self.speakingMarkView.layer.cornerRadius = 5;
    [self addSubview:self.speakingMarkView];
    
    // 对讲按钮
    float height = self.frame.size.height - self.speakingMarkView.frame.origin.y - self.speakingMarkView.frame.size.height - 20;
    self.speakingImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"videoplaying_speakingNomal"]];
    self.speakingImageView.frame = CGRectMake((self.frame.size.width - height)/2, self.speakingMarkView.frame.origin.y + self.speakingMarkView.frame.size.height, height, height);
    self.speakingImageView.userInteractionEnabled = YES;
    [self addSubview:self.speakingImageView];
    // 给对讲按钮添加长按手势
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longpressGestureAction:)];
    longPressGesture.minimumPressDuration = 0;
    [self.speakingImageView addGestureRecognizer:longPressGesture];
}


#pragma mark - 开始、结束、取消 对讲
- (void)longpressGestureAction:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self start];
        if (self.delegate && [self.delegate respondsToSelector:@selector(speakingBegan)]) {
            [self.delegate speakingBegan];
        }
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(speakingWhileTouchMoving)]) {
            [self.delegate speakingWhileTouchMoving];
        }
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        [self stop];
        if (self.delegate && [self.delegate respondsToSelector:@selector(speakingEnded)]) {
            [self.delegate speakingEnded];
        }
    } else if (sender.state == UIGestureRecognizerStateCancelled) {
        [self stop];
        if (self.delegate && [self.delegate respondsToSelector:@selector(speakingCancelled)]) {
            [self.delegate speakingCancelled];
        }
    } else if (sender.state == UIGestureRecognizerStateFailed) {
        [self stop];
        if (self.delegate && [self.delegate respondsToSelector:@selector(speakingFailed)]) {
            [self.delegate speakingFailed];
        }
    }
}
- (void)start
{
    self.speakingImageView.image = [UIImage imageNamed:@"videoplaying_speakingHighlighted"];
    [self startSpeaking]; // 开始讲话，检测声音大小，根据声音大小改变展示效果
    [self.colorPillar startChangeColorWithInterval:self.colorChangeInterval];
    self.speakingMarkView.backgroundColor = [UIColor orangeColor];
}
- (void)stop
{
    self.speakingImageView.image = [UIImage imageNamed:@"videoplaying_speakingNomal"];
    [self stopSpeaking]; // 结束讲话
    [self.colorPillar stopChangeColor];
    self.speakingMarkView.backgroundColor = [UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:0.8];
}


#pragma mark - 录音
- (void)recordVoice
{
    /* 必须添加这句话，否则在模拟器可以，在真机上获取始终是0 */
    [[AVAudioSession sharedInstance]
     setCategory: AVAudioSessionCategoryPlayAndRecord error: nil];
    
    /* 不需要保存录音文件 */
    NSURL *url = [NSURL fileURLWithPath:@"/dev/null"];
    
    NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithFloat: 44100.0], AVSampleRateKey,
                              [NSNumber numberWithInt: kAudioFormatAppleLossless], AVFormatIDKey,
                              [NSNumber numberWithInt: 2], AVNumberOfChannelsKey,
                              [NSNumber numberWithInt: AVAudioQualityMax], AVEncoderAudioQualityKey,
                              nil];
    
    NSError *error;
    self.recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
    if (self.recorder) {
        [self.recorder prepareToRecord];
        self.recorder.meteringEnabled = YES;
        [self.recorder record];
    } else {
        NSLog(@"error description ------ %@", [error description]);
    }
}


#pragma mark - 开始定时、停止定时
- (void)startSpeaking
{
    if (self.levelTimer) {
        [self.levelTimer invalidate];
        self.levelTimer = nil;
    }
    
    if (self.voiceCheckingInterval == 0) {
        self.voiceCheckingInterval = 0.1;
    }
    
    self.levelTimer = [NSTimer scheduledTimerWithTimeInterval:self.voiceCheckingInterval target: self selector: @selector(voiceLevelCallback:) userInfo: nil repeats: YES];
    [self.levelTimer fire];
}
- (void)stopSpeaking
{
    [self.levelTimer invalidate];
    self.levelTimer = nil;
    
    [self.colorPillar stopChangeHeight];
}

// 音量随环境变化而变化
- (void)voiceLevelCallback:(NSTimer *)timer
{
    [self.recorder updateMeters];
    
    float   minDecibels = -60.0f; // Or use -60dB, which I measured in a silent room.
    float   decibels    = [self.recorder averagePowerForChannel:0];
    
    if (decibels < minDecibels)
    {
        _level = 0.0f;
    }
    else if (decibels >= 0.0f)
    {
        _level = 1.0f;
    }
    else
    {
        float   root            = 2.0f;
        float   minAmp          = powf(10.0f, 0.05f * minDecibels);
        float   inverseAmpRange = 1.0f / (1.0f - minAmp);
        float   amp             = powf(10.0f, 0.05f * decibels);
        float   adjAmp          = (amp - minAmp) * inverseAmpRange;
        
        _level = powf(adjAmp, 1.0f / root);
    }
    
    // level范围[0 ~ 1]之间
    dispatch_async(dispatch_get_main_queue(), ^{
        float height = _level * self.colorPillar.frame.size.height;
        [self.colorPillar startChangeHeightWithVerticalHeight:height andTimeInterval:timer.timeInterval];
    });
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
