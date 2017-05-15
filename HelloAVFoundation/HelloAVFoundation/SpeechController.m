//
//  SpeechController.m
//  HelloAVFoundation
//
//  Created by 杨晴贺 on 2017/5/15.
//  Copyright © 2017年 Silence. All rights reserved.
//

#import "SpeechController.h"

@interface SpeechController ()

@property (nonatomic,strong) AVSpeechSynthesizer *synthesizer ;
@property (nonatomic,strong) NSArray *voices ;
@property (nonatomic,strong) NSArray *speechStrings ;

@end

@implementation SpeechController

+ (instancetype)speechController {
    return [[self alloc]init] ;
}

- (instancetype)init {
    if (self = [super init]) {
        _synthesizer = [[AVSpeechSynthesizer alloc]init] ;
        
        /*
        "[AVSpeechSynthesisVoice 0x978a0b0] Language: th-TH",
        "[AVSpeechSynthesisVoice 0x977a450] Language: pt-BR",
        "[AVSpeechSynthesisVoice 0x977a480] Language: sk-SK",
        "[AVSpeechSynthesisVoice 0x978ad50] Language: fr-CA",
        "[AVSpeechSynthesisVoice 0x978ada0] Language: ro-RO",
        "[AVSpeechSynthesisVoice 0x97823f0] Language: no-NO",
        "[AVSpeechSynthesisVoice 0x978e7b0] Language: fi-FI",
        "[AVSpeechSynthesisVoice 0x978af50] Language: pl-PL",
        "[AVSpeechSynthesisVoice 0x978afa0] Language: de-DE",
        "[AVSpeechSynthesisVoice 0x978e390] Language: nl-NL",
        "[AVSpeechSynthesisVoice 0x978b030] Language: id-ID",
        "[AVSpeechSynthesisVoice 0x978b080] Language: tr-TR",
        "[AVSpeechSynthesisVoice 0x978b0d0] Language: it-IT",
        "[AVSpeechSynthesisVoice 0x978b120] Language: pt-PT",
        "[AVSpeechSynthesisVoice 0x978b170] Language: fr-FR",
        "[AVSpeechSynthesisVoice 0x978b1c0] Language: ru-RU",
        "[AVSpeechSynthesisVoice 0x978b210]Language: es-MX",
        "[AVSpeechSynthesisVoice 0x978b2d0] Language: zh-HK",
        "[AVSpeechSynthesisVoice 0x978b320] Language: sv-SE",
        "[AVSpeechSynthesisVoice 0x978b010] Language: hu-HU",
        "[AVSpeechSynthesisVoice 0x978b440] Language: zh-TW",
        "[AVSpeechSynthesisVoice 0x978b490] Language: es-ES",
        "[AVSpeechSynthesisVoice 0x978b4e0] Language: zh-CN",汉语
        "[AVSpeechSynthesisVoice 0x978b530] Language: nl-BE",
        "[AVSpeechSynthesisVoice 0x978b580] Language: en-GB",
        "[AVSpeechSynthesisVoice 0x978b5d0] Language: ar-SA",
        "[AVSpeechSynthesisVoice 0x978b620] Language: ko-KR",
        "[AVSpeechSynthesisVoice 0x978b670] Language: cs-CZ",
        "[AVSpeechSynthesisVoice 0x978b6c0] Language: en-ZA",
        "[AVSpeechSynthesisVoice 0x978aed0] Language: en-AU",
        "[AVSpeechSynthesisVoice 0x978af20] Language: da-DK",
        "[AVSpeechSynthesisVoice 0x978b810] Language: en-US",
        "[AVSpeechSynthesisVoice 0x978b860] Language: en-IE",
        "[AVSpeechSynthesisVoice 0x978b8b0] Language: hi-IN",
        "[AVSpeechSynthesisVoice 0x978b900] Language: el-GR",
        "[AVSpeechSynthesisVoice 0x978b950] Language: ja-JP"
         */
        
        _voices = @[[AVSpeechSynthesisVoice voiceWithLanguage:@"en-US"],
                    [AVSpeechSynthesisVoice voiceWithLanguage:@"en-GB"]] ;
        
        _speechStrings = [self buildSpeechStrings];
    }
    return self ;
}

- (NSArray *)buildSpeechStrings {
    return @[@"Hello AV Foundation. How are you?",
             @"I'm well! Thanks for asking.",
             @"Are you excited about the book?",
             @"Very! I have always felt so misunderstood.",
             @"What's your favorite feature?",
             @"Oh, they're all my babies.  I couldn't possibly choose.",
             @"It was great to speak with you!",
             @"The pleasure was all mine!  Have fun!"];
}

- (void)beginConversion {
    for (NSInteger i = 0 ; i < self.speechStrings.count ;i++) {
        AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc]initWithString:self.speechStrings[i]] ;
        utterance.voice = self.voices[i%2];
        utterance.rate = 0.5f ;
        utterance.pitchMultiplier = 0.8f;
        utterance.postUtteranceDelay = 0.1f;
        [self.synthesizer speakUtterance:utterance];
    }
}

@end
