//
//  iFlyMSClient.m
//  jinher.app.SelfRectification
//
//  Created by admin on 2018/12/17.
//  Copyright © 2018 Jinher. All rights reserved.
//

#import "iFlyMSClient.h"
//讯飞语音合成
#import "iflyMSC/IFlyMSC.h"
#import "Definition.h"

@interface iFlyMSClient()<IFlySpeechSynthesizerDelegate>
//讯飞
@property (nonatomic, strong) IFlySpeechSynthesizer *iFlySpeechSynthesizer;

@end

@implementation iFlyMSClient

+(id)shared {
    static iFlyMSClient *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
        //Set log level
        [IFlySetting setLogFile:LVL_ALL];
        
        //Set whether to output log messages in Xcode console
        [IFlySetting showLogcat:YES];
        
        //Set the local storage path of SDK
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cachePath = [paths objectAtIndex:0];
        [IFlySetting setLogFilePath:cachePath];
        
        //Set APPID
        NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",APPID_VALUE];
        
        //Configure and initialize iflytek services.(This interface must been invoked in application:didFinishLaunchingWithOptions:)
        [IFlySpeechUtility createUtility:initString];
    });
    return shared;
}

- (void)startSynContent:(NSString *)content {
    if (content.length == 0) {
        content = @"你好，我是科大讯飞的小燕";
    }
    NSLog(@"%@",content);
    //获取语音合成单例
    _iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance];
    //设置协议委托对象
    _iFlySpeechSynthesizer.delegate = self;
    //设置合成参数
    //设置在线工作方式
    [_iFlySpeechSynthesizer setParameter:[IFlySpeechConstant TYPE_CLOUD]
                                  forKey:[IFlySpeechConstant ENGINE_TYPE]];
    //设置音量，取值范围 0~100
    [_iFlySpeechSynthesizer setParameter:@"50"
                                  forKey: [IFlySpeechConstant VOLUME]];
    //发音人，默认为”xiaoyan”，可以设置的参数列表可参考“合成发音人列表”
    [_iFlySpeechSynthesizer setParameter:@" xiaoyan "
                                  forKey: [IFlySpeechConstant VOICE_NAME]];
    //保存合成文件名，如不再需要，设置为nil或者为空表示取消，默认目录位于library/cache下
    [_iFlySpeechSynthesizer setParameter:@" tts.pcm"
                                  forKey: [IFlySpeechConstant TTS_AUDIO_PATH]];
    //启动合成会话
    [_iFlySpeechSynthesizer startSpeaking: content];
    
}

# pragma mark 讯飞代理
//IFlySpeechSynthesizerDelegate协议实现
//合成结束
- (void) onCompleted:(IFlySpeechError *) error {
     NSLog(@"合成结束-------");
}
//合成开始
- (void) onSpeakBegin {
    NSLog(@"合成开始-------");
}
//合成缓冲进度
- (void) onBufferProgress:(int) progress message:(NSString *)msg {
    
}
//合成播放进度
- (void) onSpeakProgress:(int) progress beginPos:(int)beginPos endPos:(int)endPos {
    NSLog(@"合成播放进度-------%d",progress);
}
@end
