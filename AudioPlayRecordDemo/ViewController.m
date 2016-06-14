//
//  ViewController.m
//  AudioPlayRecordDemo
//
//  Created by zx_05 on 16/3/8.
//  Copyright © 2016年 flybear_tech. All rights reserved.
//

#import "ViewController.h"
#import "SendAudioCell.h"
#import "RecordAudioView.h"
#import "AudioRecordModel.h"
#import "RecordAudio.h"
#import "SoundPlay.h"
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,SendAudioCellDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataArray = [[NSMutableArray alloc]init];
    [self initTableView];
    [self initRecordView];
    [self initSoundPlay];
 
    //[self initData];
    if (!recordModel) {
        recordModel = [[AudioRecordModel alloc]  init];
    }
    sendWaveArray = [[NSArray alloc] initWithObjects:
                     [UIImage imageNamed:@"chatgroup_audio_send_wave1"],
                     [UIImage imageNamed:@"chatgroup_audio_send_wave2"],
                     [UIImage imageNamed:@"chatgroup_audio_send_wave3"],nil];
}
-(void)initTableView{
    displayTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-50) style:UITableViewStylePlain];
    displayTableView.delegate = self;
    displayTableView.dataSource = self;
    [displayTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:displayTableView];
}
-(void)initRecordView{
    recordBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kWidth, 50)];
    recordBtn.layer.cornerRadius = 4.0;
    recordBtn.layer.masksToBounds = YES;
    recordBtn.layer.borderColor =RGBColor(207, 207, 207, 1.0).CGColor;
    recordBtn.layer.borderWidth = 0.5;
    [recordBtn setTitle:@"按住 说话" forState:UIControlStateNormal];
    [recordBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    recordView =[[UIView alloc]initWithFrame:CGRectMake(0, kHeight-50, kWidth, 50)];
    recordView.backgroundColor = [UIColor whiteColor]   ;
    [recordView addSubview:recordBtn];
    [self.view addSubview:recordView];
    
    UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(pressToRecord:)];
    press.minimumPressDuration= 0.1;
    [recordView addGestureRecognizer:press];
    
    [self initRecordNoteView];

}
-(void)initSoundPlay{

    soundPlay = [SoundPlay instance];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(stopTimerNotification:)
                                                 name:SOUNDPLAYFINISH
                                               object:nil];
}

-(void)initRecordNoteView{
    recordNoteView = [[RecordAudioView alloc]initWithFrame:CGRectMake(kWidth/2-150/2,( kHeight-64)/2-150/2, 150, 150)];
    recordNoteView.hidden = YES;
    [self.view addSubview:recordNoteView];
    
    
}

-(void)initData{
    
}

-(void)pressToRecord:(UILongPressGestureRecognizer*)press
{
    CGPoint touchPoint = [press locationInView:recordView];
    if (press.state ==  UIGestureRecognizerStateBegan) {
        if (CGRectContainsPoint(recordBtn.frame, touchPoint) == YES) {
            [recordNoteView startAnimation];
            recordNoteView.hidden = NO;
            recordBtn.backgroundColor =  RGBColor(215, 215, 215, 1.0);
            [recordBtn setTitle:@"松开 结束" forState:UIControlStateNormal];
            isSended = NO;
            [self beginRecord];
        }
    }
    if (press.state == UIGestureRecognizerStateEnded)
    {
        if (CGRectContainsPoint(recordBtn.frame, touchPoint) == YES)
        {
            if (recordAudioSeconds < 1)
            {
                [recordNoteView recordingTooShort];
                recordBtn.backgroundColor = [UIColor whiteColor];
                [recordBtn setTitle:@"按住 说话" forState:UIControlStateNormal];
                
                [self cancelRecord];
                dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC));
                dispatch_after(time, dispatch_get_main_queue(), ^{
                    recordNoteView.hidden = YES;
                    [self restoreNoteViews];
                });
                return;
            }
            if (!isSended)
            {
                dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC));
                dispatch_after(time, dispatch_get_main_queue(), ^{
                    [self sendAudioRecord];
                });
            }
        }
        else {
            [self cancelRecord];
        }
        [self restoreNoteViews];
    }
    if (press.state == UIGestureRecognizerStateChanged)
    {
        if (CGRectContainsPoint(recordBtn.frame, touchPoint) == YES)
        {
            [recordNoteView cancelRecordNoteInView];
            recordBtn.backgroundColor = RGBColor(215, 215, 215, 1.0);
            [recordBtn setTitle:@"松开 结束" forState:UIControlStateNormal];
        }
        else
        {
            [recordNoteView cancelRecordNoteOutsideView];
            recordBtn.backgroundColor = [UIColor whiteColor];
            [recordBtn setTitle:@"按住 说话" forState:UIControlStateNormal];
        }
    }
    
}


