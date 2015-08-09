//
//  SoundFile.m
//  bishibashi
//
//  Created by Kenny Tang on 4/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "Constants.h"
#import "SoundFile.h"

@implementation SoundFile

@synthesize avAudioPlayer = _avAudioPlayer;

@synthesize interruptedOnPlayback;

-(void)playSound{
	if (![LocalStorageManager boolForKey:MUSIC_OFF]){
		[self.avAudioPlayer play];
	}
}

-(void)playSoundOnLoop{
	if (![LocalStorageManager boolForKey:MUSIC_OFF]){
		[self.avAudioPlayer setNumberOfLoops:-1];
		[self.avAudioPlayer play];
	}
}

-(void)pauseSound{
	[self.avAudioPlayer pause];
}

-(void)stopSound{
	[self.avAudioPlayer stop];
}


-(id)initWithFileName:(NSString*)name andExt:(NSString*)ext{
	if (![super init]){
		return nil;
	}
	NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:name ofType:ext];
	if (soundFilePath == nil) {
		NSLog(@"soundFilePath = nil");
		return nil;
	}
	NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
	AVAudioPlayer *newPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: fileURL error: nil];
	[fileURL release];
	self.avAudioPlayer = newPlayer;
	[newPlayer release];	
	
	[self.avAudioPlayer setDelegate:self];
	[self.avAudioPlayer prepareToPlay];
	[self.avAudioPlayer setVolume:0.3];
	return self;
}


#pragma mark AV Foundation delegate methods____________

- (void) audioPlayerDidFinishPlaying: (AVAudioPlayer *) appSoundPlayer successfully: (BOOL) flag {
		// nothing to do
}

- (void) audioPlayerBeginInterruption: player {
	
	NSLog (@"Interrupted. The system has paused audio playback.");
	interruptedOnPlayback = YES;
}

- (void) audioPlayerEndInterruption: player {
	
	NSLog (@"Interruption ended. Resuming audio playback.");
	
	// Reactivates the audio session, whether or not audio was playing
	//		when the interruption arrived.
	
	if (interruptedOnPlayback) {
		[self.avAudioPlayer prepareToPlay];
		[self.avAudioPlayer play];
		interruptedOnPlayback = NO;
	}
}



-(void)dealloc {
	self.avAudioPlayer = nil;
	[super dealloc];
}
@end