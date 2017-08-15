//
//  ZYTabBarController.m
//  tabbar增加弹出bar
//
//  Created by tarena on 16/7/2.
//  Copyright © 2016年 张永强. All rights reserved.
//

#import "ZYTabBarController.h"
#import "ZYTabBar.h"
#import "SYJDrawController.h"
#import "SYJMineController.h"
#import "SYJNavitionController.h"
#import "SYJRecordController.h"
#import "SMNoteFolderController.h"
#import "JZViewController.h"

@interface ZYTabBarController ()<ZYTabBarDelegate>

@end

@implementation ZYTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置子视图
    [self setUpAllChildVc];
    [self configureZYPathButton];
    
    
}


- (void)configureZYPathButton {
    ZYTabBar *tabBar = [ZYTabBar new];
    tabBar.delegate = self;
    ZYPathItemButton *itemButton_1 = [[ZYPathItemButton alloc]initWithImage:[UIImage imageNamed:@"视频"]highlightedImage:[UIImage imageNamed:@"视频"]backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
    ZYPathItemButton *itemButton_2 = [[ZYPathItemButton alloc]initWithImage:[UIImage imageNamed:@"record"]highlightedImage:[UIImage imageNamed:@"record"]backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
    
    ZYPathItemButton *itemButton_3 = [[ZYPathItemButton alloc]initWithImage:[UIImage imageNamed:@"编辑"]highlightedImage:[UIImage imageNamed:@"编辑"]backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
    
//    ZYPathItemButton *itemButton_4 = [[ZYPathItemButton alloc]initWithImage:[UIImage imageNamed:@"chooser-moment-icon-thought"]highlightedImage:[UIImage imageNamed:@"chooser-moment-icon-thought-highlighted"]backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
//    
//    ZYPathItemButton *itemButton_5 = [[ZYPathItemButton alloc]initWithImage:[UIImage imageNamed:@"chooser-moment-icon-sleep"]highlightedImage:[UIImage imageNamed:@"chooser-moment-icon-sleep-highlighted"]backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
    tabBar.pathButtonArray = @[itemButton_1 , itemButton_2 , itemButton_3];
    tabBar.basicDuration = 0.5;
    tabBar.allowSubItemRotation = YES;
    tabBar.bloomRadius = 100;
    tabBar.allowCenterButtonRotation = YES;
    tabBar.bloomAngel = 100;
    //kvc实质是修改了系统的_tabBar
    [self setValue:tabBar forKeyPath:@"tabBar"];
    
}


- (void)setUpAllChildVc {
    
    SYJDrawController *HomeVC = [[SYJDrawController alloc] init];
    [self setUpOneChildVcWithVc:HomeVC Image:@"画板1" selectedImage:@"画板" title:@"Drawing"];
    
    SYJMineController *MineVC = [[SYJMineController alloc] init];
    [self setUpOneChildVcWithVc:MineVC Image:@"我1" selectedImage:@"我" title:@"Mine"];
}
#pragma mark - 初始化设置tabBar上面单个按钮的方法

/**
 *  @author li bo, 16/05/10
 *
 *  设置单个tabBarButton
 *
 *  @param Vc            每一个按钮对应的控制器
 *  @param image         每一个按钮对应的普通状态下图片
 *  @param selectedImage 每一个按钮对应的选中状态下的图片
 *  @param title         每一个按钮对应的标题
 */
- (void)setUpOneChildVcWithVc:(UIViewController *)Vc Image:(NSString *)image selectedImage:(NSString *)selectedImage title:(NSString *)title
{
    
    Vc.tabBarItem  = [Vc.tabBarItem initWithTitle:title image:[[UIImage imageNamed:image]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
//    Vc.view.backgroundColor = [self randomColor];
    
    UIImage *myImage = [UIImage imageNamed:image];
    myImage = [myImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //tabBarItem，是系统提供模型，专门负责tabbar上按钮的文字以及图片展示
    Vc.tabBarItem.image = myImage;
    UIImage *mySelectedImage = [UIImage imageNamed:selectedImage];
    mySelectedImage = [mySelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    Vc.tabBarItem.selectedImage = mySelectedImage;
    Vc.tabBarItem.title = title;
    Vc.navigationItem.title = title;
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:RGBA(121, 167, 84, 1.0),NSFontAttributeName:[UIFont systemFontOfSize:12]} forState:UIControlStateSelected];

    
   
    SYJNavitionController *nav = [[SYJNavitionController alloc] initWithRootViewController:Vc];
    [self addChildViewController:nav];
    
}
- (UIColor *)randomColor
{
    CGFloat r = arc4random_uniform(256);
    CGFloat g = arc4random_uniform(256);
    CGFloat b = arc4random_uniform(256);
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
}
- (void)pathButton:(ZYPathButton *)ZYPathButton clickItemButtonAtIndex:(NSUInteger)itemButtonIndex {
    NSLog(@" 点中了第%ld个按钮" , itemButtonIndex);
    if (itemButtonIndex == 0) {
        
        SYJNavitionController *Vc = [[SYJNavitionController alloc]initWithRootViewController:[JZViewController new]];
        [self presentViewController:Vc animated:YES completion:nil];

    }else if (itemButtonIndex == 1){
        
        SYJNavitionController *Vc = [[SYJNavitionController alloc]initWithRootViewController:[SYJRecordController new]];
        [self presentViewController:Vc animated:YES completion:nil];

 
    }else{
        
        SYJNavitionController *Vc = [[SYJNavitionController alloc]initWithRootViewController:[SMNoteFolderController new]];
        [self presentViewController:Vc animated:YES completion:nil];
    }
}



@end
