//
//  ViewController.m
//  AVViewControllerDemo
//
//  Created by 杨晴贺 on 2017/5/16.
//  Copyright © 2017年 Silence. All rights reserved.
//

#import "ViewController.h"
@import AVFoundation ;
@import AVKit ;


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)showAVVC:(id)sender {
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Demo" withExtension:@"m4v"] ;
    AVPlayerViewController *playerVc = [[AVPlayerViewController alloc]init] ;
    playerVc.player = [AVPlayer playerWithURL:url] ;
    [playerVc.player play] ;
    
    
    [self presentViewController:playerVc animated:YES completion:nil] ;
}


@end
