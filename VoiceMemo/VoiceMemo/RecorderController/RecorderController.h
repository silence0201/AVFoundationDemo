//
//  RecorderController.h
//  VoiceMemo
//
//  Created by 杨晴贺 on 2017/5/15.
//  Copyright © 2017年 Silence. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RecorderControllerDelegate <NSObject>
- (void)interruptionBegan;
@end

typedef void(^RecordingStopCompletionHandler)(BOOL);
typedef void(^RecordingSaveCompletionHandler)(BOOL, id);

@class Memo;
@class LevelPair;

@interface RecorderController : NSObject

@property (nonatomic, readonly) NSString *formattedCurrentTime;
@property (weak, nonatomic) id <RecorderControllerDelegate> delegate;

// Recorder methods
- (BOOL)record;

- (void)pause;

- (void)stopWithCompletionHandler:(RecordingStopCompletionHandler)handler;

- (void)saveRecordingWithName:(NSString *)name
            completionHandler:(RecordingSaveCompletionHandler)handler;

- (LevelPair *)levels;

// Player methods
- (BOOL)playbackMemo:(Memo *)memo;

@end

