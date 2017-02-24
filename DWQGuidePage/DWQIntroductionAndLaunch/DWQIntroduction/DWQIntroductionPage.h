//
//  DWQIntroductionPage.h
//  DWQGuidePage
//
//  Created by 杜文全 on 16/2/12.
//  Copyright © 2016年 com.sdzw.duwenquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "UIImage+DWQGif.h"
@protocol DWQIntroductionDelegate <NSObject>

- (void)dwqIntroductionViewEnterTap:(id)sender;

@end


@interface DWQIntroductionPage : UIViewController
@property (nonatomic,strong)UIScrollView * dwqPageScrollView;//浮层ScrollView
@property (nonatomic,strong)UIButton     * dwqEnterBtn;//进入按钮
@property (nonatomic,assign)BOOL           dwqAutoScrolling;//是否自动滚动
@property (nonatomic,assign)BOOL           dwqAutoLoopPlayVideo;//是否自动循环播放
@property (nonatomic,assign)CGPoint        dwqPageControlOffSet;//pageControl默认偏移量
@property (nonatomic,strong)UIPageControl *dwqPageControl;//引导pageControl


@property (nonatomic,strong)NSArray      * dwqBackgroundImgArr;//底层背景图数组
@property (nonatomic,strong)NSArray      * dwqCoverImgArr;//浮层图片数组
@property (nonatomic,strong)NSArray      * dwqCoverTitlesArr;//浮层文字数组
@property (nonatomic,strong)NSDictionary * dwqLabelAttributesDic;//文字特性
@property (nonatomic,assign)float          dwqVolume;//声音大小
@property (nonatomic,strong)NSURL     *    dwqVideoUrl;//视频地址
@property (nonatomic,strong)NSArray *      dwqPageArr;//放置浮层view数组

@property (nonatomic,weak)  id<DWQIntroductionDelegate>dwqDelegate;

- (instancetype)init;


@end
