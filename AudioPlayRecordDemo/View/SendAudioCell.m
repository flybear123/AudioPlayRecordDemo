//
//  SendAudioCell.m
//  AudioPlayRecordDemo
//
//  Created by zx_05 on 16/3/8.
//  Copyright © 2016年 flybear_tech. All rights reserved.
//

#import "SendAudioCell.h"
#import "AudioRecordModel.h"
@implementation SendAudioCell

- (void)awakeFromNib {
    // Initialization code
}

//-(void)setAudioRecordModel:(AudioRecordModel *)audioRecordModel{
//    if (_audioRecordModel != audioRecordModel) {
//        _audioRecordModel = [audioRecordModel copy];
//    }
//    
//}

+(SendAudioCell *)cellWithTableView:(UITableView*)tableView{
    static NSString *ID = @"displayCell";
    SendAudioCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle]  loadNibNamed:@"SendAudioCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

- (IBAction)playAudio:(id)sender {
    if ([self.delegate respondsToSelector:@selector(clickAudioPlayOfCell:)]) {
        [self.delegate clickAudioPlayOfCell:self];
    }
    
}



@end
