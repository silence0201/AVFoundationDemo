//
//  SampleDataFilter.m
//  WaveformView
//
//  Created by 杨晴贺 on 2017/5/18.
//  Copyright © 2017年 Silence. All rights reserved.
//

#import "SampleDataFilter.h"

@interface SampleDataFilter ()
@property (nonatomic, strong) NSData *sampleData;
@end

@implementation SampleDataFilter

- (id)initWithData:(NSData *)sampleData {
    self = [super init];
    if (self) {
        _sampleData = sampleData;
    }
    return self;
}

- (NSArray *)filteredSamplesForSize:(CGSize)size {
    
    NSMutableArray *filteredSamples = [[NSMutableArray alloc] init];        // 1
    NSUInteger sampleCount = self.sampleData.length / sizeof(SInt16);
    NSUInteger binSize = sampleCount / size.width;
    
    SInt16 *bytes = (SInt16 *) self.sampleData.bytes;
    
    SInt16 maxSample = 0;
    
    for (NSUInteger i = 0; i < sampleCount; i += binSize) {
        
        SInt16 sampleBin[binSize];
        
        for (NSUInteger j = 0; j < binSize; j++) {                          // 2
            sampleBin[j] = CFSwapInt16LittleToHost(bytes[i + j]);
        }
        
        SInt16 value = [self maxValueInArray:sampleBin ofSize:binSize];     // 3
        [filteredSamples addObject:@(value)];
        
        if (value > maxSample) {                                            // 4
            maxSample = value;
        }
    }
    
    CGFloat scaleFactor = (size.height / 2) / maxSample;                    // 5
    
    for (NSUInteger i = 0; i < filteredSamples.count; i++) {                // 6
        filteredSamples[i] = @([filteredSamples[i] integerValue] * scaleFactor);
    }
    
    return filteredSamples;
}

- (SInt16)maxValueInArray:(SInt16[])values ofSize:(NSUInteger)size {
    SInt16 maxValue = 0;
    for (int i = 0; i < size; i++) {
        if (abs(values[i]) > maxValue) {
            maxValue = abs(values[i]);
        }
    }
    return maxValue;
}

@end
