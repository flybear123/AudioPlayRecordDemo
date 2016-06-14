//
//  RecordAudioView.h
//  yunyunTerminal
//
//  Created by zx_05 on 16/3/1.
//  Copyright © 2016年 
//

#import <UIKit/UIKit.h>

@interface RecordAudioView : UIView
{
    UIImageView     *recordNote;//录制提示image
    UIImageView     *cancelNote;//取消提示image
    UIImageView     *animationNote;//动画提示image
    UILabel         *switchLab;//切换label

}
/**
 录制时间过长
 */
-(void)recordingTooLong;

/**
    重新初始化视图
 */
-(void)reInitNoteViews;
/**
 视图内停止触摸取消录制
 */
-(void)cancelRecordNoteInView;
/**
 视图外停止触摸取消录制
 */
-(void)cancelRecordNoteOutsideView;
/**
 录制时间过短
 */
-(void)recordingTooShort;
/**
 录制动画开始
 */
-(void)startAnimation;

@end
