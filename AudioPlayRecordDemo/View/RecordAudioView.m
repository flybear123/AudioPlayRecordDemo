//
//  RecordAudioView.m
//  yunyunTerminal
//
//  Created by zx_05 on 16/3/1.
//  Copyright © 2016年 ZIGSUN. All rights reserved.
//录音时的动画视图

#import "RecordAudioView.h"
#import "UIViewExt.h"
@implementation RecordAudioView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

-(void)initSubViews
{
    self.backgroundColor = [UIColor clearColor];
    
    UIView *alphaV = [[UIView alloc] initWithFrame: self.bounds];
    alphaV.backgroundColor = [UIColor blackColor];
    alphaV.alpha = 0.6;
    alphaV.layer.cornerRadius = 5.0;
    [self addSubview:alphaV];
    
    UIImage *image = [UIImage imageNamed:@"record_logo"];
    UIImage *image1 = [UIImage imageNamed:@"record_signal_1"];
    recordNote = [[UIImageView alloc] initWithFrame:CGRectMake(( self.width-image.size.width-image1.size.width)/2,
                                                               ( self.height-image.size.height-25)/2,
                                                               image.size.width,
                                                               image.size.height)];
    recordNote.image = image;
    [self addSubview: recordNote];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < 5; i++) {
        [array addObject:[UIImage imageNamed:[NSString stringWithFormat:@"record_signal_%d",i+1]]];
    }
    
    //录音时的动画
    animationNote = [[UIImageView alloc] initWithFrame:CGRectMake( recordNote.origin.x+ recordNote.width+5,
                                                                  ( self.height-image1.size.height-25)/2,
                                                                  image1.size.width,
                                                                  image1.size.height)];
    animationNote.image = image1;
    animationNote.animationImages = array;
    animationNote.animationRepeatCount = 1000000000;
    animationNote.animationDuration = 1;
    [self addSubview: animationNote];
    
    switchLab = [[UILabel alloc] initWithFrame:CGRectMake(7,  self.height-30,  self.width-14, 23)];
    switchLab.backgroundColor = [UIColor clearColor];
    switchLab.layer.cornerRadius = 4.0;
    switchLab.layer.masksToBounds = YES;
    switchLab.text = @"手指上滑，取消发送";
    switchLab.textColor = [UIColor whiteColor];
    switchLab.textAlignment = NSTextAlignmentCenter;
    switchLab.font = [UIFont systemFontOfSize:14.0];
    [self addSubview: switchLab];
    
    image = [UIImage imageNamed:@"record_cancel"];
    cancelNote = [[UIImageView alloc] initWithFrame:CGRectMake(( self.width-image.size.width)/2,
                                                               ( self.height-image.size.height-25)/2,
                                                               image.size.width,
                                                               image.size.height)];
    cancelNote.image = image;
    [self addSubview: cancelNote];
    cancelNote.hidden = YES;
}

-(void)reInitNoteViews
{
    cancelNote.hidden = YES;
    cancelNote.image = [UIImage imageNamed:@"record_cancel"];
    recordNote.hidden = NO;
    animationNote.hidden = NO;
    switchLab.text = @"手指上滑，取消发送";
    switchLab.backgroundColor = [UIColor clearColor];
    if ([ animationNote isAnimating]) {
        [ animationNote stopAnimating];
    }
}

-(void)recordingTooLong
{
    cancelNote.hidden = NO;
    cancelNote.image = [UIImage imageNamed:@"record_short"];
    recordNote.hidden = YES;
    animationNote.hidden = YES;
    switchLab.text = @"说话时间超长";
    switchLab.backgroundColor = [UIColor clearColor];
}

-(void)cancelRecordNoteInView
{
    cancelNote.hidden = YES;
    recordNote.hidden = NO;
    animationNote.hidden = NO;
    switchLab.text = @"手指上滑，取消发送";
    switchLab.backgroundColor = [UIColor clearColor];
}

-(void)cancelRecordNoteOutsideView
{
    cancelNote.hidden = NO;
    recordNote.hidden = YES;
    animationNote.hidden = YES;
    switchLab.text = @"松开手指，取消发送";
    switchLab.backgroundColor = RGBColor(152, 56, 54, 1.0);
}

-(void)recordingTooShort
{
    recordNote.hidden =YES;
    cancelNote.hidden = NO;
    cancelNote.image = [UIImage imageNamed:@"record_short"];
    animationNote.hidden = YES;
    switchLab.text = @"说话时间太短";
    switchLab.backgroundColor = [UIColor clearColor];
    
}

-(void)startAnimation
{
    [animationNote startAnimating];
}

@end
