//
//  ViewController.m
//  WaveformView
//
//  Created by 杨晴贺 on 2017/5/18.
//  Copyright © 2017年 Silence. All rights reserved.
//

#import "ViewController.h"
#import "WaveformView.h"
#import "UIColor+Extension.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet WaveformView *keysWaveformView;
@property (weak, nonatomic) IBOutlet WaveformView *beatWaveformView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *keysURL = [[NSBundle mainBundle] URLForResource:@"keys"
                                             withExtension:@"mp3"];
    
    NSURL *beatURL  = [[NSBundle mainBundle] URLForResource:@"beat"
                                              withExtension:@"aiff"];
    
    self.keysWaveformView.waveColor = [UIColor blueWaveColor];
    self.keysWaveformView.backgroundColor = [UIColor blueBackgroundColor];
    self.keysWaveformView.asset = [AVURLAsset assetWithURL:keysURL];
    
    self.beatWaveformView.waveColor = [UIColor greenWaveColor];
    self.beatWaveformView.backgroundColor = [UIColor greenBackgroundColor];
    self.beatWaveformView.asset = [AVURLAsset assetWithURL:beatURL];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}



@end
