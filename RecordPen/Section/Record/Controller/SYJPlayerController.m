//
//  SYJPlayerController.m
//  RecordPen
//
//  Created by 尚勇杰 on 2017/8/3.
//  Copyright © 2017年 尚勇杰. All rights reserved.
//

#import "SYJPlayerController.h"
#import <AVFoundation/AVFoundation.h>
#import "JPColorPillar.h"
#import "NSTimer+SYJTimer.h"
#import "SYJTagertModel.h"

@interface SYJPlayerController ()<AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) UIProgressView *proressView;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIButton *pause;
@property (nonatomic, strong) UILabel *labelTxet;

@property (nonatomic, strong) JPColorPillar *colorpilar;


@end

@implementation SYJPlayerController

- (void)dealloc{
    
    [self.timer invalidate];
    self.timer = nil;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [self.timer invalidate];
    self.timer = nil;
    
}

- (JPColorPillar *)colorpilar{
    
    if (_colorpilar == nil) {
        _colorpilar = [[JPColorPillar alloc]initWithFrame:CGRectMake(10, 20, KSceenW - 20, KSceenW) backgroundColor:[UIColor clearColor] backgroundImage:[UIImage imageNamed:@"pillarViewBackgroundImage"] pillarWidth:1 pillarModelStyle:PillarModelStyleNomal pillarSpacingStyle:PillarSpacingStyleNext pillarWaveStyle:PillarWaveStyleElectrocardiographyToRight pillarColorStyle:PillarColorStyleSevenColorHorizontalChanging coatImage:nil coatImageAlpha:0.0];
        
        _colorpilar.hasColorTransitionEffect = YES;
    }
    
    return _colorpilar;
    
}



//懒加载

//-(NSTimer *)timer{
//    if (!_timer) {
//        
//        
//        
//          }
//    return _timer;
//}


- (AVAudioPlayer *)audioPlayer{
    
    if (_audioPlayer == nil) {
       
        NSString *urlStr = [documentPath stringByAppendingString:self.fileName];
        NSURL *url = [NSURL fileURLWithPath:urlStr];
        NSError *error = nil;
        //初始化播放器，注意这里的Url参数只能时文件路径，不支持HTTP Url
        _audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
        //设置播放器属性
        _audioPlayer.numberOfLoops=0;//设置为0不循环
        _audioPlayer.delegate = self;
        [_audioPlayer prepareToPlay];//加载音频文件到缓存
        if(error){
            SYJLog(@"初始化播放器过程发生错误,错误信息:%@",error.localizedDescription);
            return nil;
        }
    }
    
    return _audioPlayer;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = [UILabel titleWithColor:[UIColor whiteColor] title:@"Player" font:16.0];

    
    [self setUI];
//    
    __weak typeof(self) weakSelf = self;
//    _timer = [NSTimer xx_scheduledTimerWithTimeInterval:.5
//                                                  block:^{
//                                                      SYJPlayerController *strongSelf = weakSelf;
//                                                      [strongSelf updateProgress];
//                                                  }
//                                                repeats:YES];
    
    _timer = [SYJTagertModel scheduledTimerWithTimeInterval:0.1 target:weakSelf selector:@selector(updateProgress) userInfo:nil repeats:YES];
    
    
    
    [self play];
    
    // Do any additional setup after loading the view.
}

- (void)setUI{
    
    [self.view addSubview:self.colorpilar];
    
    [self.colorpilar startChangeColorWithInterval:1.0];

    
    self.proressView = [[UIProgressView alloc]init];
    self.proressView.progressTintColor = TextColor;
    self.proressView.progressViewStyle = UIProgressViewStyleDefault;
    self.proressView.trackTintColor = [UIColor grayColor];
    [self.view addSubview:self.proressView];
    self.proressView.sd_layout.leftSpaceToView(self.view, 15).rightSpaceToView(self.view, 15).topSpaceToView(self.colorpilar, 10).heightIs(15);
//    self.proressView.progress = 0.4;
    
    self.labelTxet = [[UILabel alloc]init];
    [self.view addSubview:self.labelTxet];
    self.labelTxet.font = [UIFont systemFontOfSize:16.0];
    self.labelTxet.textColor = [UIColor colorWithWhite:0.7 alpha:1.0];
    self.labelTxet.textAlignment = NSTextAlignmentRight;
    self.labelTxet.sd_layout.rightSpaceToView(self.view, 18).topSpaceToView(self.proressView, 10).heightIs(20).widthIs(200);
    self.labelTxet.text = @"0:11/3:38";
    
    self.pause = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.pause];
    [self.pause setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
    [self.pause addTarget:self action:@selector(pauseOrPlay:) forControlEvents:UIControlEventTouchUpInside];
    self.pause.selected = NO;
    self.pause.sd_layout.centerXEqualToView(self.view).topSpaceToView(self.proressView, 40).heightIs(80).widthIs(80);
    
}

- (void)pauseOrPlay:(UIButton *)sender{
    
    if(sender.selected == NO){
        [sender setImage:[UIImage imageNamed:@"播放"] forState:UIControlStateNormal];
        [self pausePlay];
        self.pause.selected = YES;
    }else{
        [sender setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
        [self play];
        self.pause.selected = NO;
    }
    
}

/**
 *  播放音频
 */
-(void)play{
    if (![self.audioPlayer isPlaying]) {
        [self.audioPlayer play];
        self.timer.fireDate=[NSDate distantPast];//恢复定时器
    }
}

/**
 *  暂停播放
 */
-(void)pausePlay{
    if ([self.audioPlayer isPlaying]) {
        [self.audioPlayer pause];
        self.timer.fireDate = [NSDate distantFuture];//暂停定时器，注意不能调用invalidate方法，此方法会取消，之后无法恢复
        
    }
}



/**
 *  更新播放进度
 */
-(void)updateProgress{
    
    [self.audioPlayer updateMeters];
//    NSUInteger channels = self.audioPlayer.numberOfChannels;//只读属性

//    float peakPower = pow(10, (0.05 * [self.audioPlayer peakPowerForChannel:0]));
////    float averagePower = pow(10, (0.05 * [self.audioPlayer averagePowerForChannel:0]));
//    
//    float alt = self.colorpilar.height;
//
    
    float x = (arc4random() % 340) + 40;
    
    
    [self.colorpilar startChangeHeightWithVerticalHeight:x andTimeInterval:self.timer.timeInterval];
    float progress = self.audioPlayer.currentTime / self.audioPlayer.duration;
    [self.proressView setProgress:progress animated:true];
    
    self.labelTxet.text = [NSString stringWithFormat:@"%.2fs / %.2fs",self.audioPlayer.currentTime,self.audioPlayer.duration];
}

#pragma mark - 播放器代理方法
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    NSLog(@"音乐播放完成...");
    [self pausePlay];
    self.timer = nil;//暂停定时器，注意不能调用invalidate方法，此方法会取消，之后无法恢复
    self.pause.selected = YES;
    [self.pause setImage:[UIImage imageNamed:@"播放"] forState:UIControlStateNormal];
    
}


//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    [super touchesBegan:touches withEvent:event];
//    [self.view endEditing:YES];
//    [self dismissViewControllerAnimated:NO completion: nil];
//}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
