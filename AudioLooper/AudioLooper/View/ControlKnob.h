//
//  ControlKnob.h
//  AudioLooper
//
//  Created by 杨晴贺 on 2017/5/15.
//  Copyright © 2017年 Silence. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ControlKnob : UIControl

@property (nonatomic) float maximumValue;
@property (nonatomic) float minimumValue;
@property (nonatomic) float value;
@property (nonatomic) float defaultValue;

@end

@interface GreenControlKnob : ControlKnob

@end

@interface OrangeControlKnob : ControlKnob

@end
