//
//  WaveformView.h
//  WaveformView
//
//  Created by 杨晴贺 on 2017/5/18.
//  Copyright © 2017年 Silence. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@interface WaveformView : UIView

@property (strong, nonatomic) AVAsset *asset;
@property (strong, nonatomic) UIColor *waveColor;

@end
