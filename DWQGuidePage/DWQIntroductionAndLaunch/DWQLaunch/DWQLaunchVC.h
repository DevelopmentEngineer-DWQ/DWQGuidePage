//
//  DWQLaunchVC.h
//  DWQGuidePage
//
//  Created by 杜文全 on 16/2/12.
//  Copyright © 2016年 com.sdzw.duwenquan. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    DWQLaunchNormal,//默认启动图
    DWQLaunchGuide,//向导启动图
    DWQLaunchAD,//广告启动图
    DWQLaunchGif,//gif启动图
    DWQLaunchAutoRoll//自动滚动图片
} DWQLaunchType;
//协议
@protocol DWQLaunchDelegate <NSObject>
- (void)dwqLaunchAdImgViewAction:(id)sender withObject:(id)object;
@end
@interface DWQLaunchVC : UIViewController
@property (nonatomic,strong)UIViewController * dwqRootVC;//根视图控制器
@property (nonatomic,assign)DWQLaunchType       dwqLaunchType;//启动图类型
@property (nonatomic,weak)id<DWQLaunchDelegate> dwqDelegate;
@property (nonatomic,strong)UIButton * dwqEnterBtn;//进入按钮
@property (nonatomic,strong)UIPageControl * dwqPageControl;//pageControl
@property (nonatomic,strong)UIColor       * dwqFrontViewBgColor;//最上面浮层试图

//默认系统样式启动图
@property (nonatomic,strong)NSString * dwqNormalImgName;//本地图片名称
@property (nonatomic,strong)NSString * dwqNormalImgUrl;//网络
@property (nonatomic,assign)NSInteger  dwqNormalDuration;//延长时间

//广告
@property (nonatomic,strong)NSTimer * dwqAdTimer;//广告定时器
@property (nonatomic,strong)UILabel * dwqTimerLabel;//倒数时间label
@property (nonatomic,assign)BOOL      dwqIsCloseTimer;//是否关不启动定时器
@property (nonatomic,strong)UIImageView * dwqAdImgView;//广告图
@property (nonatomic,strong)UITapGestureRecognizer * dwqSkipLabelTap;//跳过手势
@property (nonatomic,strong)NSString * dwqAdImgUrl;//广告网络图片
@property (nonatomic,strong)NSString * dwqAdLocalImgName;//广告本地图片
@property (nonatomic,strong)NSString * dwqAdPlaceholderImgName;//默认图
@property (nonatomic,assign)NSInteger  dwqAdDuration;//显示时间
@property (nonatomic,strong)NSString * dwqAdActionUrl;//详情页weburl
@property (nonatomic,strong)NSString * dwqAdTitle;//详情页广告标题
@property (nonatomic,assign)BOOL       dwqIsSkip;//是否显示跳过按钮

//新手向导
@property (nonatomic,strong)NSArray * dwqGuideImgNameArr;//本地图片数组
@property (nonatomic,strong)NSArray * dwqGuideImgUrlArr;//网络图片url数组

//gif
@property (nonatomic,strong)NSString * dwqGifImgName;//gif本地名称
@property (nonatomic,strong)NSString * dwqGifImgUrl;//gif网络url
@property (nonatomic,strong)UIView   * dwqGifFrontView;//浮层
@property (nonatomic,assign)BOOL       dwqIsHideEnterBtn;//是否显示进入按钮

//自动滚动
@property (nonatomic,strong)NSString * dwqRollImgName;//本地图片名称
@property (nonatomic,strong)NSString * dwqRollImgUrl;//网络图片url
@property (nonatomic,strong)UIView   * dwqRollFrontView;//浮层
@property (nonatomic,strong)UIImage  * dwqRollImg;//滚动img
@property (nonatomic,strong)UIImageView * dwqRollImgView;//滚动imgview
@property (nonatomic,strong)NSTimer  * dwqRollTimer;//定时

//init
- (instancetype)initWithRootVC:(UIViewController *)rootVC withLaunchType:(DWQLaunchType)launchType;

//重置开启定时器
- (void)dwq_startFire;

@end
