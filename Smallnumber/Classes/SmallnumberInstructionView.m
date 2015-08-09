//
//  SmallnumberInstructionView.m
//  bishibashi
//
//  Created by Eric on 19/05/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SmallnumberInstructionView.h"


@implementation SmallnumberInstructionView
@synthesize curRedSeq = _curRedSeq;
@synthesize curBlueSeq = _curBlueSeq;
@synthesize curGreenSeq = _curGreenSeq;
@synthesize redSeq = _redSeq;
@synthesize greenSeq = _greenSeq;
@synthesize blueSeq = _blueSeq;


- (void) dealloc	{
	self.redSeq = nil;
	self.greenSeq = nil;
	self.blueSeq = nil;
	
	[super dealloc];
}


- (void) initScenarios
{
	[super initScenarios];
	/* scenario is an array of 3 arrays, each array represents a RGB color and is an array of 8 NSNumber for random number 1-24 */
	NSMutableArray* theSeq = [[NSMutableArray alloc] initWithCapacity:8];
	[self.scenarios addObject:theSeq];
	[theSeq release];
	
	theSeq = [[NSMutableArray alloc] initWithCapacity:8];
	[self.scenarios addObject:theSeq];
	[theSeq release];
	
	theSeq = [[NSMutableArray alloc] initWithCapacity:8];
	[self.scenarios addObject:theSeq];
	[theSeq release];
	int positions[3] = {0,0,0};
	for (int i=1; i<=24; i++)	{
		int color = arc4random()%3;
		while (positions[color]>=8)
			color = arc4random()%3;
		[[self.scenarios objectAtIndex:color] addObject:[NSNumber numberWithInt:i]];
		positions[color]++;
	}	
	theSeq = [[NSMutableArray alloc] initWithCapacity:8];
	self.redSeq = theSeq;
	int pos = 0;
	for (NSNumber* theNum in [self.scenarios objectAtIndex:kRed])	{
		Number* theNo = [[Number alloc] initWithNo:[theNum intValue] AndColor:kRed AndPos:pos++ AndOrientation:11];
		[self.redSeq addObject:theNo];
		[self addSubview:theNo];
		[theNo release];
	}
	[theSeq release];
	
	theSeq = [[NSMutableArray alloc] initWithCapacity:8];
	self.greenSeq = theSeq;
	pos = 0;
	for (NSNumber* theNum in [self.scenarios objectAtIndex:kGreen])	{
		Number* theNo = [[Number alloc] initWithNo:[theNum intValue] AndColor:kGreen AndPos:pos++ AndOrientation:11];
		[self addSubview:theNo];
		[self.greenSeq addObject:theNo];
		[theNo release];
	}
	[theSeq release];
	
	theSeq = [[NSMutableArray alloc] initWithCapacity:8];
	self.blueSeq = theSeq;
	pos = 0;
	for (NSNumber* theNum in [self.scenarios objectAtIndex:kBlue])	{
		Number* theNo = [[Number alloc] initWithNo:[theNum intValue] AndColor:kBlue AndPos:pos++ AndOrientation:11];
		[self addSubview:theNo];
		[self.blueSeq addObject:theNo];
		[theNo release];
	}
	[theSeq release];
	
}

-(void) initBackground
{
	[super initBackground];
	UIImageView* background = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"buildingbackground" ofType:@"jpg"]]];
	background.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-60);
	[self addSubview:background];
	self.backgroundView = background;
	[background release];
	
}

- (void) startScenarios 
{
	for (int i=1; i<12; i++)	{
		for (Number* number in self.redSeq)	{
			if ([number no] == i)	{
				[self performSelector:@selector(redButClicked) withObject:nil afterDelay:i];
				break;
			}
		}
		for (Number* number in self.blueSeq)	{
			if ([number no] == i)	{
				[self performSelector:@selector(blueButClicked) withObject:nil afterDelay:i];
				break;
			}
		}
		for (Number* number in self.greenSeq)	{
			if ([number no] == i)	{
				[self performSelector:@selector(greenButClicked) withObject:nil afterDelay:i];
				break;
			}
		}
	}
}

- (int) getNo:(NSArray*)seq
{
	if ([seq count]==0)
		return 1000;
	else
		return [[seq objectAtIndex:0] no];
}

- (void) redButClicked
{
	[super redButClicked];
	int redno = [self getNo:self.redSeq];
	int greenno = [self getNo:self.greenSeq];
	int blueno = [self getNo:self.blueSeq];
	
	if (redno <= greenno && redno <=blueno)	{
		[sharedSoundEffectsManager playDropSound];
		[[self.redSeq objectAtIndex:0] dispose];
		[self.redSeq removeObjectAtIndex:0];
		for (Number* theNo in self.redSeq)
			[theNo show];
	}
}

- (void) blueButClicked
{
	[super blueButClicked];
	int redno = [self getNo:self.redSeq];
	int greenno = [self getNo:self.greenSeq];
	int blueno = [self getNo:self.blueSeq];
	
	if (blueno <= greenno && blueno <=redno)	{
		[sharedSoundEffectsManager playDropSound];
		[[self.blueSeq objectAtIndex:0] dispose];
		[self.blueSeq removeObjectAtIndex:0];
		for (Number* theNo in self.blueSeq)
			[theNo show];
	}
}

- (void) greenButClicked
{
	[super greenButClicked];
	int redno = [self getNo:self.redSeq];
	int greenno = [self getNo:self.greenSeq];
	int blueno = [self getNo:self.blueSeq];
	
	if (greenno <= redno && greenno <=blueno)	{
		[sharedSoundEffectsManager playDropSound];
		[[self.greenSeq objectAtIndex:0] dispose];
		[self.greenSeq removeObjectAtIndex:0];
		for (Number* theNo in self.greenSeq)
			[theNo show];
	}
}

@end