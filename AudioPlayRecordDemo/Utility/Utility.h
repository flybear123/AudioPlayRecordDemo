//
//  Utility.h
//  AudioPlayRecordDemo
//
//  Created by zx_05 on 16/3/8.
//  Copyright © 2016年 flybear_tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject


+ (NSString *)getTimeStringByTimeStemp:(double)timeStemp;
+ (int)getCurrentTimestamp;
+(long long int)getNowTimestamp;
// 获取音频文件路径
+(NSString*)getAudioDir;
+(NSString *)getAudioFilePath;
+ (NSString *)getCurrentTime;
+ (NSString *)getDateByTimestamp:(NSInteger)timestamp type:(NSInteger)timeType;
@end
