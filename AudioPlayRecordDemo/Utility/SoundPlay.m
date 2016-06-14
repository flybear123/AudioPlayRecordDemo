//
//  SoundPlay.m
//  AudioPlayRecordDemo
//
//  Created by zx_05 on 16/3/9.
//  Copyright © 2016年 flybear_tech. All rights reserved.
//

#import "SoundPlay.h"

static SoundPlay *soundPlay = nil;

@implementation SoundPlay

/** 单例*/
+ (id)instance{
    if (!soundPlay) {
        soundPlay = [[SoundPlay alloc]init];
    }
    return soundPlay;
}

/** 是否正在播放*/
- (BOOL)isPlaying{

    return audioPlayer.isPlaying;
}

/** 播放*/
- (void)play{
    if ([audioPlayer prepareToPlay]) {
        [audioPlayer play];
    }

}

/** 暂停*/
- (void)pause{
    if ([audioPlayer isPlaying]) {
        [audioPlayer pause];
    }

}

/** 停止播放*/
- (void)stopSound{
    if ([audioPlayer isPlaying]) {
        [audioPlayer stop];
    }

}

/** 播放某路径下的文件*/
- (void)playSoundBy:(NSString *)filePath{
    if (audioPlayer) {
        [self stopSound];
        audioPlayer = nil;
    }
    NSURL *fileURL = [[NSURL alloc]initFileURLWithPath:filePath];
    NSError *error;
    audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:fileURL error:&error];
    audioPlayer.delegate = self;
    audioPlayer.numberOfLoops  = 0;
    audioPlayer.volume = 1.0;
    if ([audioPlayer prepareToPlay]) {
        [audioPlayer play];
    }

}

/** 获取当前播放文件的路径*/
- (NSString *)getCurrentPlayFilePath{

    if (audioPlayer) {
        return [[audioPlayer url] absoluteString];
    }
    return nil;
}
#pragma mark --AVAudioPlayerDelegate
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[audioPlayer.url absoluteString] forKey:@"filePath"];
    [[NSNotificationCenter defaultCenter] postNotificationName:SOUNDPLAYFINISH object:nil userInfo:userInfo];

}


@end
