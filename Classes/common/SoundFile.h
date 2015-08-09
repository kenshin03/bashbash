//
//  SoundFile.h
//  bishibashi
//
//  Created by Kenny Tang on 4/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "LocalStorageManager.h"


@interface SoundFile : NSObject <AVAudioPlayerDelegate>{
	AVAudioPlayer* _avAudioPlayer;
	BOOL interruptedOnPlayback;
}
@property (nonatomic, retain) AVAudioPlayer *avAudioPlayer;
@property (readwrite) BOOL interruptedOnPlayback;


-(id)initWithFileName:(NSString*)name andExt:(NSString*)ext;
-(void)playSound;
-(void)playSoundOnLoop;
-(void)pauseSound;

@end
