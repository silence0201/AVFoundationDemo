//
//  PlayerController.h
//  AudioLooper
//
//  Created by 杨晴贺 on 2017/5/15.
//  Copyright © 2017年 Silence. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PlayerControllerDelegate <NSObject>
- (void)playbackStopped;
- (void)playbackBegan;
@end

@interface PlayerController : NSObject

@property (nonatomic, getter = isPlaying) BOOL playing;
@property (weak, nonatomic) id <PlayerControllerDelegate> delegate;

// Global methods
- (void)play;
- (void)stop;
- (void)adjustRate:(float)rate;

// Player-specific methods
- (void)adjustPan:(float)pan forPlayerAtIndex:(NSUInteger)index;
- (void)adjustVolume:(float)volume forPlayerAtIndex:(NSUInteger)index;

@end