-(void)beginRecord{
    if (!recordAudioInstance)
        recordAudioInstance  = [[RecordAudio alloc]init];
    [recordAudioInstance cancelRecording];
    [recordAudioInstance startRecording];
    
    if (recordTimer) {
        [recordTimer invalidate];
        recordTimer = nil;
    }
    recordAudioSeconds = 0;
    recordTimer =[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(recordSecond) userInfo:nil repeats:YES];
}
-(void)cancelRecord{
    if (recordTimer) {
        [recordTimer invalidate];
        recordTimer = nil;
    }
    if (recordAudioInstance) {
        [recordAudioInstance cancelRecording];
    }

}

//计时器
-(void)recordSecond
{
    if (recordAudioSeconds > 59)
    {
        [recordNoteView recordingTooLong];
        recordBtn.backgroundColor = [UIColor whiteColor];
        [recordBtn setTitle:@"按住 说话" forState:UIControlStateNormal];
        
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC));
        dispatch_after(time, dispatch_get_main_queue(), ^{
            [self restoreNoteViews];
            [self sendAudioRecord];
        });
        return;
    }
    recordAudioSeconds ++;
}

//发送语音文件
- (void)sendAudioRecord{
    isSended = YES;
    if (recordTimer) {
        [recordTimer invalidate];
        recordTimer = nil;
    }
    if (!recordAudioInstance) {
        return;
    }
    NSString *recordFilePath = [recordAudioInstance stopRecording];
    //将音频存储，点击对应音频可以播放
    AudioRecordModel *model1 = [[AudioRecordModel alloc] init];
    model1.fileLength = recordAudioSeconds;
    model1.filePath = recordFilePath;
    model1.infoTime = [Utility getCurrentTimestamp];
    [self.dataArray addObject:model1];
    [displayTableView reloadData];
}

-(void)restoreNoteViews{
    recordBtn.backgroundColor = [UIColor whiteColor];
    [recordBtn setTitle:@"按住 说话" forState:UIControlStateNormal];
    recordNoteView.hidden = YES;
    [recordNoteView reInitNoteViews];
}

#pragma mark --UItableview Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AudioRecordModel *model = [self.dataArray objectAtIndex:indexPath.row];
    SendAudioCell *cell = [SendAudioCell cellWithTableView:tableView];
    cell.audioRecordModel = model;
    cell.delegate = self;
    cell.tag = indexPath.row;
    cell.timeLab.text = [NSString stringWithFormat:@"%@",[Utility getDateByTimestamp:model.infoTime type:5]] ;
    cell.playTimeLab.text = [NSString stringWithFormat:@"%d'",model.fileLength];
    return cell;
}


