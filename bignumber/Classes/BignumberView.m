//
//  BignumberView.m
//  bishibashi
//
//  Created by Eric on 25/03/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BignumberView.h"

@implementation BignumberView
@synthesize redDice = _redDice;
@synthesize greenDice = _greenDice;
@synthesize blueDice = _blueDice;
@synthesize currentRound = _currentRound;

static const CGRect backgroundRectP = {{10, 80}, {300, 310}};
static const CGRect backgroundRectL = {{10, 30}, {300, 210}};
static const CGRect backgroundRectR = {{15, 40}, {0, 0}};

static const CGRect SingleOKRect = {{100, 210}, {120, 140}};
static const CGRect SingleOKTimeRectP = {{100, 170}, {120, 40}};

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
	[sharedSoundEffectsManager stopMahjongNoiseSound];
	self.redDice = nil;
	self.greenDice = nil;
	self.blueDice = nil;

	[super dealloc];
}

- (void) prepareToStartGameWithNewScenario:(BOOL)newScenario
{
	// to make the initial start round startable
	self.myTimeUsed = 1.0;
	self.opponentTimeUsed = 1.0;

	self.noRun = 10;
	self.overheadTime=1.84;
	self.currentRound=0;
	
	if ((self.gameType != multi_players_arcade)&& (self.gameType != multi_players_level_select)){	
		if ((!self.isRemoteView)){
			if (newScenario)	{
				[self.scenarios removeAllObjects];
				[self initScenarios:nil];
			}
		}
	}
	[super prepareToStartGameWithNewScenario:newScenario];
}

- (void) changeOrientationTo:(UIInterfaceOrientation) orientation
{
	[super changeOrientationTo:orientation];
	[self.redDice changeOrientationTo:orientation];
	[self.greenDice changeOrientationTo:orientation];
	[self.blueDice changeOrientationTo:orientation];	
	
	switch (orientation)	{
		case (UIInterfaceOrientationPortrait):
		case (UIInterfaceOrientationPortraitUpsideDown):
			self.backgroundView.frame = backgroundRectP;
			break;
		case (UIInterfaceOrientationLandscapeLeft):
		case (UIInterfaceOrientationLandscapeRight):
			self.backgroundView.frame = backgroundRectL;
			break;
		case (10):
			self.backgroundView.frame = backgroundRectR;
			break;
	}
}

- (void) initScenarios:(NSArray*)scenarios
{
	[super initScenarios:scenarios];
	if (!scenarios)
	{
		self.noRun = 10;
		/* scenario is an array of 3 NSNumber(integer) of random number 1-6 */
		for (int i=0; i<self.noRun; i++)	{
			NSArray* scenario = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:arc4random()%6+1],[NSNumber numberWithInt:arc4random()%6+1], [NSNumber numberWithInt:arc4random()%6+1], nil];
			[self.scenarios addObject:scenario];
			[scenario release];
		}
		
		if (self.difficultiesLevel == kWorldClass)	{
			for (int i=0; i<self.noRun; i++)	{
				NSArray* scenario = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:arc4random()%6+1],[NSNumber numberWithInt:arc4random()%6+1], [NSNumber numberWithInt:arc4random()%6+1], nil];
				[self.scenarios2 addObject:scenario];
				[scenario release];
			}
		}
	}
	if (self.remoteView){
		[self.remoteView initScenarios:self.scenarios];
	}
}

- (void) switchScenario
{
	self.scenarios2 = self.scenarios;
	for (int i=0; i<self.noRun; i++)	{
		NSArray* scenario = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:arc4random()%6+1],[NSNumber numberWithInt:arc4random()%6+1], [NSNumber numberWithInt:arc4random()%6+1], nil];
		[self.scenarios2 addObject:scenario];
		[scenario release];
	}
}
- (void) startGame
{
	[super startGame];
	// set time bar max value in VS mode
	if (self.gkMatch||self.gkSession)	{
		self.timeBar.maxValue=10;
		self.opponentTimeBar.maxValue=10;
		self.timeBar.currentValue = 0;
		self.opponentTimeBar.currentValue = 0;
		
		// set to normal for VS mode
		self.difficultiesLevel = kNormal;
	}
	
	[self startRound];	
	
	if (self.remoteView)
		[self.remoteView startGame];
}

- (void) initImages {
	[super initImages];
	
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
	
	Dice* dice = [[Dice alloc] initWithColor:kRed AndVal:arc4random()%6+1];
	self.redDice = dice;
	[self addSubview:dice];
	[dice release];
	dice = [[Dice alloc] initWithColor:kGreen AndVal:arc4random()%6+1];
	self.greenDice = dice;
	[self addSubview:dice];
	[dice release];
	dice = [[Dice alloc] initWithColor:kBlue AndVal:arc4random()%6+1];
	self.blueDice = dice;
	[self addSubview:dice];
	[dice release];
	
}


