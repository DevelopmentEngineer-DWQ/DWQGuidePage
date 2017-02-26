# DWQGuidePage
引导页超级封装：包含倒计时，滑动引导，自动滑动，视频，gif，浮层添加等的强大的引导页的封装。
![image](https://github.com/DevelopmentEngineer-DWQ/DWQGuidePage/raw/master/DWQGuideImage/杜文全正式.jpeg)



##使用方法

 *一丶将DWQIntroductionAndLaunch拖入工程中【注意】，此框架依托于SDWebImage，如果你的程序中已经存在，请删除文件夹下的。
 *二丶在Appelegate中引入头文件"DWQLaunchVC.h”，”DWQAdDetailVC.h”，”DWQIntroductionPage.h”，然后遵循协议，声明属性，代码如下
```objective-c

@interface AppDelegate ()<DWQLaunchDelegate,DWQIntroductionDelegate>
{
    DWQIntroductionPage * _dwqIntroductionPage;
    NSArray *            _dwqCoverImgNameArr; //浮层
    NSArray *            _dwqBgImgNameArr;//引导页图片
    NSArray *            _dwqCoverTitleArr;//浮层title
    NSURL   *            _dwqVideoUrl; //视频
    DWQLaunchVC *         _dwqLaunch;
}

```
 *三丶引导页的调用方法有五种，具体如下，调用方法为【self   normalGuid】；具体种类的模式下方代码介绍
```objective-c
/*分别为:normalGuid,      传统引导页
                guidWithCover,   带有浮层的引导页
                coverWithCustom, 可在浮层中添加自定义控件
                videoGuid,       视频引导页
           videoGuidWithCustom   视频可以自定义浮层的
         */

```
 *四丶详情页使用，在Appdelegate.m文件中加入代理方法和点击事件
```objective-c
//详情页代理
- (void)dwqLaunchAdImgViewAction:(id)sender withObject:(id)object{
    DWQLaunchVC * dwqVC = object;
    
    DWQAdDetailVC * detailVC = [[DWQAdDetailVC alloc]init];
    detailVC.dwqWebUrl = @"https://github.com/DevelopmentEngineer-DWQ";
    detailVC.dwqRootVC = dwqVC.dwqRootVC;
    [dwqVC presentViewController:detailVC animated:YES completion:nil];
}
//进入按钮事件
- (void)dwqIntroductionViewEnterTap:(id)sender{
    _dwqIntroductionPage = nil;
    [_dwqLaunch dwq_startFire];//和引导页(DWQIntroductionPage)一起用的时候加上这句
 
}

```
 *五丶使用注意事项：1.在添加自定义控件时，要确保添加的自定义控件的数组和引导页的张数保持一致，2.如果想使用倒计时模式，需要注释掉   _dwqIntroductionPage = [self coverWithCustom];//五种方式调用方法 3.本地视频播放需要把视频文件添加到工程Build Phase下的Copy Bundle Resources中。
 *六丶Demo中有很多的注释，已经详细描述了如何使用。
 
##效果展示
![image](https://github.com/DevelopmentEngineer-DWQ/DWQGuidePage/raw/master/DWQGuideImage/传统模式静态图.gif)

![image](https://github.com/DevelopmentEngineer-DWQ/DWQGuidePage/raw/master/DWQGuideImage/传统模式Gif图.gif)

![image](https://github.com/DevelopmentEngineer-DWQ/DWQGuidePage/raw/master/DWQGuideImage/倒计时最终.gif)

![image](https://github.com/DevelopmentEngineer-DWQ/DWQGuidePage/raw/master/DWQGuideImage/带浮层引导页.gif)

![image](https://github.com/DevelopmentEngineer-DWQ/DWQGuidePage/raw/master/DWQGuideImage/带有自定义控件的引导页.gif)

![image](https://github.com/DevelopmentEngineer-DWQ/DWQGuidePage/raw/master/DWQGuideImage/带有视频的.gif)


##有问题反馈
在使用中有任何问题，欢迎反馈给我，可以用以下联系方式跟我交流

* 邮件(duwenquan0414@gmail.com)
* QQ: 439878592





