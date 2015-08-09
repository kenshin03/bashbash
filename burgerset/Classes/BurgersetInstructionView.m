//
//  BurgersetInstructionView.m
//  bishibashi
//
//  Created by Eric on 20/05/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BurgersetInstructionView.h"


@implementation BurgersetInstructionView
@synthesize targetQueue = _targetQueue;
@synthesize currentQueue = _currentQueue;
@synthesize targetQueueBurger = _targetQueueBurger;
@synthesize currentQueueBurger = _currentQueueBurger;


static const CGRect backgroundRectP = {{0, 0}, {240, 260}};


- (void) dealloc	{
	self.currentQueue = nil;
	self.targetQueue = nil;
	self.currentQueueBurger = nil;
	self.targetQueueBurger = nil;
	
	[super dealloc];
}

-(void) initBackground
{
	UIImage* tmpImage = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"burgersetbackground" ofType:@"png"]];
	UIImageView* tmpView = [[UIImageView alloc] initWithImage:tmpImage];
	[tmpView setFrame:backgroundRectP];
	[self setBackgroundColor:[UIColor blackColor]];
	self.backgroundView = tmpView;
	[self addSubview:tmpView];
	[tmpView release];
	
}




- (void) initScenarios
{
	[super initScenarios];
		/* scenario is an array of 3 NSNumber for random number 1-5 */
		for (int i=0; i<1; i++)	{
			NSArray* scenario = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:arc4random()%5+1], [NSNumber numberWithInt:arc4random()%5+1], [NSNumber numberWithInt:arc4random()%5+1], nil];
			[self.scenarios addObject:scenario];
			[scenario release];
		}
}

- (void) startScenarios
{
	[self startRound];
	int seq = 1;
	for (int i=0; i<3; i++)	{
		int noObj = [[[self.scenarios objectAtIndex:0] objectAtIndex:i] intValue];
		switch (i)	{
			case (kRed):	
				for (int j=0; j<noObj; j++)	{
					[self performSelector:@selector(redButClicked) withObject:nil afterDelay:0.8*seq];
					seq++;
				}
				break;
			case (kGreen):
				for (int j=0; j<noObj; j++)	{
					[self performSelector:@selector(greenButClicked) withObject:nil afterDelay:0.8*seq];
					seq++;
				}
				break;
			case (kBlue):					
				for (int j=0; j<noObj; j++)	{
					[self performSelector:@selector(blueButClicked) withObject:nil afterDelay:0.8*seq];
					seq++;
				}
				break;
		}
	}
}
				

- (void) startRound	{
		for (int i=0; i<3; i++)	{
			NSArray* theArr = [self.targetQueueBurger objectAtIndex:i];
			for (Burger* aBurger in theArr)	{
				[aBurger removeFromSuperview];
				NSLog(@"remove target burger at %d", i);
			}
			theArr = [self.currentQueueBurger objectAtIndex:i];
			for (Burger* aBurger in theArr)	{
				[aBurger removeFromSuperview];
				NSLog(@"remove current burger at %d", i);
			}
		}
		
		self.targetQueue = [[[NSMutableArray alloc] initWithCapacity:3] autorelease];
		self.currentQueue = [[[NSMutableArray alloc] initWithCapacity:3] autorelease];
		self.targetQueueBurger = [[[NSMutableArray alloc] initWithCapacity:3] autorelease];
		self.currentQueueBurger = [[[NSMutableArray alloc] initWithCapacity:3] autorelease];
		
		NSArray* scenario = [self.scenarios objectAtIndex:0];
		int totalNo = 0;
		for (int i=0; i<3; i++)	{
			[self.currentQueue addObject:[NSNumber numberWithInt:0]];
			int theNo = [[scenario objectAtIndex:i] intValue];
			totalNo += theNo;
			[self.targetQueue addObject:[NSNumber numberWithInt:theNo]];
			NSMutableArray* theArr = [[NSMutableArray alloc] initWithCapacity:5];
			for (int j=0; j<theNo; j++)	{
				Burger* aBurger = [[Burger alloc] initWithColor:i AndPos:j AndEmpty:YES AndOrientation:11];
				[self addSubview:aBurger];
				[aBurger show];
				[theArr addObject:aBurger];
				[aBurger release];
			}
			[self.targetQueueBurger addObject:theArr];
			[theArr release];
			
			theArr = [[NSMutableArray alloc] initWithCapacity:5];
			[self.currentQueueBurger addObject:theArr];
			[theArr release];
		}
	
}


