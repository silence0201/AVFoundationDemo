//
//  SampleDataFilter.h
//  WaveformView
//
//  Created by 杨晴贺 on 2017/5/18.
//  Copyright © 2017年 Silence. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface SampleDataFilter : NSObject

- (id)initWithData:(NSData *)sampleData;

- (NSArray *)filteredSamplesForSize:(CGSize)size;

@end
