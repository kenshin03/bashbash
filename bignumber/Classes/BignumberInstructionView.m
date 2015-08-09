//
//  BignumberInstructionView.m
//  bishibashi
//
//  Created by Eric on 20/05/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BignumberInstructionView.h"


@implementation BignumberInstructionView
@synthesize redDice = _redDice;
@synthesize greenDice = _greenDice;
@synthesize blueDice = _blueDice;
@synthesize currentRound = _currentRound;

static const CGRect backgroundRectP = {{0, 0}, {240, 260}};

-(void) initBackground
{
	[super initBackground];
	
	UIImage* tmpImage = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"mahjongtable" ofType:@"png"]];
	UIImageView* tmpView = [[UIImageView alloc] initWithImage:tmpImage];
	self.backgroundView = tmpView;
	[tmpView release];
	[self.backgroundView setFrame:backgroundRectP];
	[self addSubview:self.backgroundView];
}

- (void) dealloc	{
	self.redDice = nil;
	self.greenDice = nil;
	self.blueDice = nil;
	
	[super dealloc];
}

- (void) initScenarios
{
	[super initScenarios];
		/* scenario is an array of 3 NSNumber(integer) of random number 1-6 */
		for (int i=0; i<5; i++)	{
			NSArray* scenario = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:arc4random()%6+1],[NSNumber numberWithInt:arc4random()%6+1], [NSNumber numberWithInt:arc4random()%6+1], nil];
			[self.scenarios addObject:scenario];
			[scenario release];
		}
	
}
- (void) startScenarios
{
	self.currentRound = 0;
	[self startRound];
	for (int i=0; i<5; i++)	{
		int color = arc4random()%3;
		switch (color)	{
			case (kRed):
				[self performSelector:@selector(redButClicked) withObject:nil afterDelay:(i+1)*2.5];
				break;
			case (kGreen):
				[self performSelector:@selector(greenButClicked) withObject:nil afterDelay:(i+1)*2.5];
				break;
			case (kBlue):
				[self performSelector:@selector(blueButClicked) withObject:nil afterDelay:(i+1)*2.5];
				break;
		}
	}
}
				


- (void) initImages {
	[super initImages];
	
	/*
	for (int i=1; i<=6; i++)	{
		Dice* dice = [[Dice alloc] initWithColor:kRed AndVal:i];
		self.redDice = dice;
		self.redDice.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png", i]];
		[self addSubview:dice];
		[dice release];
		dice = [[Dice alloc] initWithColor:kBlue AndVal:i];
		self.blueDice = dice;
		self.blueDice.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png", i]];
		[self addSubview:dice];
		[dice release];
		dice = [[Dice alloc] initWithColor:kGreen AndVal:i];
		self.greenDice = dice;
		self.greenDice.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png", i]];
		[self addSubview:dice];
		[dice release];
		[self.redDice removeFromSuperview];
		[self.greenDice removeFromSuperview];
		[self.blueDice removeFromSuperview];
	}
	*/
	Dice* dice = [[Dice alloc] initWithColor:kRed AndVal:arc4random()%6+1];
	self.redDice = dice;
	[self.redDice changeOrientationTo:11];
	[self addSubview:dice];
	[dice release];
	dice = [[Dice alloc] initWithColor:kGreen AndVal:arc4random()%6+1];
	self.greenDice = dice;
	[self.greenDice changeOrientationTo:11];
	[self addSubview:dice];
	[dice release];
	dice = [[Dice alloc] initWithColor:kBlue AndVal:arc4random()%6+1];
	self.blueDice = dice;
	[self.blueDice changeOrientationTo:11];
	[self addSubview:dice];
	[dice release];
	
}


- (void) startRound	{
		
		NSArray* Scenario = [self.scenarios objectAtIndex:self.currentRound];
		self.redDice.val = [[Scenario objectAtIndex:0] intValue];
		self.greenDice.val = [[Scenario objectAtIndex:1] intValue];
		self.blueDice.val = [[Scenario objectAtIndex:2] intValue];
		self.currentRound++;
		
		[self.redDice show];
		[self.greenDice show];
		[self.blueDice show];
}	

- (void) fail	{
	[sharedSoundEffectsManager playFailSound];
	[self addSubview:self.crossView];	
	[self.crossView setFrame:CGRectMake(self.crossView.frame.origin.x-1, self.crossView.frame.origin.y, self.crossView.frame.size.width, self.crossView.frame.size.height)];
	[UIView beginAnimations:@"end" context:nil];
	[UIView setAnimationDuration:0.6];
	[UIView setAnimationDelegate:self]; 
	[UIView setAnimationDidStopSelector: @selector(animationDidStop:finished:context:)];	
	[self.crossView setFrame:CGRectMake(self.crossView.frame.origin.x+1, self.crossView.frame.origin.y, self.crossView.frame.size.width, self.crossView.frame.size.height)];
	[UIView commitAnimations];
}

- (void) success	{
	[sharedSoundEffectsManager playYeahSound];
	[self addSubview:self.OKView];	
	[self.OKView setFrame:CGRectMake(self.OKView.frame.origin.x-1, self.OKView.frame.origin.y, self.OKView.frame.size.width, self.OKView.frame.size.height)];
	[UIView beginAnimations:@"end" context:nil];
	[UIView setAnimationDuration:0.6];
	[UIView setAnimationDelegate:self]; 
	[UIView setAnimationDidStopSelector: @selector(animationDidStop:finished:context:)];	
	[self.OKView setFrame:CGRectMake(self.OKView.frame.origin.x+1, self.OKView.frame.origin.y, self.OKView.frame.size.width, self.OKView.frame.size.height)];
	[UIView commitAnimations];
}


- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	int contextid = [((NSNumber*)context) intValue];
	if ([animationID isEqualToString:@"end"])	{
		[self.crossView removeFromSuperview];
		[self.OKView removeFromSuperview];
		[self startRound];
	}
}


- (void) redButClicked
{
	[super redButClicked];
	if (self.redDice.val >= self.greenDice.val && self.redDice.val >= self.blueDice.val)
		[self success];
	else
		[self fail];
}

- (void) blueButClicked
{
	[super blueButClicked];
	if (self.blueDice.val >= self.greenDice.val && self.blueDice.val >= self.redDice.val)
		[self success];
	else
		[self fail];	
}

- (void) greenButClicked
{
	[super greenButClicked];
	if (self.greenDice.val >= self.redDice.val && self.greenDice.val >= self.blueDice.val)
		[self success];
	else
		[self fail];
}

@end