//
//  ViewController.m
//  LearnOpenGLES--VideoOutPut
//
//  Created by LuckyPan on 2020/4/21.
//  Copyright © 2020 潘伟建. All rights reserved.
//

#import "ViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import "PJEAGLView.h"

@interface PJImagePickerController : UIImagePickerController

@end

@implementation PJImagePickerController

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

@end

@interface ViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,AVPlayerItemOutputPullDelegate>
{
    AVPlayer *_player;
    CADisplayLink *_link;
    AVPlayerItemVideoOutput *_videoOutPut;
    dispatch_queue_t _myVideoOutputQueue;
}

@property(nonatomic, strong) AVPlayerLayer *playerLayer;

@property(nonatomic, strong) PJEAGLView * playerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _playerView = [[PJEAGLView alloc] initWithFrame:self.view.bounds];
    _playerView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_playerView];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 100, 30);
    [btn setTitle:@"选择视频" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(jumpImageVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    
    _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkAction:)];
    [_link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [_link setPaused:YES];
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord
             withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker
                   error:nil];
    
    NSDictionary *pixBuffAttributes = @{(id)kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange)};
    _videoOutPut = [[AVPlayerItemVideoOutput alloc] initWithPixelBufferAttributes:pixBuffAttributes];
    _myVideoOutputQueue = dispatch_queue_create("myVideoOutputQueue", DISPATCH_QUEUE_SERIAL);
    [_videoOutPut setDelegate:self queue:_myVideoOutputQueue];
    
}

#pragma mark - AVPlayerItemOutputPullDelegate

- (void)outputMediaDataWillChange:(AVPlayerItemOutput *)sender
{
    // Restart display link.
    [_link setPaused:NO];
}

-(void)displayLinkAction:(CADisplayLink *)link
{
//    CMTime outputItemTime = kCMTimeInvalid;
//    CFTimeInterval nextSync = link.timestamp + link.duration;
//    //根据下一帧屏幕刷新的时间转换成 _videoOutPut 对应的播放时间
//    outputItemTime = [_videoOutPut itemTimeForHostTime:nextSync];
//    if ([_videoOutPut hasNewPixelBufferForItemTime:outputItemTime]) {
//        //判断对应的outputItemTime是否有可用的像素信息
//        CVPixelBufferRef pixelBuffer = [_videoOutPut copyPixelBufferForItemTime:outputItemTime itemTimeForDisplay:NULL];
//        [self.playerView displayPixelBuffer:pixelBuffer];
//        if (pixelBuffer != NULL) {
//            CFRelease(pixelBuffer);
//        }
//    }
    CMTime outputTime = kCMTimeInvalid;
    CFTimeInterval nextSync = link.timestamp + link.duration;
    outputTime = [_videoOutPut itemTimeForHostTime:nextSync];
    if ([_videoOutPut hasNewPixelBufferForItemTime:outputTime]) {
        CVPixelBufferRef pixbuffer = [_videoOutPut copyPixelBufferForItemTime:outputTime itemTimeForDisplay:NULL];
//        [self.playerView displayPixelBuffer:pixbuffer];
        [self.playerView displayPixelBuffers:pixbuffer];
        if (pixbuffer != NULL) {
            CFRelease(pixbuffer);
        }
    }
}

-(void)jumpImageVC
{
    PJImagePickerController * videoPicker = [[PJImagePickerController alloc] init];
    videoPicker.delegate = self;
    videoPicker.modalPresentationStyle = UIModalPresentationCurrentContext;
    videoPicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    videoPicker.mediaTypes = @[(NSString*)kUTTypeMovie];
    [self presentViewController:videoPicker animated:YES completion:nil];
}

#pragma mark -- UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    if (info[UIImagePickerControllerMediaURL]) {
        NSURL * url = info[UIImagePickerControllerMediaURL];
        AVPlayerItem * item = [AVPlayerItem playerItemWithURL:url];
        [item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        [item addOutput:_videoOutPut];
        _player = [AVPlayer playerWithPlayerItem:item];
        //        AVPlayerLayer * playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
        //        playerLayer.frame = self.view.bounds;
        //        [self.view.layer addSublayer:playerLayer];
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    AVPlayerItem * avplayeritem = (AVPlayerItem *)object;
    
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status = [[change objectForKey:@"new"] intValue];
        if (status == AVPlayerStatusReadyToPlay) {
            NSLog(@"准备好播放");
            self.playerView.presentationRect = [[_player currentItem] presentationSize];
            CMTime duration = avplayeritem.duration;
            NSLog(@"视频总时长:%.2f",CMTimeGetSeconds(duration));//总时长
            [_videoOutPut requestNotificationOfMediaDataChangeWithAdvanceInterval:0.03];
            // 播放
            [_player play];
        }else if (status == AVPlayerStatusFailed){
            NSLog(@"视频准备发生错误");
        }else{
            NSLog(@"位置错误");
        }
    }
}


@end
