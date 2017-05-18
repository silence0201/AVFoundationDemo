//
//  SampleDataProvider.h
//  WaveformView
//
//  Created by 杨晴贺 on 2017/5/18.
//  Copyright © 2017年 Silence. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

typedef void(^SampleDataCompletionBlock)(NSData *);

@interface SampleDataProvider : NSObject

+ (void)loadAudioSamplesFromAsset:(AVAsset *)asset
                  completionBlock:(SampleDataCompletionBlock)completionBlock;

@end
