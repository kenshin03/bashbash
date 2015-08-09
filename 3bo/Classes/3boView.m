//
//  3boView.m
//  bishibashi
//
//  Created by Eric on 23/03/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "3boView.h"
#import "TitleMenuViewController.h"


@implementation the3BoView
@synthesize curSeq = _curSeq;
@synthesize seq = _seq;
@synthesize opponentSeq = _opponentSeq;
@synthesize finishedseq = _finishedseq;
@synthesize stickView = _stickView;

@synthesize redButSample = _redButSample;
@synthesize greenButSample = _greenButSample;
@synthesize blueButSample = _blueButSample;


static const CGRect redButRectP = {{30, 335}, {60, 50}};
static const CGRect redButRectL = {{30, 200}, {60, 35}};

static const CGRect greenButRectP = {{130, 335}, {60, 50}};
static const CGRect greenButRectL = {{130, 200}, {60, 35}};

static const CGRect blueButRectP = {{230, 335}, {60, 50}};
static const CGRect blueButRectL = {{230, 200}, {60, 35}};

static const CGRect backgroundRectP = {{20, 80}, {290, 310}};
static const CGRect backgroundRectL = {{30, 30}, {280, 210}};
static const CGRect backgroundRectR = {{15, 40}, {0, 0}};


- (void) dealloc	{
	self.seq = nil;
	self.opponentSeq = nil;
	self.stickView = nil;
	self.finishedseq = nil;
	self.redButSample = nil;
	self.blueButSample = nil;
	self.greenButSample = nil;

	[super dealloc];
}


- (void) startGame
{
	_VSModeIsRoundBased = NO;
	
	// set to normal for VS mode
	if (self.gkSession || self.gkMatch)	{
		self.difficultiesLevel = kNormal;
	}
	[super startGame];
	

	[self startRound];	
	if (self.remoteView)
		[self.remoteView startGame];
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
	
	UIImageView* redButSample = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"redbo.png"]];
	redButSample.frame = redButRectP;
	[self addSubview:redButSample];
	self.redButSample = redButSample;
	[redButSample release];
	
	UIImageView* greenButSample = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"greenbo.png"]];
	greenButSample.frame = greenButRectP;
	[self addSubview:greenButSample];
	self.greenButSample = greenButSample;
	[greenButSample release];
	
	UIImageView* blueButSample = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bluebo.png"]];
	blueButSample.frame = blueButRectP;
	[self addSubview:blueButSample];
	self.blueButSample = blueButSample;
	[blueButSample release];
}

- (void) initImages {
	[super initImages];
	
	UIImageView* tmpView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"stick.png"]];
	[self addSubview:tmpView];
	self.stickView = tmpView;
	[tmpView release];
	[self.stickView setFrame:CGRectMake(0, 320, self.stickView.frame.size.width, self.stickView.frame.size.height)];

}

