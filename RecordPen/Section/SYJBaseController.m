//
//  SYJBaseController.m
//  RecordPen
//
//  Created by 尚勇杰 on 2017/7/27.
//  Copyright © 2017年 尚勇杰. All rights reserved.
//

#import "SYJBaseController.h"

@interface SYJBaseController ()

@end

@implementation SYJBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bgImgView.image = [UIImage imageNamed:@"123.jpg"];
    [self.view addSubview:bgImgView];
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, bgImgView.frame.size.width, bgImgView.frame.size.height)];
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    [bgImgView addSubview:toolbar];
    
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
