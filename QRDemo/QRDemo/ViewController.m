//
//  ViewController.m
//  QRDemo
//
//  Created by 杨晴贺 on 2017/5/20.
//  Copyright © 2017年 Silence. All rights reserved.
//

#import "ViewController.h"
#import <CoreImage/CoreImage.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *captureView;

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *arr = [CIFilter filterNamesInCategory:kCICategoryBlur];
    NSLog(@"%@",arr);
}

- (IBAction)createQR:(id)sender {
    // 实例化二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 恢复滤镜默认值,滤镜可能保存上一次的属性
    [filter setDefaults];
    // 将字符转化为NSData
    NSData *data = [@"http://www.playcode.cc" dataUsingEncoding:NSUTF8StringEncoding];
    // 通过KVO
    [filter setValue:data forKey:@"inputMessage"];
    // 生成二维码
    CIImage*outputImage = [filter outputImage];
    UIImage *image = [UIImage imageWithCIImage:outputImage];
    // 设置生成好得二维码到ImageView上
    self.imageView.image = image ;
}

- (IBAction)QR:(id)sender {
    // 1. 实例化拍摄设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // 2. 设置输入设备
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    
    // 3. 设置元数据输出
    // 3.1 实例化拍摄元数据输出
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    // 3.3 设置输出数据代理
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // 4. 添加拍摄会话
    // 4.1 实例化拍摄会话
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    // 4.2 添加会话输入
    [session addInput:input];
    // 4.3 添加会话输出
    [session addOutput:output];
    // 4.3 设置输出数据类型，需要将元数据输出添加到会话后，才能指定元数据类型，否则会报错
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    
    self.session = session;
    
    // 5. 视频预览图层
    // 5.1 实例化预览图层, 传递_session是为了告诉图层将来显示什么内容
    AVCaptureVideoPreviewLayer *preview = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    
    preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    preview.frame = self.captureView.bounds;
    // 5.2 将图层插入当前视图
    [self.captureView.layer insertSublayer:preview atIndex:100];
    
    self.previewLayer = preview;
    
    // 6. 启动会话
    [_session startRunning];
}


- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    // 会频繁的扫描，调用代理方法
    // 1. 如果扫描完成，停止会话
    [self.session stopRunning];
    // 2. 删除预览图层
    [self.previewLayer removeFromSuperlayer];
    
    NSLog(@"%@", metadataObjects);
    // 3. 设置界面显示扫描结果
    
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        // 提示：如果需要对url或者名片等信息进行扫描，可以在此进行扩展！
        NSLog(@"%@", obj.stringValue);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:obj.stringValue]] ;
    }
}


@end
