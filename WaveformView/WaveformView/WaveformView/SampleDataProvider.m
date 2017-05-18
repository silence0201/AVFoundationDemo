//
//  SampleDataProvider.m
//  WaveformView
//
//  Created by 杨晴贺 on 2017/5/18.
//  Copyright © 2017年 Silence. All rights reserved.
//

#import "SampleDataProvider.h"

@implementation SampleDataProvider

+ (void)loadAudioSamplesFromAsset:(AVAsset *)asset
                  completionBlock:(SampleDataCompletionBlock)completionBlock {
    
    NSString *tracks = @"tracks";
    
    [asset loadValuesAsynchronouslyForKeys:@[tracks] completionHandler:^{   // 1
        
        AVKeyValueStatus status = [asset statusOfValueForKey:tracks error:nil];
        
        NSData *sampleData = nil;
        
        if (status == AVKeyValueStatusLoaded) {                             // 2
            sampleData = [self readAudioSamplesFromAsset:asset];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{                        // 3
            completionBlock(sampleData);
        });
    }];
    
}

+ (NSData *)readAudioSamplesFromAsset:(AVAsset *)asset {
    
    NSError *error = nil;
    
    AVAssetReader *assetReader =                                            // 1
    [[AVAssetReader alloc] initWithAsset:asset error:&error];
    
    if (!assetReader) {
        NSLog(@"Error creating asset reader: %@", [error localizedDescription]);
        return nil;
    }
    
    AVAssetTrack *track =                                                   // 2
    [[asset tracksWithMediaType:AVMediaTypeAudio] firstObject];
    
    NSDictionary *outputSettings = @{                                       // 3
                                     AVFormatIDKey               : @(kAudioFormatLinearPCM),
                                     AVLinearPCMIsBigEndianKey   : @NO,
                                     AVLinearPCMIsFloatKey		: @NO,
                                     AVLinearPCMBitDepthKey		: @(16)
                                     };
    
    
    AVAssetReaderTrackOutput *trackOutput =                                 // 4
    [[AVAssetReaderTrackOutput alloc] initWithTrack:track
                                     outputSettings:outputSettings];
    
    [assetReader addOutput:trackOutput];
    
    [assetReader startReading];
    
    NSMutableData *sampleData = [NSMutableData data];
    
    while (assetReader.status == AVAssetReaderStatusReading) {
        
        CMSampleBufferRef sampleBuffer = [trackOutput copyNextSampleBuffer];// 5
        
        if (sampleBuffer) {
            
            CMBlockBufferRef blockBufferRef =                               // 6
            CMSampleBufferGetDataBuffer(sampleBuffer);
            
            size_t length = CMBlockBufferGetDataLength(blockBufferRef);
            SInt16 sampleBytes[length];
            CMBlockBufferCopyDataBytes(blockBufferRef,                      // 7
                                       0,
                                       length,
                                       sampleBytes);
            
            [sampleData appendBytes:sampleBytes length:length];
            
            CMSampleBufferInvalidate(sampleBuffer);                         // 8
            CFRelease(sampleBuffer);
        }
    }
    
    if (assetReader.status == AVAssetReaderStatusCompleted) {               // 9
        return sampleData;
    } else {
        NSLog(@"Failed to read audio samples from asset");
        return nil;
    }
}


@end
