//
//  WaveformView.m
//  WaveformView
//
//  Created by 杨晴贺 on 2017/5/18.
//  Copyright © 2017年 Silence. All rights reserved.
//

#import "WaveformView.h"
#import "SampleDataFilter.h"
#import "SampleDataProvider.h"

static const CGFloat WidthScaling = 0.95;
static const CGFloat HeightScaling = 0.85;

@interface WaveformView ()
@property (strong, nonatomic) SampleDataFilter *filter;
@property (strong, nonatomic) UIActivityIndicatorView *loadingView;
@end

@implementation WaveformView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.backgroundColor = [UIColor clearColor];
    self.waveColor = [UIColor whiteColor];
    self.layer.cornerRadius = 2.0f;
    self.layer.masksToBounds = YES;
    
    UIActivityIndicatorViewStyle style = UIActivityIndicatorViewStyleWhiteLarge;
    
    _loadingView =
    [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
    
    CGSize size = _loadingView.frame.size;
    CGFloat x = (self.bounds.size.width - size.width) / 2;
    CGFloat y = (self.bounds.size.height - size.height) / 2;
    _loadingView.frame = CGRectMake(x, y, size.width, size.height);
    [self addSubview:_loadingView];
    
    [_loadingView startAnimating];
}

- (void)setWaveColor:(UIColor *)waveColor {
    _waveColor = waveColor;
    self.layer.borderWidth = 2.0f;
    self.layer.borderColor = waveColor.CGColor;
    [self setNeedsDisplay];
}

- (void)setAsset:(AVAsset *)asset {
    if (_asset != asset) {
        _asset = asset;
        
        [SampleDataProvider loadAudioSamplesFromAsset:self.asset          // 1
                                        completionBlock:^(NSData *sampleData) {
                                            
                                            self.filter =                                                   // 2
                                            [[SampleDataFilter alloc] initWithData:sampleData];
                                            
                                            [self.loadingView stopAnimating];                               // 3
                                            [self setNeedsDisplay];
                                        }];
    }
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextScaleCTM(context, WidthScaling, HeightScaling);            // 1
    
    CGFloat xOffset = self.bounds.size.width -
    (self.bounds.size.width * WidthScaling);
    
    CGFloat yOffset = self.bounds.size.height -
    (self.bounds.size.height * HeightScaling);
    
    CGContextTranslateCTM(context, xOffset / 2, yOffset / 2);
    
    NSArray *filteredSamples =                                              // 2
    [self.filter filteredSamplesForSize:self.bounds.size];
    
    CGFloat midY = CGRectGetMidY(rect);
    
    CGMutablePathRef halfPath = CGPathCreateMutable();                      // 3
    CGPathMoveToPoint(halfPath, NULL, 0.0f, midY);
    
    for (NSUInteger i = 0; i < filteredSamples.count; i++) {
        float sample = [filteredSamples[i] floatValue];
        CGPathAddLineToPoint(halfPath, NULL, i, midY - sample);
    }
    
    CGPathAddLineToPoint(halfPath, NULL, filteredSamples.count, midY);
    
    CGMutablePathRef fullPath = CGPathCreateMutable();                      // 4
    CGPathAddPath(fullPath, NULL, halfPath);
    
    CGAffineTransform transform = CGAffineTransformIdentity;                // 5
    transform = CGAffineTransformTranslate(transform, 0, CGRectGetHeight(rect));
    transform = CGAffineTransformScale(transform, 1.0, -1.0);
    CGPathAddPath(fullPath, &transform, halfPath);
    
    CGContextAddPath(context, fullPath);                                    // 6
    CGContextSetFillColorWithColor(context, self.waveColor.CGColor);
    CGContextDrawPath(context, kCGPathFill);
    
    CGPathRelease(halfPath);                                                // 7
    CGPathRelease(fullPath);
}

@end

