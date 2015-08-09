//
//  AlarmClockInstructionView.m
//  bishibashi
//
//  Created by Eric on 20/05/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AlarmClockInstructionView.h"


@implementation AlarmClockInstructionView
@synthesize speed = _speed;
@synthesize theTimer = _theTimer;
@synthesize shortArrow = _shortArrow;
@synthesize longArrow = _longArrow;
@synthesize currentRound = _currentRound;
@synthesize toQuit = _toQuit;

static const CGRect backgroundRectP = {{49, 81}, {150, 150}};

static const CGRect OKRectP = {{20, 20}, {140, 110}};


- (void) dealloc	{
	NSLog(@"dealloc AlarmClockInstructionView");
	if (self.theTimer)
		[self.theTimer invalidate];
	self.theTimer = nil;
	self.longArrow = nil;
	self.shortArrow = nil;
	[sharedSoundEffectsManager stopAlarmClockTickingSound];
	[super dealloc];
}

-(void) initBackground
{
	UIImage* tmpImage = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"clock" ofType:@"png"]];
	UIImageView* tmpView = [[UIImageView alloc] initWithImage:tmpImage];
	tmpView.frame = backgroundRectP;
	self.backgroundView = tmpView;
	[self addSubview:self.backgroundView];
	[tmpView release];
	
	[self setBackgroundColor:[UIColor blackColor]];
	self.toQuit = NO;
}

- (void) initImages
{
	[super initImages];
	
	UIImageView* tmpView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"notmoving" ofType:@"png"]]];
	self.OKView = tmpView;
	[self.OKView setFrame:OKRectP];
	[tmpView release];
}

- (void) initScenarios
{
	[super initScenarios];
		/* scenario is an array of 1 NSNumber(integer) of consecutively diminishing numbers */
		for (int i=5; 0<i; i--)	{
			[self.scenarios addObject:[NSNumber numberWithInt:(12-i)]];
		}
}

- (void) startRound{
	if (!self.shortArrow)		{
		Arrow* shortArrow = [[Arrow alloc]initWithOwner:self ForLong:NO AndAngle:([[self.scenarios objectAtIndex:self.currentRound]intValue])*30.0 AndSpeed:0.5 AndOrientation:11];
		self.shortArrow = shortArrow;
		[shortArrow release];
		[self addSubview:self.shortArrow];
	}
	else	{
		[self.shortArrow setAngle:([[self.scenarios objectAtIndex:self.currentRound]intValue])*30.0	AndSpeed:0.5];
	}
	if (!self.longArrow)	{
		Arrow* longArrow = [[Arrow alloc]initWithOwner:self ForLong:YES  AndAngle:0.0 AndSpeed:0.5 AndOrientation:11];
		self.longArrow = longArrow;
		[longArrow release];
		[self addSubview:self.longArrow];
	}
	else	{
		[self.longArrow setAngle:0.0 AndSpeed:0.5];			
	}
	
	self.theTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
	[sharedSoundEffectsManager playAlarmClockTickingSound];
	[self performSelector:@selector(redButClicked) withObject:nil afterDelay:1.5];
	self.currentRound++;
	
}

- (void) timerFireMethod:(NSTimer*)theTimer
{
	[self.shortArrow showTime];
	[self.longArrow showTime];
}

- (void) startScenarios
{
	self.currentRound = 0;
	[self startRound];
}
	



- (void) success
{	
	if (!self.toQuit)	{
		[sharedSoundEffectsManager playYeahSound];
		[self.OKView setFrame:CGRectMake(self.OKView.frame.origin.x-1, self.OKView.frame.origin.y, self.OKView.frame.size.width, self.OKView.frame.size.height)];
		[self addSubview:self.OKView];
		
		[UIView beginAnimations:@"end" context:nil];
		[UIView setAnimationDuration:1];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector: @selector(animationDidStop:finished:context:)];	
		[self.OKView setHidden:NO];
		[self.OKView setFrame:CGRectMake(self.OKView.frame.origin.x+1, self.OKView.frame.origin.y, self.OKView.frame.size.width, self.OKView.frame.size.height)];
		[self bringSubviewToFront:self.OKView];
		[UIView commitAnimations];
	}
}


- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	if ([animationID isEqualToString:@"end"] && !self.toQuit)	{
		[self.crossView removeFromSuperview];
		[self.OKView removeFromSuperview];
		if (self.currentRound <5)
			[self startRound];
	}		
}

- (void) redButClicked
{
	[super redButClicked];
	[self.theTimer invalidate];
	[sharedSoundEffectsManager pauseAlarmClockTickingSound];
	[self success];
}

- (void) blueButClicked
{
	[super blueButClicked];
	[self.theTimer invalidate];
	[sharedSoundEffectsManager pauseAlarmClockTickingSound];
	[self success];
}

- (void) greenButClicked
{
	[super greenButClicked];
	[self.theTimer invalidate];
	[sharedSoundEffectsManager pauseAlarmClockTickingSound];
	[self success];	
}
@end
