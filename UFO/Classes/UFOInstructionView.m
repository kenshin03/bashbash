//
//  UFOInstructionView.m
//  bishibashi
//
//  Created by Eric on 19/05/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UFOInstructionView.h"


@implementation UFOInstructionView
@synthesize rightBackgroundView = _rightBackgroundView;
@synthesize toLeft = _toLeft;
@synthesize speed = _speed;
@synthesize currentRound = _currentRound;
@synthesize UFOs = _UFOs;
@synthesize theUFO = _theUFO;
@synthesize toLeftUFOs = _toLeftUFOs;
@synthesize toRightUFOs = _toRightUFOs;

static const CGRect leftBackgroundRectP = {{0, 0}, {240, 230}};
static const CGRect rightBackgroundRectP = {{0, 0}, {240, 230}};


static const CGRect theUFORectP = {{0, 230}, {60, 24}};


- (void) dealloc	{
	NSLog(@"dealloc UFOView");
	self.theUFO = nil;
	self.UFOs = nil;
	self.toLeftUFOs = nil;
	self.toRightUFOs = nil;
	
	[super dealloc];
}

-(void) initBackground
{
	UIImage* tmpImage = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"ufobackground" ofType:@"png"]];
	UIImageView* tmpView = [[UIImageView alloc] initWithImage:tmpImage];
	[tmpView setFrame:leftBackgroundRectP];
	[self setBackgroundColor:[UIColor blackColor]];
	[self addSubview:tmpView];
	self.backgroundView = tmpView;
	[tmpView release];
	
	tmpImage = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"ufomask" ofType:@"png"]];
	tmpView = [[UIImageView alloc] initWithImage:tmpImage];
	[tmpView setFrame:rightBackgroundRectP];
	[self addSubview:tmpView];
	self.rightBackgroundView = tmpView;
	[tmpView release];	

	self.toLeftUFOs = [[[NSMutableArray alloc] initWithCapacity:4]autorelease];
	self.toRightUFOs = [[[NSMutableArray alloc] initWithCapacity:4]autorelease];
	self.UFOs = [[[NSMutableArray alloc] initWithCapacity:3]autorelease];
	
	for (int i=0; i<4; i++)	{
		UFO* theUFO = [[UFO alloc] initWithSeq:i AndToLeft:YES AndOrientation:11];
		[self addSubview:theUFO];
		[theUFO setHidden:YES];
		[self.toLeftUFOs addObject:theUFO];
		[theUFO release];
	}
	for (int i=0; i<4; i++)	{
		UFO* theUFO = [[UFO alloc] initWithSeq:i AndToLeft:NO AndOrientation:11];
		[self addSubview:theUFO];
		[theUFO setHidden:YES];
		[self.toRightUFOs addObject:theUFO];
		[theUFO release];
	}
}


- (void) initScenarios
{
	[super initScenarios];
	/* scenario is an array of 4 NSNumber(integer) , 1st 3 are random number 0-3, 4th is random color 0-2 */
	for (int i=0; i<8; i++)	{			
		NSMutableArray* scenario = [[NSMutableArray alloc] initWithCapacity:4];
		for (int i=0; i<3; i++)	{
			[scenario addObject:[NSNumber numberWithInt:arc4random()%(4-i)]];
		}
		
		[scenario addObject:[NSNumber numberWithInt:arc4random()%3]];
		[self.scenarios addObject:scenario];
		[scenario release];
	}
}

- (void) startScenarios
{
	self.currentRound = 0;
	self.speed = 1.8;
	[self startRound];
	for (int i=0; i<5; i++)	{
		NSArray* scenario = [self.scenarios objectAtIndex:i];
		UFO* theUFO = [self.UFOs objectAtIndex:[[scenario objectAtIndex:3] intValue]];
		ButState color = theUFO.color;
		if (color == kRed)
			[self performSelector:@selector(redButClicked) withObject:nil afterDelay:(i+1)*2];
		else if (color == kGreen)
			[self performSelector:@selector(greenButClicked) withObject:nil afterDelay:(i+1)*2];			
		else if (color == kBlue)
			[self performSelector:@selector(blueButClicked) withObject:nil afterDelay:(i+1)*2];
	}		
}

- (void) startRound	{

		for (UFO* theUFO in self.UFOs)	{
			if (self.toLeft)	{
				[self.toLeftUFOs addObject:theUFO];
				[theUFO setHidden:YES];
			}
			else {
				[self.toRightUFOs addObject:theUFO];
				[theUFO setHidden:YES];
			}
		}
		[self.UFOs removeAllObjects];
		
		
		if (self.toLeft)
			self.toLeft = NO;
		else {
			self.toLeft = YES;
		}
		
		NSArray* scenario = [self.scenarios objectAtIndex:self.currentRound];
		for (int i=0; i<3; i++)	{
			UFO* theUFO;
			if (self.toLeft)	{
				theUFO = [self.toLeftUFOs objectAtIndex:[[scenario objectAtIndex:i] intValue]];
				[self.UFOs addObject:theUFO];
				[self.toLeftUFOs removeObject:theUFO];
			}
			else	{
				theUFO = [self.toRightUFOs objectAtIndex:[[scenario objectAtIndex:i] intValue]];
				[self.UFOs addObject:theUFO];
				[self.toRightUFOs removeObject:theUFO];
			}			
			theUFO.color = i;
			theUFO.speed = [self getSpeed];
			[theUFO setHidden:NO];
					[theUFO setFrame:theUFORectP];
					[theUFO setFrame:CGRectMake(10+i*80, theUFO.frame.origin.y, theUFO.frame.size.width, theUFO.frame.size.height)];
			
		}
		
		self.theUFO = [[self.UFOs objectAtIndex:[[scenario objectAtIndex:3] intValue]] copy];
		
		[self addSubview:self.theUFO];
		[self bringSubviewToFront:self.rightBackgroundView];
	
//		[self sendSubviewToBack:self.theUFO];
		[self.theUFO show];		
		[sharedSoundEffectsManager playUFOFlyPassSound];
		self.currentRound++;
	
}

-(float) getSpeed
{
	self.speed *= 0.95;
	return self.speed;
}

- (void) success
{
	[sharedSoundEffectsManager playYeahSound];
	[self.OKView setFrame:CGRectMake(self.OKView.frame.origin.x-1, self.OKView.frame.origin.y, self.OKView.frame.size.width, self.OKView.frame.size.height)];
	[self addSubview:self.OKView];
	[UIView beginAnimations:@"end" context:nil];
	[UIView setAnimationDuration:0.6];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector: @selector(animationDidStop:finished:context:)];	
	[self.OKView setHidden:NO];
	[self.OKView setFrame:CGRectMake(self.OKView.frame.origin.x+1, self.OKView.frame.origin.y, self.OKView.frame.size.width, self.OKView.frame.size.height)];
	[self bringSubviewToFront:self.OKView];
	[UIView commitAnimations];
	[self.theUFO removeFromSuperview];
	self.theUFO = nil;
}



- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	if ([animationID isEqualToString:@"end"])	{
		[self.crossView removeFromSuperview];
		[self.OKView removeFromSuperview];
		[self startRound];
		
	}
}
- (void) redButClicked
{
	[super redButClicked];
	[self success];
}

- (void) blueButClicked
{
	[super blueButClicked];
	[self success];
}

- (void) greenButClicked
{
	[super greenButClicked];
	[self success];
}
@end
