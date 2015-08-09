//
//  Game1View.m
//  bishibashi
//
//  Created by Eric on 06/03/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EatbeansView.h"
#import "Constants.h"


@implementation EatbeansView
@synthesize hits = _hits;
@synthesize noBeans = _noBeans;
@synthesize beanNo = _beanNo;
@synthesize theLeftBaby = _theLeftBaby;
@synthesize theRightBaby = _theRightBaby;
@synthesize theCenterBaby = _theCenterBaby;
@synthesize theCoverImg = _theCoverImg;
@synthesize ballQueue = _ballQueue;
@synthesize state = _state;


static const CGRect backgroundRectP = {{15, 18}, {290, 360}};

static const CGRect coverRectP = {{15, 198}, {290, 180}};

static const CGRect babyLeftP = {{10, 195}, {120,120}};
static const CGRect babyCenterP = {{100, 195}, {120,120}};
static const CGRect babyRightP = {{195, 185}, {120,120}};

static const CGRect babyLeftR = {{5, 110}, {60,120}};
static const CGRect babyCenterR = {{50, 120}, {60,120}};
static const CGRect babyRightR = {{95, 100}, {60,120}};




- (id) initWithFrame:(CGRect)frameRect AndOwner:(id)owner AndGame:(Game) game AndGameType:(currrentGameType) gameType AndLevel:(GameLevel) level
{
    self = [super initWithFrame:(CGRect)frameRect AndOwner:(id)owner AndGame:(Game) game AndGameType:gameType AndLevel:level];
	NSMutableArray* ballQueue = [[NSMutableArray alloc] initWithCapacity:20];
	self.ballQueue = ballQueue;
	[ballQueue release];
    return self;
}

- (void) dealloc	{
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	self.theCoverImg = nil;
	self.theLeftBaby = nil;
	self.theCenterBaby = nil;
	self.theRightBaby = nil;
	self.ballQueue = nil;

	[super dealloc];
}

