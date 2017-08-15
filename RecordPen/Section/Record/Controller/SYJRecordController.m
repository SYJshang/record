
//
//  SYJRecordController.m
//  RecordPen
//
//  Created by 尚勇杰 on 2017/7/28.
//  Copyright © 2017年 尚勇杰. All rights reserved.
//

#import "SYJRecordController.h"
#import "SYJRecordView.h"
#import "JYZRecorder.h"
#import "SYJListController.h"
#import "ZYTabBarController.h"
#import "AppDelegate.h"

typedef enum PlayOrPauseState {
    PlayStatePaly  = 0,
    PlayStatePause,
    PlayStateStop
} PlayState;

@interface SYJRecordController ()<UIScrollViewDelegate>

//录音图表
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)SYJRecordView *voiceView;//画线
@property (nonatomic, strong) UIButton *scrollBtn; //录制的跑动线
@property(nonatomic,copy)NSMutableArray * voiceArray;//保存声音地址数组

@property (nonatomic,strong) NSTimer *timer;//录音声波监控（注意这里暂时不对播放进行监控）

@property(nonatomic,copy)NSMutableArray * array;

@property (nonatomic, strong) JYZRecorder *recorder;

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) UIButton *playBtn;

@property (nonatomic, strong) UIButton *pauseBtn;

@property (nonatomic, strong) UIButton *saveBtn;

@property (nonatomic, strong) UILabel *labelText;

@property (nonatomic, assign) int type;
@property (nonatomic, strong) NSString *filePath;


@end

@implementation SYJRecordController

#pragma mark - 懒加载

-(UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc]init];
        _label.frame = CGRectMake(10, 320, self.view.frame.size.width - 300, 30);
        _label.textColor = [UIColor whiteColor];
        if(IS_IPHONE_5){_label.frame = CGRectMake(10, 320, self.view.frame.size.width - 300, 30);}
        _label.textAlignment = 1;
        _label.text = @"00:00:00";
        
    }
    return _label;
    
    
}


-(NSMutableArray *)array{
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}

// 绘图定时器  目前每秒画40次
-(NSTimer *)timer{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector(audioPowerChange) userInfo:nil repeats:YES];
    }
    return _timer;
}


-(NSMutableArray *)voiceArray{
    if (!_voiceArray) {
        _voiceArray = [NSMutableArray array];
    }
    return _voiceArray;
}

- (SYJRecordView *)voiceView{
    
    if (_voiceView == nil) {
        _voiceView = [[SYJRecordView alloc]init];
        _voiceView.frame =CGRectMake(0, 0, self.scrollView.frame.size.width,self.scrollView.frame.size.height);
        
        _voiceView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1.0];
        //先添加初始界面数字 竖线
        for (int i = 0 ; i <=6; i++) {
            
            UILabel * label =[[UILabel alloc]init];
            label.frame= CGRectMake(i*self.view.frame.size.width/6+15, 12, 30, 10);
            label.textColor = [UIColor  whiteColor];
            label.text = [NSString stringWithFormat:@"00:0%d",i];
            label.font = [UIFont systemFontOfSize:10];
//            label.textAlignment = NSTextAlignmentCenter;
            [_voiceView addSubview:label];
            UIButton* btn = [UIButton new];
            
            btn.frame=CGRectMake(10+i*self.view.frame.size.width/6, 12, 1, 20);
            btn.backgroundColor = [UIColor whiteColor];
            [_voiceView addSubview:btn];
            
        }
        
        //添加初始界面小标记
        for (int i = 0 ; i <=24; i++) {
            UIButton * btn2 = [[UIButton alloc]init];
            btn2.frame=CGRectMake(10+i*self.view.frame.size.width/24, 27, 1, 5);
            btn2.backgroundColor = [UIColor whiteColor];
            [_voiceView addSubview:btn2];
        }

    }
    
    return _voiceView;
    
}

-(UIButton *)scrollBtn{
    if (!_scrollBtn) {
        _scrollBtn = [[UIButton alloc]init];
        [self.view addSubview:_scrollBtn];
        _scrollBtn.backgroundColor = [UIColor redColor];
    }
    return _scrollBtn;
}
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, 350 * KSceenHScale);
        _scrollView.backgroundColor = [UIColor lightGrayColor];
        
        
    }
    return _scrollView;
    
    
}

- (void)btnClick{
    
    [self.navigationController pushViewController:[SYJListController new] animated:YES];
}

