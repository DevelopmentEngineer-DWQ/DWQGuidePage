//
//  AppDelegate.m
//  DWQGuidePage
//
//  Created by 杜文全 on 16/2/12.
//  Copyright © 2016年 com.developer.duwenquan. All rights reserved.

#import "AppDelegate.h"
#import "ViewController.h"
#import "DWQLaunchVC.h"
#import "DWQAdDetailVC.h"
#import "DWQIntroductionPage.h"
@interface AppDelegate ()<DWQLaunchDelegate,DWQIntroductionDelegate>
{
    DWQIntroductionPage * _dwqIntroductionPage;
    NSArray *            _dwqCoverImgNameArr;
    NSArray *            _dwqBgImgNameArr;
    NSArray *            _dwqCoverTitleArr;
    NSURL   *            _dwqVideoUrl;
    DWQLaunchVC *         _dwqLaunch;
}


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    ViewController * dwqVC = [[ViewController alloc]init];
    
#pragma mark-dwq －启动页
    
#pragma mark-dwq -默认
    //      _dwqLaunch = [[DWQLaunchVC alloc]initWithRootVC:dwqVC withLaunchType:DWQLaunchNormal];
    //        _dwqLaunch.dwqNormalDuration = 2;
    //    //本地
    ////      _dwqLaunch.dwqNormalImgName = @"DWQLaunchImg.jpeg";
    //    //网络
    //    _dwqLaunch.dwqIsCloseTimer = YES;//跟引导页(DWQIntroductionPage)一起用的时候要打开/否则关闭
    //        _dwqLaunch.dwqNormalImgUrl = @"https://a-ssl.duitang.com/uploads/item/201409/05/20140905150403_N8J8Z.thumb.700_0.jpeg";
    
#pragma mark-dwq -广告
//    _dwqLaunch = [[DWQLaunchVC alloc]initWithRootVC:dwqVC withLaunchType:DWQLaunchAD];
//    _dwqLaunch.dwqAdDuration = 4;
//    _dwqLaunch.dwqDelegate = self;
//    _dwqLaunch.dwqAdActionUrl = @"https://github.com/DevelopmentEngineer-DWQ";
//    //        _dwqLaunch.dwqIsCloseTimer = YES;//跟引导页(DWQIntroductionPage)一起用的时候要打开/否则关闭
//    //网络
//    //        _dwqLaunch.dwqAdImgUrl = @"https://a-ssl.duitang.com/uploads/item/201409/05/20140905150403_N8J8Z.thumb.700_0.jpeg";
//    // 本地
//    _dwqLaunch.dwqAdLocalImgName = @"DWQAd.png";
    
#pragma mark-dwq -新手向导
//            _dwqLaunch = [[DWQLaunchVC alloc]initWithRootVC:dwqVC withLaunchType:DWQLaunchGuide];
//            //本地
//           _dwqLaunch.dwqGuideImgNameArr = @[@"DWQGuide01.jpeg",@"DWQGuide02.jpeg",@"DWQGuide03.jpeg"];
//            //网络
//           _dwqLaunch.dwqGuideImgUrlArr = @[@"https://a-ssl.duitang.com/uploads/item/201409/05/20140905150403_N8J8Z.thumb.700_0.jpeg",@"https://a-ssl.duitang.com/uploads/item/201508/02/20150802181000_mYurv.jpeg"];
    
#pragma mark-dwq -gif动态图
//            _dwqLaunch = [[DWQLaunchVC alloc]initWithRootVC:dwqVC withLaunchType:DWQLaunchGif];
//        //本地
//            _dwqLaunch.dwqGifImgName = @"DWQ01";
    //    //网络
    ////        _dwqLaunch.dwqGifImgUrl = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1487946714041&di=a2522f1c0449bf5f4f0f36fa4ec665bb&imgtype=0&src=http%3A%2F%2Fiosfile.feng91.com%2Fforum%2F201306%2F29%2F231324onbs8c0d0chcon9c.gif";
    
#pragma mark-dwq -自动滚动
//            _dwqLaunch = [[DWQLaunchVC alloc]initWithRootVC:dwqVC withLaunchType:DWQLaunchAutoRoll];
//            //本地
//         //  _dwqLaunch.dwqRollImgName = @"DWQRoll.jpeg";
//    //        //网络
//            _dwqLaunch.dwqRollImgUrl  = @"http://bizhi.zhuoku.com/2017/02/23/zhuoku/zhuoku186.jpg";
//            _dwqLaunch.dwqFrontViewBgColor = [UIColor clearColor];
//         //自定义加浮层控件
//            UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 100,[UIScreen mainScreen].bounds.size.width , 60)];
//    
//            titleLable.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
//    
//            titleLable.textColor = [UIColor whiteColor];
//    
//            titleLable.textAlignment = NSTextAlignmentCenter;
//    
//            titleLable.text = @"别忘了给个star哦~";
//    
//            [_dwqLaunch.dwqRollFrontView addSubview:titleLable];
    
    self.window.rootViewController = _dwqLaunch;
    
#pragma mark-dwq -引导页
        _dwqCoverImgNameArr = @[@"学无止境.png", @"求知若渴.png", @"学海无涯.png"];
        /*使用浮层时候需要将上方这个打开*/
    
    
        _dwqBgImgNameArr = @[@"dwq01.jpeg", @"dwq02.jpeg", @"dwq03.jpeg"];
        /*分别为:normalGuid,      传统引导页
                guidWithCover,   带有浮层的引导页
                coverWithCustom, 可在浮层中添加自定义控件
                videoGuid,       视频引导页
           videoGuidWithCustom   视频可以自定义浮层的
         */
        _dwqIntroductionPage = [self videoGuid];
    
        self.window.rootViewController = dwqVC;//只用引导页的时候打开此项
        [self.window addSubview:_dwqIntroductionPage.view];
    

    return YES;
}

