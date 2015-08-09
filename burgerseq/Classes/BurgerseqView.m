//
//  BurgetseqView.m
//  bishibashi
//
//  Created by Eric on 21/03/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BurgerseqView.h"


@implementation BurgerseqView
@synthesize redButSample = _redButSample;
@synthesize greenButSample = _greenButSample;
@synthesize blueButSample = _blueButSample;

@synthesize curSeq = _curSeq;
@synthesize noSeq = _noSeq;
@synthesize seq = _seq;
@synthesize ingredients = _ingredients;
@synthesize currentRound = _currentRound;


static const CGRect redButRectP = {{30, 355}, {70, 24}};
static const CGRect redButRectL = {{30, 200}, {70, 16}};

static const CGRect greenButRectP = {{130, 355}, {70, 24}};
static const CGRect greenButRectL = {{130, 200}, {70, 16}};

static const CGRect blueButRectP = {{230, 355}, {70, 24}};
static const CGRect blueButRectL = {{230, 200}, {70, 16}};

static const CGRect backgroundRectP = {{20, 80}, {290, 310}};
static const CGRect backgroundRectL = {{30, 35}, {280, 200}};
static const CGRect backgroundRectR = {{15, 35}, {140, 200}};

static const CGRect SingleOKRect = {{100, 200}, {120, 140}};
static const CGRect SingleOKTimeRectP = {{100, 160}, {120, 30}};


- (void) dealloc	{
	self.seq = nil;
	self.ingredients = nil;
	self.redButSample = nil;
	self.greenButSample = nil;
	self.blueButSample = nil;
	
	[super dealloc];
}


- (void) startGame
{
	[super startGame];
	self.noRun = 10;
	// set time bar max value in VS mode
	if (self.gkMatch||self.gkSession)	{
		self.timeBar.maxValue=10;
		self.opponentTimeBar.maxValue=10;
		self.timeBar.currentValue = 0;
		self.opponentTimeBar.currentValue = 0;
		
		// set to normal for VS mode
		self.difficultiesLevel = kNormal;
	}
	
	if ((self.gameType != multi_players_arcade)&& (self.gameType != multi_players_level_select)){	
		if ((!self.isRemoteView) ){
			[self initScenarios:nil];
		}
	}
	self.currentRound=0;
	[self startRound];	
	if (self.remoteView)
		[self.remoteView startGame];
}

-(void) initBackground
{
	[super initBackground];
	
	UIImage* tmpImage = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"mcdonald" ofType:@"png"]];
	UIImageView* tmpView = [[UIImageView alloc] initWithImage:tmpImage];
	self.backgroundView = tmpView;
	[tmpView release];
	[self.backgroundView setFrame:backgroundRectP];
	[self addSubview:self.backgroundView];
		
	UIImageView* redButSample = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tomato.png"]];
	redButSample.frame = redButRectP;
	self.redButSample = redButSample;
	[self addSubview:redButSample];
	[redButSample release];

	UIImageView* greenButSample = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vegatable.png"]];
	greenButSample.frame = greenButRectP;
	self.greenButSample = greenButSample;
	[self addSubview:greenButSample];
	[greenButSample release];

	UIImageView* blueButSample = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"meat.png"]];
	blueButSample.frame = blueButRectP;
	self.blueButSample = blueButSample;
	[self addSubview:blueButSample];
	[blueButSample release];
}


