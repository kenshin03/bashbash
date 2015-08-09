//
//  SoundEffect.m
//  bishibashi
//
//  Created by Kenny Tang on 4/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SoundEffect.h"
@implementation SoundEffect

-(void)play {
	if (![LocalStorageManager boolForKey:SOUNDOFF]){
		AudioServicesPlaySystemSound(ssId);	
	}
}

-(id)initWithFileName:(NSString*)name andExt:(NSString*)ext {
	if (![super init])
		return nil;
	// NSLog(@"initWithFileName: %@.%@", name, ext);
	// Get path inside appl bundle
	NSString *resPath = [[NSBundle mainBundle] pathForResource:name ofType:ext];
	if (resPath == nil) {
		NSLog(@"resPath = nil");
		return nil;
	}
	// NSLog(@"resPath = %@", resPath);
	NSURL *myURLRef = [NSURL fileURLWithPath:resPath isDirectory:NO];
	// NSLog(@"myURLRef = %@", myURLRef);
	OSStatus ossCode = AudioServicesCreateSystemSoundID ((CFURLRef)myURLRef, &ssId);
	if (ossCode) {
		NSLog(@"ossCode = %X", ossCode);
		return nil;
	}
	return self;
}

-(void)dealloc {
	OSStatus ossCode = AudioServicesDisposeSystemSoundID (ssId);
	if (ossCode)
		NSLog(@"dealloc: ssId ossCode = %X", ossCode);
	[super dealloc];
}
@end