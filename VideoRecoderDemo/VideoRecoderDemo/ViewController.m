//
//  ViewController.m
//  VideoRecoderDemo
//
//  Created by 杨晴贺 on 2017/5/20.
//  Copyright © 2017年 Silence. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController () <AVCaptureFileOutputRecordingDelegate>

@property (nonatomic,strong) AVCaptureSession *captureSession ;  // 捕捉会话
@property (nonatomic,strong) AVCaptureMovieFileOutput *captureMovieFileOutput ;  // 视频输出
@property (nonatomic,strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer ; // 相机拍摄预览图层

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.captureSession = [[AVCaptureSession alloc]init] ;
    if ([_captureSession canSetSessionPreset:AVCaptureSessionPresetHigh]) {
        [_captureSession setSessionPreset:AVCaptureSessionPresetHigh];
    }
    
    NSError *inputError ;
    [self setupSessionInputs:&inputError] ;
    [self setupSessionOutputs] ;
    self.captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.captureSession] ;
    _captureVideoPreviewLayer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 100);
    _captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill; // 填充模式
    [self.view.layer addSublayer:_captureVideoPreviewLayer];
    self.view.layer.masksToBounds = YES ;
    
    [self.captureSession startRunning] ;
}

/// 初始化 捕捉输入
- (BOOL)setupSessionInputs:(NSError **)error {
    // 添加摄像头
    AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:error] ;
    if (!videoInput)  return  NO ;
    if ([self.captureSession canAddInput:videoInput]) {
        [self.captureSession addInput:videoInput];
    }else{
        return NO ;
    }
    
    // 添加音频输入
    AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    AVCaptureDeviceInput *audioInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:error];
    if (!audioInput) return NO ;
    if ([self.captureSession canAddInput:audioInput]) {
        [self.captureSession addInput:audioInput] ;
    }else{
        return NO ;
    }
    return YES ;
}

/// 初始化 捕捉输出
- (BOOL)setupSessionOutputs{
    self.captureMovieFileOutput = [[AVCaptureMovieFileOutput alloc]init] ;
    AVCaptureConnection *captureConnection = [self.captureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
    
    // 设置录制模式
    if ([captureConnection isVideoStabilizationSupported]) {
        captureConnection.preferredVideoStabilizationMode=AVCaptureVideoStabilizationModeAuto;
    }
    
    // 将设备输出添加到会话中
    if ([self.captureSession canAddOutput:self.captureMovieFileOutput]) {
        [self.captureSession addOutput:self.captureMovieFileOutput];
    }
    return YES ;
}

- (IBAction)recordAction:(UIButton *)button {
    if (![self.captureMovieFileOutput isRecording]) {
        AVCaptureConnection *captureConnection=[self.captureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
        captureConnection.videoOrientation=[self.captureVideoPreviewLayer connection].videoOrientation;
        [self.captureMovieFileOutput startRecordingToOutputFileURL:({
            // 录制 缓存地址。
            NSURL *url = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"temp.mov"]];
            if ([[NSFileManager defaultManager] fileExistsAtPath:url.path]) {
                [[NSFileManager defaultManager] removeItemAtURL:url error:nil];
            }
            url;
        }) recordingDelegate:self];
        [button setTitle:@"暂停录制" forState:UIControlStateNormal] ;
    }else{
        [button setTitle:@"开始录制" forState:UIControlStateNormal] ;
        [self.captureMovieFileOutput stopRecording];//停止录制
    }
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error{
    [self videoCompression];
}

- (void)videoCompression {
    NSLog(@"开始") ;
    NSURL *tempURL = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"temp.mov"]];
    // 加载视频资源
    AVAsset *asset = [AVAsset assetWithURL:tempURL];
    // 创建视频导出会话
    AVAssetExportSession *session = [[AVAssetExportSession alloc]initWithAsset:asset presetName:AVAssetExportPresetMediumQuality] ;
    // 创建导出视频的URL
    session.outputURL = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"tempLow.mov"]];
    // 必须配置输出属性
    session.outputFileType = @"com.apple.quicktime-movie";
    // 导出视频
    [session exportAsynchronouslyWithCompletionHandler:^{
        NSLog(@"导出成功");
    }] ;
}



@end
