//
//  DWQLaunchVC.m
//  DWQGuidePage
//
//  Created by 杜文全 on 16/2/12.
//  Copyright © 2016年 com.sdzw.duwenquan. All rights reserved.
//

#import "DWQLaunchVC.h"
#import "UIImageView+WebCache.h"
#import "UIImage+DWQGif.h"
#define DWQScreenBounds [UIScreen mainScreen].bounds
@interface DWQLaunchVC ()<UIScrollViewDelegate>
{
    int _dwqRollX;
    bool _dwqIsReverse;
}
@end


@implementation DWQLaunchVC

- (instancetype)initWithRootVC:(UIViewController *)rootVC withLaunchType:(DWQLaunchType)launchType{
    self = [super init];
    if(self){
        self.dwqRootVC = rootVC;
        self.dwqAdDuration = 5;
        self.dwqLaunchType = launchType;
        self.dwqIsSkip = YES;
        self.dwqGifFrontView  = [[UIView alloc]initWithFrame:DWQScreenBounds];
        self.dwqRollFrontView = [[UIView alloc]initWithFrame:DWQScreenBounds];
        if(_dwqLaunchType == DWQLaunchAD){
            self.dwqAdImgView = [[UIImageView alloc]initWithFrame:DWQScreenBounds];
            
        }
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    switch (self.dwqLaunchType) {
        case DWQLaunchNormal:{
            [self dwqLayoutNormalLaunch];
        }
            break;
        case DWQLaunchGuide:{
            [self dwqLayoutPageControl];
            [self dwqLayoutEnterBtn];
            [self dwqLayoutGuide];
        }
            break;
        case DWQLaunchAD:{
            [self dwqLayoutADImgView];
            [self dwqLayoutTimerLabel];
            
        }
            break;
        case DWQLaunchGif:{
            [self dwqLayoutEnterBtn];
            [self dwqLayoutGifImg];
            
        }
            break;
        case DWQLaunchAutoRoll:{
            [self dwqLayoutEnterBtn];
            [self dwqLayoutAutoRollImgView];
            
            
        }
            break;
            
        default:
            break;
    }
}

- (void)dwqLayoutEnterBtn{
    self.dwqEnterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.dwqEnterBtn.frame = CGRectMake(DWQScreenBounds.size.width/2 - 60, DWQScreenBounds.size.height - 120, 120, 40);
    self.dwqEnterBtn.tintColor = [UIColor lightGrayColor];
    [self.dwqEnterBtn setImage:[UIImage imageNamed:@"XYEnter"] forState:UIControlStateNormal];
    [self.dwqEnterBtn addTarget:self action:@selector(dwqSkipTap) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)dwqLayoutNormalLaunch{
    
    UIImageView * launchImgView = [[UIImageView alloc]initWithFrame:DWQScreenBounds];
    [self.view addSubview:launchImgView];
    if(self.dwqNormalImgName.length >0){
        [launchImgView setImage:[UIImage imageNamed:self.dwqNormalImgName]];
        self.dwqAdTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(dwqReleaseAll) userInfo:nil repeats:NO];
        if(self.dwqIsCloseTimer == YES){
            [self.dwqAdTimer setFireDate:[NSDate distantFuture]];
        }
        
        
    }else if(self.dwqNormalImgUrl.length >0){
        __weak typeof (self)selfWeak = self;
        
        [launchImgView sd_setImageWithURL:[NSURL URLWithString:self.dwqNormalImgUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            selfWeak.dwqAdTimer = [NSTimer scheduledTimerWithTimeInterval:self.dwqNormalDuration target:self selector:@selector(dwqReleaseAll) userInfo:nil repeats:NO];
            if(selfWeak.dwqIsCloseTimer == YES){
                [selfWeak.dwqAdTimer setFireDate:[NSDate distantFuture]];
            }
            
        }];
    }
}

- (void)dwq_startFire{
    if(self.dwqLaunchType == DWQLaunchAD){
        self.dwqAdTimer = [NSTimer scheduledTimerWithTimeInterval:1.00 target:self selector:@selector(dwqTimerAction) userInfo:nil repeats:YES];
        
    }else if(self.dwqLaunchType == DWQLaunchNormal){
        
        [self performSelector:@selector(dwqReleaseAll) withObject:nil afterDelay:self.dwqNormalDuration];
        
    }
}

//广告
- (void)dwqLayoutADImgView{
    UITapGestureRecognizer * dwqAdTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dwqAdTap:)];
    [self.dwqAdImgView addGestureRecognizer:dwqAdTap];
    self.dwqAdImgView.userInteractionEnabled = YES;
    [self.view addSubview:self.dwqAdImgView];
}

