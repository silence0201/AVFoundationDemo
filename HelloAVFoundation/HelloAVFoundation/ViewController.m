//
//  ViewController.m
//  HelloAVFoundation
//
//  Created by 杨晴贺 on 2017/5/15.
//  Copyright © 2017年 Silence. All rights reserved.
//

#import "ViewController.h"
#import "BubbleCell.h"
#import "SpeechController.h"

@interface ViewController ()<AVSpeechSynthesizerDelegate>

@property (nonatomic,strong) SpeechController *speechControl ;
@property (nonatomic,strong) NSMutableArray *speechStrings ;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self sayHello];
    self.tableView.contentInset = UIEdgeInsetsMake(20.0f, 0.0f, 20.0f, 0.0f) ;
    self.speechControl = [SpeechController speechController] ;
    self.speechControl.synthesizer.delegate = self ;
    self.speechStrings = [NSMutableArray array] ;
    [self.speechControl beginConversion] ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.speechStrings.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = indexPath.row %2 == 0 ? @"YouCell" : @"AVFCell" ;
    BubbleCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier] ;
    cell.messageLabel.text = self.speechStrings[indexPath.row] ;
    return cell ;
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didStartSpeechUtterance:(AVSpeechUtterance *)utterance {
    [self.speechStrings addObject:utterance.speechString] ;
    [self.tableView reloadData] ;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.speechStrings.count - 1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}


- (void)sayHello {
    AVSpeechSynthesizer *synthesizer = [[AVSpeechSynthesizer alloc]init] ;
    AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc]initWithString:@"你好世界"] ;
    AVSpeechSynthesisVoice *voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
    utterance.voice = voice ;
    utterance.rate = 0.5 ; // 声速
    
    [synthesizer speakUtterance:utterance] ;
}




@end
