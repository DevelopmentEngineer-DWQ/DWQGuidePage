//
//  ViewController.m
//  DWQGuidePage
//
//  Created by 杜文全 on 16/2/12.
//  Copyright © 2016年 com.sdzw.duwenquan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.frame];
    
    imageView.image = [UIImage imageNamed:@"杜文全背景"];
    
    [self.view addSubview:imageView];
    


}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
