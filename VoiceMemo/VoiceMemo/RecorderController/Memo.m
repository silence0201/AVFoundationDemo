//
//  Memo.m
//  VoiceMemo
//
//  Created by 杨晴贺 on 2017/5/15.
//  Copyright © 2017年 Silence. All rights reserved.
//

#import "Memo.h"

#define TITLE_KEY        @"title"
#define URL_KEY            @"url"
#define DATE_STRING_KEY    @"dateString"
#define TIME_STRING_KEY    @"timeString"

#define MIN_DB -60.0f
#define TABLE_SIZE 300

@implementation Memo

+ (instancetype)memoWithTitle:(NSString *)title url:(NSURL *)url {
    return [[self alloc] initWithTitle:title url:url];
}

- (id)initWithTitle:(NSString *)title url:(NSURL *)url {
    self = [super init];
    if (self) {
        _title = [title copy];
        _url = url;
        
        NSDate *date = [NSDate date];
        _dateString = [self dateStringWithDate:date];
        _timeString = [self timeStringWithDate:date];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.title forKey:TITLE_KEY];
    [coder encodeObject:self.url forKey:URL_KEY];
    [coder encodeObject:self.dateString forKey:DATE_STRING_KEY];
    [coder encodeObject:self.timeString forKey:TIME_STRING_KEY];
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        _title = [decoder decodeObjectForKey:TITLE_KEY];
        _url = [decoder decodeObjectForKey:URL_KEY];
        _dateString = [decoder decodeObjectForKey:DATE_STRING_KEY];
        _timeString = [decoder decodeObjectForKey:TIME_STRING_KEY];
    }
    return self;
}

- (NSString *)dateStringWithDate:(NSDate *)date {
    NSDateFormatter *formatter = [self formatterWithFormat:@"MMddyyyy"];
    return [formatter stringFromDate:date];
}

- (NSString *)timeStringWithDate:(NSDate *)date {
    NSDateFormatter *formatter = [self formatterWithFormat:@"HHmmss"];
    return [formatter stringFromDate:date];
}

- (NSDateFormatter *)formatterWithFormat:(NSString *)template {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    NSString *format = [NSDateFormatter dateFormatFromTemplate:template options:0 locale:[NSLocale currentLocale]];
    [formatter setDateFormat:format];
    return formatter;
}

- (BOOL)deleteMemo {
    NSError *error;
    BOOL success = [[NSFileManager defaultManager] removeItemAtURL:self.url error:&error];
    if (!success) {
        NSLog(@"Unable to delete: %@", [error localizedDescription]);
    }
    return success;
}


@end

@implementation MeterTable{
    float _scaleFactor;
    NSMutableArray *_meterTable;
}

- (id)init {
    self = [super init];
    if (self) {
        float dbResolution = MIN_DB / (TABLE_SIZE - 1);
        
        _meterTable = [NSMutableArray arrayWithCapacity:TABLE_SIZE];
        _scaleFactor = 1.0f / dbResolution;
        
        float minAmp = dbToAmp(MIN_DB);
        float ampRange = 1.0 - minAmp;
        float invAmpRange = 1.0 / ampRange;
        
        for (int i = 0; i < TABLE_SIZE; i++) {
            float decibels = i * dbResolution;
            float amp = dbToAmp(decibels);
            float adjAmp = (amp - minAmp) * invAmpRange;
            _meterTable[i] = @(adjAmp);
        }
    }
    return self;
}

float dbToAmp(float dB) {
    return powf(10.0f, 0.05f * dB);
}

- (float)valueForPower:(float)power {
    if (power < MIN_DB) {
        return 0.0f;
    } else if (power >= 0.0f) {
        return 1.0f;
    } else {
        int index = (int) (power * _scaleFactor);
        return [_meterTable[index] floatValue];
    }
}


@end