- (void) startRound	{
	if (self.difficultiesLevel == kWorldClass)
	{
		if (self.noRun==0)	{
			self.noRun=10;
			[self switchScenario];
		}
	}
	if (self.noRun==0)	{
		[sharedSoundEffectsManager stopMahjongNoiseSound];
		[self showPlayAgain];
	}
	else {
		[super startRound];

	
		NSArray* Scenario = [self.scenarios objectAtIndex:self.currentRound];
		self.redDice.val = [[Scenario objectAtIndex:0] intValue];
		self.greenDice.val = [[Scenario objectAtIndex:1] intValue];
		self.blueDice.val = [[Scenario objectAtIndex:2] intValue];
		self.currentRound++;

		[self.redDice show];
		[self.greenDice show];
		[self.blueDice show];
		[self setTimer:self.difficultFactor];
		
		[sharedSoundEffectsManager playMahjongNoiseSound];
		
	}
	self.noRun--;
}	

- (void) fail	{
	/* send time spent to opponent */
	if (self.gkMatch || self.gkSession)	{
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
		[self addSubview:self.crossView];	
		[self.crossView setFrame:CGRectMake(self.crossView.frame.origin.x-1, self.crossView.frame.origin.y, self.crossView.frame.size.width, self.crossView.frame.size.height)];
		[UIView beginAnimations:@"fail_end" context:nil];
		[UIView setAnimationDuration:0.6];
		[UIView setAnimationDelegate:self]; 
		[UIView setAnimationDidStopSelector: @selector(animationDidStop:finished:context:)];	
		[self.crossView setFrame:CGRectMake(self.crossView.frame.origin.x+1, self.crossView.frame.origin.y, self.crossView.frame.size.width, self.crossView.frame.size.height)];
		[UIView commitAnimations];
	}
	else {
		[self showRoundVSResult];
	}
}

- (void) success	{
	self.statTotalNum++;
	self.score += (int)([self calScore]/10.0);
	[sharedSoundEffectsManager playYeahSound];
	[self disableButtons];
	
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
		[self enableButtons];
		
		if (self.gameType == multi_players_level_select){
			;
		}else if (!_toQuit){
			if ((self.difficultiesLevel == kWorldClass) && [animationID isEqualToString:@"fail_end"])	{
				[sharedSoundEffectsManager stopMahjongNoiseSound];
				[self showPlayAgain];
			}
			else {
				if (self.gkMatch || self.gkSession)	{
					[self showRoundVSResult];
				}
				else
					[self startRound];
			}		}
		
	}
}


- (void) redButClicked
{
	[self.theTimer invalidate];
	[super redButClicked];
	if (self.redDice.val >= self.greenDice.val && self.redDice.val >= self.blueDice.val)	{
		self.scoreFrame = CGRectOffset(self.redDice.frame, 20, -20);
		[self success];
	}
	else	{
		[self fail];	
	}
}

- (void) blueButClicked
{
	[self.theTimer invalidate];
	[super blueButClicked];
	if (self.blueDice.val >= self.greenDice.val && self.blueDice.val >= self.redDice.val)	{
		self.scoreFrame = CGRectOffset(self.blueDice.frame, 20, -20);
		[self success];
	}
	else	{
		[self fail];	
	}
}

- (void) greenButClicked
{
	[self.theTimer invalidate];
	[super greenButClicked];
	if (self.greenDice.val >= self.redDice.val && self.greenDice.val >= self.blueDice.val)	{
		self.scoreFrame = CGRectOffset(self.greenDice.frame, 20, -20);
		[self success];
	}
	else
		[self fail];	
}

- (void) switchToConfig
{
	if ([self.owner mustLandscape])
		[self.owner setMustLandscape:NO];
	else
		[self.owner setMustLandscape:YES];
}

// overwrite setScore for VS mode to not send /update time bar
- (void) setScore:(int) score
{
	if (!self.gkMatch&&!self.gkSession)
		[super setScore:score];
}

-(NSString*) getStat
{
	return [NSString stringWithFormat:NSLocalizedString(@"每次用:%1.2fs", nil), (float)(self.statTotalSum/self.statTotalNum)];
}

-(UIImage*) getStatPic
{
	UIImageView* img = [[[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"3" ofType:@"png"]]] autorelease];
	img.frame = CGRectMake(20,20,40,40);
	return img;
}
@end