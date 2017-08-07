
//
//  SYJShareFileController.m
//  RecordPen
//
//  Created by 尚勇杰 on 2017/8/4.
//  Copyright © 2017年 尚勇杰. All rights reserved.
//

#import "SYJShareFileController.h"
#import "GCDWebUploader.h"


@interface SYJShareFileController ()<UIApplicationDelegate> {
    GCDWebUploader *_webUploader;
}


@property (nonatomic, strong) UILabel *label1;
@property (nonatomic, strong) UILabel *lable2;
@property (nonatomic, strong) UILabel *label3;

@end

@implementation SYJShareFileController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = [UILabel titleWithColor:[UIColor whiteColor] title:@"File sharing" font:17.0];
    
    UIImageView *img1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"手机"]];
    [self.view addSubview:img1];
    img1.sd_layout.leftSpaceToView(self.view, 20).topSpaceToView(self.view, 80).heightIs(80).widthIs(80);
    
    UIImageView *img2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"WIFI"]];
    [self.view addSubview:img2];
    img2.sd_layout.centerXEqualToView(self.view).topSpaceToView(self.view, 80).heightIs(80).widthIs(80);
    
    UIImageView *img3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"电脑"]];
    [self.view addSubview:img3];
    img3.sd_layout.rightSpaceToView(self.view, 20).topSpaceToView(self.view, 80).heightIs(80).widthIs(80);
    
    self.label1 = [[UILabel alloc]init];
    [self.view addSubview:self.label1];
    self.label1.font = [UIFont systemFontOfSize:16];
    self.label1.textColor = [UIColor whiteColor];
    self.label1.numberOfLines = 0;
    self.label1.textAlignment = NSTextAlignmentCenter;
    self.label1.sd_layout.leftSpaceToView(self.view, 10).rightSpaceToView(self.view, 10).topSpaceToView(img2, 60).heightIs(40);
    self.label1.text = @"1.Please ensure that your iPhone is connected to a wireless network！";
    
    self.lable2 = [[UILabel alloc]init];
    [self.view addSubview:self.lable2];
    self.lable2.font = [UIFont systemFontOfSize:16];
    self.lable2.textColor = [UIColor whiteColor];
    self.lable2.numberOfLines = 0;
    self.lable2.textAlignment = NSTextAlignmentCenter;
    self.lable2.sd_layout.leftSpaceToView(self.view, 10).rightSpaceToView(self.view, 10).topSpaceToView(self.label1, 10).heightIs(40);
    self.lable2.text = @"2.Open the following address in the browser:";
    
    
    NSString *documentsPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingString:@"/FilePath"];
    
    _webUploader = [[GCDWebUploader alloc] initWithUploadDirectory:documentsPath];
    [_webUploader start];
    NSLog(@"Visit %@ in your web browser", _webUploader.serverURL);

    
    self.label3 = [[UILabel alloc]init];
    [self.view addSubview:self.label3];
    self.label3.font = [UIFont systemFontOfSize:16];
    self.label3.textColor = [UIColor whiteColor];
    self.label3.numberOfLines = 0;
    self.label3.textAlignment = NSTextAlignmentCenter;
    self.label3.sd_layout.leftSpaceToView(self.view, 10).rightSpaceToView(self.view, 10).topSpaceToView(self.lable2, 10).heightIs(40);
    self.label3.text = [NSString stringWithFormat:@"%@",_webUploader.serverURL];
    
    // Do any additional setup after loading the view.
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
