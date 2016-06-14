//
//  SoundPlay.h
//  AudioPlayRecordDemo
//
//  Created by zx_05 on 16/3/9.
//  Copyright © 2016年 flybear_tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SoundPlay : NSObject<AVAudioPlayerDelegate>
{
    AVAudioPlayer *audioPlayer;

}

/** 单例*/
+ (id)instance;

/** 是否正在播放*/
- (BOOL)isPlaying;

/** 播放*/
- (void)play;

/** 暂停*/
- (void)pause;

/** 停止播放*/
- (void)stopSound;

/** 播放某路径下的文件*/
- (void)playSoundBy:(NSString *)filePath;

/** 获取当前播放文件的路径*/
- (NSString *)getCurrentPlayFilePath;


@end