- (void)dwqLayoutTimerLabel{
    self.dwqTimerLabel  = [[UILabel alloc]initWithFrame:CGRectMake(DWQScreenBounds.size.width - 90, 20, 80, 30)];
    self.dwqTimerLabel.backgroundColor = [UIColor colorWithRed:125/256.0 green:125/256.0  blue:125/256.0  alpha:0.5];
    self.dwqTimerLabel.textColor = [UIColor whiteColor];
    self.dwqTimerLabel.textAlignment = NSTextAlignmentCenter;
    self.dwqTimerLabel.layer.masksToBounds = YES;
    self.dwqTimerLabel.layer.cornerRadius = 5;
    self.dwqTimerLabel.userInteractionEnabled = YES;
    if(self.dwqIsSkip){
        self.dwqTimerLabel.text = [NSString stringWithFormat:@"跳过 %ld",(long)self.dwqAdDuration];
        
    }else{
        self.dwqTimerLabel.text = [NSString stringWithFormat:@"剩余 %ld",(long)self.dwqAdDuration];
    }
    [self.view addSubview:self.dwqTimerLabel];
    
    if(self.dwqIsSkip){
        self.dwqSkipLabelTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dwqSkipTap)];
        [self.dwqTimerLabel addGestureRecognizer:self.dwqSkipLabelTap];
    }
    
    if(self.dwqIsCloseTimer == YES){
        
    }else{
        self.dwqAdTimer = [NSTimer scheduledTimerWithTimeInterval:1.00 target:self selector:@selector(dwqTimerAction) userInfo:nil repeats:YES];
        
    }
    
}

- (void)setDwqAdImgUrl:(NSString *)dwqAdImgUrl{
    _dwqAdImgUrl = dwqAdImgUrl;
    __weak typeof (self)selfWeak = self;
    [self.dwqAdImgView sd_setImageWithURL:[NSURL URLWithString:dwqAdImgUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if(selfWeak.dwqAdTimer){
            [selfWeak.dwqAdTimer fire];
        }
        
    }];
}
-(void)setDwqAdLocalImgName:(NSString *)dwqAdLocalImgName{
    _dwqAdLocalImgName = dwqAdLocalImgName;
    __weak typeof (self)selfWeak = self;
    [self.dwqAdImgView setImage:[UIImage imageNamed:dwqAdLocalImgName]];
    if(selfWeak.dwqAdTimer){
        [selfWeak.dwqAdTimer fire];
    }


}


