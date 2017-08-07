//
//  SYJAboutController.m
//  RecordPen
//
//  Created by 尚勇杰 on 2017/8/4.
//  Copyright © 2017年 尚勇杰. All rights reserved.
//

#import "SYJAboutController.h"

@interface SYJAboutController ()

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *versionLab;
@property (nonatomic, strong) UILabel *copyrightLab;

@end

@implementation SYJAboutController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = Gray;
    
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];

    NSString *icon = [[infoPlist valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];

    UIImage *image = [UIImage imageNamed:icon];
    if (image) {
        self.icon = [[UIImageView alloc]initWithImage:image];
  
    }else{
        self.icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_noteMemo_attachments"]];
 
    }
    [self.view addSubview:self.icon];
    self.icon.sd_layout.centerXEqualToView(self.view).topSpaceToView(self.view, 40).heightIs(160).widthIs(160);
    
    self.versionLab = [[UILabel alloc]init];
    [self.view addSubview:self.versionLab];
    self.versionLab.font = [UIFont systemFontOfSize:15];
    self.versionLab.textColor = [UIColor whiteColor];
    self.versionLab.textAlignment = NSTextAlignmentCenter;
    self.versionLab.sd_layout.leftSpaceToView(self.view, 40).rightSpaceToView(self.view, 40).heightIs(20).topSpaceToView(self.icon, 10);
    NSString *app_Version = [infoPlist objectForKey:@"CFBundleShortVersionString"];
    self.versionLab.text = [NSString stringWithFormat:@"The current version number is:%@",app_Version];
    
    self.copyrightLab = [[UILabel alloc]init];
    [self.view addSubview:self.copyrightLab];
    self.copyrightLab.font = [UIFont systemFontOfSize:15];
    self.copyrightLab.textColor = [UIColor whiteColor];
    self.copyrightLab.textAlignment = NSTextAlignmentCenter;
    self.copyrightLab.numberOfLines = 0;
    self.copyrightLab.sd_layout.leftSpaceToView(self.view, 40).rightSpaceToView(self.view, 40).heightIs(60).topSpaceToView(self.versionLab, 30);
    self.copyrightLab.text = [NSString stringWithFormat:@"Copyright information: Shanghai moxi culture media co., LTD"];
    
    
    
    
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