- (void) initScenarios:(NSArray*)scenarios
{
	self.noRun = 40;
	[super initScenarios:scenarios];
	if (!scenarios)
	{
		/* scenario is an array of noRun NSNumber for random number 1-24 */
		for (int i=0; i<self.noRun; i++)	{
			NSNumber* scenario = [NSNumber numberWithInt:arc4random()%3];
			[self.scenarios addObject:scenario];
		}
		if (self.difficultiesLevel == kWorldClass)	{
			for (int i=0; i<self.noRun; i++)	{
				NSNumber* scenario = [NSNumber numberWithInt:arc4random()%3];
				[self.scenarios2 addObject:scenario];
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
		NSNumber* scenario = [NSNumber numberWithInt:arc4random()%3];
		[self.scenarios2 addObject:scenario];
	}
	for (NSNumber* theNumber in self.scenarios)	{
		Bo* sample = [[Bo alloc] initWithColor:[theNumber intValue] AndPos:[self.seq count] AndOrientation:self.orientation AndIsMyself:YES];
		[self addSubview:sample];
		[self.seq addObject:sample];
		[sample release];
	}		
	
}

- (void) changeOrientationTo:(UIInterfaceOrientation) orientation
{
	[self clearScreen];
	[super changeOrientationTo:orientation];
	switch (orientation)	{
		case (UIInterfaceOrientationPortrait):
		case (UIInterfaceOrientationPortraitUpsideDown):
			self.backgroundView.frame = backgroundRectP;
			self.redButSample.frame = redButRectP;
			self.greenButSample.frame = greenButRectP;
			self.blueButSample.frame = blueButRectP;
			self.stickView.frame = CGRectMake(0,300, self.stickView.frame.size.width, self.stickView.frame.size.height);
			break;
		case (UIInterfaceOrientationLandscapeLeft):
		case (UIInterfaceOrientationLandscapeRight):
			self.backgroundView.frame = backgroundRectL;
			self.redButSample.frame = redButRectL;
			self.greenButSample.frame = greenButRectL;
			self.blueButSample.frame = blueButRectL;
			self.stickView.frame = CGRectMake(0,170, self.stickView.frame.size.width, self.stickView.frame.size.height);
			break;
		case (10):
			self.backgroundView.frame = backgroundRectR;
			[self.redButSample setHidden:YES];
			[self.greenButSample setHidden:YES];
			[self.blueButSample setHidden:YES];
			self.stickView.frame = CGRectMake(0,210, 90, self.stickView.frame.size.height);
			break;
	}
	
}

- (void) playAgainButClicked{
	[self clearScreen];
	[super playAgainButClicked];
}

- (void) clearScreen	{
	if (self.seq)	{
		for (Bo* sample in self.seq)	{
			[sample removeFromSuperview];
		}
	}
	if (self.finishedseq)	{
		for (Bo* sample in self.finishedseq)	{
			[sample removeFromSuperview];
		}
	}
	self.seq=nil;
	self.finishedseq=nil;
}

- (void) prepareToStartGameWithNewScenario:(BOOL)newScenario
{
	[super prepareToStartGameWithNewScenario:newScenario];

	if ((self.gameType != multi_players_arcade)&& (self.gameType != multi_players_level_select)){	
		if ((!self.isRemoteView) && newScenario){
			self.scenarios = nil;
			[self initScenarios:nil];
		}
	}
	self.noRun = 40;
	
	
	if (self.seq)	{
		for (Bo* sample in self.seq)	{
			[sample removeFromSuperview];
		}
	}
	if (self.finishedseq)	{
		for (Bo* sample in self.finishedseq)	{
			[sample removeFromSuperview];
		}
	}
	NSMutableArray* theSeq = [[NSMutableArray alloc] initWithCapacity:self.noRun];
	self.seq = theSeq;
	[theSeq release];
	
	theSeq = [[NSMutableArray alloc] initWithCapacity:self.noRun];
	self.finishedseq = theSeq;
	[theSeq release];
	
	for (int i=0; i<self.noRun; i++)	{
		Bo* sample = [[Bo alloc] initWithColor:[[self.scenarios objectAtIndex:i] intValue] AndPos:i AndOrientation:self.orientation AndIsMyself:YES];
		[self addSubview:sample];
		[self.seq addObject:sample];
		[sample release];
	}		
	if (self.gkMatch||self.gkSession)	{
		if (self.opponentSeq){
			for (Bo* sample in self.opponentSeq)	
				[sample removeFromSuperview];
		}
		NSMutableArray* theSeq = [[NSMutableArray alloc] initWithCapacity:self.noRun];
		self.opponentSeq = theSeq;
		[theSeq release];
		for (int i=0; i<self.noRun; i++)	{
			Bo* sample = [[Bo alloc] initWithColor:[[self.scenarios objectAtIndex:i] intValue] AndPos:i AndOrientation:self.orientation AndIsMyself:NO];
			[self addSubview:sample];
			[self.opponentSeq addObject:sample];
			[sample release];
		}		
	}		
}


- (void) startRound	{
	self.curSeq = 0;
	self.overheadTime = [self.seq count]*0.225;
	[super startRound];
	if (self.difficultiesLevel!=kWorldClass)
		[self setTimer:self.difficultFactor];
	else	{
		[self setTimer:2];
		self.remainedTime=1;
		[self.roundStartTime init]; 
	}

}	

- (void) failGame{
	self.statTotalSum = -(float)[self.roundStartTime timeIntervalSinceNow];
	/* send time spent to opponent if game end*/
	if ((self.gkMatch||self.gkSession) && [[GameCenterManager sharedInstance] theGameState]==kGKGameStateEnded)	{
		self.gamePacket.packetType = kGKPacketTypeEndWithTimeUsed;
		self.gamePacket.timeUsed = -(float)[self.roundStartTime timeIntervalSinceNow];
		NSLog(@"gamePacket.timeUsed is %f", self.gamePacket.timeUsed);
		NSError* error;
		if (self.gkMatch)
			[self.gkMatch sendDataToAllPlayers:[self.gamePacket toNSData] withDataMode:GKSendDataReliable error:&error];
		else
			[self.gkSession sendDataToAllPeers:[self.gamePacket toNSData] withDataMode:GKSendDataReliable error:&error];

	}
	[self showPlayAgain];
}

- (void) fail	{
	[sharedSoundEffectsManager playFailSound];
	[self disableButtons];
	[self addSubview:self.crossView];	
	[self.crossView setFrame:CGRectMake(self.crossView.frame.origin.x-1, self.crossView.frame.origin.y, self.crossView.frame.size.width, self.crossView.frame.size.height)];
	[UIView beginAnimations:@"end" context:nil];
	[UIView setAnimationDuration:0.6];
	[UIView setAnimationDelegate:self]; 
	[UIView setAnimationDidStopSelector: @selector(animationDidStop:finished:context:)];	
	[self.crossView setFrame:CGRectMake(self.crossView.frame.origin.x+1, self.crossView.frame.origin.y, self.crossView.frame.size.width, self.crossView.frame.size.height)];
	[UIView commitAnimations];
}

-(void) changeStick	{
	@synchronized(self.finishedseq)	{
		for (Bo* theBo in self.finishedseq)	{
			[theBo removeFromSuperview];
		}
		[self.finishedseq removeAllObjects];
	}
}
	
- (void) moveStick	{	
	self.statTotalNum++;
	switch (self.orientation)	{
		case (UIInterfaceOrientationPortrait):
		case (UIInterfaceOrientationPortraitUpsideDown):
			self.stickView.frame = CGRectMake(0,300, self.stickView.frame.size.width, self.stickView.frame.size.height);
			break;
		case (UIInterfaceOrientationLandscapeLeft):
		case (UIInterfaceOrientationLandscapeRight):
			self.stickView.frame = CGRectMake(0,170, self.stickView.frame.size.width, self.stickView.frame.size.height);
			break;
		case (10):
			self.stickView.frame = CGRectMake(0,210, 90, self.stickView.frame.size.height);
			break;
	}	
	[UIView beginAnimations:@"moveStick" context:nil];
	[UIView setAnimationDuration:0.1];
	[UIView setAnimationDelegate:self]; 
	[UIView setAnimationDidStopSelector: @selector(animationDidStop:finished:context:)];	
	[UIView setAnimationBeginsFromCurrentState:YES];
	switch (self.orientation)	{
		case (UIInterfaceOrientationPortrait):
		case (UIInterfaceOrientationPortraitUpsideDown):
			self.stickView.frame = CGRectMake(120,300, self.stickView.frame.size.width, self.stickView.frame.size.height);
			break;
		case (UIInterfaceOrientationLandscapeLeft):
		case (UIInterfaceOrientationLandscapeRight):
			self.stickView.frame = CGRectMake(120,170, self.stickView.frame.size.width, self.stickView.frame.size.height);
			break;
		case (10):
			self.stickView.frame = CGRectMake(60,210, 90, self.stickView.frame.size.height);
			break;
	}	
	[UIView commitAnimations];
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	int contextid = [((NSNumber*)context) intValue];
	if ([animationID isEqualToString:@"end"])	{
		[self.crossView removeFromSuperview];
		[self enableButtons];
	}
	else if ([animationID isEqualToString:@"moveStick"])	{
		[UIView beginAnimations:@"moveStick2" context:nil];
		[UIView setAnimationDuration:0.1];
		[UIView setAnimationBeginsFromCurrentState:YES];
		switch (self.orientation)	{
			case (UIInterfaceOrientationPortrait):
			case (UIInterfaceOrientationPortraitUpsideDown):
				self.stickView.frame = CGRectMake(0,300, self.stickView.frame.size.width, self.stickView.frame.size.height);
				break;
			case (UIInterfaceOrientationLandscapeLeft):
			case (UIInterfaceOrientationLandscapeRight):
				self.stickView.frame = CGRectMake(0,170, self.stickView.frame.size.width, self.stickView.frame.size.height);
				break;
			case (10):
				self.stickView.frame = CGRectMake(0,210, 90, self.stickView.frame.size.height);
				break;
		}	
		[UIView commitAnimations];
	}
	
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
		if (self.difficultiesLevel == kWorldClass)	{
			self.remainedTime -= 0.25;
			if (self.curSeq == self.noRun-20)	{
				[self switchScenario];
				self.noRun+=40;
			}
			else if (self.curSeq%40==0)
				[self changeStick];
		}
		if (self.curSeq == self.noRun)	{
			/* send time spent to opponent if game end*/
			if (self.gkMatch||self.gkSession)	{
				self.score = self.curSeq;
				self.gamePacket.packetType = kGKPacketTypeEndWithTimeUsed;
				self.gamePacket.timeUsed = -(float)[self.roundStartTime timeIntervalSinceNow];
				NSLog(@"gamePacket.timeUsed is %f", self.gamePacket.timeUsed);
				NSError* error;
				if (self.gkMatch)
					[self.gkMatch sendDataToAllPlayers:[self.gamePacket toNSData] withDataMode:GKSendDataReliable error:&error];
				else
					[self.gkSession sendDataToAllPeers:[self.gamePacket toNSData] withDataMode:GKSendDataReliable error:&error];

			}			
			self.statTotalSum = -(float)[self.roundStartTime timeIntervalSinceNow];
			[self showPlayAgain];
		}
		
	}
	else	
		if (self.difficultiesLevel==kWorldClass)	{
			self.statTotalSum = -(float)[self.roundStartTime timeIntervalSinceNow];
			[self showPlayAgain];
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
		if (self.difficultiesLevel == kWorldClass)	{
			self.remainedTime -= 0.25;
			if (self.curSeq == self.noRun-20)	{
				[self switchScenario];
				self.noRun+=40;
			}
			else if (self.curSeq%40==0)
				[self changeStick];
		}
		if (self.curSeq == self.noRun)	{
			/* send time spent to opponent if game end*/
			if (self.gkMatch||self.gkSession)	{
				self.score = self.curSeq;
				self.gamePacket.packetType = kGKPacketTypeEndWithTimeUsed;
				self.gamePacket.timeUsed = -(float)[self.roundStartTime timeIntervalSinceNow];
				NSLog(@"gamePacket.timeUsed is %f", self.gamePacket.timeUsed);
				NSError* error;
				if (self.gkMatch)
					[self.gkMatch sendDataToAllPlayers:[self.gamePacket toNSData] withDataMode:GKSendDataReliable error:&error];
				else 
					[self.gkSession sendDataToAllPeers:[self.gamePacket toNSData] withDataMode:GKSendDataReliable error:&error];					
				

			}
			self.statTotalSum = -(float)[self.roundStartTime timeIntervalSinceNow];
			[self showPlayAgain];
		}
	}
	else	
		if (self.difficultiesLevel==kWorldClass)	{
			self.statTotalSum = -(float)[self.roundStartTime timeIntervalSinceNow];
			[self showPlayAgain];
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
		if (self.difficultiesLevel == kWorldClass)	{
			self.remainedTime -= 0.25;
			if (self.curSeq == self.noRun-20)	{
				[self switchScenario];
				self.noRun+=40;
			}
			else if (self.curSeq%40==0)
				[self changeStick];
		}
		if (self.curSeq == self.noRun)	{
			/* send time spent to opponent if game end*/
			if (self.gkMatch||self.gkSession)	{
				self.score = self.curSeq;
				self.gamePacket.packetType = kGKPacketTypeEndWithTimeUsed;
				self.gamePacket.timeUsed = -(float)[self.roundStartTime timeIntervalSinceNow];
				NSLog(@"gamePacket.timeUsed is %f", self.gamePacket.timeUsed);
				NSError* error;
				if (self.gkMatch)
					[self.gkMatch sendDataToAllPlayers:[self.gamePacket toNSData] withDataMode:GKSendDataReliable error:&error];
				else
					[self.gkSession sendDataToAllPeers:[self.gamePacket toNSData] withDataMode:GKSendDataReliable error:&error];

			}
			self.statTotalSum = -(float)[self.roundStartTime timeIntervalSinceNow];
			[self showPlayAgain];
		}
		
	}
	else	
		if (self.difficultiesLevel==kWorldClass)	{
			self.statTotalSum = -(float)[self.roundStartTime timeIntervalSinceNow];
			[self showPlayAgain];
		}
		else
			[self fail];		
}

- (void) redButClickedOpponent
{
	if ([[self.opponentSeq objectAtIndex:0] color] == kRed)	{
		[[self.opponentSeq objectAtIndex:0] removeFromSuperview];
		[self.opponentSeq removeObjectAtIndex:0];
//		self.curSeq ++;
		for (Bo* bo in self.opponentSeq)
			[bo show];
	}
}

- (void) blueButClickedOpponent
{
	if ([[self.opponentSeq objectAtIndex:0] color] == kBlue)	{
		[[self.opponentSeq objectAtIndex:0] removeFromSuperview];
		[self.opponentSeq removeObjectAtIndex:0];
		//		self.curSeq ++;
		for (Bo* bo in self.opponentSeq)
			[bo show];
	}
}
- (void) greenButClickedOpponent
{
	if ([[self.opponentSeq objectAtIndex:0] color] == kGreen)	{
		[[self.opponentSeq objectAtIndex:0] removeFromSuperview];
		[self.opponentSeq removeObjectAtIndex:0];
		//		self.curSeq ++;
		for (Bo* bo in self.opponentSeq)
			[bo show];
	}
}

- (void) updateTimeBar:(NSTimer*)theTimer
{
	if (self.difficultiesLevel == kWorldClass)	{
		self.score = self.curSeq;
		self.remainedTime +=0.2;
		if (self.remainedTime<0)
			self.timePie.curVal = 0;
		else if (self.remainedTime>2)	{
			self.timePie.curVal = 2;
			[self showPlayAgain];
		}
		else
			self.timePie.curVal = self.remainedTime;
	}
	else {
		[super updateTimeBar:theTimer];
		// single mode, calculate score
		if (!self.gkMatch&&!self.gkSession)
			self.score = [self calScore];
		// VS mode score = curSeq
		else {
			self.score = self.curSeq;
		}

	}
}

-(NSString*) getStat
{
	return [NSString stringWithFormat:NSLocalizedString(@"每個用:%1.2fs", nil), (float)(self.statTotalSum/self.statTotalNum)];
}

-(UIImage*) getStatPic
{
	UIImageView* img = [[[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"redbo" ofType:@"png"]]] autorelease];
	img.frame = CGRectMake(20,20,40,40);
	return img;
}
@end