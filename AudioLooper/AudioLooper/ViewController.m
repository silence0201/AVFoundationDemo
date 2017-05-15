//
//  ViewController.m
//  AudioLooper
//
//  Created by 杨晴贺 on 2017/5/15.
//  Copyright © 2017年 Silence. All rights reserved.
//

#import "ViewController.h"
#import "ControlKnob.h"
#import "PlayerController.h"

@interface ViewController ()<PlayerControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *playLabel;
@property (weak, nonatomic) IBOutlet ControlKnob *rateKnob;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (strong, nonatomic) IBOutletCollection(ControlKnob) NSArray *panKnobs;
@property (strong, nonatomic) IBOutletCollection(ControlKnob) NSArray *volumeKnobs;
@property (strong, nonatomic) PlayerController *controller;

@end

@implementation ViewController

- (void)viewDidLoad {
    self.controller = [[PlayerController alloc] init];
    self.controller.delegate = self;
    
    self.rateKnob.minimumValue = 0.5f;
    self.rateKnob.maximumValue = 1.5f;
    self.rateKnob.value = 1.0f;
    self.rateKnob.defaultValue = 1.0f;
    
    // Panning L = -1, C = 0, R = 1
    for (ControlKnob *knob in self.panKnobs) {
        knob.minimumValue = -1.0f;
        knob.maximumValue = 1.0f;
        knob.value = 0.0f;
        knob.defaultValue = 0.0f;
    }
    
    // Volume Ranges from 0..1
    for (ControlKnob *knob in self.volumeKnobs) {
        knob.minimumValue = 0.0f;
        knob.maximumValue = 1.0f;
        knob.value = 1.0f;
        knob.defaultValue = 1.0f;
    }
}

- (IBAction)play:(UIButton *)sender {
    if (!self.controller.isPlaying) {
        [self.controller play];
        self.playLabel.text = NSLocalizedString(@"Stop", nil);
    } else {
        [self.controller stop];
        self.playLabel.text = NSLocalizedString(@"Play", nil);
    }
    self.playButton.selected = !self.playButton.selected;
}

- (IBAction)adjustRate:(ControlKnob *)sender {
    [self.controller adjustRate:sender.value];
}

- (IBAction)adjustPan:(ControlKnob *)sender {
    [self.controller adjustPan:sender.value forPlayerAtIndex:sender.tag];
}

- (IBAction)adjustVolume:(ControlKnob *)sender {
    [self.controller adjustVolume:sender.value forPlayerAtIndex:sender.tag];
}

#pragma mark - THPlayerControllerDelegate Methods

- (void)playbackStopped {
    self.playButton.selected = NO;
    self.playLabel.text = NSLocalizedString(@"Play", nil);
}

- (void)playbackBegan {
    self.playButton.selected = YES;
    self.playLabel.text = NSLocalizedString(@"Stop", nil);
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}



@end