-(void) initImages
{
	Baby* baby;
	switch (self.orientation)	{
		case (UIInterfaceOrientationPortrait):
		case (UIInterfaceOrientationPortraitUpsideDown):
			baby = [[Baby alloc] initWithFrame:babyLeftP AndColor:kRed AndOrientation:self.orientation];
			self.theLeftBaby = baby;
			[baby release];
			baby = [[Baby alloc] initWithFrame:babyCenterP AndColor:kGreen AndOrientation:self.orientation];
			self.theCenterBaby = baby;
			[baby release];
			baby = [[Baby alloc] initWithFrame:babyRightP AndColor:kBlue AndOrientation:self.orientation];
			self.theRightBaby = baby;
			[baby release];
			break;
		case (11):
			baby = [[Baby alloc] initWithFrame:babyLeftR AndColor:kRed AndOrientation:self.orientation];
			self.theLeftBaby = baby;
			[baby release];
			baby = [[Baby alloc] initWithFrame:babyCenterR AndColor:kGreen AndOrientation:self.orientation];
			self.theCenterBaby = baby;
			[baby release];
			baby = [[Baby alloc] initWithFrame:babyRightR AndColor:kBlue AndOrientation:self.orientation];
			self.theRightBaby = baby;
			[baby release];
			break;
	}
	[self addSubview:self.theLeftBaby];
	[self addSubview:self.theCenterBaby];
	[self addSubview:self.theRightBaby];
	[self bringSubviewToFront:self.theCoverImg];
	[self bringSubviewToFront:self.gameFrame];
	[self bringSubviewToFront:self.redBut];
	[self bringSubviewToFront:self.greenBut];
	[self bringSubviewToFront:self.blueBut];
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

- (void) initScenarios:(NSArray*)scenarios
{
	[super initScenarios:scenarios];
	if (!scenarios)
	{
		self.noRun = 10;
		/* scenario is an array of random NSNumber(integer) of random color 0-2 */
		for (int i=0; i<self.noRun; i++)	{
			int noBean = arc4random()%5+ (int)(i/2)+1;
			NSMutableArray* scenario = [[NSMutableArray alloc] initWithCapacity:noBean];
			for (int j=0; j<noBean; j++)	{
				[scenario addObject:[NSNumber numberWithInt:arc4random()%3]];
			}
			[self.scenarios addObject:scenario];
			[scenario release];
		}
		/* for Master Level */
		if (self.difficultiesLevel == kWorldClass)	{
			for (int i=0; i<self.noRun; i++)	{
				int noBean = arc4random()%5+ (int)(i/2)+1;
				NSMutableArray* scenario = [[NSMutableArray alloc] initWithCapacity:noBean];
				for (int j=0; j<noBean; j++)	{
					[scenario addObject:[NSNumber numberWithInt:arc4random()%3]];
				}
				[self.scenarios2 addObject:scenario];
				[scenario release];
			}
		}			
	}
	if (self.remoteView)
		[self.remoteView initScenarios:self.scenarios];
}

- (void) switchScenario
{
	self.noBeans = 0;
	self.beanNo = 0;
	int seq = 0;
	
	if (self.remoteView)
		[self.remoteView startGame];
	
	for (NSArray* scenario in self.scenarios2)	{
		for (int i=0; i<[scenario count]; i++)	{
			[self performSelector:@selector(fireBall:) withObject:[scenario objectAtIndex:i] afterDelay:self.difficultFactor*2.0*seq];
			seq ++;
			self.noBeans++;
		}
		seq +=2;
	}

	
	self.scenarios = self.scenarios2;
	for (int i=0; i<self.noRun; i++)	{
		int noBean = arc4random()%5+ (int)(i/2)+1;
		NSMutableArray* scenario = [[NSMutableArray alloc] initWithCapacity:noBean];
		for (int j=0; j<noBean; j++)	{
			[scenario addObject:[NSNumber numberWithInt:arc4random()%3]];
		}
		[self.scenarios2 addObject:scenario];
		[scenario release];
	}
	
}



- (void) prepareToStartGameWithNewScenario:(BOOL)newScenario
{
	self.state = kGreen;
	self.theCenterBaby.frame = CGRectOffset(babyCenterP, 0, -70);
	self.theLeftBaby.frame = babyLeftP;
	self.theRightBaby.frame = babyRightP;
	[super prepareToStartGameWithNewScenario:newScenario];
}

-(void) startGame
{
	_VSModeIsRoundBased = NO;
	[super startGame];
	self.noRun = 10;
	self.hits = 0;
	_toQuit = NO;
	
	if ((self.gameType != multi_players_arcade)&& (self.gameType != multi_players_level_select)){	
		if ((!self.isRemoteView) ){
			if ([self.scenarios count] == 0){
				[self initScenarios:nil];
			}
		}
	}
	
	self.noBeans = 0;
	self.beanNo = 0;
	int seq = 0;
	
	if (self.remoteView)
		[self.remoteView startGame];
	
	for (NSArray* scenario in self.scenarios)	{
		for (int i=0; i<[scenario count]; i++)	{
			[self performSelector:@selector(fireBall:) withObject:[scenario objectAtIndex:i] afterDelay:self.difficultFactor*2.0*seq];
			seq ++;
			self.noBeans++;
		}
		seq +=2;
	}
}

- (void)fireBall:(NSNumber*) Color
{
	float speed = self.difficultFactor;
	Ball* theBall = [[Ball alloc] initWithOwner:self AndSpeed:(float)speed AndColor:[Color intValue] AndOrientation:self.orientation];
	[self addSubview:theBall];
	[self.ballQueue addObject:theBall];
	[theBall show];
	[theBall release];
	
	self.statTotalNum+=1;
}	
					 
-(void) removeFromQueue:(Ball*)theBall
{
	if (theBall.direction == self.state)	{
		self.hits +=1;
		self.statTotalSum+=1;
		[sharedSoundEffectsManager playMouthPopSound]; 
		[self.theLeftBaby beanCome:theBall.direction];
		[self.theCenterBaby beanCome:theBall.direction];
		[self.theRightBaby beanCome:theBall.direction];
		float rate = 1.36 / self.difficultFactor;
		switch (self.state)	{
			case(kRed):
				self.scoreFrame = CGRectOffset(self.theLeftBaby.frame, 30,-15);
				break;
			case(kGreen):
				self.scoreFrame = CGRectOffset(self.theCenterBaby.frame,30,-15);
				break;
			case (kBlue):
				self.scoreFrame = CGRectOffset(self.theRightBaby.frame,30,-15);
				break;
		}
		self.score += ceil(rate/5);
//		self.score = ((float)(self.hits)/(float)(self.noBeans)) * 10.0 * rate;
				
	}
	else {
		[sharedSoundEffectsManager playTapSound]; 
		[self.theLeftBaby beanCome:theBall.direction];
		[self.theCenterBaby beanCome:theBall.direction];
		[self.theRightBaby beanCome:theBall.direction];
		
		// For Master Level
		if ((self.difficultiesLevel == kWorldClass) && !_toQuit)	{
			[NSObject cancelPreviousPerformRequestsWithTarget:self];
			_toQuit = YES;
			[self showPlayAgain];
		}
	}
	
	[self.ballQueue removeObject:theBall];
	self.beanNo ++;
	if (self.beanNo >= self.noBeans)	{
		// For Master Level
		if (self.difficultiesLevel == kWorldClass)	{
			self.noRun = 10;
			[self switchScenario];
			
		}
		else
			[self showPlayAgain];
	}
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
		//[self bringSubviewToFront:self.theLeftBaby];
		[self.theLeftBaby moveUp];
	}
	//[self bringSubviewToFront:self.theCoverImg];
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
		//[self bringSubviewToFront:self.theRightBaby];
		[self.theRightBaby moveUp];
	}
	//[self bringSubviewToFront:self.theCoverImg];
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
		//[self bringSubviewToFront:self.theCenterBaby];
		[self.theCenterBaby moveUp];
	}
	//[self bringSubviewToFront:self.theCoverImg];
}

-(NSString*) getStat
{
	NSLog(@"statTotalSum is %d", (int)(self.statTotalSum));
	NSLog(@"statTotalNum is %d", self.statTotalNum);

	return [NSString stringWithFormat:NSLocalizedString(@"食中率:%2d%%", nil), (int)(100*(float)(self.statTotalSum/self.statTotalNum))];
}

-(UIImage*) getStatPic
{
	UIImageView* img = [[[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"redbean0" ofType:@"png"]]] autorelease];
	img.frame = CGRectMake(20,20,40,40);
	return img;
}

@end