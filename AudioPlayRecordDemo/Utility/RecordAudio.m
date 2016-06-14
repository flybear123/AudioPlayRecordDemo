//
//  RecordAudio.m
//  AudioPlayRecordDemo
//
//  Created by zx_05 on 16/3/9.
//  Copyright © 2016年 flybear_tech. All rights reserved.
//

#import "RecordAudio.h"
#import <lame/lame.h>
@implementation RecordAudio




/*
 @description 开始录音
 @param
 @result
 */
- (void) startRecording{
    AVAudioSession *audioSession =[AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    BOOL change = [[[NSUserDefaults standardUserDefaults] objectForKey:@"arpiece"] boolValue];
    UInt32 audioRouteOverride = change?kAudioSessionOverrideAudioRoute_None:kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(audioRouteOverride), &audioRouteOverride);
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];//为啥写两遍？
    [audioSession setActive:YES error:nil];
    NSDictionary *recordSetting = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithInt:kAudioFormatLinearPCM],AVFormatIDKey,
                                   [NSNumber numberWithFloat:11025.0],AVSampleRateKey,
                                   [NSNumber numberWithInt:2],AVNumberOfChannelsKey,
                                   [NSNumber numberWithInt:AVAudioQualityMin],AVEncoderAudioQualityKey,
                                   nil];
    filePath = [Utility getAudioFilePath];
    NSURL *audioURL = [NSURL fileURLWithPath:filePath];
    recorder = [[AVAudioRecorder alloc] initWithURL:audioURL settings:recordSetting error:nil];
    if (!recorder) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"录音失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    [recorder setDelegate:self];
    recorder.meteringEnabled = YES;
    [recorder prepareToRecord];
    [recorder record];

}

/*
 
 @description 取消声音的录制
 @param
 @result
 */
- (void)cancelRecording{
    [recorder stop];
    [recorder deleteRecording];
    recorder = nil;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:NO error:nil];

}

/*
 
 @description 录制完成
 @param
 返回音频路径
 */
- (NSString *)stopRecording{
    [recorder stop];
    recorder = nil;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:NO error:nil];
    
    NSString *mp3Path = [self audioToMP3:filePath]  ;
    
    return mp3Path;
}


/** 音频转码caf转mp3*/
-(NSString *)audioToMP3:(NSString *)audioPath
{
    NSString *mp3Path;
    if ([audioPath hasSuffix:@".caf"]) {
        mp3Path = [audioPath stringByReplacingOccurrencesOfString:@".caf" withString:@".mp3"];
    } else{
        return nil;
    }
    
    @try {
        int read, write;
        
        FILE *pcm = fopen([audioPath cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
        FILE *mp3 = fopen([mp3Path cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 11025.0);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0){
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            } else {
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            }
            //转换完的音频写入到指定路径下
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        //NSLog(@"%@",[exception description]);
    }
    @finally {
        NSFileManager *fileManager=[NSFileManager defaultManager];
        [fileManager removeItemAtPath:audioPath error:nil];
        return mp3Path;
    }
    return nil;
}

#pragma mark - AVAudioRecorderDelegate
-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    NSLog(@"audioRecorderDidFinishRecording");
}

-(void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error
{
    NSLog(@"audioRecorderEncodeErrorDidOccur");
    
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@"audioPlayerDidFinishPlaying");
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    NSLog(@"audioPlayerDecodeErrorDidOccur");
}



@end
