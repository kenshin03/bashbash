//
//  BignumberView.m
//  bishibashi
//
//  Created by Eric on 23/03/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SmallnumberView.h"


@implementation SmallnumberView
@synthesize curRedSeq = _curRedSeq;
@synthesize curBlueSeq = _curBlueSeq;
@synthesize curGreenSeq = _curGreenSeq;
@synthesize redSeq = _redSeq;
@synthesize greenSeq = _greenSeq;
@synthesize blueSeq = _blueSeq;


- (void) dealloc	{
	[sharedSoundEffectsManager stopHarbourSound];
	self.redSeq = nil;
	self.greenSeq = nil;
	self.blueSeq = nil;

	[super dealloc];
}


- (void) initScenarios:(NSArray*)scenarios
{
	[super initScenarios:scenarios];
	if (!scenarios)
	{
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
		if (self.difficultiesLevel != kWorldClass)	{
			for (int i=1; i<=24; i++)	{
				int color = arc4random()%3;
				while (positions[color]>=8)
					color = arc4random()%3;
				[[self.scenarios objectAtIndex:color] addObject:[NSNumber numberWithInt:i]];
				 positions[color]++;
			}	
			NSLog(@"%@", self.scenarios);
		}
		else{
			int j=0;
			for (int i=1; i<=24; i++)	{
				int color = arc4random()%3;
				while (positions[color]>=8)
					color = arc4random()%3;
				j+= arc4random()%5;
				[[self.scenarios objectAtIndex:color] addObject:[NSNumber numberWithInt:j]];
				positions[color]++;
			}	
		}
	}
	if (self.remoteView)
		[self.remoteView initScenarios:self.scenarios];
}

- (void) changeOrientationTo:(UIInterfaceOrientation) orientation
{
	[super changeOrientationTo:orientation];
	switch (orientation)	{
		case (UIInterfaceOrientationPortrait):
		case (UIInterfaceOrientationPortraitUpsideDown):
			self.backgroundView.frame = CGRectMake(0, -62, self.frame.size.width, self.frame.size.height);
			break;
		case (UIInterfaceOrientationLandscapeLeft):
		case (UIInterfaceOrientationLandscapeRight):
			self.backgroundView.frame = CGRectMake(0, -222, self.frame.size.width, self.frame.size.height);
			break;
		case (10):
			self.backgroundView.frame = CGRectMake(0,-44, self.frame.size.width, self.frame.size.height);
			break;
	}

}

-(void) initBackground
{
	[super initBackground];
	UIImageView* background = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"buildingbackground" ofType:@"jpg"]]];
	background.frame = CGRectMake(0, -62, self.frame.size.width, self.frame.size.height);
	[self addSubview:background];
	self.backgroundView = background;
	[background release];
}

- (void) prepareToStartGameWithNewScenario:(BOOL)newScenario
{
	[super prepareToStartGameWithNewScenario:newScenario];
	if ((self.gameType != multi_players_arcade)&& (self.gameType != multi_players_level_select)){	
		if ((!self.isRemoteView) ){
			if (newScenario)	{
				[self.scenarios removeAllObjects];
				[self initScenarios:nil];
			}
		}
	}

	if (self.redSeq)	{
		for (Number* sample in self.redSeq)	{
			[sample removeFromSuperview];
		}
	}
	if (self.greenSeq)	{
		for (Number* sample in self.greenSeq)	{
			[sample removeFromSuperview];
		}
	}
	if (self.blueSeq)	{
		for (Number* sample in self.blueSeq)	{
			[sample removeFromSuperview];
		}
	}
	
	
	NSMutableArray* theSeq = [[NSMutableArray alloc] initWithCapacity:8];
	self.redSeq = theSeq;
	int pos = 0;
	for (NSNumber* theNum in [self.scenarios objectAtIndex:kRed])	{
		Number* theNo = [[Number alloc] initWithNo:[theNum intValue] AndColor:kRed AndPos:pos++ AndOrientation:self.orientation];
		[self.redSeq addObject:theNo];
		[self addSubview:theNo];
		[theNo release];
	}
	[theSeq release];
	
	theSeq = [[NSMutableArray alloc] initWithCapacity:8];
	self.greenSeq = theSeq;
	pos = 0;
	for (NSNumber* theNum in [self.scenarios objectAtIndex:kGreen])	{
		Number* theNo = [[Number alloc] initWithNo:[theNum intValue] AndColor:kGreen AndPos:pos++ AndOrientation:self.orientation];
		[self addSubview:theNo];
		[self.greenSeq addObject:theNo];
		[theNo release];
	}
	[theSeq release];
	
	theSeq = [[NSMutableArray alloc] initWithCapacity:8];
	self.blueSeq = theSeq;
	pos = 0;
	for (NSNumber* theNum in [self.scenarios objectAtIndex:kBlue])	{
		Number* theNo = [[Number alloc] initWithNo:[theNum intValue] AndColor:kBlue AndPos:pos++ AndOrientation:self.orientation];
		[self addSubview:theNo];
		[self.blueSeq addObject:theNo];
		[theNo release];
	}
	[theSeq release];
	[self bringSubviewToFront:self.gameFrame];
	[self bringSubviewToFront:self.redBut];
	[self bringSubviewToFront:self.greenBut];
	[self bringSubviewToFront:self.blueBut];
}

