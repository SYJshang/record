//
//  SYJNavitionController.m
//  MoXiDemo
//
//  Created by 尚勇杰 on 2017/5/26.
//  Copyright © 2017年 尚勇杰. All rights reserved.
//

#import "SYJNavitionController.h"

@interface SYJNavitionController ()

@end

@implementation SYJNavitionController

+ (void)initialize
{
    // 设置整个项目所有item的主题样式
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    
    // 设置普通状态
    // key：NS****AttributeName
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor orangeColor];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    // 设置不可用状态
    NSMutableDictionary *disableTextAttrs = [NSMutableDictionary dictionary];
    disableTextAttrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.7];
    
    //  每一个像素都有自己的颜色，每一种颜色都可以由RGB3色组成
    //  12bit颜色: #f00  #0f0 #00f #ff0
    //  24bit颜色: #ff0000 #ffff00  #000000  #ffffff
    
    // #ff ff ff
    // R:255
    // G:255
    // B:255
    
    // RGBA
    //  32bit颜色: #556677
    
    // #ff00ff
    
    disableTextAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    [item setTitleTextAttributes:disableTextAttrs forState:UIControlStateDisabled];
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"123"] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.barStyle = UIBarStyleBlack;
    
    //    self.interactivePopGestureRecognizer.delegate = (id)self;
    //
    //    UIGestureRecognizer *gesture = self.interactivePopGestureRecognizer;
    //    gesture.enabled = NO;
    //    UIView *gestureView = gesture.view;
    //
    //    UIPanGestureRecognizer *popRecognizer = [[UIPanGestureRecognizer alloc] init];
    //    popRecognizer.delegate = self;
    //    popRecognizer.maximumNumberOfTouches = 1;
    //    [gestureView addGestureRecognizer:popRecognizer];
    //
    //    /**
    //     *  获取系统手势的target数组
    //     */
    //    NSMutableArray *_targets = [gesture valueForKey:@"_targets"];
    //    /**
    //     *  获取它的唯一对象，我们知道它是一个叫UIGestureRecognizerTarget的私有类，它有一个属性叫_target
    //     */
    //    id gestureRecognizerTarget = [_targets firstObject];
    //    /**
    //     *  获取_target:_UINavigationInteractiveTransition，它有一个方法叫handleNavigationTransition:
    //     */
    //    id navigationInteractiveTransition = [gestureRecognizerTarget valueForKey:@"_target"];
    //    /**
    //     *  通过前面的打印，我们从控制台获取出来它的方法签名。
    //     */
    //    SEL handleTransition = NSSelectorFromString(@"handleNavigationTransition:");
    //    /**
    //     *  创建一个与系统一模一样的手势，我们只把它的类改为UIPanGestureRecognizer
    //     */
    //    [popRecognizer addTarget:navigationInteractiveTransition action:handleTransition];
    
    
    
    //    self.navigationBar.alpha = 1.0;
    
    //    self.navigationBar.translucent = NO;
    ////    self.navigationBar.barStyle = UIBarStyleBlack;
    //    self.navigationBar.backgroundColor = TextColor;
    //    self.navigationBar.tintColor = [UIColor colorWithRed:51.0/255.0 green:143.0/255.0 blue:210.0/255.0 alpha:0.8];
    
    
    // Do any additional setup after loading the view.
}

//-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
//
//    /**
//     *  这里有两个条件不允许手势执行，1、当前控制器为根控制器；2、如果这个push、pop动画正在执行（私有属性）
//     */
//    return self.viewControllers.count != 1 && ![[self valueForKey:@"_isTransitioning"] boolValue];
//}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) { // 这时push进来的控制器viewController，不是第一个子控制器（不是根控制器）
        /* 自动显示和隐藏tabbar */
//        viewController.hidesBottomBarWhenPushed = YES;
        
        /* 设置导航栏上面的内容 */
        // 设置左边的返回按钮
        /* 设置导航栏上面的内容 */
        // 设置左边的返回按钮
        //        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:<#(id)#> action:<#(SEL)#> image:<#(NSString *)#> highImage:<#(NSString *)#>];
        
        //         设置右边的更多按钮
        //        viewController.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(more) image:@"主页_消息" highImage:@"主页_消息"];
        
    }
    
    [super pushViewController:viewController animated:animated];
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
