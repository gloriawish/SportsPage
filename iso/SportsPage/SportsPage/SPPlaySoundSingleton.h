//
//  SPPlaySoundSingleton.h
//  SportsPage
//
//  Created by Qin on 2016/12/7.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface SPPlaySoundSingleton : NSObject

//为播放震动效果初始化
- (instancetype)initForPlayingVibrate;

//为播放系统音效初始化(无需提供音频文件)
- (instancetype)initForPlayingSystemSoundEffectWith:(NSString *)resourceName ofType:(NSString *)type;

//为播放特定的音频文件初始化（需提供音频文件）
- (instancetype)initForPlayingSoundEffectWith:(NSString *)filename;

//播放音效
- (void)play;

@end
