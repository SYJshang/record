//
//  SYJTabBarController.m
//  MoXiDemo
//
//  Created by 尚勇杰 on 2017/5/26.
//  Copyright © 2017年 尚勇杰. All rights reserved.
//

#import "SYJTabBarController.h"
#import "SYJBaseController.h"
#import "SYJNavitionController.h"
#import "SYJRecordController.h"
#import "SYJVideoController.h"
#import "SYJMineController.h"
#import "SMNoteFolderController.h"



@interface SYJTabBarController ()

@end

@implementation SYJTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //
    SYJRecordController *main = [[SYJRecordController alloc]init] ;
    //    main.view.backgroundColor = [UIColor redColor];
    [self addChildVc:main Title:@"Recode" withTitleSize:12.0 andFoneName:@"HelveticaNeue-Bold" selectedImage:@"录音s" withTitleColor:TextColor unselectedImage:@"录音1" withTitleColor:[UIColor lightGrayColor]];
    //
    SMNoteFolderController  *caseVC = [[SMNoteFolderController alloc]init];
    //    caseVC.view.backgroundColor = [UIColor grayColor];
    [self addChildVc:caseVC Title:@"Note" withTitleSize:12.0 andFoneName:@"HelveticaNeue-Bold" selectedImage:@"记事本" withTitleColor:TextColor unselectedImage:@"记事本1" withTitleColor:[UIColor lightGrayColor]];
    //
   
    SYJMineController *luntanVC = [[SYJMineController alloc]init];
    [self addChildVc:luntanVC Title:@"Mine" withTitleSize:12.0 andFoneName:@"HelveticaNeue-Bold" selectedImage:@"我的" withTitleColor:TextColor unselectedImage:@"我的1" withTitleColor:[UIColor lightGrayColor]];
    
    //我的
//    SYJMineController *MyVC = [[SYJMineController alloc]init];
//    //    MyVC.view.backgroundColor = [UIColor purpleColor];
//    [self addChildVc:MyVC Title:@"Mine" withTitleSize:12.0 andFoneName:@"HelveticaNeue-Bold" selectedImage:@"我的1" withTitleColor:TextColor unselectedImage:@"我的2" withTitleColor:[UIColor lightGrayColor]];
    
    
    // Do any additional setup after loading the view.
}


- (void)addChildVc:(UIViewController *)childVc
             Title:(NSString *)title
     withTitleSize:(CGFloat)size
       andFoneName:(NSString *)foneName
     selectedImage:(NSString *)selectedImage
    withTitleColor:(UIColor *)selectColor
   unselectedImage:(NSString *)unselectedImage
    withTitleColor:(UIColor *)unselectColor{
    childVc.title = title;
   // 设置图片
    childVc.tabBarItem  = [childVc.tabBarItem initWithTitle:title image:[[UIImage imageNamed:unselectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    //未选中字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:unselectColor,NSFontAttributeName:[UIFont fontWithName:foneName size:size]} forState:UIControlStateNormal];
    
    //选中字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:selectColor,NSFontAttributeName:[UIFont fontWithName:foneName size:size]} forState:UIControlStateSelected];
    SYJNavitionController *nav = [[SYJNavitionController alloc] initWithRootViewController:childVc];
    // 添加为子控制器
    [self addChildViewController:nav];
    
    /*
     //base64加密

    NSString *str = @"134567";
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSString *sta = [data base64EncodedStringWithOptions:0];
    
    NSData *nsdataFromBase64String = [[NSData alloc]
                                      initWithBase64EncodedString:sta options:0];
    
    // Decoded NSString from the NSData
    NSString *base64Decoded = [[NSString alloc]
                               initWithData:nsdataFromBase64String encoding:NSUTF8StringEncoding];
     */
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
