//
//  UFOView.m
//  bishibashi
//
//  Created by Eric on 14/03/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UFOView.h"
#import "Constants.h"


@implementation UFOView
@synthesize rightBackgroundView = _rightBackgroundView;
@synthesize toLeft = _toLeft;
@synthesize speed = _speed;

@synthesize UFOs = _UFOs;
@synthesize theUFO = _theUFO;
@synthesize toLeftUFOs = _toLeftUFOs;
@synthesize toRightUFOs = _toRightUFOs;
@synthesize currentRound = _currentRound;

static const CGRect leftBackgroundRectP = {{15, 80}, {292, 270}};
static const CGRect rightBackgroundRectP = {{15, 80}, {292, 270}};

static const CGRect leftBackgroundRectL = {{0, 40}, {320, 160}};
static const CGRect rightBackgroundRectL = {{0, 40}, {320,160}};

static const CGRect leftBackgrondRectR = {{0, 30}, {160, 130}};
static const CGRect rightBackgrondRectR = {{0, 30}, {160, 130}};

static const CGRect theUFORectP = {{0, 355}, {80, 30}};
static const CGRect theUFORectL = {{0, 198}, {80, 20}};
static const CGRect theUFORectR = {{0, 180}, {0,0}};

static const CGRect SingleOKRect = {{100, 200}, {120, 140}};
static const CGRect SingleOKTimeRectP = {{100, 160}, {120, 30}};


					
- (id) initWithFrame:(CGRect)frameRect AndOwner:(id)owner AndGame:(Game) game AndGameType:(currrentGameType) gameType AndLevel:(GameLevel) level
{
	self = [super initWithFrame:frameRect AndOwner:owner AndGame:game AndGameType:gameType AndLevel:level];
	self.toLeftUFOs = [[[NSMutableArray alloc] initWithCapacity:4]autorelease];
	self.toRightUFOs = [[[NSMutableArray alloc] initWithCapacity:4]autorelease];
	self.UFOs = [[[NSMutableArray alloc] initWithCapacity:3]autorelease];
	
	for (int i=0; i<4; i++)	{
		UFO* theUFO = [[UFO alloc] initWithSeq:i AndToLeft:YES AndOrientation:self.orientation];
		[self addSubview:theUFO];
		[theUFO setHidden:YES];
		[self.toLeftUFOs addObject:theUFO];
		[theUFO release];
	}
	for (int i=0; i<4; i++)	{
		UFO* theUFO = [[UFO alloc] initWithSeq:i AndToLeft:NO AndOrientation:self.orientation];
		[self addSubview:theUFO];
		[theUFO setHidden:YES];
		[self.toRightUFOs addObject:theUFO];
		[theUFO release];
	}
	return self;
}
		
- (void) dealloc	{
	NSLog(@"dealloc UFOView");
	[sharedSoundEffectsManager stopCrossWalkSound];
	self.theUFO = nil;
	self.UFOs = nil;
	self.toLeftUFOs = nil;
	self.toRightUFOs = nil;

	[super dealloc];
}

- (void) prepareToStartGameWithNewScenario:(BOOL)newScenario
{
	// to make the initial start round startable
	self.myTimeUsed = 1.0;
	self.opponentTimeUsed = 1.0;
	
	self.noRun = 10;
	self.currentRound = 0;
	self.overheadTime = 0.5;
	self.speed = self.difficultFactor;
	self.toLeft = YES;
	if ((self.gameType != multi_players_arcade)&& (self.gameType != multi_players_level_select)){	
		if ((!self.isRemoteView) ){
			if (newScenario)	{
				[self.scenarios removeAllObjects];
				[self initScenarios:nil];
			}
		}
	}

	
	[super prepareToStartGameWithNewScenario:newScenario];
}

-(void) initBackground
{
	UIImage* tmpImage = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"ufobackground" ofType:@"png"]];
	UIImageView* tmpView = [[UIImageView alloc] initWithImage:tmpImage];
	[tmpView setFrame:leftBackgroundRectP];
	[self setBackgroundColor:[UIColor blackColor]];
	[self addSubview:tmpView];
	self.backgroundView = tmpView;
	[tmpView release];
	
	tmpImage = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"ufomask" ofType:@"png"]];
	tmpView = [[UIImageView alloc] initWithImage:tmpImage];
	[tmpView setFrame:rightBackgroundRectP];
	[self addSubview:tmpView];
	self.rightBackgroundView = tmpView;
	[tmpView release];	
	self.scoreFrame = CGRectMake(220, 50, 20, 20);
}


