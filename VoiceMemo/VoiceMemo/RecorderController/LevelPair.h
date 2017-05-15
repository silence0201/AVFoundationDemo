//
//  LevelPair.h
//  VoiceMemo
//
//  Created by 杨晴贺 on 2017/5/15.
//  Copyright © 2017年 Silence. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LevelPair : NSObject

@property (nonatomic, readonly) float level;
@property (nonatomic, readonly) float peakLevel;

+ (instancetype)levelsWithLevel:(float)level peakLevel:(float)peakLevel;

- (instancetype)initWithLevel:(float)level peakLevel:(float)peakLevel;

@end
