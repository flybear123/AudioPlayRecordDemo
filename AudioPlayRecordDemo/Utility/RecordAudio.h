//
//  RecordAudio.h
//  AudioPlayRecordDemo
//
//  Created by zx_05 on 16/3/9.
//  Copyright © 2016年 flybear_tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecordAudio : NSObject<AVAudioRecorderDelegate,AVAudioPlayerDelegate>
{
    AVAudioRecorder     *recorder;
    NSString            *filePath;

}

/*
 @description 开始录音
 @param
 @result
 */
- (void) startRecording;

/*

 @description 取消声音的录制
 @param
 @result
 */
- (void)cancelRecording;

/*

 @description 录制完成
 @param
 @result      音频路径
 */
- (NSString *)stopRecording;
@end
