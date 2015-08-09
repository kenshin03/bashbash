//
//  DancingView.m
//  bishibashi
//
//  Created by Eric on 04/07/2010.
//  Copyright 2010 Red Soldier. All rights reserved.
//

#import "DancingView.h"


@implementation DancingView
@synthesize beats = _beats;
@synthesize receivedBeats = _receivedBeats;
@synthesize currentRound = _currentRound;
@synthesize theBaby = _theBaby;
@synthesize theDot = _theDot;
@synthesize totalDelta = _totalDelta;
@synthesize timeFactor = _timeFactor;
@synthesize numSeq = _numSeq;

static const CGRect backgroundRectP = {{20, 78}, {280, 315}};


- (void) initScenarios:(NSArray*)scenarios
{
	[super initScenarios:scenarios];
	if (!scenarios)
	{
		self.noRun = 8;
		/* scenario is an array of N random KBeatType */
		for (int i=0; i<self.noRun; i++)	{
			NSMutableArray* scenario = [NSMutableArray arrayWithCapacity:self.numSeq];
			for (int j=0; j<self.numSeq; j++)	{
				if (self.difficultiesLevel==kEasy || self.difficultiesLevel ==kNormal)	
					[scenario addObject:[NSNumber numberWithInt:arc4random()%2+1]];
				else
					[scenario addObject:[NSNumber numberWithInt:arc4random()%3]];
			}
			[self.scenarios addObject:scenario];
		}
	}
	if (self.remoteView){
		[self.remoteView initScenarios:self.scenarios];
	}
}

- (void) initBackground {
	[super initBackground];
	Dot* theDot = [[Dot alloc] init];
	self.theDot = theDot;
	[theDot release];
	[self addSubview:self.theDot];
	
	self.timeFactor = [[[[Constants sharedInstance] gameTimerArray] objectAtIndex:self.game] objectAtIndex:_difficultiesLevel];
	self.numSeq = 7+_difficultiesLevel;
	self.scoreFrame = CGRectMake(220, 80, 20, 20);

}

- (void) initImages {
	[super initImages];
	BigBaby* theBaby = [[BigBaby alloc] initWithFrame:backgroundRectP AndOrientation:UIInterfaceOrientationPortrait];
	self.theBaby = theBaby;
	[theBaby release];
	[self addSubview:self.theBaby];
}
	
	
	
- (void) startGame
{
	[super startGame];
	self.noRun = 8;
	self.currentRound=0;
	
	if ((self.gameType != multi_players_arcade)&& (self.gameType != multi_players_level_select)){	
		if ((!self.isRemoteView)){
			[self initScenarios:nil];
		}
	}
	[self bringSubviewToFront:self.theDot];
	[self startRound];	
	
	if (self.remoteView)
		[self.remoteView startGame];
}



- (void) startRound	{
	self.totalDelta = 0.0;
	if (self.noRun==0)	{
		[self showPlayAgain];
	}
	else {
		[super startRound];
		[self disableButtons];
		for (Beat* beat in self.beats)
			[beat removeFromSuperview];

		self.theDot.frame = CGRectMake(0, 95, self.theDot.frame.size.width, self.theDot.frame.size.height);
		[self.theDot unHide];

		NSArray* Scenario = [self.scenarios objectAtIndex:self.currentRound];
		self.beats = [NSMutableArray arrayWithCapacity:self.numSeq];
		self.receivedBeats = [NSMutableArray arrayWithCapacity:self.numSeq];
		float delay = 1.0;
		[self.theDot jumpWithContext:[NSArray arrayWithObjects:[NSNumber numberWithFloat:(float)(0)], [NSNumber numberWithFloat:(float)(25)], [NSNumber numberWithFloat:1.0], nil]];
		for (int i=0; i<self.numSeq; i++)	{
			Beat* beat;
			if (i==self.numSeq-1)
				beat = [[Beat alloc] initWithBeatType:kFinishBeat];
			else
				beat = [[Beat alloc] initWithBeatType:[[Scenario objectAtIndex:i] intValue]];
			beat.frame = CGRectMake(25+i*32, 77, beat.frame.size.width, beat.frame.size.height);
			[self addSubview:beat];
			
			[self.theDot performSelector:@selector(jumpWithContext:) withObject:[NSArray arrayWithObjects:[NSNumber numberWithFloat:(float)(15+i*32)], [NSNumber numberWithFloat:(float)(15+i*32+beat.frame.size.width)], [NSNumber numberWithFloat:[beat getTime:[self.timeFactor floatValue]]], nil] afterDelay:delay];
			[beat performSelector:@selector(show:) withObject:self.timeFactor afterDelay:delay];
			delay += [beat getTime:[self.timeFactor floatValue]];
			[self.beats addObject:beat];
			[beat release];
		}			
		[self.theDot performSelector:@selector(hide) withObject:nil afterDelay:delay];
		[self performSelector:@selector(enableButtons) withObject:nil afterDelay:delay];
	}
}	


