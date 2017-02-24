//
//  UIImage+DWQGif.m
//  DWQGuidePage
//
//  Created by 杜文全 on 16/2/12.
//  Copyright © 2016年 com.sdzw.duwenquan. All rights reserved.
//

#import "UIImage+DWQGif.h"

@implementation UIImage (DWQGif)
+ (UIImage *)dwq_setAnimatedGIFWithData:(NSData *)data{
    if(!data){
        return nil;
    }
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    size_t count = CGImageSourceGetCount(source);
    UIImage * animatedImg;
    if(count <= 1){
        animatedImg = [[UIImage alloc]initWithData:data];
    }else{
        NSMutableArray * imgsArr = [NSMutableArray array];
        NSTimeInterval duration = 0.0f;
        for(size_t i = 0; i < count;i++){
            CGImageRef img = CGImageSourceCreateImageAtIndex(source, i, NULL);
            if(!img){
                continue;
            }
            duration += [self dwq_setFrameDurationAtIndex:i source:source];
            [imgsArr addObject:[UIImage imageWithCGImage:img scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp]];
            CGImageRelease(img);
        }
        if(!duration){
            duration = (1.0f/10.0f) * count;
        }
        animatedImg = [UIImage animatedImageWithImages:imgsArr duration:duration];
    }
    CFRelease(source);
    return animatedImg;
}



+ (UIImage *)dwq_setAnimatedGIFWithGifName:(NSString *)name{
    CGFloat xyScale = [UIScreen mainScreen].scale;
    if(xyScale >1.0f){
        NSString * retinaPath = [[NSBundle mainBundle] pathForResource:[name stringByAppendingString:@"@2x"] ofType:@"gif"];
        NSData * data = [NSData dataWithContentsOfFile:retinaPath];
        if(data){
            return [UIImage dwq_setAnimatedGIFWithData:data];
        }
        NSString * path = [[NSBundle mainBundle] pathForResource:name ofType:@"gif"];
        data = [NSData dataWithContentsOfFile:path];
        if(data){
            return [UIImage dwq_setAnimatedGIFWithData:data];
        }
        return [UIImage imageNamed:name];
    }else{
        NSString * path = [[NSBundle mainBundle] pathForResource:name ofType:@"gif"];
        NSData * data = [NSData dataWithContentsOfFile:path];
        if(data){
            return [UIImage dwq_setAnimatedGIFWithData:data];
        }
        return [UIImage imageNamed:name];
    }
}

+ (float)dwq_setFrameDurationAtIndex:(NSUInteger)index source:(CGImageSourceRef)source{
    float frameDuration = 0.1f;
    CFDictionaryRef cfFrameProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil);
    NSDictionary * frameProperties = (__bridge NSDictionary *)cfFrameProperties;
    NSDictionary * gifProperties = frameProperties[(NSString *)kCGImagePropertyGIFDictionary];
    NSNumber * delayTimeUnclampedProp = gifProperties[(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
    if(delayTimeUnclampedProp){
        frameDuration = [delayTimeUnclampedProp floatValue];
    }else{
        NSNumber * delayTimeProp = gifProperties[(NSString *)kCGImagePropertyGIFDelayTime];
        if(delayTimeProp){
            frameDuration = [delayTimeProp floatValue];
        }
    }
    if(frameDuration < 0.011f){
        frameDuration = 0.100f;
    }
    CFRelease(cfFrameProperties);
    return frameDuration;
}


@end
