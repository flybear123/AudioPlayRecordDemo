//
//  AudioRecordModel.h
//  AudioPlayRecordDemo
//
//  Created by zx_05 on 16/3/8.
//  Copyright © 2016年 flybear_tech. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface AudioRecordModel : JKDBModel
{
    

}

//消息发送时间
@property(nonatomic,assign)unsigned int infoTime;
//录音时长
@property(nonatomic,assign) int fileLength;

/** 文件路径（录音、） */
@property (nonatomic,copy) NSString *filePath;


#pragma mark - 数据库中不需要创建的字段
/** 文件数据流（录音） */
@property (nonatomic,retain) NSData *fileData;


- (id)initWithPropertiesDictionary:(NSDictionary *)dic;
- (NSDictionary *)getPropertiesNameAndValueDictionary;
+(NSArray *)transients;
@end
