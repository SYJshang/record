//
//  AppDelegate.m
//  RecordPen
//
//  Created by 尚勇杰 on 2017/7/26.
//  Copyright © 2017年 尚勇杰. All rights reserved.
//

#import "AppDelegate.h"
//#import "SYJRecordController.h"
//#import "SYJListController.h"
//#import "SYJRecordController.h"
#import "ZYTabBarController.h"
#import "SYJNavitionController.h"

#import "BATouchID.h"
#import "BATouchIDLoginVC.h"

#import "NSString+BAKit.h"

@interface AppDelegate ()<UIApplicationDelegate> {
//    GCDWebUploader *_webUploader;
}

@end

@implementation AppDelegate

- (void)switchToRootVc{
    
#pragma mark - 后台配置信息
    
//    This is a professional tool for learning, including audio, video, drawing, recording screen content, notes; click on the video recording, you can also choose to modify the video, pictures, background music, add text, a variety of interesting features. Also added password settings, enter App settings password, to protect their privacy.
//    
//    [specific highlights]
//    1. powerful drawing board function, click the top left corner, select the shape, below the tool box, you can choose the color and line thickness, finished painting to save to the local;
//    2. click the recording screen above the left and save it to your local album;
//    3. video recording, you can choose album, video, or shoot video, and can edit the video, add background pictures or background music, and can record video saved locally;
//    4. recording function, add recording function, and deposited in the local, you can share with the computer file;
//    5., diary function, personality diary, record their important content;
//    6. add password settings, enter App input fingerprint or gesture password, protect user privacy;
//    
//    So powerful tools, shouldn't you have one? Hurry up and join us!
    
    
#pragma mark - 描述

//    This is a powerful utility, including Sketchpad, screen recording, video recording, editing, recording, diary, adding password settings to protect user privacy.
//    Click on the top left corner to open the screen recording, completed and saved to the album, select the handwriting Sketchpad click on the top right corner, and some color settings; click on the middle Reference, select the video recording, or diary; open the password in the settings, to protect user privacy.
//    The next version focuses on optimizing the interface, enhancing user experience and beautifying the App interface.
    
    
    ZYTabBarController *vc = [[ZYTabBarController alloc]init];
    vc.selectedIndex = 0;
    self.window.rootViewController = vc;
    
}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    

    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self checkIsAlreadyOpenTouchIDIsStart:YES];

    
//    ZYTabBarController *vc = [[ZYTabBarController alloc]init];
//    self.window.rootViewController = vc;
    
    [self.window makeKeyAndVisible];
    
    
//    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    
    
    
    
    // Override point for customization after application launch.
    return YES;
}


- (void)test
{
    NSDate *date = [kUserDefaults objectForKey:kLastEnterBackgroundDate];
    
    // 进入后台 10 秒后需要重新验证指纹
    if (!date || [[NSString ba_intervalSinceNow:date] floatValue] > 1*3)
    {
        [self checkIsAlreadyOpenTouchIDIsStart:NO];
    }
}

- (void)checkIsAlreadyOpenTouchIDIsStart:(BOOL)isStart
{
//    id isLogin = [kUserDefaults objectForKey:kIsLogin];
    id isOpenTouchID = [kUserDefaults objectForKey:kIsOpenTouchID];
    id isGesterID = [kUserDefaults objectForKey:kIsOpenUnlockedGesture];
    

        if ([isOpenTouchID intValue] == 1 || [isGesterID intValue] == 1)
        {
            
            BATouchIDLoginVC *vc = [BATouchIDLoginVC new];
            SYJNavitionController *navi = [[SYJNavitionController alloc] initWithRootViewController:vc];
            if (isStart)
            {
                vc.isStart = YES;
                [[UIApplication sharedApplication].windows lastObject].rootViewController = navi;
            }
            else
            {
                [self.window.rootViewController presentViewController:navi animated:NO completion:nil];
            }
        }else{
            
            self.window.rootViewController = [ZYTabBarController new];
        }
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    [kUserDefaults setObject:[NSDate date] forKey:kLastEnterBackgroundDate];

    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
