//
//  SendAudioCell.h
//  AudioPlayRecordDemo
//
//  Created by zx_05 on 16/3/8.
//  Copyright © 2016年 flybear_tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioRecordModel.h"
@protocol SendAudioCellDelegate;
@interface SendAudioCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@property (weak, nonatomic) IBOutlet UIButton *playButton;

@property (weak, nonatomic) IBOutlet UILabel *playTimeLab;

@property (weak, nonatomic) IBOutlet UIImageView *bubbleImageView;

@property(nonatomic,strong)AudioRecordModel *audioRecordModel;

@property(nonatomic,weak)id <SendAudioCellDelegate> delegate;

+(SendAudioCell *)cellWithTableView:(UITableView*)tableView;


@end

@protocol SendAudioCellDelegate <NSObject>

-(void)clickAudioPlayOfCell:(SendAudioCell*)cell;


@end
