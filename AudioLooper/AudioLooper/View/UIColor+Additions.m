//
//  UIColor+Additions.m
//  AudioLooper
//
//  Created by 杨晴贺 on 2017/5/15.
//  Copyright © 2017年 Silence. All rights reserved.
//

#import "UIColor+Additions.h"

@implementation UIColor (Additions)

- (UIColor *)lighterColor {
    CGFloat hue, saturation, brightness, alpha;
    if ([self getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha]) {
        return [UIColor colorWithHue:hue saturation:saturation brightness:MIN(brightness * 1.3, 1.0) alpha:0.5];
    }
    return nil;
}

- (UIColor *)darkerColor {
    CGFloat hue, saturation, brightness, alpha;
    if ([self getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha]) {
        return [UIColor colorWithHue:hue saturation:saturation brightness:brightness * 0.92 alpha:alpha];
    }
    return nil;
}

@end