- (void)back{
    
    AppDelegate *appleDeletae = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appleDeletae switchToRootVc];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = Gray;
    
    self.navigationItem.titleView = [UILabel titleWithColor:[UIColor colorWithWhite:0.5 alpha:1.0] title:@"Record" font:17.0];

    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10, 10, 40, 24);
    [btn setTitle:@"File" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(10, 10, 40, 40);
    [btn1 setImage:[UIImage imageNamed:@"取消"] forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn1.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [btn1 addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn1];
    
    [self.view addSubview:self.scrollView];
    [self setScrollView];
    [self addSubViews];
    [self addBtn];
    
    self.type = 0;
    
    self.recorder = [JYZRecorder initRecorder];
    self.recorder.recorder.meteringEnabled = YES;
    self.recorder.recordName = [NSString stringWithFormat:@"/%.0f.caf", [[NSDate date] timeIntervalSince1970] * 1000];
    
}

- (void)addBtn{
    
    self.labelText = [[UILabel alloc]init];
    [self.view addSubview:self.labelText];
    self.labelText.textColor = [UIColor whiteColor];
    self.labelText.textAlignment = NSTextAlignmentLeft;
    self.labelText.font = [UIFont systemFontOfSize:16.0];
    self.labelText.sd_layout.leftSpaceToView(self.view, 20).topSpaceToView(self.scrollView, 10).heightIs(20).widthIs(240);
    
    self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.playBtn];
    [self.playBtn setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    self.playBtn.selected = NO;
    [self.playBtn addTarget:self action:@selector(playOrPause:) forControlEvents:UIControlEventTouchUpInside];
    self.playBtn.sd_layout.centerXEqualToView(self.view).topSpaceToView(self.scrollView, 30).heightIs(120 * KSceenWScale).widthIs(120 * KSceenWScale);
    
    self.pauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.pauseBtn];
    [self.pauseBtn setTitle:@"Stop" forState:UIControlStateNormal];
    [self.pauseBtn  setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.pauseBtn addTarget:self action:@selector(stopRecord:) forControlEvents:UIControlEventTouchUpInside];
    self.pauseBtn.sd_layout.rightSpaceToView(self.playBtn, 10).centerYEqualToView(self.playBtn).heightIs(25 * KSceenWScale).widthIs(40 * KSceenWScale);
    
    self.saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.saveBtn];
    [self.saveBtn setTitle:@"Save" forState:UIControlStateNormal];
    [self.saveBtn  setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];    self.saveBtn.selected = NO;
    [self.saveBtn addTarget:self action:@selector(saveFile:) forControlEvents:UIControlEventTouchUpInside];
    self.saveBtn.sd_layout.leftSpaceToView(self.playBtn, 10).centerYEqualToView(self.playBtn).heightIs(25 * KSceenWScale).widthIs(40 * KSceenWScale);
    
    
}

- (void)saveFile:(UIButton *)sender{
    
    
    
    
    if ([self.recorder.recorder isRecording]) {
        
        [SVProgressHUD showSuccessWithStatus:@"In the recording!"];

    }else{
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"Title" message:@"Input the file name" preferredStyle:UIAlertControllerStyleAlert];
        [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            
            textField.placeholder = @"File Name";
            
        }];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"cancle" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self.recorder stopRecorder];

            UITextField *textFiled = alertVC.textFields.firstObject;
            NSString *str = textFiled.text;
            if (!NULLString(str)) {
               
                NSFileManager *fileManager = [NSFileManager defaultManager];
                
                [fileManager createDirectoryAtPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingString:@"/FilePath"] withIntermediateDirectories:YES attributes:nil error:nil];
                
                NSString *pathstr = [NSString stringWithFormat:@"/FilePath/%@.caf",str];
                
                NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingString:pathstr];
                
                
                
                if (![fileManager fileExistsAtPath:path]) {
                    
                    [fileManager moveItemAtPath:[self.recorder getRecorderUrlPath] toPath:path error:nil];
                    [SVProgressHUD showSuccessWithStatus:@"Save Success!"];

                }else{
                    [SVProgressHUD showInfoWithStatus:@"Files already exist!"];
                }
                
            }else{
                
                [SVProgressHUD showSuccessWithStatus:@"Name is not Null !"];
 
            }
            
            
        }];
        
        [alertVC addAction:action];
        [alertVC addAction:action1];
        [self presentViewController:alertVC animated:YES completion:nil];
        

    }
    
    
}

