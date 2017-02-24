//
//  DWQIntroductionPage.m
//  DWQGuidePage
//
//  Created by 杜文全 on 16/2/12.
//  Copyright © 2016年 com.sdzw.duwenquan. All rights reserved.
//

#import "DWQIntroductionPage.h"

@interface DWQIntroductionPage ()<UIScrollViewDelegate>
{
    NSArray       * _dwqBgViewArr;
    NSInteger       _dwqCenterPageIndex;
    AVPlayer      * _dwqPlayer;
    NSTimer       * _dwqTimer;
    AVPlayerLayer * _dwqPlayerLayer;
}
@end


@implementation DWQIntroductionPage

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_dwqPlayer pause];
    _dwqPlayer  = nil;
    [self dwqStopTimer];
    self.view = nil;
}

- (NSArray *)dwqGetPageArr{
    if([self dwqGetPagesNum] <1){
        return  nil;
    }
    if(_dwqPageArr){
        return _dwqPageArr;
    }
    NSMutableArray * tmpArr = [[NSMutableArray alloc]init];
    if(_dwqCoverImgArr){
        [_dwqCoverImgArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [tmpArr addObject:[self dwqGetCoverImgViewWithImgName:obj]];
        }];
    }else if(_dwqCoverTitlesArr){
        [_dwqCoverTitlesArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [tmpArr addObject:[self dwqGetPageWithTitle:obj]];
        }];
    }
    _dwqPageArr = tmpArr;
    return  _dwqPageArr;
}

- (void)dwqReloadCoverTitles{
    for(UILabel * label in _dwqPageArr){
        
        CGFloat height = 30;
        NSString * text = [label.attributedText string];
        if([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending){
            CGSize size = [text sizeWithAttributes:_dwqLabelAttributesDic];
            height = size.height;
        }
        label.attributedText = [[NSAttributedString alloc]initWithString:text attributes:_dwqLabelAttributesDic];
    }
}

- (instancetype)init{
    if(self = [super init]){
        [self dwqInitSelf];
        
    }
    return self;
}

- (void)dwqInitSelf{
    self.dwqAutoScrolling = NO;
    self.dwqAutoLoopPlayVideo = YES;
    [self dwqLayoutEnterBtn];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dwqApplicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self dwqStopTimer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self dwqAddPageScroll];
    [self dwqStartTimer];
    
}

- (void)dwqBringSubViewToFront{
    [self.view bringSubviewToFront:self.dwqPageScrollView];
    [self.view bringSubviewToFront:_dwqPageControl];
    [self.view bringSubviewToFront:self.dwqEnterBtn];
}

- (void)dwqAddVideo{
    if(!_dwqVideoUrl){
        return;
    }
    AVPlayerItem * dwqPlayerItem = [AVPlayerItem playerItemWithURL:_dwqVideoUrl];
    _dwqPlayer = [AVPlayer playerWithPlayerItem:dwqPlayerItem];
    _dwqPlayer.volume = self.dwqVolume;
    
    _dwqPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:_dwqPlayer];
    _dwqPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _dwqPlayerLayer.frame = self.view.layer.bounds;
    [self.view.layer addSublayer:_dwqPlayerLayer];
    
    [_dwqPlayer play];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movidePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:_dwqPlayer.currentItem];
    
    [self dwqBringSubViewToFront];
}

- (void)setDwqVolume:(float)dwqVolume{
    _dwqVolume = dwqVolume;
    _dwqPlayer.volume = dwqVolume;
    
}

- (void)dwqEnter:(id)object{
    [self dwqStopTimer];
    
    if(self.dwqDelegate && [self.dwqDelegate respondsToSelector:@selector(dwqIntroductionViewEnterTap:)]){
        [self.dwqDelegate dwqIntroductionViewEnterTap:object];
    }
    
}

- (void)dwqAddBackgroundViews{
    CGRect frame = self.view.bounds;
    NSMutableArray * tmpArr = [NSMutableArray new];
    [[[_dwqBackgroundImgArr reverseObjectEnumerator] allObjects] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString * suffix;
        if([obj componentsSeparatedByString:@"."]){
            suffix = [obj componentsSeparatedByString:@"."][1];
            
        }
        UIImageView * imgView = [[UIImageView alloc]init];
        if([suffix isEqualToString:@"gif"]){
            NSString * gifImgName = [obj componentsSeparatedByString:@"."][0];
            imgView.image = [UIImage dwq_setAnimatedGIFWithGifName:gifImgName];
        }else {
            imgView.image = [UIImage imageNamed:obj];
            
        }
        
        imgView.frame = frame;
        imgView.tag = idx + 1;
        [tmpArr addObject:imgView];
        [self.view addSubview:imgView];
        
    }];
    _dwqBgViewArr = [[tmpArr reverseObjectEnumerator] allObjects];
    [self.view bringSubviewToFront:self.dwqPageScrollView];
    [self.view bringSubviewToFront:_dwqPageControl];
}

