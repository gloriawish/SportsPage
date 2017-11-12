//
//  SPPlaySoundSingleton.m
//  SportsPage
//
//  Created by Qin on 2016/12/7.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPPlaySoundSingleton.h"

@implementation SPPlaySoundSingleton  {
    SystemSoundID soundID;
}

- (instancetype)initForPlayingVibrate {
    self = [super init];
    if (self) {
        soundID = kSystemSoundID_Vibrate;
    }
    return self;
}

- (instancetype)initForPlayingSystemSoundEffectWith:(NSString *)resourceName ofType:(NSString *)type {
    self = [super init];
    if (self) {
        NSString *path = [[NSBundle bundleWithIdentifier:@"com.apple.UIKit"] pathForResource:resourceName ofType:type];
        if (path) {
            SystemSoundID theSoundID;
            OSStatus error =  AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &theSoundID);
            if (error == kAudioServicesNoError) {
                soundID = theSoundID;
            } else {
                NSLog(@"Failed to create sound ");
            }
        }
    }
    return self;
}

- (instancetype)initForPlayingSoundEffectWith:(NSString *)filename {
    self = [super init];
    if (self) {
        NSURL *fileURL = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
        if (fileURL != nil) {
            SystemSoundID theSoundID;
            OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)fileURL, &theSoundID);
            if (error == kAudioServicesNoError) {
                soundID = theSoundID;
            } else {
                NSLog(@"Failed to create sound ");
            }
        }
    }
    return self;
}

- (void)play {
    AudioServicesPlaySystemSound(soundID);
}

- (void)dealloc {
    AudioServicesDisposeSystemSoundID(soundID);
}

@end