//guide
- (void)dwqLayoutGuide{
    UIScrollView * imgScrollView = [[UIScrollView alloc]initWithFrame:DWQScreenBounds];
    imgScrollView.delegate = self;
    imgScrollView.pagingEnabled = YES;
    imgScrollView.showsHorizontalScrollIndicator = NO;
    imgScrollView.showsVerticalScrollIndicator = NO;
    imgScrollView.bounces = NO;
    [self.view addSubview:imgScrollView];
    [self.view addSubview:self.dwqPageControl];
    
    //加载本地
    if(self.dwqGuideImgNameArr.count >0){
        self.dwqPageControl.numberOfPages = self.dwqGuideImgNameArr.count;
        
        imgScrollView.contentSize = CGSizeMake(DWQScreenBounds.size.width * self.dwqGuideImgNameArr.count, DWQScreenBounds.size.height);
        
        
        for(int i=0;i<self.dwqGuideImgNameArr.count;i++){
            UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake(DWQScreenBounds.size.width *i, 0, DWQScreenBounds.size.width, DWQScreenBounds.size.height)];
            imgView.image = [UIImage imageNamed:self.dwqGuideImgNameArr[i]];
            imgView.userInteractionEnabled = YES;
            [imgScrollView addSubview:imgView];
            
            if(i==self.dwqGuideImgNameArr.count - 1){
                [imgView addSubview:self.dwqEnterBtn];
            }
        }
    }else if(self.dwqGuideImgUrlArr.count >0){
        self.dwqPageControl.numberOfPages = self.dwqGuideImgUrlArr.count;
        
        imgScrollView.contentSize = CGSizeMake(DWQScreenBounds.size.width * self.dwqGuideImgUrlArr.count, DWQScreenBounds.size.height);
        for(int i=0;i<self.dwqGuideImgUrlArr.count;i++){
            UIImageView * dwqimgView = [[UIImageView alloc]initWithFrame:CGRectMake(DWQScreenBounds.size.width * i, 0, DWQScreenBounds.size.width, DWQScreenBounds.size.height)];
            [dwqimgView sd_setImageWithURL:self.dwqGuideImgUrlArr[i] placeholderImage:nil];
            [imgScrollView addSubview:dwqimgView];
            dwqimgView.userInteractionEnabled = YES;
            if(i== self.dwqGuideImgUrlArr.count - 1){
                [dwqimgView addSubview:self.dwqEnterBtn];
            }
            
        }
        
    }
    
    
}

- (void)dwqLayoutPageControl{
    self.dwqPageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, DWQScreenBounds.size.height - 40, DWQScreenBounds.size.width, 40)];
    self.dwqPageControl.currentPage = 0;
    self.dwqPageControl.currentPageIndicatorTintColor = [UIColor blueColor];
    self.dwqPageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
}

//gif
- (void)dwqLayoutGifImg{
    UIImageView * gifImgView = [[UIImageView alloc]initWithFrame:DWQScreenBounds];
    if(self.dwqGifImgName.length >0){
        gifImgView.image = [UIImage dwq_setAnimatedGIFWithGifName:self.dwqGifImgName];
    }else if(self.dwqGifImgUrl.length >0){
        [gifImgView sd_setImageWithURL:[NSURL URLWithString:self.dwqGifImgUrl]];
    }
    [self.view addSubview:gifImgView];
    
    if(self.dwqFrontViewBgColor){
        self.dwqGifFrontView.backgroundColor = self.dwqFrontViewBgColor;
        
    }else{
        self.dwqGifFrontView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9  blue:0.9  alpha:0.5];
        
    }
    if(self.dwqIsHideEnterBtn != YES){
        [self.dwqGifFrontView addSubview:self.dwqEnterBtn];
        self.dwqEnterBtn.tintColor = [UIColor blueColor];
    }
    [self.view addSubview:self.dwqGifFrontView];
}

//自动滚动
- (void)dwqLayoutAutoRollImgView{
    _dwqRollX = 0;
    _dwqIsReverse = NO;
    if(self.dwqFrontViewBgColor){
        self.dwqRollFrontView.backgroundColor = self.dwqFrontViewBgColor;
        
    }else{
        self.dwqRollFrontView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9  blue:0.9  alpha:0.3];
        
    }
    
    if(self.dwqRollImgName.length >0){
        self.dwqRollImg = [UIImage imageNamed:self.dwqRollImgName];
        [self dwqAddRollImgAndRollTimer];
    }else if(self.dwqRollImgUrl.length >0){
        [self dwqCreateDownLoadImgWithImgUrl:self.dwqRollImgUrl];
    }
}

