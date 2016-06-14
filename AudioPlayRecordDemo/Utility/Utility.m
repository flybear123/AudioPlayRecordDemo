//
//  Utility.m
//  AudioPlayRecordDemo
//
//  Created by zx_05 on 16/3/8.
//  Copyright © 2016年 flybear_tech. All rights reserved.
//

#import "Utility.h"

@implementation Utility

//将毫秒转换为秒
+ (long long int)changeMsecToSec:(long long)timestamp
{
    NSString *timestampStr = [NSString stringWithFormat:@"%lld",timestamp];
    if (timestampStr.length > 10) {
        timestampStr = [timestampStr substringToIndex:10];
    }
    return [timestampStr longLongValue];
}

+ (NSString *)getTimeStringByTimeStemp:(double)timeStemp
{
    timeStemp = [self changeMsecToSec:timeStemp];
    
    NSString *temString = @"";
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setTimeZone:timeZone];
    
    NSDate *dat = [NSDate date];
    NSString *datStr = [dateFormatter stringFromDate:dat];
    NSArray *arr = [datStr componentsSeparatedByString:@"-"];
    NSString *tempStr = [arr objectAtIndex:0];
    int y1 = [tempStr intValue];
    tempStr = [arr objectAtIndex:1];
    int m1 = [tempStr intValue];
    tempStr = [arr objectAtIndex:2];
    int d1 = [tempStr intValue];
    
    //获取timeStemp转换的年月日
    dat = [NSDate dateWithTimeIntervalSince1970:timeStemp];
    datStr = [dateFormatter stringFromDate:dat];
    arr = [datStr componentsSeparatedByString:@"-"];
    tempStr = [arr objectAtIndex:0];
    int y2 = [tempStr intValue];
    tempStr = [arr objectAtIndex:1];
    int m2 = [tempStr intValue];
    tempStr = [arr objectAtIndex:2];
    int d2 = [tempStr intValue];
    
    //确定日期格式
    if (y1 > y2) {
        [dateFormatter setDateFormat:@"yy-MM-dd"];
    }
    else if(m1 > m2) {
        [dateFormatter setDateFormat:@"yy-MM-dd"];
    }
    else if(d1 > d2)
    {
        if (d1 - d2 == 1)
        {
            [dateFormatter setDateFormat:@"HH:mm"];
            temString = @"昨天 ";
        }
        else {
            [dateFormatter setDateFormat:@"MM-dd HH:mm"];
        }
    }
    else {
        [dateFormatter setDateFormat:@"HH:mm"];
    }
    temString = [NSString stringWithFormat:@"%@%@",temString,[dateFormatter stringFromDate:dat]];
    return temString;
}

+(NSString *)getCurrentTimeLong
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%f", a];
    return [timeString substringToIndex:13];
}

+ (int)getCurrentTimestamp
{
    NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSInteger Timestamp = a;
    return (int)Timestamp;
}
+ (NSString *)getCurrentTime
{
    int Timestamp = [self getCurrentTimestamp];
    NSString *currentTime = [self getDateByTimestamp:Timestamp type:5];
    return currentTime;
}
+ (NSString *)getDateByTimestamp:(NSInteger)timestamp type:(NSInteger)timeType
{
    if (timestamp == 0) {
        return nil;
    }
    
    NSTimeInterval time = timestamp;
    NSDate *detaildate =[NSDate dateWithTimeIntervalSince1970:(double)time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    switch (timeType)
    {
        case 0:
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            break;
            
        case 1:
            [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
            break;
            
        case 2:
            [dateFormatter setDateFormat:@"yyyy/MM/dd"];
            break;
            
        case 3:
            [dateFormatter setDateFormat:@"yyyy年MM月"];
            break;
            
        case 4:
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            break;
            
        case 5:
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            break;
            
        case 6:
            [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
            break;
            
        case 7:
            [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
            break;
            
        default:
            break;
    }
    NSString *timeString =  [dateFormatter stringFromDate:detaildate];
    return timeString;
}


+(NSString*)getAudioDir{
    NSString *userPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *audioPath = [userPath stringByAppendingPathComponent:@"audioFile"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:audioPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:audioPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return audioPath;
    
}
// 获取音频文件路径
+(NSString *)getAudioFilePath{
    NSString *audioPath = [self getAudioDir];
    NSString *timeStampLong = [self getCurrentTimeLong];
    NSString *filePath = [audioPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.caf",timeStampLong]];
    
    return filePath;
}

@end