- (void) initScenarios:(NSArray*)scenarios
{
	[super initScenarios:scenarios];
	if (!scenarios)
	{
		self.noRun = 10;
		/* scenario is an array of 4 NSNumber(integer) , 1st 3 are random number 0-3, 4th is random color 0-2 */
		for (int i=0; i<self.noRun; i++)	{			
			NSMutableArray* scenario = [[NSMutableArray alloc] initWithCapacity:4];
			for (int i=0; i<3; i++)	{
				[scenario addObject:[NSNumber numberWithInt:arc4random()%(4-i)]];
			}
			
			[scenario addObject:[NSNumber numberWithInt:arc4random()%3]];
			[self.scenarios addObject:scenario];
			[scenario release];
		}
		// for master level
		if (self.difficultiesLevel == kWorldClass)	{
			for (int i=0; i<self.noRun; i++)	{
				NSMutableArray* scenario = [[NSMutableArray alloc] initWithCapacity:4];
				for (int i=0; i<3; i++)	{
					[scenario addObject:[NSNumber numberWithInt:arc4random()%(4-i)]];
				}
				
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
			NSMutableArray* scenario = [[NSMutableArray alloc] initWithCapacity:4];
			for (int i=0; i<3; i++)	{
				[scenario addObject:[NSNumber numberWithInt:arc4random()%(4-i)]];
			}
			
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
			self.backgroundView.frame = leftBackgroundRectP;
			self.rightBackgroundView.frame = rightBackgroundRectP;
			break;
		case (UIInterfaceOrientationLandscapeLeft):
		case (UIInterfaceOrientationLandscapeRight):
			self.backgroundView.frame = leftBackgroundRectL;
			self.rightBackgroundView.frame = rightBackgroundRectL;
			break;
		case (10):
			self.backgroundView.frame = leftBackgrondRectR;
			self.rightBackgroundView.frame = rightBackgrondRectR;
			break;
	}
	for (UFO* ufo in self.UFOs)
		[ufo changeOrientationTo:orientation];
	for (UFO* ufo in self.toLeftUFOs)
		[ufo changeOrientationTo:orientation];
	for (UFO* ufo in self.toRightUFOs)
		[ufo changeOrientationTo:orientation];
	
	
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
		
		// set as Normal for VS
		self.difficultiesLevel = kNormal;
	}
	
	[self startRound];
	if (self.remoteView)
		[self.remoteView startGame];
}


- (void) startRound	{
	// for master level
	if (self.difficultiesLevel == kWorldClass)
	{
		if (self.noRun==0)	{
			self.noRun=10;
			[self switchScenario];
		}
	}
	
	if (self.noRun ==0){
		[sharedSoundEffectsManager stopCrossWalkSound];
		[self.theTimer invalidate];
		[self showPlayAgain];
		
	}else	{
		[sharedSoundEffectsManager playCrossWalkSound];
		[super startRound];
		[self setTimer:self.difficultFactor*2.5];
		for (UFO* theUFO in self.UFOs)	{
			if (self.toLeft)	{
				[self.toLeftUFOs addObject:theUFO];
				[theUFO setHidden:YES];
			}
			else {
				[self.toRightUFOs addObject:theUFO];
				[theUFO setHidden:YES];
			}
		}
		[self.UFOs removeAllObjects];

		
		self.noRun--;
		if (self.toLeft)
			self.toLeft = NO;
		else {
			self.toLeft = YES;
		}

		NSArray* scenario = [self.scenarios objectAtIndex:self.currentRound];
		for (int i=0; i<3; i++)	{
			UFO* theUFO;
			if (self.toLeft)	{
				theUFO = [self.toLeftUFOs objectAtIndex:[[scenario objectAtIndex:i] intValue]];
				[self.UFOs addObject:theUFO];
				[self.toLeftUFOs removeObject:theUFO];
			}
			else	{
				theUFO = [self.toRightUFOs objectAtIndex:[[scenario objectAtIndex:i] intValue]];
				[self.UFOs addObject:theUFO];
				[self.toRightUFOs removeObject:theUFO];
			}			
			theUFO.color = i;
			theUFO.speed = [self getSpeed];
			[theUFO setHidden:NO];
			switch (self.orientation)	{
				case (UIInterfaceOrientationPortrait):
				case (UIInterfaceOrientationPortraitUpsideDown):
					[theUFO setFrame:theUFORectP];
					[theUFO setFrame:CGRectMake(25+i*90, theUFO.frame.origin.y, theUFO.frame.size.width, theUFO.frame.size.height)];
					break;
				case (UIInterfaceOrientationLandscapeLeft):
				case (UIInterfaceOrientationLandscapeRight):
					[theUFO setFrame:theUFORectL];
					[theUFO setFrame:CGRectMake(25+i*90, theUFO.frame.origin.y, theUFO.frame.size.width, theUFO.frame.size.height)];
					break;
				case (10):
					[theUFO setHidden:YES];
					break;
			}
		}
		
		self.theUFO = [[self.UFOs objectAtIndex:[[scenario objectAtIndex:3] intValue]] copy];
		[self enableButtons];
		self.currentRound++;
		
		[self addSubview:self.theUFO];
		[self bringSubviewToFront:self.rightBackgroundView];
		[self bringSubviewToFront:self.gameFrame];
		[self bringSubviewToFront:self.redBut];
		[self bringSubviewToFront:self.greenBut];
		[self bringSubviewToFront:self.blueBut];

//		[self sendSubviewToBack:self.theUFO];
		[self.theUFO show];		
		[sharedSoundEffectsManager playUFOFlyPassSound];
	}
	
}

-(float) getSpeed
{
	if (self.speed > 0.21)	
		self.speed *= 0.95;
	return self.speed;
}

- (void) success
{
	self.score += (int)([self calScore]/10.0);
	[self disableButtons];
	[sharedSoundEffectsManager playYeahSound];
	
	// do not show the big OK in VS mode
	if (!self.gkMatch&&!self.gkSession)	{
		self.OKView.frame = SingleOKRect;
		self.myOKView.frame = SingleOKTimeRectP;
		self.myOKView.font = [UIFont systemFontOfSize:30];
		float timeUsed = -(float)[self.roundStartTime timeIntervalSinceNow];
		self.statTotalSum += timeUsed;
		self.statTotalNum++;
		[self.myOKView setTime:timeUsed];
		[self addSubview:self.myOKView];
		[self addSubview:self.OKView];
		[UIView beginAnimations:@"success_end" context:nil];
		[UIView setAnimationDuration:0.6];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector: @selector(animationDidStop:finished:context:)];	
		self.OKView.frame = CGRectOffset(self.OKView.frame, 0.1, 0);
		self.myOKView.frame = CGRectOffset(self.myOKView.frame, 0.1,0);
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
	
	[self.theUFO removeFromSuperview];
	self.theUFO = nil;
}

- (void) fail
{
	/* send time spent to opponent */
	if (self.gkMatch||self.gkSession)	{
		float timeUsed = -(float)[self.roundStartTime timeIntervalSinceNow];
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
	
	[self disableButtons];
	[sharedSoundEffectsManager playFailSound];
	
	// do not show big cross in VS mode
	if (!self.gkMatch&&!self.gkSession)	{
		[self.crossView setFrame:CGRectMake(self.crossView.frame.origin.x-1, self.crossView.frame.origin.y, self.crossView.frame.size.width, self.crossView.frame.size.height)];
		[self addSubview:self.crossView];
		[UIView beginAnimations:@"fail_end" context:nil];
		[UIView setAnimationDuration:0.6];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector: @selector(animationDidStop:finished:context:)];	
		[self.crossView setHidden:NO];
		[self.crossView setFrame:CGRectMake(self.crossView.frame.origin.x+1, self.crossView.frame.origin.y, self.crossView.frame.size.width, self.crossView.frame.size.height)];
		[self bringSubviewToFront:self.crossView];
		[UIView commitAnimations];
	}
	else {
		[self showRoundVSResult];
	}

	[self.theUFO removeFromSuperview];
	self.theUFO = nil;
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	if (([animationID isEqualToString:@"success_end"]) || ([animationID isEqualToString:@"fail_end"]))	{
		[self.crossView removeFromSuperview];
		[self.OKView removeFromSuperview];
		[self.myOKView removeFromSuperview];
		if (self.gameType == multi_players_level_select){
			;	
		}else if (!_toQuit){
			if ([animationID isEqualToString:@"fail_end"] && (self.difficultiesLevel == kWorldClass))	{
				self.noRun = 0;
				[sharedSoundEffectsManager stopCrossWalkSound];
				[self.theTimer invalidate];
				
				for (UFO* theUFO in self.UFOs)	{
					[theUFO removeFromSuperview];
				}
				[self.UFOs removeAllObjects];
				[self.toLeftUFOs removeAllObjects];
				[self.toRightUFOs removeAllObjects];
				for (int i=0; i<4; i++)	{
					UFO* theUFO = [[UFO alloc] initWithSeq:i AndToLeft:YES AndOrientation:self.orientation];
					[self addSubview:theUFO];
					[theUFO setHidden:YES];
					[self.toLeftUFOs addObject:theUFO];
					[theUFO release];
				}
				for (int i=0; i<4; i++)	{
					UFO* theUFO = [[UFO alloc] initWithSeq:i AndToLeft:NO AndOrientation:self.orientation];
					[self addSubview:theUFO];
					[theUFO setHidden:YES];
					[self.toRightUFOs addObject:theUFO];
					[theUFO release];
				}

				[self showPlayAgain];
			}
			else
			{
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
	[self.theTimer invalidate];
	[super redButClicked];
	if (self.theUFO.color == kRed)	
		[self success];
	else 
		[self fail];
}

- (void) blueButClicked
{
	[self.theTimer invalidate];
	[super blueButClicked];
	if (self.theUFO.color == kBlue)	
		[self success];
	else 
		[self fail];
}

- (void) greenButClicked
{
	[self.theTimer invalidate];
	[super greenButClicked];
	if (self.theUFO.color == kGreen)	
		[self success];
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
	return [NSString stringWithFormat:NSLocalizedString(@"睇車用:%1.2fs", nil), (float)(self.statTotalSum/self.statTotalNum)];
}

-(UIImage*) getStatPic
{
	UIImageView* img = [[[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"goright2" ofType:@"png"]]] autorelease];
	img.frame = CGRectMake(10,25,60,30);
	return img;
}
@end
