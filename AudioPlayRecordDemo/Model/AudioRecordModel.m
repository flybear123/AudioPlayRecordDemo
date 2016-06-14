//
//  AudioRecordModel.m
//  AudioPlayRecordDemo
//
//  Created by zx_05 on 16/3/8.
//  Copyright © 2016年 flybear_tech. All rights reserved.
//

#import "AudioRecordModel.h"


@implementation AudioRecordModel

- (id)initWithPropertiesDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        if (dic != nil) {
            self.fileLength  = [[dic objectForKey:@"fileLength"] intValue];
            self.filePath = [dic objectForKey:@"filePath"]  ;
            NSString *time = [dic objectForKey:@"infoTime"];
            if ([time length] >=13) {
                time = [time substringToIndex:10];
            }
            self.infoTime = [time intValue];
        }
    }
    return self;
}

- (NSDictionary *)getPropertiesNameAndValueDictionary
{
    NSMutableDictionary *retDic = [[NSMutableDictionary alloc] init];
    [retDic setObject:[NSNumber numberWithInt:self.fileLength] forKey:@"fileLength"];
    [retDic setObject:[self getString:self.filePath] forKey:@"filePath"];
    [retDic setObject:[NSNumber numberWithUnsignedInt:self.infoTime] forKey:@"infoTime"];
                            
    return retDic;
}

-(NSString*)getString:(NSString*)_string
{
    if ([_string length]>0) {
        return _string;
    }else{
        return @"";
    }
}
+(NSArray *)transients
{
    return [NSArray arrayWithObjects:@"fileData",nil];
}

@end