//暂停 Or 播放
- (void)playOrPause:(UIButton *)sender{
    
    if (sender.selected == NO && self.type == 0) {
        
    [SVProgressHUD showInfoWithStatus:@"Start the recording!"];
    
    [self.playBtn setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
    self.recorder.recordName = [NSString stringWithFormat:@"/%.0f.caf", [[NSDate date] timeIntervalSince1970] * 1000];
 
    [self.recorder startRecorder];


    self.timer.fireDate = [NSDate distantPast];
   
    self.scrollView.scrollEnabled = NO;
    self.scrollView.contentOffset = CGPointMake(0, 0);
    if(self.array.count == 0 ){
        self.label.frame = CGRectMake(10, 320, self.view.frame.size.width - 300, 30);
    }
        
    self.playBtn.selected = YES;
        self.type = 1;
 
    }else if (sender.selected == NO && self.type == 1){
        
        [SVProgressHUD showInfoWithStatus:@"Start the recording!"];
        
        [self.playBtn setImage:[UIImage imageNamed:@"麦克风"] forState:UIControlStateNormal];

        [self.recorder pauseToStartRecorder];
        self.timer.fireDate = [NSDate distantPast];
        
        self.scrollView.scrollEnabled = NO;
        self.scrollView.contentOffset = CGPointMake(0, 0);
        if(self.array.count == 0 ){
            self.label.frame = CGRectMake(10, 320, self.view.frame.size.width - 300, 30);
        }
        
        self.playBtn.selected = YES;

        
    }
    else{
        
        [SVProgressHUD showInfoWithStatus:@"Pause the recording!"];

        if ([self.recorder.recorder isRecording]) {
            [self.playBtn setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];

            [self.recorder pauseRecorder];
            self.timer.fireDate = [NSDate distantFuture];
            
        }
        self.scrollView.scrollEnabled = YES;

        self.playBtn.selected = NO;
        self.type = 1;
        
    }
    
    
}

//结束录音
- (void)stopRecord:(UIButton *)sender{
    
    NSInteger time = [self.recorder getRecorderTotalTime];
    SYJLog(@"%ld",time);
    
    if ([self.recorder.recorder isRecording]) {
        
        [SVProgressHUD showInfoWithStatus:@"Stop the recording!"];

        
//        [self.pauseBtn setImage:[UIImage imageNamed:@"播放"] forState:UIControlStateNormal];
        [self.playBtn setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];

        [self.recorder stopRecorder];
        self.array = nil;
        self.timer.fireDate = [NSDate distantFuture];
        self.scrollView.scrollEnabled = YES;

        self.playBtn.selected = NO;
        self.type = 0;

    }else{
        [SVProgressHUD showInfoWithStatus:@"Haven't started the recording yet!"];
    }
    
}



-(void)addSubViews{
//    for (int i = 0; i <7; i++) {
//        UILabel * label = [UILabel new];
//        label.frame= CGRectMake(self.view.frame.size.width - 25 , 241+i*24, 20, 10);
//        label.textAlignment = 2;
//        if (i==0) {
//            label.text = [NSString stringWithFormat:@"-10"];
//        }
//        if (i==1) {
//            label.text = [NSString stringWithFormat:@"-7"];
//        }if (i==2) {
//            label.text = [NSString stringWithFormat:@"-5"];
//        }if (i==3) {
//            label.text = [NSString stringWithFormat:@"-3"];
//        }if (i==4) {
//            label.text = [NSString stringWithFormat:@"-2"];
//        }if (i==5) {
//            label.text = [NSString stringWithFormat:@"-1"];
//        }if (i==6) {
//            label.text = [NSString stringWithFormat:@"0"];
//        }
//        
//        label.font = [UIFont systemFontOfSize:10];
//        label.textColor = [UIColor whiteColor];
//        [self.view addSubview:label];
//    }
//    for (int i = 0; i <7; i++) {
//        UILabel * label = [UILabel new];
//        label.frame= CGRectMake(self.view.frame.size.width - 25 , 221-i*24, 20, 10);
//        label.textAlignment = 2;
//        if (i==0) {
//            label.text = [NSString stringWithFormat:@"-10"];
//        }
//        if (i==1) {
//            label.text = [NSString stringWithFormat:@"-7"];
//        }if (i==2) {
//            label.text = [NSString stringWithFormat:@"-5"];
//        }if (i==3) {
//            label.text = [NSString stringWithFormat:@"-3"];
//        }if (i==4) {
//            label.text = [NSString stringWithFormat:@"-2"];
//        }if (i==5) {
//            label.text = [NSString stringWithFormat:@"-1"];
//        }if (i==6) {
//            label.text = [NSString stringWithFormat:@"0"];
//        }
//        
//        label.font = [UIFont systemFontOfSize:10];
//        label.textColor = [UIColor whiteColor];
//        [self.view addSubview:label];
//        self.scrollBtn.frame = CGRectMake(10+self.scrollView.frame.origin.x, self.scrollView.frame.origin.y+32, 1, self.scrollView.frame.size.height-32);
//    }
//    
    
}

//设置scrollView
-(void)setScrollView{
    
    self.scrollView.delegate = self;
    self.scrollView.directionalLockEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(self.voiceView.frame.size.width , self.voiceView.frame.size.height);
    //开启分页
    self.scrollView.pagingEnabled = NO;
    //滚动条
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator= NO;
    self.scrollView.bounces = NO;
    self.scrollView.scrollEnabled = YES;
    [self.scrollView addSubview:self.voiceView];
}


//画声波图
-(void)audioPowerChange{
    
    [self.recorder.recorder updateMeters];//更新测量值
    NSFileManager *manger = [NSFileManager defaultManager];
    self.labelText.text = [NSString stringWithFormat:@"total: %.2lluKb",[[manger attributesOfItemAtPath:[self.recorder filePath] error:nil] fileSize] / 1024];
    float power = [self.recorder.recorder averagePowerForChannel:0];//取得第一个通道的音频，注意音频强度范围时-160到0
    NSNumber * number = [NSNumber numberWithFloat:power];
    [self.array addObject:number];
    
    self.voiceView.array = self.array;
    float i = 0 ;
    if (IS_IPHONE_6) {
        i  = self.array.count * 375/600.0;
        
    }
    if (IS_IPHONE_6P) {
        i  = self.array.count * 414.0/600.0;
        
    }
    if (IS_IPHONE_5) {
        i  = self.array.count * 320.0 /600.0;
        
    }
    int d = (int)self.array.count;
    self.label.text = [NSString stringWithFormat:@"%d%d:%d%d.%d%d",d/60000%6,d/6000%10,d/1000%6,d/100%10,d/10%10,d%10];
    
    //添加竖线,数字
    if (self.array.count % 25 == 0 ) {
        UIButton *btn = [UIButton new];
        btn.frame=CGRectMake(10+i+self.view.frame.size.width, 25, 1, 5);
        btn.backgroundColor = [UIColor whiteColor];
        [_voiceView addSubview:btn];
    }
    
    if (self.array.count % 100 == 0) {
        UIButton *btn = [UIButton new];
        btn.frame=CGRectMake(10+i+self.view.frame.size.width, 12, 1, 20);
        btn.backgroundColor = [UIColor whiteColor];
        [_voiceView addSubview:btn];
        UILabel * label =[UILabel new];
        label.font = [UIFont systemFontOfSize:10];
        label.textColor = [UIColor  whiteColor];
        label.frame= CGRectMake(10+i+self.view.frame.size.width+5, 12, 30, 10);
        int f = (int)self.array.count / 100 + 6;
        label.text = [NSString stringWithFormat:@"%d%d:%d%d",f/600%6,f/60%10,f/10%6,f%10];
        [_voiceView addSubview:label];
        
        
    }
    if (i<= self.scrollView.frame.size.width/1.5-10) {
        self.scrollBtn.frame = CGRectMake(10+self.scrollView.frame.origin.x+i, self.scrollView.frame.origin.y+32, 1, self.scrollView.frame.size.height-32);
        if(self.scrollBtn.frame.origin.x >= self.label.center.x){
            self.label.center = CGPointMake(10+self.scrollView.frame.origin.x+i, self.label.center.y);
        }
    }
    //如果超过屏幕一半  增加view的frame
    
    if (i>= self.scrollView.frame.size.width/1.5-10) {
        //屏幕移动
        self.scrollView.contentOffset =CGPointMake(i-self.view.frame.size.width/1.5+10, 0);
        self.voiceView.frame =CGRectMake(0, 0, self.view.frame.size.width*1.0/1.5+10+i,self.voiceView.frame.size.height*1.0);
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width*1.0/1.5+ 10+i , self.voiceView.frame.size.height*1.0);
        
    }
    else{
        
        self.voiceView.frame =CGRectMake(0, 0, 10+self.view.frame.size.width,self.voiceView.frame.size.height);
        self.scrollView.contentSize = CGSizeMake(10+self.view.frame.size.width, self.voiceView.frame.size.height);
        
    }
    [self.voiceView setNeedsDisplay];
}





#pragma mark - 设置状态栏颜色
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}



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
