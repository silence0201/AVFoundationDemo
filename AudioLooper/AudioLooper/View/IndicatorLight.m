//
//  IndicatorLight.m
//  AudioLooper
//
//  Created by 杨晴贺 on 2017/5/15.
//  Copyright © 2017年 Silence. All rights reserved.
//

#import "IndicatorLight.h"
#import "UIColor+Additions.h"

@implementation IndicatorLight

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setUserInteractionEnabled:NO];
    }
    return self;
}

- (void)setLightColor:(UIColor *)lightColor {
    _lightColor = lightColor;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat midX = CGRectGetMidX(rect);
    CGFloat minY = CGRectGetMinY(rect);
    CGFloat width = CGRectGetWidth(rect) * 0.15;
    CGFloat height = CGRectGetHeight(rect) * 0.15;
    CGRect indicatorRect = CGRectMake(midX - (width / 2), minY + 15, width, height);
    
    UIColor *strokeColor = [self.lightColor darkerColor];
    CGContextSetStrokeColorWithColor(context, strokeColor.CGColor);
    CGContextSetFillColorWithColor(context, self.lightColor.CGColor);
    
    UIColor *shadowColor = [self.lightColor lighterColor];
    CGSize shadowOffset = CGSizeMake(0.0f, 0.0f);
    CGFloat blurRadius = 5.0f;
    
    CGContextSetShadowWithColor(context, shadowOffset, blurRadius, shadowColor.CGColor);
    
    CGContextAddEllipseInRect(context, indicatorRect);
    CGContextDrawPath(context, kCGPathFillStroke);
}


@end
