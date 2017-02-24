//
//  UIImage+DWQGif.h
//  DWQGuidePage
//
//  Created by 杜文全 on 16/2/12.
//  Copyright © 2016年 com.sdzw.duwenquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ImageIO/ImageIO.h>
@interface UIImage (DWQGif)
+ (UIImage *)dwq_setAnimatedGIFWithGifName:(NSString *)name;


+ (UIImage *)dwq_setAnimatedGIFWithData:(NSData *)data;

+ (float)dwq_setFrameDurationAtIndex:(NSUInteger)index source:(CGImageSourceRef)source;
@end