- (void)dwqAddRollImgAndRollTimer{
    
    self.dwqRollImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, DWQScreenBounds.size.height * self.dwqRollImg.size.width/self.dwqRollImg.size.height, DWQScreenBounds.size.height)];
    self.dwqRollImgView.image = self.dwqRollImg;
    self.dwqRollTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(dwqRollImgAction) userInfo:nil repeats:YES];
    [self.view addSubview:self.dwqRollImgView];
    if(self.dwqIsHideEnterBtn != YES){
        [self.dwqRollFrontView addSubview:self.dwqEnterBtn];
        self.dwqEnterBtn.tintColor = [UIColor blueColor];
    }
    [self.view addSubview:self.dwqRollFrontView];
    [self.dwqRollTimer fire];
    
}

- (void)dwqCreateDownLoadImgWithImgUrl:(NSString *)imgUrlStr{
    
    NSURL * imgUrl = [NSURL URLWithString:imgUrlStr];
    NSURLSession * session = [NSURLSession sharedSession];
    __weak typeof (self)selfWeak = self;
    
    //创建任务
    NSURLSessionDownloadTask * dwqTask = [session downloadTaskWithURL:imgUrl completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSData * dwqData = [NSData dataWithContentsOfURL:location];
        UIImage * dwqImg = [UIImage imageWithData:dwqData];
        dispatch_async(dispatch_get_main_queue(), ^{
            selfWeak.dwqRollImg = dwqImg;
            [selfWeak dwqAddRollImgAndRollTimer];
        });
    }];
    
    [dwqTask resume];
    
}

#pragma mark-dwq--------------------事件------------------------------------------
- (void)dwqTimerAction{
    
    self.dwqAdDuration --;
    if(self.dwqAdDuration <0){
        [self.dwqAdTimer invalidate];
        self.view.window.rootViewController = self.dwqRootVC;
    }
    if(self.dwqIsSkip){
        self.dwqTimerLabel.text = [NSString stringWithFormat:@"跳过 %ld",self.dwqAdDuration];
        
    }else{
        self.dwqTimerLabel.text = [NSString stringWithFormat:@"剩余 %ld",self.dwqAdDuration];
    }
}

- (void)dwqSkipTap{
    [self dwqReleaseAll];
    
}

- (void)dwqReleaseAll{
    if(self.dwqAdTimer !=nil){
        [self.dwqAdTimer invalidate];
        self.dwqAdTimer = nil;
    }
    
    if(self.dwqRollTimer != nil){
        [self.dwqRollTimer invalidate];
        self.dwqRollTimer = nil;
    }
    
    [self dwqBackMainVC];
}

- (void)dwqBackMainVC{
    self.view.window.rootViewController = self.dwqRootVC;
    
}

- (void)dwqAdTap:(id)sender{
    
    if(self.dwqDelegate && [self.dwqDelegate respondsToSelector:@selector(dwqLaunchAdImgViewAction: withObject:)]){
        [self.dwqDelegate dwqLaunchAdImgViewAction:sender withObject:self];
    }
    
}

- (void)dwqRollImgAction{
    
    if(_dwqRollX - 1 > (DWQScreenBounds.size.width - DWQScreenBounds.size.height * self.dwqRollImg.size.width/self.dwqRollImg.size.height)&&_dwqIsReverse==NO){
        _dwqRollX = _dwqRollX -1;
    }else{
        _dwqIsReverse = YES;
    }
    
    if(_dwqRollX + 1 <0 && _dwqIsReverse){
        _dwqRollX = _dwqRollX + 1;
    }else{
        _dwqIsReverse = NO;
    }
    self.dwqRollImgView.frame = CGRectMake(_dwqRollX, 0,self.dwqRollImg.size.width, DWQScreenBounds.size.height);
    
    
}

#pragma mark-dwq --------------------代理--------------------------------------------
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger  currentPage = scrollView.contentOffset.x/DWQScreenBounds.size.width;
    self.dwqPageControl.currentPage = currentPage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    
    if (self.dwqAdTimer !=nil) {
        
        [self.dwqAdTimer invalidate];
        self.dwqAdTimer = nil;
    }
    
    if (self.dwqRollTimer != nil) {
        [self.dwqRollTimer invalidate];
        self.dwqRollTimer = nil;
    }
    
    
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
