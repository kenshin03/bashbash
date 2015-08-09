//
//  BurgerseqInstructionView.m
//  bishibashi
//
//  Created by Eric on 18/05/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BurgerseqInstructionView.h"


@implementation BurgerseqInstructionView

static const CGRect redButRectP = {{30, 200}, {70, 16}};
static const CGRect greenButRectP = {{130, 200}, {70, 16}};
static const CGRect blueButRectP = {{230, 200}, {70, 16}};
static const CGRect backgroundRectP = {{0, 35}, {240, 200}};


-(void) initBackground
{
	[super initBackground];
	
	UIImage* tmpImage = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"mcdonald" ofType:@"png"]];
	UIImageView* tmpView = [[UIImageView alloc] initWithImage:tmpImage];
	self.backgroundView = tmpView;
	[tmpView release];
	[self.backgroundView setFrame:backgroundRectP];
	[self addSubview:self.backgroundView];
	
}


- (void) initScenarios
{
	[super initScenarios];
		/* scenario is an array of NSNumber for random color 0-2 */
	int noIngredients = 5;
	NSMutableArray* scenario = [[NSMutableArray alloc] initWithCapacity:noIngredients];
	[scenario addObject:[NSNumber numberWithInt:-2]];
	for (int j=0; j<noIngredients; j++)	
	 [scenario addObject:[NSNumber numberWithInt:j%3]];
	[self.scenarios addObject:scenario];
	[scenario release];
}

- (void) startScenarios 
{
	[self startRound];
	[self performSelector:@selector(redButClicked:) withObject:[NSNumber numberWithInt:1] afterDelay:2];
	[self performSelector:@selector(greenButClicked:) withObject:[NSNumber numberWithInt:2] afterDelay:4];
	[self performSelector:@selector(blueButClicked:) withObject:[NSNumber numberWithInt:3] afterDelay:6];
	[self performSelector:@selector(redButClicked:) withObject:[NSNumber numberWithInt:4] afterDelay:8];
	[self performSelector:@selector(greenButClicked:) withObject:[NSNumber numberWithInt:5] afterDelay:10];
}

- (void) startRound	{
		NSArray* scenario = [self.scenarios objectAtIndex:0];
		Ingredient* bottom = [[Ingredient alloc] initWithColor:-2 AndPos:0 AndSample:YES AndOrientation:11];
		[self addSubview:bottom];
		[bottom show];
		[bottom release];
		for (int i=1; i<[scenario count]; i++)	{
			Ingredient* sample = [[Ingredient alloc] initWithColor:[[scenario objectAtIndex:i]intValue] AndPos:i AndSample:YES AndOrientation:11];
			[self addSubview:sample];
			[NSTimer scheduledTimerWithTimeInterval:0.3*i target:sample selector:@selector(show) userInfo:nil repeats:NO];
			[sample release];
		}
		Ingredient* top = [[Ingredient alloc] initWithColor:-1 AndPos:[scenario count] AndSample:YES AndOrientation:11];
		[self addSubview:top];
		[NSTimer scheduledTimerWithTimeInterval:0.3*[scenario count] target:top selector:@selector(show) userInfo:nil repeats:NO];
		[top release];
		
		bottom = [[Ingredient alloc] initWithColor:-2 AndPos:0 AndSample:NO AndOrientation:11];
		[self addSubview:bottom];
		[bottom show];
		[bottom release];
		
		
	
}	


- (void) redButClicked:(NSNumber*) theSeq
{
	[sharedSoundEffectsManager playDropSound];
	int curSeq = [theSeq intValue];
	[super redButClicked];
	Ingredient* sample = [[Ingredient alloc] initWithColor:kRed AndPos:curSeq AndSample:NO AndOrientation:11];
	[self addSubview:sample];
	[sample show];
	[sample release];
	
}

- (void) blueButClicked:(NSNumber*) theSeq
{
	[sharedSoundEffectsManager playDropSound];	
	int curSeq = [theSeq intValue];
	[super blueButClicked];
	Ingredient* sample = [[Ingredient alloc] initWithColor:kBlue AndPos:curSeq AndSample:NO AndOrientation:11];
	[self addSubview:sample];
	[sample show];
	[sample release];
}

- (void) greenButClicked:(NSNumber*) theSeq
{
	[sharedSoundEffectsManager playDropSound];	
	int curSeq = [theSeq intValue];
	[super greenButClicked];
	Ingredient* sample = [[Ingredient alloc] initWithColor:kGreen AndPos:curSeq AndSample:NO AndOrientation:11];
	[self addSubview:sample];
	[sample show];
	[sample release];
}

@end