- (void) startGame
{	
	_VSModeIsRoundBased = NO;
	
	// set to normal for VS mode
	if (self.gkSession || self.gkMatch)	{
		self.difficultiesLevel = kNormal;
	}
	
	[super startGame];
	self.overheadTime = 5.5;
	[sharedSoundEffectsManager playHarbourSound];
	
		 
	[super startRound];
	if (self.remoteView)	
		[self.remoteView startGame];
	if (!self.isRemoteView)
		[self setTimer:self.difficultFactor];
}	
- (void) failGame{
	[self showPlayAgain];
}

- (void) fail	{
	if (!self.isRemoteView){
		[sharedSoundEffectsManager playFailSound];
		;
	}
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


- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	int contextid = [((NSNumber*)context) intValue];
	if ([animationID isEqualToString:@"end"])	{
		[self.crossView removeFromSuperview];
		if (self.difficultiesLevel ==kWorldClass)	{
			[self failGame];
		}
		else
			[self enableButtons];
	}
}

- (void) showPlayAgain{
	self.statTotalSum = -(float)[self.roundStartTime timeIntervalSinceNow];
	/* send time spent to opponent */
	if (self.gkMatch||self.gkSession)	{
		self.gamePacket.packetType = kGKPacketTypeTimeUsed;
		self.gamePacket.timeUsed = -(float)[self.roundStartTime timeIntervalSinceNow];
		NSLog(@"gamePacket.timeUsed is %f", self.gamePacket.timeUsed);
		NSError* error;
		if (self.gkMatch)
			[self.gkMatch sendDataToAllPlayers:[self.gamePacket toNSData] withDataMode:GKSendDataReliable error:&error];
		else
			[self.gkSession sendDataToAllPeers:[self.gamePacket toNSData] withDataMode:GKSendDataReliable error:&error];
	}

	
	[sharedSoundEffectsManager stopHarbourSound];
	[super showPlayAgain];
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
		if (!self.isRemoteView){
			[sharedSoundEffectsManager playDropSound];
			;
		}
		self.statTotalNum++;
		[[self.redSeq objectAtIndex:0] dispose];
		[self.redSeq removeObjectAtIndex:0];
		if (self.difficultiesLevel==kWorldClass || self.gkMatch||self.gkSession)
			self.score += 1;
		for (Number* theNo in self.redSeq)
			[theNo show];
		if ([self.redSeq count]==0 && [self.greenSeq count]==0 && [self.blueSeq count]==0){
			if (self.difficultiesLevel == kWorldClass)	{
				[self initScenarios:nil];
				[self prepareToStartGameWithNewScenario:YES];
				[self setTimer:self.difficultFactor];
				[self startRound];
			}
			else
				[self showPlayAgain];				
			
		}
	}
	else	
		[self fail];		
}

- (void) blueButClicked
{
	[super blueButClicked];
	int redno = [self getNo:self.redSeq];
	int greenno = [self getNo:self.greenSeq];
	int blueno = [self getNo:self.blueSeq];
	
	if (blueno <= greenno && blueno <=redno)	{
		if (!self.isRemoteView){
			[sharedSoundEffectsManager playDropSound];
			;
		}
		self.statTotalNum++;
		[[self.blueSeq objectAtIndex:0] dispose];
		[self.blueSeq removeObjectAtIndex:0];
		if (self.difficultiesLevel==kWorldClass || self.gkMatch||self.gkSession)
			self.score += 1;
		for (Number* theNo in self.blueSeq)
			[theNo show];
		if ([self.redSeq count]==0 && [self.greenSeq count]==0 && [self.blueSeq count]==0){
			if (self.difficultiesLevel == kWorldClass){
				[self initScenarios:nil];
				[self prepareToStartGameWithNewScenario:YES];
				[self setTimer:self.difficultFactor];
				[self startRound];
			}
			else
				[self showPlayAgain];				
		}
	}
	else	
		[self fail];		
}

- (void) greenButClicked
{
	[super greenButClicked];
	int redno = [self getNo:self.redSeq];
	int greenno = [self getNo:self.greenSeq];
	int blueno = [self getNo:self.blueSeq];
	
	if (greenno <= redno && greenno <=blueno)	{
		if (!self.isRemoteView){
			[sharedSoundEffectsManager playDropSound];
			;
		}
		self.statTotalNum++;
		[[self.greenSeq objectAtIndex:0] dispose];
		[self.greenSeq removeObjectAtIndex:0];
		if (self.difficultiesLevel==kWorldClass || self.gkMatch||self.gkSession)
			self.score += 1;
		for (Number* theNo in self.greenSeq)
			[theNo show];
		if ([self.redSeq count]==0 && [self.greenSeq count]==0 && [self.blueSeq count]==0){
			if (self.difficultiesLevel == kWorldClass){
				[self initScenarios:nil];
				[self prepareToStartGameWithNewScenario:YES];
				[self setTimer:self.difficultFactor];
				[self startRound];
			}
			else
				[self showPlayAgain];				
		}
	}
	else	
		[self fail];		
}

- (void) updateTimeBar:(NSTimer*)theTimer
{
	[super updateTimeBar:theTimer];
	if (self.difficultiesLevel!=kWorldClass &&  !self.gkMatch&&!self.gkSession)	{
		self.score = [self calScore];
	}
}


-(NSString*) getStat
{
	return [NSString stringWithFormat:NSLocalizedString(@"拆每層用:%1.2fs", nil), (float)(self.statTotalSum/self.statTotalNum)];
}

-(UIImage*) getStatPic
{
	UIImageView* img = [[[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"boc5" ofType:@"png"]]] autorelease];
	img.frame = CGRectMake(20,20,40,40);
	return img;
}

@end