- (void) success
{
	[sharedSoundEffectsManager playYeahSound];
	NSLog(@"success");
	[self.OKView setFrame:CGRectMake(self.OKView.frame.origin.x-1, self.OKView.frame.origin.y, self.OKView.frame.size.width, self.OKView.frame.size.height)];
	[self addSubview:self.OKView];	
	[UIView beginAnimations:@"end" context:nil];
	[UIView setAnimationDuration:0.6];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector: @selector(animationDidStop:finished:context:)];	
	[self.OKView setFrame:CGRectMake(self.OKView.frame.origin.x+1, self.OKView.frame.origin.y, self.OKView.frame.size.width, self.OKView.frame.size.height)];
	[self bringSubviewToFront:self.OKView];
	[UIView commitAnimations];
}



- (void) checkSuccess
{
	BOOL isSuccess = YES;
	for (int i=0; i<3; i++)	{
		int target = [[self.targetQueue objectAtIndex:i] intValue];
		int current = [[self.currentQueue objectAtIndex:i] intValue];
		if (current > target)	{
			[self fail];
			return;
		}
		if (current < target)
			isSuccess=NO;
	}
	if (isSuccess)
		[self success];
}
- (void) redButClicked
{
	[super redButClicked];
	[sharedSoundEffectsManager playDropSound];
	NSNumber* theNo = [self.currentQueue objectAtIndex:kRed];
	NSNumber* newNo = [NSNumber numberWithInt:[theNo intValue]+1];
	Burger* aBurger = [[Burger alloc]initWithColor:kRed AndPos:[theNo intValue] AndEmpty:NO AndOrientation:11];
	[self addSubview:aBurger];
	[aBurger show];
	[[self.currentQueueBurger objectAtIndex:kGreen] addObject:aBurger];
	[self.currentQueue replaceObjectAtIndex:kRed withObject:newNo];
	[aBurger release];
	[self checkSuccess];
}

- (void) blueButClicked
{
	[super blueButClicked];
	[sharedSoundEffectsManager playDropSound];
	NSNumber* theNo = [self.currentQueue objectAtIndex:kBlue];
	NSNumber* newNo = [NSNumber numberWithInt:[theNo intValue]+1];
	Burger* aBurger = [[Burger alloc]initWithColor:kBlue AndPos:[theNo intValue] AndEmpty:NO AndOrientation:11];
	[self addSubview:aBurger];
	[aBurger show];
	[[self.currentQueueBurger objectAtIndex:kBlue] addObject:aBurger];
	[self.currentQueue replaceObjectAtIndex:kBlue withObject:newNo];
	[aBurger release];
	[self checkSuccess];
}

- (void) greenButClicked
{
	[super greenButClicked];
	[sharedSoundEffectsManager playDropSound];
	NSNumber* theNo = [self.currentQueue objectAtIndex:kGreen];
	NSNumber* newNo = [NSNumber numberWithInt:[theNo intValue]+1];
	Burger* aBurger = [[Burger alloc]initWithColor:kGreen AndPos:[theNo intValue] AndEmpty:NO AndOrientation:11];
	[self addSubview:aBurger];
	[aBurger show];
	[[self.currentQueueBurger objectAtIndex:kGreen] addObject:aBurger];
	[self.currentQueue replaceObjectAtIndex:kGreen withObject:newNo];
	[aBurger release];
	[self checkSuccess];
}


@end