- (void) success	{
	[self disableButtons];
	self.score += (int)([self calScore]/10.0);
	NSLog(@"score is %f", self.score);
	[sharedSoundEffectsManager playYeahSound];
	self.noRun--;
	self.currentRound++;
	
	if (self.gameType == multi_players_level_select){
		;
	}else{
		[self performSelector:@selector(startRound) withObject:nil afterDelay:1];
	}
	
	
}

- (int) calScore
{
	float factor;
	switch (_difficultiesLevel)	{
		case (kEasy):
			factor = 0.4;
			break;
		case (kNormal):
			factor = 0.6;
			break;
		case (kHard):
			factor = 0.8;
			break;
		case (kWorldClass):
			factor = 1.0;
			break;
	}
	
	float temp = [self.timeFactor floatValue]*7 - self.totalDelta;
//	NSLog(@"totalDelta is %f, temp is %f", self.totalDelta, temp);
	if(temp<0)
		temp = 0;
	return (int)((factor*125*temp)/([self.timeFactor floatValue]*7));
}


- (BeatType) findBeatType:(NSTimeInterval) interval AndConstant:(float) constant AndRange:(float) range
{
	float beat = interval / constant;
	if ((fabs(beat - 0.5)) / 0.5 <range)
		return k8Beat;
	else if (fabs(beat -1) < range)
		return k4Beat;
	else if ((fabs(beat -2)) / 2 < range)
		return k2Beat;
}

- (void) redButClicked
{
	[super redButClicked];
	[[MediaManager sharedInstance]playTapSound];
	NSTimeInterval timeDelta = - [self.roundStartTime timeIntervalSinceNow];
	NSTimeInterval stepDelta;
	if ([self.receivedBeats count] >0)	{
		NSNumber* lastTimeDelta = [self.receivedBeats objectAtIndex:[self.receivedBeats count]-1];
		stepDelta = timeDelta - [lastTimeDelta floatValue];

		BeatType theBeatType = [self findBeatType:stepDelta AndConstant:[self.timeFactor floatValue] AndRange:[self.timeFactor floatValue]];
	//	NSLog(@"stepDelta is %f", stepDelta);
		self.totalDelta += fabs(stepDelta-[[self.beats objectAtIndex:[self.receivedBeats count]-1] getTime:[self.timeFactor floatValue]]);
	//	NSLog(@"beat type is %d", theBeatType);
	//	NSLog(@"beat type should be %d", [[self.beats objectAtIndex:[self.receivedBeats count]-1] theBeatType]); 
		if (theBeatType == [[self.beats objectAtIndex:[self.receivedBeats count]-1] theBeatType])	
			[[self.beats objectAtIndex:[self.receivedBeats count]-1] showCorrect];
		else
			[[self.beats objectAtIndex:[self.receivedBeats count]-1] showInCorrect];
	}
	[self.theBaby move];
	[self.receivedBeats addObject:[NSNumber numberWithFloat:timeDelta]];
	if ([self.receivedBeats count]==self.numSeq)
		[self success];
}

