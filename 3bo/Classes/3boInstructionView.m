//
//  3boInstructionView.m
//  bishibashi
//
//  Created by Eric on 19/05/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "3boInstructionView.h"

@implementation the3boInstructionView
@synthesize curSeq = _curSeq;
@synthesize stickView = _stickView;
@synthesize finishedseq = _finishedseq;
@synthesize seq = _seq;

static const CGRect redButRectP = {{30, 325}, {60, 50}};
static const CGRect redButRectL = {{30, 200}, {60, 35}};

static const CGRect greenButRectP = {{130, 325}, {60, 50}};
static const CGRect greenButRectL = {{130, 200}, {60, 35}};

static const CGRect blueButRectP = {{230, 325}, {60, 50}};
static const CGRect blueButRectL = {{230, 200}, {60, 35}};

static const CGRect backgroundRectP = {{0, 0}, {240, 260}};
static const CGRect backgroundRectL = {{0, 0}, {240, 260}};
static const CGRect backgroundRectR = {{15, 40}, {0, 0}};


- (void) dealloc	{
	self.seq = nil;
	self.stickView = nil;
	self.finishedseq = nil;
	[super dealloc];
}


-(void) initBackground
{
	[super initBackground];
	
	UIImage* tmpImage = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"mkstreet" ofType:@"png"]];
	UIImageView* tmpView = [[UIImageView alloc] initWithImage:tmpImage];
	self.backgroundView = tmpView;
	[tmpView release];
	[self.backgroundView setFrame:backgroundRectP];
	[self addSubview:self.backgroundView];
	tmpView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"stick.png"]];
	[self addSubview:tmpView];
	self.stickView = tmpView;
	[tmpView release];
	[self.stickView setFrame:CGRectMake(0, 220, self.stickView.frame.size.width, self.stickView.frame.size.height)];
	
}


- (void) initScenarios
{
	[super initScenarios];
		/* scenario is an array of noRun NSNumber for random number 1-24 */
		for (int i=0; i<11; i++)	{
			NSNumber* scenario = [NSNumber numberWithInt:i%3];
			[self.scenarios addObject:scenario];
		}
}
-(void) startGame
{
	NSMutableArray* theSeq = [[NSMutableArray alloc] initWithCapacity:9];
	self.seq = theSeq;
	[theSeq release];
	
	theSeq = [[NSMutableArray alloc] initWithCapacity:9];
	self.finishedseq = theSeq;
	[theSeq release];
	
	for (int i=0; i<11; i++)	{
		Bo* sample = [[Bo alloc] initWithColor:[[self.scenarios objectAtIndex:i] intValue] AndPos:i AndOrientation:11 AndIsMyself:YES];
		[self addSubview:sample];
		[self.seq addObject:sample];
		[sample release];
	}
}
- (void) startScenarios 
{
	[self startGame];
	[self performSelector:@selector(redButClicked) withObject:nil afterDelay:1];
	[self performSelector:@selector(greenButClicked) withObject:nil afterDelay:2];
	[self performSelector:@selector(blueButClicked) withObject:nil afterDelay:3];
	[self performSelector:@selector(redButClicked) withObject:nil afterDelay:4];
	[self performSelector:@selector(greenButClicked) withObject:nil afterDelay:5];
	[self performSelector:@selector(blueButClicked) withObject:nil afterDelay:6];
	[self performSelector:@selector(redButClicked) withObject:nil afterDelay:7];
	[self performSelector:@selector(greenButClicked) withObject:nil afterDelay:8];
	[self performSelector:@selector(blueButClicked) withObject:nil afterDelay:9];
	[self performSelector:@selector(redButClicked) withObject:nil afterDelay:10];
	[self performSelector:@selector(greenButClicked) withObject:nil afterDelay:11];
}


- (void) moveStick	{	
	self.stickView.frame = CGRectMake(0,220, self.stickView.frame.size.width, self.stickView.frame.size.height);
	[UIView beginAnimations:@"moveStick" context:nil];
	[UIView setAnimationDuration:0.1];
	[UIView setAnimationDelegate:self]; 
	[UIView setAnimationDidStopSelector: @selector(animationDidStop:finished:context:)];	
	[UIView setAnimationBeginsFromCurrentState:YES];
	self.stickView.frame = CGRectMake(120,220, self.stickView.frame.size.width, self.stickView.frame.size.height);
	[UIView commitAnimations];
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
		[UIView beginAnimations:@"moveStick2" context:nil];
		[UIView setAnimationDuration:0.1];
		[UIView setAnimationBeginsFromCurrentState:YES];
		self.stickView.frame = CGRectMake(0,220, self.stickView.frame.size.width, self.stickView.frame.size.height);
			
		[UIView commitAnimations];
	
}


- (void) redButClicked
{
	[super redButClicked];
	if ([[self.seq objectAtIndex:0] color] == kRed)	{
		[sharedSoundEffectsManager playDropSound];
		[self moveStick];
		[[self.seq objectAtIndex:0] dispose];
		[self.finishedseq addObject:[self.seq objectAtIndex:0]];
		[self.seq removeObjectAtIndex:0];
		self.curSeq ++;
		for (Bo* bo in self.seq)
			[bo show];
	}
	else	
		[self fail];		
}

- (void) blueButClicked
{
	[super blueButClicked];
	if ([[self.seq objectAtIndex:0] color] == kBlue)	{
		[sharedSoundEffectsManager playDropSound];
		[self moveStick];
		[[self.seq objectAtIndex:0] dispose];
		[self.finishedseq addObject:[self.seq objectAtIndex:0]];
		[self.seq removeObjectAtIndex:0];
		self.curSeq ++;
		for (Bo* bo in self.seq)
			[bo show];
	}
	else	
		[self fail];		
}

- (void) greenButClicked
{
	[super greenButClicked];
	if ([[self.seq objectAtIndex:0] color] == kGreen)	{
		[sharedSoundEffectsManager playDropSound];
		[self moveStick];
		[[self.seq objectAtIndex:0] dispose];
		[self.finishedseq addObject:[self.seq objectAtIndex:0]];
		[self.seq removeObjectAtIndex:0];
		self.curSeq ++;
		for (Bo* bo in self.seq)
			[bo show];
	}
	else	
		[self fail];		
}

@end