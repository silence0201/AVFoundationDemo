//
//  SpeechController.h
//  HelloAVFoundation
//
//  Created by 杨晴贺 on 2017/5/15.
//  Copyright © 2017年 Silence. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface SpeechController : NSObject

@property (nonatomic,strong,readonly) AVSpeechSynthesizer *synthesizer ;

+ (instancetype)speechController ;
- (void)beginConversion ;

@end
