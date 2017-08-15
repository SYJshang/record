//
//  SYJDrawController.m
//  RecordPen
//
//  Created by 尚勇杰 on 2017/8/9.
//  Copyright © 2017年 尚勇杰. All rights reserved.
//

#import "SYJDrawController.h"
#import "ZYQAssetPickerController.h"
#import "UIView+WHB.h"
#import "HBDrawingBoard.h"
#import "JXPopoverView.h"
#import "CDPReplay.h"
#import <Photos/Photos.h>



@interface SYJDrawController ()<ZYQAssetPickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,HBDrawingBoardDelegate,CDPReplayDelegate>

@property (nonatomic, strong) HBDrawingBoard *drawView;
@property (nonatomic, strong) UIButton *btn;


@end

@implementation SYJDrawController

#pragma mark - 点击事件
////开始录制
//-(void)start{
//
//}
////结束录制
//-(void)end{
//    
//}


- (void)record:(UIButton *)sender{
    
    if (sender.selected == NO) {
        
        [[CDPReplay sharedReplay] startRecord];
        
        [self.btn setTitle:@"Initializing" forState:UIControlStateNormal];
        
        sender.selected = YES;

    }else{
        
        [[CDPReplay sharedReplay] stopRecordAndShowVideoPreviewController:YES];
        
        [self.btn setTitle:@"Record" forState:UIControlStateNormal];
        sender.selected = NO;

    }
    
}