- (void) blueButClicked
{
	[super blueButClicked];
	[[MediaManager sharedInstance]playTapSound];
	NSTimeInterval timeDelta = - [self.roundStartTime timeIntervalSinceNow];
	NSTimeInterval stepDelta;
	if ([self.receivedBeats count] >0)	{
		NSNumber* lastTimeDelta = [self.receivedBeats objectAtIndex:[self.receivedBeats count]-1];
		stepDelta = timeDelta - [lastTimeDelta floatValue];
		
		BeatType theBeatType = [self findBeatType:stepDelta AndConstant:[self.timeFactor floatValue] AndRange:[self.timeFactor floatValue]];
//		NSLog(@"stepDelta is %f", stepDelta);
		self.totalDelta += fabs(stepDelta-[[self.beats objectAtIndex:[self.receivedBeats count]-1] getTime:[self.timeFactor floatValue]]);
//		NSLog(@"beat type is %d", theBeatType);
//		NSLog(@"beat type should be %d", [[self.beats objectAtIndex:[self.receivedBeats count]-1] theBeatType]); 
		if (theBeatType == [[self.beats objectAtIndex:[self.receivedBeats count]-1] theBeatType])	
			[[self.beats objectAtIndex:[self.receivedBeats count]-1] showCorrect];
		else
			[[self.beats objectAtIndex:[self.receivedBeats count]-1] showInCorrect];
	}
	[self.theBaby move];	
	[self.receivedBeats addObject:[NSNumber numberWithFloat:timeDelta]];
	if ([self.receivedBeats count]==self.numSeq)
		[self success];
}

- (void) greenButClicked
{
	[super greenButClicked];
	[[MediaManager sharedInstance]playTapSound];
	NSTimeInterval timeDelta = - [self.roundStartTime timeIntervalSinceNow];
	NSTimeInterval stepDelta;
	if ([self.receivedBeats count] >0)	{
		NSNumber* lastTimeDelta = [self.receivedBeats objectAtIndex:[self.receivedBeats count]-1];
		stepDelta = timeDelta - [lastTimeDelta floatValue];
		
		BeatType theBeatType = [self findBeatType:stepDelta AndConstant:[self.timeFactor floatValue] AndRange:[self.timeFactor floatValue]];
//		NSLog(@"stepDelta is %f", stepDelta);
		self.totalDelta += fabs(stepDelta-[[self.beats objectAtIndex:[self.receivedBeats count]-1] getTime:[self.timeFactor floatValue]]);
//		NSLog(@"beat type is %d", theBeatType);
//		NSLog(@"beat type should be %d", [[self.beats objectAtIndex:[self.receivedBeats count]-1] theBeatType]); 
		if (theBeatType == [[self.beats objectAtIndex:[self.receivedBeats count]-1] theBeatType])	
			[[self.beats objectAtIndex:[self.receivedBeats count]-1] showCorrect];
		else
			[[self.beats objectAtIndex:[self.receivedBeats count]-1] showInCorrect];
	}
	[self.theBaby move];	
	[self.receivedBeats addObject:[NSNumber numberWithFloat:timeDelta]];
	if ([self.receivedBeats count]==self.numSeq)
		[self success];
}

- (void) dealloc
{
	NSLog(@"dealloc Dancing View");
	if (self.theDot)
		[NSObject cancelPreviousPerformRequestsWithTarget:self.theDot];
	self.timeFactor = nil;
	self.theDot = nil;
	self.theBaby = nil;
	self.beats = nil;
	self.receivedBeats = nil;
	[super dealloc];
}

-(NSString*) getStat
{
	return nil;
}

-(UIImage*) getStatPic
{
	return [NSArray array];
}
@end
