//
//  DancingInstructionView.m
//  bishibashi
//
//  Created by Eric on 10/07/2010.
//  Copyright 2010 Red Soldier. All rights reserved.
//

#import "DancingInstructionView.h"


@implementation DancingInstructionView
@synthesize beats = _beats;
@synthesize theBaby = _theBaby;
@synthesize theDot = _theDot;

static const CGRect backgroundRectP = {{0, 0}, {240, 260}};
static const float beatYOffset = 0;

- (void) initScenarios
{
	NSLog(@"initScenarios");
	[super initScenarios];
	[self.scenarios removeAllObjects];
	_numSeq = 7;
	_timeFactor = 1.0;
	_totalDelay = 0.0;
	_currentBeat = 0;
	/* scenario is an array of N random KBeatType */
	NSMutableArray* scenario = [NSMutableArray arrayWithCapacity:_numSeq];
	for (int j=0; j<_numSeq; j++)	{
			[scenario addObject:[NSNumber numberWithInt:arc4random()%2+1]];
	}
	[self.scenarios addObject:scenario];
}

- (void) initImages {
	[super initImages];
	BigBaby* theBaby = [[BigBaby alloc] initWithFrame:backgroundRectP AndOrientation:11];
	self.theBaby = theBaby;
	[theBaby release];
	[self addSubview:self.theBaby];
	Dot* theDot = [[Dot alloc] init];
	self.theDot = theDot;
	[theDot release];
	[self addSubview:self.theDot];
	
}

- (void) startScenarios
{
	NSLog(@"startScenarios");

	[self startRound];
	NSArray* scenario = [self.scenarios objectAtIndex:0];
	_totalDelay += 1.0;
	_currentBeat = 0;
//	NSLog(@"in start Scen current seq is %d", _currentBeat);
	[self performSelector:@selector(redButClicked) withObject:nil afterDelay:_totalDelay];
//	NSLog(@"in start Scen current seq is %d", _currentBeat);
	for (int i=0; i<_numSeq-1; i++)	{
		Beat* beat = [[Beat alloc] initWithBeatType:[[scenario objectAtIndex:i] intValue]];
		_totalDelay += [beat getTime:_timeFactor];
		[beat release];
		[self performSelector:@selector(redButClicked) withObject:nil afterDelay:_totalDelay];
	}
}




- (void) startRound	{
//		NSLog(@"startRound");
		self.theDot.frame = CGRectMake(0, 10, self.theDot.frame.size.width, self.theDot.frame.size.height);
		[self.theDot unHide];
		
		NSArray* Scenario = [self.scenarios objectAtIndex:0];
		self.beats = [NSMutableArray arrayWithCapacity:_numSeq];
		float delay = 1.0;
		[self.theDot jumpWithContext:[NSArray arrayWithObjects:[NSNumber numberWithFloat:(float)(0)], [NSNumber numberWithFloat:(float)(25)], [NSNumber numberWithFloat:1.0], nil]];
		for (int i=0; i<_numSeq; i++)	{
//			NSLog(@"i is %d beat Types is %d", i, [[Scenario objectAtIndex:i] intValue]);
//			NSLog(@"current seq is %d", _currentBeat);

			Beat* beat;
			if (i==_numSeq-1)
				beat = [[Beat alloc] initWithBeatType:kFinishBeat];
			else
				beat = [[Beat alloc] initWithBeatType:[[Scenario objectAtIndex:i] intValue]];
			beat.frame = CGRectMake(25+i*32, beatYOffset, beat.frame.size.width, beat.frame.size.height);
			[self addSubview:beat];
			
			[self.theDot performSelector:@selector(jumpWithContext:) withObject:[NSArray arrayWithObjects:[NSNumber numberWithFloat:(float)(25+i*32)], [NSNumber numberWithFloat:(float)(25+i*32+beat.frame.size.width)], [NSNumber numberWithFloat:[beat getTime:_timeFactor]], nil] afterDelay:delay];
			[beat performSelector:@selector(show:) withObject:[NSNumber numberWithFloat:[beat getTime:_timeFactor]] afterDelay:delay];
			delay += [beat getTime:_timeFactor];
			[self.beats addObject:beat];
			[beat release];
		}			
		[self.theDot performSelector:@selector(hide) withObject:nil afterDelay:delay];
	
		_totalDelay = delay;
}	


- (void) success	{
	_roundNo++;
	[sharedSoundEffectsManager playYeahSound];
	for (Beat* beat in self.beats)	{
		[beat removeFromSuperview];
	}
	
	if (_roundNo<2)	{
		[self initScenarios];
		[self startScenarios];
	}
}


- (void) redButClicked
{
	[super redButClicked];
	[[MediaManager sharedInstance]playTapSound];
//	NSLog(@"current seq is %d", _currentBeat);
	if (_currentBeat >0)	{
		[[self.beats objectAtIndex:_currentBeat-1] showCorrect];
	}
	[self.theBaby move];
	_currentBeat += 1;
	if (_currentBeat==_numSeq)
		[self success];
}



- (void) dealloc
{
	NSLog(@"dealloc Dancing Instruction View");
	[NSObject cancelPreviousPerformRequestsWithTarget:self.theDot];
	[NSObject cancelPreviousPerformRequestsWithTarget:self.theBaby];
	for (Beat* theBeat in self.beats)
		[NSObject cancelPreviousPerformRequestsWithTarget:theBeat];
	self.theDot = nil;
	self.theBaby = nil;
	self.beats = nil;
	[super dealloc];
}
@end