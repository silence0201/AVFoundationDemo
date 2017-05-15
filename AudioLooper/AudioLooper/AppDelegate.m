//
//  AppDelegate.m
//  AudioLooper
//
//  Created by 杨晴贺 on 2017/5/15.
//  Copyright © 2017年 Silence. All rights reserved.
//

#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    NSError *error;
    if (![session setCategory:AVAudioSessionCategoryPlayback error:&error]) {
        NSLog(@"Category Error: %@", [error localizedDescription]);
    }
    
    if (![session setActive:YES error:&error]) {
        NSLog(@"Activation Error: %@", [error localizedDescription]);
    }
    
    return YES;
}

@end
