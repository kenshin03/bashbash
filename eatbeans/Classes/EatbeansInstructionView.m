//
//  EatbeansInstructionView.m
//  bishibashi
//
//  Created by Eric on 29/05/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EatbeansInstructionView.h"


@implementation EatbeansInstructionView
@synthesize noBeans = _noBeans;
@synthesize beanNo = _beanNo;
@synthesize theLeftBaby = _theLeftBaby;
@synthesize theRightBaby = _theRightBaby;
@synthesize theCenterBaby = _theCenterBaby;
@synthesize theCoverImg = _theCoverImg;
@synthesize ballQueue = _ballQueue;
@synthesize state = _state;


static const CGRect backgroundRectP = {{0, 0}, {240, 260}};

static const CGRect coverRectP = {{0, 140}, {240, 120}};

static const CGRect babyLeftI = {{0, 130}, {80,80}};
static const CGRect babyCenterI = {{80, 130}, {80,80}};
static const CGRect babyRightI = {{160, 124}, {80,80}};



- (void) dealloc	{
	NSLog(@"dealloc eatbeans instruction view");
	self.theCoverImg = nil;
	self.theLeftBaby = nil;
	self.theCenterBaby = nil;
	self.theRightBaby = nil;
	
//	[self performSelector:@selector(setBallQueue:) withObject:nil afterDelay:1];
	NSLog(@"dealloc ballquque");
	self.ballQueue = nil;
	NSLog(@"finished dealloc ballquque");
	
	[super dealloc];
}

-(void) initImages
{
	[super initImages];
	Baby* baby;

	baby = [[Baby alloc] initWithFrame:babyLeftI AndColor:kRed AndOrientation:11];
	self.theLeftBaby = baby;
	[baby release];
	baby = [[Baby alloc] initWithFrame:babyCenterI AndColor:kGreen AndOrientation:11];
	self.theCenterBaby = baby;
	[baby release];
	baby = [[Baby alloc] initWithFrame:babyRightI AndColor:kBlue AndOrientation:11];
	self.theRightBaby = baby;
	[baby release];
	[self addSubview:self.theLeftBaby];
	[self addSubview:self.theCenterBaby];
	[self addSubview:self.theRightBaby];
	[self bringSubviewToFront:self.theCoverImg];
	self.state = kGreen;
	[self.theCenterBaby moveUp];
}

-(void) initBackground
{
	[super initBackground];
	UIImage* tmpImage = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"eatbeansbackground" ofType:@"png"]];
	UIImageView* tmpView = [[UIImageView alloc] initWithImage:tmpImage];
	self.backgroundView = tmpView;
	[tmpView release];
	[self.backgroundView setFrame:backgroundRectP];
	[self addSubview:self.backgroundView];
	
	tmpImage = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"eatbeanscover" ofType:@"png"]];
	tmpView = [[UIImageView alloc] initWithImage:tmpImage];
	self.theCoverImg = tmpView;
	[tmpView release];
	[self.theCoverImg setFrame:coverRectP];
	[self addSubview:self.theCoverImg];
}

- (void) startScenarios 
{
	[self startRound];
	for (int j=0; j<8; j++)	{
		if (j%3==0)
			[self performSelector:@selector(redButClicked) withObject:nil afterDelay:1.45*j+0.4];
		else if (j%3==1)
			[self performSelector:@selector(greenButClicked) withObject:nil afterDelay:1.45*j+0.4];
		else if (j%3==2)
			[self performSelector:@selector(blueButClicked) withObject:nil afterDelay:1.45*j+0.4];
	}
}

- (void) initScenarios
{
	[super initScenarios];
	NSMutableArray* ballQueue = [[NSMutableArray alloc] initWithCapacity:20];
	self.ballQueue = ballQueue;
	[ballQueue release];
	
	/* scenario is an array of random NSNumber(integer) of random color 0-2 */
	NSMutableArray* scenario = [[NSMutableArray alloc] initWithCapacity:8];
	for (int j=0; j<8; j++)	{
		[scenario addObject:[NSNumber numberWithInt:j%3]];
	}
	[self.scenarios addObject:scenario];
	[scenario release];
}




-(void) startRound
{
	
	for (NSArray* scenario in self.scenarios)	{
		for (int i=0; i<[scenario count]; i++)	{
			[self performSelector:@selector(fireBall:) withObject:[scenario objectAtIndex:i] afterDelay:1.45*i];
		}
	}
}

- (void)fireBall:(NSNumber*) Color
{
	float speed = 0.17;
	Ball* theBall = [[Ball alloc] initWithOwner:self AndSpeed:(float)speed AndColor:[Color intValue] AndOrientation:11];
	[self addSubview:theBall];
	[self.ballQueue addObject:theBall];
	[theBall show];
	[theBall release];
}	

-(void) removeFromQueue:(Ball*)theBall
{
	if (theBall.direction == self.state)	{
		[sharedSoundEffectsManager playMouthPopSound]; 
	//	switch (theBall.direction)	{
	//		case (kRed):
				[self.theLeftBaby beanCome:theBall.direction];
	//			break;
	//		case (kGreen):
				[self.theCenterBaby beanCome:theBall.direction];
	//			break;
	//		case (kBlue):
				[self.theRightBaby beanCome:theBall.direction];
	//			break;
	//	}
	}
	
	[self.ballQueue removeObject:theBall];
}


- (void) redButClicked
{
	[super redButClicked];
	if (self.state != kRed)	{
		switch(self.state)	{
			case (kRed):
				[self.theLeftBaby moveDown];
				break;
			case (kGreen):
				[self.theCenterBaby moveDown];
				break;
			case (kBlue):
				[self.theRightBaby moveDown];
				break;
		}
		self.state = kRed;
		[self.theLeftBaby moveUp];
	}
}

- (void) blueButClicked
{
	[super blueButClicked];
	if (self.state != kBlue)	{
		switch(self.state)	{
			case (kRed):
				[self.theLeftBaby moveDown];
				break;
			case (kGreen):
				[self.theCenterBaby moveDown];
				break;
			case (kBlue):
				[self.theRightBaby moveDown];
				break;
		}
		self.state = kBlue;
		[self.theRightBaby moveUp];
	}
}

- (void) greenButClicked
{
	[super greenButClicked];
	if (self.state != kGreen)	{
		switch(self.state)	{
			case (kRed):
				[self.theLeftBaby moveDown];
				break;
			case (kGreen):
				[self.theCenterBaby moveDown];
				break;
			case (kBlue):
				[self.theRightBaby moveDown];
				break;
		}
		self.state = kGreen;
		[self.theCenterBaby moveUp];
	}
}


@end