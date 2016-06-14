//
//  ViewController.h
//  AudioPlayRecordDemo
//
//  Created by zx_05 on 16/3/8.
//  Copyright © 2016年 flybear_tech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RecordAudioView  ;
@class RecordAudio;
@class SoundPlay;
@class AudioRecordModel;
@class SendAudioCell;
@interface ViewController : UIViewController
{
    UITableView *displayTableView;
    UIView      *recordView;
    UIButton *recordBtn;
    NSArray                         *sendWaveArray;                 //发送语音图片数组
    RecordAudioView                 *recordNoteView;
    BOOL                            isSended;
    int                             recordAudioSeconds;
    NSTimer         *recordTimer;
    NSTimer                                 *processTimer;

    RecordAudio   *recordAudioInstance;
    SoundPlay                         *soundPlay;
    AudioRecordModel *recordModel;
    SendAudioCell *audioCell;//获取动画处理的cell
    
}
@property(nonatomic,strong)    NSMutableArray *dataArray;
@end