#pragma mark --SendAudioCellDelegate
-(void)clickAudioPlayOfCell:(SendAudioCell *)cell{
    //设置红外感应，用于切换音频话筒模式和外音模式
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    if ([UIDevice currentDevice].proximityMonitoringEnabled == YES) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sensorStateChange:) name:UIDeviceProximityStateDidChangeNotification object:nil];
    }
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_None;
    AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(audioRouteOverride), &audioRouteOverride);
    [audioSession setActive:YES error:nil];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    if ([soundPlay isPlaying]&&[self soundPlayThisAudio]) {
        [soundPlay stopSound];
        [self stopTimer];
        [cell.bubbleImageView stopAnimating];
        cell.bubbleImageView.image = [UIImage imageNamed:@"chatgroup_audio_send_wave3"];
    }
    else{
        NSString *playSoundFilePath = [[NSString alloc]initWithString:cell.audioRecordModel.filePath];
        [soundPlay playSoundBy:playSoundFilePath];
        
        processTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(process:) userInfo:nil repeats:YES];
        audioCell =(SendAudioCell*) [cell viewWithTag:cell.tag];
        cell.bubbleImageView.animationDuration = 1.0;
        cell.bubbleImageView.animationRepeatCount = 0;
        cell.bubbleImageView.animationImages = sendWaveArray;
        [cell.bubbleImageView startAnimating];
        recordModel.filePath = cell.audioRecordModel.filePath;
        
    }

    
}

-(void)sensorStateChange:(NSNotificationCenter *)notification{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if ([[UIDevice currentDevice] proximityState]== YES) {//听筒
        UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_None;
        AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(audioRouteOverride), &audioRouteOverride);
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        [audioSession setActive:YES error:nil];
    }
    else{// 扬声器
        UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
        AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(audioRouteOverride), &audioRouteOverride);
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        [audioSession setActive:YES error:nil];
    }

}


/** 是否播放的是同一个文件*/
- (BOOL)soundPlayThisAudio
{
    NSString *audioTpStr = nil;
    audioTpStr = [self getFilePath:@".mp3"];

    //判断播放的是否为同一个文件
    if ([[NSString stringWithFormat:@"file://%@", audioTpStr] isEqualToString:[soundPlay getCurrentPlayFilePath]]) {
        return YES;
    }
    else  {
        return NO;
    }
    return YES;
}

/** 判断文件是否存在 返回正确的文件路径*/
-(NSString *)getFilePath:(NSString*)suffix
{
    NSString *tpStr = recordModel.filePath;
    NSString *docStr = nil;

    docStr = [Utility getAudioDir];

    NSFileManager *filemanage = [NSFileManager defaultManager];
    if (![filemanage fileExistsAtPath:tpStr]) {//判断该文件是否存在 有可能document前面的机器码改变 而导致文件取不到
        NSArray *arr = [tpStr componentsSeparatedByString:@"/"];
        if ([arr count]>0) {
            NSString *fileName = [arr lastObject];
            if ([fileName hasSuffix:suffix]) {
                tpStr = [NSString stringWithFormat:@"%@/%@",docStr,fileName];
            }
        }
    }
    return tpStr;
}

-(void)process:(NSTimer*)timer{
    if ([self soundPlayThisAudio]) {
        
    }
    else{
        [self stopTimer];
        
    }

}
/** 停止播放计时器，还原语音初始视图*/
- (void)stopTimer
{
    if (processTimer)
    {
        [processTimer invalidate];
        processTimer = nil;
        if ([audioCell.bubbleImageView isAnimating]) {
            [audioCell.bubbleImageView stopAnimating];
        }
            audioCell.bubbleImageView.image = [UIImage imageNamed:@"chatgroup_audio_send_wave3"];

    }
}

#pragma mark --SOUNDPLAYNOTIFICATION
-(void)stopTimerNotification:(NSNotification*)notification{
    if ([self soundPlayThisAudio])
    {
        [self stopTimer];
        
        //播放完毕取消通知
        [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
        if ([UIDevice currentDevice].proximityMonitoringEnabled == YES) {
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceProximityStateDidChangeNotification object:nil];
        }
    }
    
}

@end
