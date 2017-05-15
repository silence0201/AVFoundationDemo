//
//  SIMetadata.m
//  MetaManagerDemo
//
//  Created by 杨晴贺 on 2017/5/15.
//  Copyright © 2017年 Silence. All rights reserved.
//

#import "SIMetadata.h"
#import "SIMetadataConverterFactory.h"
#import "SIMetadataKeys.h"

@interface SIMetadata ()
@property (strong) NSDictionary *keyMapping;
@property (strong) NSMutableDictionary *metadata;
@property (strong) SIMetadataConverterFactory *converterFactory;
@end

@implementation SIMetadata

- (id)init {
    self = [super init];
    if (self) {
        _keyMapping = [self buildKeyMapping];                               // 1
        _metadata = [NSMutableDictionary dictionary];                       // 2
        _converterFactory = [[SIMetadataConverterFactory alloc] init];      // 3
    }
    return self;
}

- (NSDictionary *)buildKeyMapping {
    
    return @{
             // Name Mapping
             AVMetadataCommonKeyTitle : SIMetadataKeyName,
             
             // Artist Mapping
             AVMetadataCommonKeyArtist : SIMetadataKeyArtist,
             AVMetadataQuickTimeMetadataKeyProducer : SIMetadataKeyArtist,
             
             // Album Artist Mapping
             AVMetadataID3MetadataKeyBand : SIMetadataKeyAlbumArtist,
             AVMetadataiTunesMetadataKeyAlbumArtist : SIMetadataKeyAlbumArtist,
             @"TP2" : SIMetadataKeyAlbumArtist,
             
             // Album Mapping
             AVMetadataCommonKeyAlbumName : SIMetadataKeyAlbum,
             
             // Artwork Mapping
             AVMetadataCommonKeyArtwork : SIMetadataKeyArtwork,
             
             // Year Mapping
             AVMetadataCommonKeyCreationDate : SIMetadataKeyYear,
             AVMetadataID3MetadataKeyYear : SIMetadataKeyYear,
             @"TYE" : SIMetadataKeyYear,
             AVMetadataQuickTimeMetadataKeyYear : SIMetadataKeyYear,
             AVMetadataID3MetadataKeyRecordingTime : SIMetadataKeyYear,
             
             // BPM Mapping
             AVMetadataiTunesMetadataKeyBeatsPerMin : SIMetadataKeyBPM,
             AVMetadataID3MetadataKeyBeatsPerMinute : SIMetadataKeyBPM,
             @"TBP" : SIMetadataKeyBPM,
             
             // Grouping Mapping
             AVMetadataiTunesMetadataKeyGrouping : SIMetadataKeyGrouping,
             @"@grp" : SIMetadataKeyGrouping,
             AVMetadataCommonKeySubject : SIMetadataKeyGrouping,
             
             // Track Number Mapping
             AVMetadataiTunesMetadataKeyTrackNumber : SIMetadataKeyTrackNumber,
             AVMetadataID3MetadataKeyTrackNumber : SIMetadataKeyTrackNumber,
             @"TRK" : SIMetadataKeyTrackNumber,
             
             // Composer Mapping
             AVMetadataQuickTimeMetadataKeyDirector : SIMetadataKeyComposer,
             AVMetadataiTunesMetadataKeyComposer : SIMetadataKeyComposer,
             AVMetadataCommonKeyCreator : SIMetadataKeyComposer,
             
             // Disc Number Mapping
             AVMetadataiTunesMetadataKeyDiscNumber : SIMetadataKeyDiscNumber,
             AVMetadataID3MetadataKeyPartOfASet : SIMetadataKeyDiscNumber,
             @"TPA" : SIMetadataKeyDiscNumber,
             
             // Comments Mapping
             @"ldes" : SIMetadataKeyComments,
             AVMetadataCommonKeyDescription : SIMetadataKeyComments,
             AVMetadataiTunesMetadataKeyUserComment : SIMetadataKeyComments,
             AVMetadataID3MetadataKeyComments : SIMetadataKeyComments,
             @"COM" : SIMetadataKeyComments,
             
             // Genre Mapping
             AVMetadataQuickTimeMetadataKeyGenre : SIMetadataKeyGenre,
             AVMetadataiTunesMetadataKeyUserGenre : SIMetadataKeyGenre,
             AVMetadataCommonKeyType : SIMetadataKeyGenre
             };
}


- (void)addMetadataItem:(AVMetadataItem *)item withKey:(id)key {
    
    NSString *normalizedKey = self.keyMapping[key];                         // 1
    
    if (normalizedKey) {
        
        id <SIMetadataConverter> converter =                                // 2
        [self.converterFactory converterForKey:normalizedKey];
        
        id value = [converter displayValueFromMetadataItem:item];
        
        if ([value isKindOfClass:[NSDictionary class]]) {                   // 3
            NSDictionary *data = (NSDictionary *) value;
            for (NSString *currentKey in data) {
                if (![data[currentKey] isKindOfClass:[NSNull class]]) {
                    [self setValue:data[currentKey] forKey:currentKey];
                }
            }
        } else {
            [self setValue:value forKey:normalizedKey];
        }
        
        self.metadata[normalizedKey] = item;                                // 4
    }
}

- (NSArray *)metadataItems {
    
    NSMutableArray *items = [NSMutableArray array];                         // 1
    
    [self addMetadataItemForNumber:self.trackNumber                         // 2
                             count:self.trackCount
                         numberKey:SIMetadataKeyTrackNumber
                          countKey:SIMetadataKeyTrackCount
                           toArray:items];
    
    [self addMetadataItemForNumber:self.discNumber
                             count:self.discCount
                         numberKey:SIMetadataKeyDiscNumber
                          countKey:SIMetadataKeyDiscCount
                           toArray:items];
    
    NSMutableDictionary *metaDict = [self.metadata mutableCopy];            // 6
    [metaDict removeObjectForKey:SIMetadataKeyTrackNumber];
    [metaDict removeObjectForKey:SIMetadataKeyDiscNumber];
    
    for (NSString *key in metaDict) {
        
        id <SIMetadataConverter> converter = [self.converterFactory converterForKey:key] ;
        
        id value = [self valueForKey:key];                                  // 7
        
        AVMetadataItem *item = [converter metadataItemFromDisplayValue:value withMetadataItem:metaDict[key]] ;
        // 8
        if (item) {
            [items addObject:item];
        }
    }
    
    return items;
}

- (void)addMetadataItemForNumber:(NSNumber *)number
                           count:(NSNumber *)count
                       numberKey:(NSString *)numberKey
                        countKey:(NSString *)countKey
                         toArray:(NSMutableArray *)items {                  // 3
    
    id <SIMetadataConverter> converter =
    [self.converterFactory converterForKey:numberKey];
    
    NSDictionary *data = @{numberKey : number ?: [NSNull null],             // 4
                           countKey : count ?: [NSNull null]};
    
    AVMetadataItem *sourceItem = self.metadata[numberKey];
    
    AVMetadataItem *item =                                                  // 5
    [converter metadataItemFromDisplayValue:data
                           withMetadataItem:sourceItem];
    if (item) {
        [items addObject:item];
    }
}

@end