- (void)setDwqBackgroundImgArr:(NSArray *)dwqBackgroundImgArr{
    _dwqBackgroundImgArr = dwqBackgroundImgArr;
    [self dwqAddBackgroundViews];
    
}

- (void)setDwqCoverImgArr:(NSArray *)dwqCoverImgArr{
    _dwqCoverImgArr = dwqCoverImgArr;
    [self dwqReloadPage];
    
}

- (void)setDwqCoverTitlesArr:(NSArray *)dwqCoverTitlesArr{
    _dwqCoverTitlesArr = dwqCoverTitlesArr;
    
    [self dwqReloadPage];
    
}

- (void)setDwqLabelAttributesDic:(NSDictionary *)dwqLabelAttributesDic{
    _dwqLabelAttributesDic = dwqLabelAttributesDic;
    [self dwqReloadCoverTitles];
}

- (void)setDwqVideoUrl:(NSURL *)dwqVideoUrl{
    _dwqVideoUrl = dwqVideoUrl;
    [self dwqAddVideo];
    
}

- (void)dwqAddPageScroll{
    self.dwqPageScrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    self.dwqPageScrollView.delegate = self;
    self.dwqPageScrollView.pagingEnabled = YES;
    self.dwqPageScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.dwqPageScrollView];
    _dwqPageControl = [[UIPageControl alloc]initWithFrame:[self dwqLayoutPageControlFrame]];
    _dwqPageControl.pageIndicatorTintColor = [UIColor grayColor];
    [self.view addSubview:_dwqPageControl];
    
    
}

- (void)dwqLayoutEnterBtn{
    if(!self.dwqEnterBtn){
        self.dwqEnterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.dwqEnterBtn setTitle:@"Enter" forState:UIControlStateNormal];
        self.dwqEnterBtn.layer.borderWidth = 0.5;
        self.dwqEnterBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        self.dwqEnterBtn.hidden = NO;
        self.dwqEnterBtn.frame = [self dwqLayoutEnterBtnFrame];
    }
    [self.dwqEnterBtn addTarget:self action:@selector(dwqEnter:) forControlEvents:UIControlEventTouchUpInside];
    self.dwqEnterBtn.alpha = 0;
}

- (CGRect)dwqLayoutPageControlFrame{
    CGRect dwqFrame = CGRectMake(0, self.view.bounds.size.height - 50, self.view.bounds.size.width, 30);
    return CGRectOffset(dwqFrame,self.dwqPageControlOffSet.x, self.dwqPageControlOffSet.y);
}

- (CGRect)dwqLayoutEnterBtnFrame{
    CGSize size = self.dwqEnterBtn.bounds.size;
    if(CGSizeEqualToSize(size, CGSizeZero)){
        size = CGSizeMake(self.view.frame.size.width * 0.6, 40);
    }
    return CGRectMake(self.view.frame.size.width/2 -size.width/2,_dwqPageControl.frame.origin.y - size.height/2, size.width, size.height);
}

- (void)dwqStartTimer{
    if(_dwqAutoScrolling){
        _dwqTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(dwqOnTimer) userInfo:nil repeats:YES];
    }
}

- (void)dwqOnTimer{
    CGRect frame = self.dwqPageScrollView.frame;
    frame.origin.x = frame.size.width * (_dwqPageControl.currentPage + 1);
    frame.origin.y = 0;
    if(frame.origin.x >= self.dwqPageScrollView.contentSize.width){
        frame.origin.x = 0;
    }
    [self.dwqPageScrollView scrollRectToVisible:frame animated:YES];
}

- (void)dwqStopTimer{
    [_dwqTimer invalidate];
    _dwqTimer = nil;
}

- (void)dwqReloadPage{
    _dwqPageControl.numberOfPages = [self dwqGetPagesNum];
    _dwqPageScrollView.contentSize = [self dwqGetScrollContentSize];
    __block CGFloat x = 0;
    NSArray * dwqPageArr = [self dwqGetPageArr];
    [dwqPageArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView * view = (UIView *)obj;
        view.frame = CGRectOffset(view.frame, x, 0);
        [self.dwqPageScrollView addSubview:view];
        x += view.frame.size.width;
        if(idx == dwqPageArr.count - 1){
            [view addSubview:self.dwqEnterBtn];
        }
        
    }];
    
    if(_dwqPageControl.numberOfPages == 1){
        _dwqEnterBtn.alpha = 1;
        _dwqPageControl.alpha = 0;
    }
    if(self.dwqPageScrollView.contentSize.width == self.dwqPageScrollView.frame.size.width){
        self.dwqPageScrollView.contentSize = CGSizeMake(self.dwqPageScrollView.contentSize.width + 1, self.dwqPageScrollView.contentSize.height);
    }
    
}