- (void)drawSeting:(id)sender{
    
//    HBDrawingShapeCurve = 0,//曲线
//    HBDrawingShapeLine,//直线
//    HBDrawingShapeEllipse,//椭圆
//    HBDrawingShapeRect,//矩形
    
    JXPopoverView *popoverView = [JXPopoverView popoverView];
    JXPopoverAction *action1 = [JXPopoverAction actionWithTitle:@"curve" handler:^(JXPopoverAction *action) {
        
        self.drawView.shapType = 0;
        
        [self.drawView showSettingBoard];
    }];
    
    JXPopoverAction *action2 = [JXPopoverAction actionWithTitle:@"straight line" handler:^(JXPopoverAction *action) {
        
        self.drawView.shapType = 1;
        
        [self.drawView showSettingBoard];
        
    }];
    
    
    JXPopoverAction *action3 = [JXPopoverAction actionWithTitle:@"rectangle" handler:^(JXPopoverAction *action) {
        
        self.drawView.shapType = 3;
        
        [self.drawView showSettingBoard];
    }];
    
    
    JXPopoverAction *action4 = [JXPopoverAction actionWithTitle:@"ellipse" handler:^(JXPopoverAction *action) {
        
        self.drawView.shapType = 2;
        
        [self.drawView showSettingBoard];
        
    }];
    
    [popoverView showToView:sender withActions:@[action1,action2,action3,action4]];
    

}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *iterm = [UIButton buttonWithType:UIButtonTypeCustom];
    iterm.frame = CGRectMake(5, 10, 60, 24);
    [iterm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [iterm setTitle:@"record" forState:UIControlStateNormal];
    iterm.titleLabel.font = [UIFont systemFontOfSize:12];
    [iterm addTarget:self action:@selector(record:) forControlEvents:UIControlEventTouchUpInside];
    self.btn = iterm;
    self.btn.selected = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.btn];
    
    UIButton *iterm1 = [UIButton buttonWithType:UIButtonTypeCustom];
    iterm1.frame = CGRectMake(5, 10, 70, 24);
    [iterm1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [iterm1 setTitle:@"DrawSetting" forState:UIControlStateNormal];
    iterm1.titleLabel.font = [UIFont systemFontOfSize:12];
    [iterm1 addTarget:self action:@selector(drawSeting:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:iterm1];
    
    self.navigationItem.titleView = [UILabel titleWithColor:[UIColor colorWithWhite:0.5 alpha:1.0] title:@"DrawBoard" font:17.0];
    
    
    [self.view addSubview:self.drawView];
    
    [CDPReplay sharedReplay].delegate = self;
    
    self.drawView.shapType = 0;
    
    [self.drawView showSettingBoard];

    // Do any additional setup after loading the view.
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
//    [self drawSetting:nil];
}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.drawView.backImage.image = image;
    
    __weak typeof(self) weakSelf = self;
    [picker dismissViewControllerAnimated:YES completion:^{
        [weakSelf.drawView showSettingBoard];
    }];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    __weak typeof(self) weakSelf = self;
    [picker dismissViewControllerAnimated:YES completion:^{
        [weakSelf.drawView showSettingBoard];
    }];
}
#pragma mark - ZYQAssetPickerController Delegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    
    NSMutableArray *marray = [NSMutableArray array];
    
    for(int i=0;i<assets.count;i++){
        
        ALAsset *asset = assets[i];
        
        UIImage *image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        
        [marray addObject:image];
        
    }
    self.drawView.backImage.image = [marray firstObject];
    
}
#pragma mark - HBDrawingBoardDelegate
- (void)drawBoard:(HBDrawingBoard *)drawView action:(actionOpen)action{
    
    switch (action) {
        case actionOpenAlbum:
        {
            ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc]init];
            picker.maximumNumberOfSelection = 1;
            picker.assetsFilter = [ALAssetsFilter allAssets];
            picker.showEmptyGroups = NO;
            picker.delegate = self;
            [self presentViewController:picker animated:YES completion:nil];
        }
            
            break;
        case actionOpenCamera:
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                
                UIImagePickerController *pickVc = [[UIImagePickerController alloc] init];
                
                pickVc.sourceType = UIImagePickerControllerSourceTypeCamera;
                pickVc.delegate = self;
                [self presentViewController:pickVc animated:YES completion:nil];
                
            }else{
                
                UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"Hint" message:@"You don't have a camera!" delegate:nil cancelButtonTitle:@"ensure" otherButtonTitles:nil, nil];
                [alter show];
            }
        }
            break;
            
        default:
            break;
    }
    
}
- (void)drawBoard:(HBDrawingBoard *)drawView drawingStatus:(HBDrawingStatus)drawingStatus model:(HBDrawModel *)model{
    
//    NSLog(@"%@",model.keyValues);
}
- (HBDrawingBoard *)drawView
{
    if (!_drawView) {
        _drawView = [[HBDrawingBoard alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
        _drawView.delegate = self;
        
    }
    return _drawView;
}

#pragma mark - CDPReplayDelegate代理
/**
 *  开始录制回调
 */
-(void)replayRecordStart{
    [SVProgressHUD showSuccessWithStatus:@"Begin recording!"];
    [self.btn setTitle:@"Recording" forState:UIControlStateNormal];
}

/**
 *  录制结束或错误回调
 */
-(void)replayRecordFinishWithVC:(RPPreviewViewController *)previewViewController errorInfo:(NSString *)errorInfo{
    
    if (!NULLString(errorInfo)) {
        [SVProgressHUD showErrorWithStatus:errorInfo];
    }else{
        [SVProgressHUD showSuccessWithStatus:@"Stop recording!"];
 
    }
    
}
/**
 *  视频保存到系统相册成功回调
 */
-(void)saveSuccess{
    
    [self saveVideoSuccess:^{
       
        [SVProgressHUD showSuccessWithStatus:@"Save Success!"];
        
    }];

}


- (void)saveVideoSuccess:(void(^)())success{
    //获取最近一次的相册图片/视频的信息PHAsset
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    options.includeAssetSourceTypes = PHAssetSourceTypeNone;//默认相册
    PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];
    PHAsset *asset = [assetsFetchResults firstObject];
    PHAssetResource *assetRescource = [[PHAssetResource assetResourcesForAsset:asset] firstObject];
    
    //创建保存到沙盒的路径
    NSString *uuidString = [[NSUUID UUID] UUIDString];
    NSString *fileName = uuidString;
    
    NSString *docmentPath = [NSString stringWithFormat:@"%@/FilePath/photosFile", [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir= NO;
    BOOL existed = [fileManager fileExistsAtPath:docmentPath isDirectory:&isDir];
    if (!(existed&&isDir)){
        [fileManager createDirectoryAtPath:docmentPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *filePath = [docmentPath stringByAppendingPathComponent:fileName];
    //保存到沙盒
    __weak typeof(self) weakSelf = self;
    PHAssetResourceManager *manager = [PHAssetResourceManager defaultManager];
    [manager writeDataForAssetResource:assetRescource toFile:[NSURL fileURLWithPath:filePath] options:nil completionHandler:^(NSError * _Nullable error) {
        if (error==nil) {
            if(success)success();
            NSLog(@"保存沙盒成功");
        }else{
            [weakSelf saveVideoSuccess:success];
            NSLog(@"保存沙盒失败,重新尝试");
        }
    }];
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