- (void) initScenarios:(NSArray*)scenarios
{
	[super initScenarios:scenarios];
	if (!scenarios)
	{
		self.noRun = 10;
		/* scenario is an array of NSNumber for random color 0-2 */
		for (int i=0; i<self.noRun; i++)	{
			int noIngredients = arc4random()%8+3;
			NSMutableArray* scenario = [[NSMutableArray alloc] initWithCapacity:noIngredients];
			for (int j=0; j<noIngredients; j++)	
				[scenario addObject:[NSNumber numberWithInt:arc4random()%3]];
			[self.scenarios addObject:scenario];
			[scenario release];
		}
		if (self.difficultiesLevel == kWorldClass)	{
			for (int i=0; i<self.noRun; i++)	{
				int noIngredients = arc4random()%8+3;
				NSMutableArray* scenario = [[NSMutableArray alloc] initWithCapacity:noIngredients];
				for (int j=0; j<noIngredients; j++)	
					[scenario addObject:[NSNumber numberWithInt:arc4random()%3]];
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
	self.scenarios = self.scenarios2;
	for (int i=0; i<self.noRun; i++)	{
		for (int i=0; i<self.noRun; i++)	{
			int noIngredients = arc4random()%8+3;
			NSMutableArray* scenario = [[NSMutableArray alloc] initWithCapacity:noIngredients];
			for (int j=0; j<noIngredients; j++)	
				[scenario addObject:[NSNumber numberWithInt:arc4random()%3]];
			[self.scenarios2 addObject:scenario];
			[scenario release];
		}
	}
}

- (void) changeOrientationTo:(UIInterfaceOrientation) orientation
{
	[super changeOrientationTo:orientation];
	switch (orientation)	{
		case (UIInterfaceOrientationPortrait):
		case (UIInterfaceOrientationPortraitUpsideDown):
			self.redButSample.frame = redButRectP;
			self.greenButSample.frame = greenButRectP;
			self.blueButSample.frame = blueButRectP;
			self.backgroundView.frame = backgroundRectP;
			break;
		case (UIInterfaceOrientationLandscapeLeft):
		case (UIInterfaceOrientationLandscapeRight):
			self.redButSample.frame = redButRectL;
			self.greenButSample.frame = greenButRectL;
			self.blueButSample.frame = blueButRectL;
			self.backgroundView.frame = backgroundRectL;			
			break;
		case (10):
			self.backgroundView.frame = backgroundRectR;
			[self.redButSample setHidden:YES];
			[self.greenButSample setHidden:YES];
			[self.blueButSample setHidden:YES];
			break;
	}
	
}

- (void) startRound	{
	@synchronized(self)	{
	if (self.difficultiesLevel == kWorldClass)
	{
		if (self.noRun==0)	{
			self.noRun=10;
			[self switchScenario];
		}
	}
	if (self.noRun==0)	{
		[self showPlayAgain];
	}
	else {
		[self enableButtons];
		[super startRound];
		if (self.seq)	{
			for (Ingredient* sample in self.seq)	{
				[sample removeFromSuperview];
			}
		}
		
		if (self.ingredients)	{
			for (Ingredient* sample in self.ingredients)	{
				[sample removeFromSuperview];
			}
		}

		
		self.noRun--;
		self.seq = nil;
		self.ingredients = nil;
		
		NSArray* scenario = [self.scenarios objectAtIndex:self.currentRound];
		self.noSeq = [scenario count];
		NSMutableArray* theSeq = [[NSMutableArray alloc] initWithCapacity:[scenario count]];
		self.seq = theSeq;
		[theSeq release];
		theSeq = [[NSMutableArray alloc] initWithCapacity:[scenario count]];
		self.ingredients = theSeq;
		[theSeq release];
		Ingredient* bottom = [[Ingredient alloc] initWithColor:-2 AndPos:0 AndSample:YES AndOrientation:self.orientation];
		[self addSubview:bottom];
		[self.seq addObject:bottom];
		[bottom show];
		[bottom release];
		for (int i=1; i<[scenario count]; i++)	{
			Ingredient* sample = [[Ingredient alloc] initWithColor:[[scenario objectAtIndex:i]intValue] AndPos:i AndSample:YES AndOrientation:self.orientation];
			[self addSubview:sample];
			[self.seq addObject:sample];
			[NSTimer scheduledTimerWithTimeInterval:0.3*i target:sample selector:@selector(show) userInfo:nil repeats:NO];
			[sample release];
		}
		Ingredient* top = [[Ingredient alloc] initWithColor:-1 AndPos:[scenario count] AndSample:YES AndOrientation:self.orientation];
		[self.seq addObject:top];
		[self addSubview:top];
		[NSTimer scheduledTimerWithTimeInterval:0.3*[scenario count] target:top selector:@selector(show) userInfo:nil repeats:NO];
		[top release];
		
		bottom = [[Ingredient alloc] initWithColor:-2 AndPos:0 AndSample:NO AndOrientation:self.orientation];
		[self addSubview:bottom];
		[self.ingredients addObject:bottom];
		[bottom show];
		[bottom release];
		
		self.currentRound++;
		self.curSeq = 1;
		
		self.overheadTime = 0.5+[self.seq count]*0.25;
		[self setTimer:0.5+self.difficultFactor*[self.seq count]];
		// will this crash?
		[self enableButtons];
	}
	}
}	

- (void) fail	{
	/* send time spent to opponent */
	if (self.gkMatch||self.gkSession)	{
		NSLog(@"Failed. no run is %d", self.noRun);
		self.gamePacket.packetType = kGKPacketTypeTimeUsed;
		self.gamePacket.timeUsed = -1.0;
		self.myTimeUsed=self.gamePacket.timeUsed;
		NSLog(@"gamePacket.timeUsed is %f", self.gamePacket.timeUsed);
		NSError* error;
		if (self.gkMatch)
			[self.gkMatch sendDataToAllPlayers:[self.gamePacket toNSData] withDataMode:GKSendDataReliable error:&error];
		else
			[self.gkSession sendDataToAllPeers:[self.gamePacket toNSData] withDataMode:GKSendDataReliable error:&error];

	}
	
	[sharedSoundEffectsManager playFailSound];
	[self disableButtons];
	
	// do not show the big cross in VS mode
	if (!self.gkMatch && !self.gkSession)	{
		float timeUsed = -(float)[self.roundStartTime timeIntervalSinceNow];
		self.statTotalSum += timeUsed;
		[self addSubview:self.crossView];	
		[self.crossView setFrame:CGRectMake(self.crossView.frame.origin.x-1, self.crossView.frame.origin.y, self.crossView.frame.size.width, self.crossView.frame.size.height)];
		[UIView beginAnimations:@"fail_end" context:nil];
		[UIView setAnimationDuration:0.6];
		[UIView setAnimationDelegate:self]; 
		[UIView setAnimationDidStopSelector: @selector(animationDidStop:finished:context:)];	
		[self.crossView setFrame:CGRectMake(self.crossView.frame.origin.x+1, self.crossView.frame.origin.y, self.crossView.frame.size.width, self.crossView.frame.size.height)];
		[UIView commitAnimations];
		[self.theTimer invalidate];
	}
	else {
		[self showRoundVSResult];
	}
}

- (void) success {
	Ingredient* top = [[Ingredient alloc] initWithColor:-1 AndPos:self.noSeq AndSample:NO AndOrientation:self.orientation];
	[self.ingredients addObject:top];
	[self addSubview:top];
	[top show];
	self.scoreFrame = CGRectOffset(top.frame, 30, -15);
	[top release];
	self.score += (int)([self calScore]/10.0);
	
	[sharedSoundEffectsManager playYeahSound];
	[self disableButtons];
	[self.theTimer invalidate];
	
	// do not show the big OK in VS mode
	if (!self.gkMatch && !self.gkSession)	{
		self.OKView.frame = SingleOKRect;
		self.myOKView.frame = SingleOKTimeRectP;
		self.myOKView.font = [UIFont systemFontOfSize:24];
		float timeUsed = -(float)[self.roundStartTime timeIntervalSinceNow];
		self.statTotalSum += timeUsed;
		[self.myOKView setTime:timeUsed];
		[self addSubview:self.OKView];
		[self addSubview:self.myOKView];
		[UIView beginAnimations:@"success_end" context:nil];
		[UIView setAnimationDuration:0.6];
		[UIView setAnimationDelegate:self]; 
		[UIView setAnimationDidStopSelector: @selector(animationDidStop:finished:context:)];	
		self.OKView.frame = CGRectOffset(self.OKView.frame, 0.1, 0);
		self.myOKView.frame = CGRectOffset(self.myOKView.frame, 0.1, 0);
		[UIView commitAnimations];
	}
	else {
		self.gamePacket.packetType = kGKPacketTypeTimeUsed;
		self.gamePacket.timeUsed = -(float)[self.roundStartTime timeIntervalSinceNow];
		self.myTimeUsed=self.gamePacket.timeUsed;
		NSLog(@"gamePacket.timeUsed is %f", self.gamePacket.timeUsed);
		NSError* error;
		if (self.gkMatch)
			[self.gkMatch sendDataToAllPlayers:[self.gamePacket toNSData] withDataMode:GKSendDataReliable error:&error];		
		else
			[self.gkSession sendDataToAllPeers:[self.gamePacket toNSData] withDataMode:GKSendDataReliable error:&error];		

		[self showRoundVSResult];
	}
}


- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	int contextid = [((NSNumber*)context) intValue];
	if ([animationID isEqualToString:@"success_end"] || [animationID isEqualToString:@"fail_end"])	{
		[self.crossView removeFromSuperview];
		[self.OKView removeFromSuperview];		
		[self.myOKView removeFromSuperview];
		if (self.gameType == multi_players_level_select){
			;
		}else if (!_toQuit){
			if (([animationID isEqualToString:@"fail_end"]) && (self.difficultiesLevel == kWorldClass))	{
				self.noRun=0;
				[self showPlayAgain];
			}
			else{
				if (self.gkMatch||self.gkSession)	{
					[self showRoundVSResult];
				}
				else
					[self startRound];
			}
		}
	}
}


- (void) redButClicked
{
	[super redButClicked];
	Ingredient* sample = [[Ingredient alloc] initWithColor:kRed AndPos:self.curSeq AndSample:NO AndOrientation:self.orientation];
	[self addSubview:sample];
	[self.ingredients addObject:sample];
	[sample show];
	[sample release];
	
	if ([[self.seq objectAtIndex:self.curSeq] color] == kRed)	{
		self.statTotalNum++;
		[sharedSoundEffectsManager playDropSound];
		self.curSeq ++;
		if (self.curSeq == self.noSeq)
			[self success];
	}
	else	
		[self fail];		
}

- (void) blueButClicked
{
	[super blueButClicked];
	Ingredient* sample = [[Ingredient alloc] initWithColor:kBlue AndPos:self.curSeq AndSample:NO AndOrientation:self.orientation];
	[self addSubview:sample];
	[self.ingredients addObject:sample];
	[sample show];
	[sample release];
	if ([[self.seq objectAtIndex:self.curSeq] color] == kBlue)	{
		self.statTotalNum++;
		[sharedSoundEffectsManager playDropSound];
		self.curSeq ++;
		if (self.curSeq == self.noSeq)
			[self success];
	}
	else	
		[self fail];		
}

- (void) greenButClicked
{
	[super greenButClicked];
	Ingredient* sample = [[Ingredient alloc] initWithColor:kGreen AndPos:self.curSeq AndSample:NO AndOrientation:self.orientation];
	[self addSubview:sample];
	[self.ingredients addObject:sample];
	[sample show];
	[sample release];
	if ([[self.seq objectAtIndex:self.curSeq] color] == kGreen)	{
		self.statTotalNum++;
		[sharedSoundEffectsManager playDropSound];
		self.curSeq ++;
		if (self.curSeq == self.noSeq)
			[self success];
	}
	else	
		[self fail];		
}

// overwrite setScore for VS mode to not send /update time bar
- (void) setScore:(int) score
{
	if (!self.gkMatch&&!self.gkSession)
		[super setScore:score];
}

-(NSString*) getStat
{
	return [NSString stringWithFormat:NSLocalizedString(@"每材料用:%1.2fs", nil), (float)(self.statTotalSum/self.statTotalNum)];
}

-(UIImage*) getStatPic
{
	UIImageView* img = [[[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"meat" ofType:@"png"]]] autorelease];
	img.frame = CGRectMake(10,20,60,20);
	return img;
}
@end