- (void)setDwqAutoScrolling:(BOOL)dwqAutoScrolling{
    _dwqAutoScrolling = dwqAutoScrolling;
    if(!_dwqTimer&&_dwqAutoScrolling){
        [self dwqStartTimer];
    }
}

- (NSInteger)dwqGetPagesNum{
    if(_dwqCoverImgArr){
        return _dwqCoverImgArr.count;
        
    }else if(_dwqCoverTitlesArr){
        return _dwqCoverTitlesArr.count;
        
    }
    return 0;
}

- (NSInteger)dwqGetCurrentPage{
    return self.dwqPageScrollView.contentOffset.x/self.view.bounds.size.width;
}

- (CGSize)dwqGetScrollContentSize{
    UIView * view = [[self dwqGetPageArr] firstObject];
    return CGSizeMake(view.frame.size.width* _dwqPageArr.count, view.frame.size.height);
}

- (void)dwqApplicationWillEnterForeground:(id)sender{
    [_dwqPlayer play];
}

- (void)dwqPageControlChangePage:(UIScrollView *)pageScrollView{
    
    if([self dwqIsLastPage:_dwqPageControl]){
        if(_dwqPageControl.alpha == 1){
            [UIView animateWithDuration:1 animations:^{
                _dwqEnterBtn.alpha = 1;
                _dwqPageControl.alpha = 0;
            }];
        }
    }else{
        if(_dwqPageControl.alpha == 0){
            [UIView animateWithDuration:1 animations:^{
                _dwqEnterBtn.alpha = 0;
                _dwqPageControl.alpha = 1;
            }];
        }
    }
}

- (BOOL)dwqIsLastPage:(UIPageControl *)pageControl{
    return pageControl.numberOfPages == pageControl.currentPage + 1;
}

- (BOOL)dwqIsGoOnNext:(UIPageControl *)pageControl{
    return pageControl.numberOfPages>pageControl.currentPage + 1;
}

- (UIView *)dwqGetPageWithTitle:(NSString *)title{
    CGSize size = self.view.frame.size;
    CGRect rect;
    CGFloat height = 30;
    if([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending){
        CGSize size = [title sizeWithAttributes:_dwqLabelAttributesDic];
        height = size.height;
    }
    rect = CGRectMake(0, size.height - height - 100, size.width, height);
    UILabel * label = [[UILabel alloc]initWithFrame:rect];
    label.textAlignment = NSTextAlignmentCenter;
    label.attributedText = [[NSAttributedString alloc]initWithString:title attributes:_dwqLabelAttributesDic];
    return  label;
}

- (UIView *)dwqGetCoverImgViewWithImgName:(NSString *)imgName{
    
    UIImageView * imgView = [[UIImageView alloc]init];
    if([imgName componentsSeparatedByString:@"."].count>1&&[[imgName componentsSeparatedByString:@"."][1] isEqualToString:@"gif"]){
        
        NSString * gifImgName = [imgName componentsSeparatedByString:@"."][0];
        imgView.image = [UIImage dwq_setAnimatedGIFWithGifName:gifImgName];
    }else{
        imgView.image = [UIImage imageNamed:imgName];
    }
    
    imgView.userInteractionEnabled = YES;
    CGSize size = self.view.bounds.size;
    
    imgView.frame = CGRectMake(0,0, size.width, size.height);
    return imgView;
}

- (void)dwqApplicationWillEnterForground:(id)sender{
    [_dwqPlayer play];
}

#pragma mark-dwq ---------------------通知事件位置---------------------------------
- (void)movidePlayDidEnd:(NSNotification *)notification{
    if(_dwqAutoLoopPlayVideo){
        AVPlayerItem * item = [notification object];
        [item seekToTime:kCMTimeZero];
        [_dwqPlayer play];
    }else{
        [self dwqEnter:nil];
    }
}

#pragma mark-dwq -------------------代理位置-------------------------------------------
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x/self.view.frame.size.width;
    CGFloat dwqAlpha =  1-(scrollView.contentOffset.x - index*self.view.bounds.size.width)/self.view.bounds.size.width;
    if([_dwqBgViewArr count] >index){
        UIView * view = [_dwqBgViewArr objectAtIndex:index];
        if(view){
            view.alpha = dwqAlpha;
        }
    }
    [_dwqPageControl setCurrentPage:[self dwqGetCurrentPage]];
    [self dwqPageControlChangePage:scrollView];
    if(scrollView.isTracking){
        [self dwqStopTimer];
    }else{
        if(!_dwqTimer){
            [self dwqStartTimer];
        }
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if([scrollView.panGestureRecognizer translationInView:scrollView.superview].x<0){
        if(![self dwqIsGoOnNext:_dwqPageControl]){
            [self dwqEnter:nil];
        }
    }
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
