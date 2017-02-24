//
//  DWQAdDetailVC.m
//  DWQGuidePage
//
//  Created by 杜文全 on 16/2/12.
//  Copyright © 2016年 com.sdzw.duwenquan. All rights reserved.
//

#import "DWQAdDetailVC.h"

@interface DWQAdDetailVC ()

@end

@implementation DWQAdDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self dwqLoadNavView];
    [self dwqLoadWebView];
}

- (void)dwqLoadWebView{
    UIWebView * webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64)];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.dwqWebUrl]]];
    [self.view addSubview:webView];
}

-(void)dwqLoadNavView{
    
    UIView * navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    
    navView.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:navView];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(5, 20, 60, 44)];
    
    [button setTitle:@"关闭" forState:UIControlStateNormal];
    
    [button setTintColor:[UIColor whiteColor]];
    
    button.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    
    [button addTarget:self action:@selector(dwqCloseAd) forControlEvents:UIControlEventTouchUpInside];
    
    [navView addSubview:button];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(65, 20, self.view.frame.size.width-130, 44)];
    
    if (self.dwqWebTitle ==nil) {
        label.text = @"杜文全代言";
        
    }else{
        
        
        label.text = self.dwqWebTitle;
    }
    
    label.textColor = [UIColor whiteColor];
    
    label.textAlignment = NSTextAlignmentCenter;
    
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    
    [navView addSubview:label];
    
    
}

- (void)dwqCloseAd{
    self.view.window.rootViewController = self.dwqRootVC;
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
