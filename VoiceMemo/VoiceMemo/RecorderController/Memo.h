//
//  Memo.h
//  VoiceMemo
//
//  Created by 杨晴贺 on 2017/5/15.
//  Copyright © 2017年 Silence. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Memo : NSObject<NSCoding>

@property (copy, nonatomic, readonly) NSString *title;
@property (strong, nonatomic, readonly) NSURL *url;
@property (copy, nonatomic, readonly) NSString *dateString;
@property (copy, nonatomic, readonly) NSString *timeString;

+ (instancetype)memoWithTitle:(NSString *)title url:(NSURL *)url;

- (BOOL)deleteMemo;

@end

@interface MeterTable : NSObject

- (float)valueForPower:(float)power;

@end