//详情页代理
- (void)dwqLaunchAdImgViewAction:(id)sender withObject:(id)object{
    DWQLaunchVC * dwqVC = object;
    
    DWQAdDetailVC * detailVC = [[DWQAdDetailVC alloc]init];
    detailVC.dwqWebUrl = @"https://github.com/DevelopmentEngineer-DWQ";
    detailVC.dwqRootVC = dwqVC.dwqRootVC;
    [dwqVC presentViewController:detailVC animated:YES completion:nil];
}

//传统引导页
- (DWQIntroductionPage *)normalGuid{
    
    //可以添加gif动态图哦
       _dwqBgImgNameArr = @[@"DWQ01.gif",@"DWQ02.gif",@"DWQ03.gif"];
    
    DWQIntroductionPage * dwqPage = [[DWQIntroductionPage alloc]init];
    dwqPage.dwqCoverImgArr = _dwqBgImgNameArr;//设置浮层滚动图片数组
    //_dwqBgImgNameArr;//设置浮层滚动图片数组

   
    
    dwqPage.dwqDelegate = self;//进入按钮事件代理
    dwqPage.dwqAutoScrolling = NO;//是否自动滚动
    //可以自定义设置进入按钮样式
    [dwqPage.dwqEnterBtn setTitle:@"杜文全进入" forState:UIControlStateNormal];
    return dwqPage;
}

//带浮层引导页
- (DWQIntroductionPage *)guidWithCover{
    //可以添加gif动态图哦
    _dwqBgImgNameArr = @[@"DWQ01.gif",@"DWQ02.gif",@"DWQ03.gif"];
    
    
    
    DWQIntroductionPage * dwqPage = [[DWQIntroductionPage alloc]init];
    
    dwqPage.dwqBackgroundImgArr = _dwqBgImgNameArr;
    dwqPage.dwqCoverImgArr = _dwqCoverImgNameArr;
    
    dwqPage.dwqDelegate = self;
    
    return dwqPage;
}

//浮层中自定义添加控件
- (DWQIntroductionPage *)coverWithCustom{
    
    DWQIntroductionPage * dwqPage = [[DWQIntroductionPage alloc]init];
    dwqPage.dwqCoverImgArr = _dwqCoverImgNameArr;
    dwqPage.dwqBackgroundImgArr = _dwqBgImgNameArr;
    dwqPage.dwqDelegate = self;
    [dwqPage.dwqEnterBtn setTitle:@"杜文全进入" forState:UIControlStateNormal];
    
    //浮层中自定义添加空间
    [dwqPage.dwqPageArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView * imgView = obj;
        NSArray * textArr = @[@"hello,我是杜文全~",@"希望大家能够喜欢~",@"进去给个star哦~"];
        UILabel * lable1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50)];
        lable1.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2,130);
        lable1.text = textArr[idx];
        lable1.textAlignment = NSTextAlignmentCenter;
        lable1.textColor = [UIColor blackColor];
        [imgView addSubview:lable1];
    }];
    return dwqPage;
}

//视频
- (DWQIntroductionPage *)videoGuid{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"DWQVideo1" ofType:@"mp4"];
    NSLog(@"路径:%@",[NSBundle mainBundle]);
    //NSBundle </var/containers/Bundle/Application/38262A52-3F93-400A-AD21-B441B2BAF652/DWQGuidePage.app> (loaded)
    _dwqVideoUrl = [NSURL fileURLWithPath:filePath];
    DWQIntroductionPage * dwqPage = [[DWQIntroductionPage alloc]init];
    dwqPage.dwqVideoUrl = _dwqVideoUrl;
    dwqPage.dwqVolume = 0.7;
    dwqPage.dwqCoverImgArr = _dwqCoverImgNameArr;
    dwqPage.dwqAutoScrolling = YES;
    dwqPage.dwqDelegate = self;
    return  dwqPage;
}

//自定义浮层标题
- (DWQIntroductionPage *)videoGuidWithCustom{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"DWQVideo" ofType:@"mp4"];
    NSLog(@"路径:%@",[NSBundle mainBundle]);
    _dwqCoverTitleArr = @[@"努力的你",@"给个star吧~"];
    
    _dwqVideoUrl = [NSURL fileURLWithPath:filePath];
    UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(3, self.window.frame.size.height - 60, self.window.frame.size.width - 6, 50)];
    loginButton.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
    [loginButton setTitle:@"Login" forState:UIControlStateNormal];
    
    DWQIntroductionPage * dwqPage = [[DWQIntroductionPage alloc]init];
    dwqPage.dwqPageControl.hidden = YES;
    dwqPage.dwqLabelAttributesDic = @{ NSFontAttributeName : [UIFont fontWithName:@"Arial-BoldMT" size:18.0],
                                     NSForegroundColorAttributeName : [UIColor whiteColor] };
    dwqPage.dwqVideoUrl = _dwqVideoUrl;
    dwqPage.dwqCoverTitlesArr = _dwqCoverTitleArr;
    dwqPage.dwqAutoScrolling = YES;
    dwqPage.dwqPageControlOffSet = CGPointMake(0, -100);
    [dwqPage.view addSubview:loginButton];
    return  dwqPage;
}

//进入按钮事件
- (void)dwqIntroductionViewEnterTap:(id)sender{
    _dwqIntroductionPage = nil;
    [_dwqLaunch dwq_startFire];//和引导页(DWQIntroductionPage)一起用的时候加上这句
    
   
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
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
