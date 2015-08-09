//
//  3in1View.m
//  bishibashi
//
//  Created by Eric on 08/03/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BurgersetView.h"
#import "Constants.h"

@implementation BurgersetView

@synthesize targetQueue = _targetQueue;
@synthesize currentQueue = _currentQueue;
@synthesize targetQueueBurger = _targetQueueBurger;
@synthesize currentQueueBurger = _currentQueueBurger;
@synthesize currentRound = _currentRound;


static const CGRect backgroundRectP = {{15, 80}, {290, 310}};
static const CGRect backgroundRectL = {{10, 40}, {290, 210}};
static const CGRect backgroundRectR = {{5, 40}, {145, 210}};

static const CGRect SingleOKRect = {{100, 200}, {120, 140}};
static const CGRect SingleOKTimeRectP = {{100, 160}, {120, 30}};


- (void) dealloc	{
	self.currentQueue = nil;
	self.targetQueue = nil;
	self.currentQueueBurger = nil;
	self.targetQueueBurger = nil;

	[super dealloc];
}

- (void) prepareToStartGameWithNewScenario:(BOOL)newScenario
{
	// to make the initial start round startable
	self.myTimeUsed = 1.0;
	self.opponentTimeUsed = 1.0;
	
	self.noRun = 10;
	self.currentRound = 0;
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
	UIImage* tmpImage = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"burgersetbackground" ofType:@"png"]];
	 UIImageView* tmpView = [[UIImageView alloc] initWithImage:tmpImage];
	 [tmpView setFrame:backgroundRectP];
	[self setBackgroundColor:[UIColor blackColor]];
	self.backgroundView = tmpView;
	 [self addSubview:tmpView];
	 [tmpView release];
	self.scoreFrame = CGRectMake(220, 50, 20, 20);

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
		
		// set VS as normal
		self.difficultiesLevel = kNormal;
	}
	
	[self startRound];
	if (self.remoteView)
		[self.remoteView startGame];
}

- (void) initScenarios:(NSArray*)scenarios
{
	[super initScenarios:scenarios];
	if (!scenarios)
	{
		self.noRun = 10;
		/* scenario is an array of 3 NSNumber for random number 1-5 */
		for (int i=0; i<self.noRun; i++)	{
			NSArray* scenario = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:arc4random()%5+1], [NSNumber numberWithInt:arc4random()%5+1], [NSNumber numberWithInt:arc4random()%5+1], nil];
			[self.scenarios addObject:scenario];
			[scenario release];
		}
		if (self.difficultiesLevel == kWorldClass)	{
			for (int i=0; i<self.noRun; i++)	{
				NSArray* scenario = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:arc4random()%5+1], [NSNumber numberWithInt:arc4random()%5+1], [NSNumber numberWithInt:arc4random()%5+1], nil];
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
		NSArray* scenario = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:arc4random()%5+1], [NSNumber numberWithInt:arc4random()%5+1], [NSNumber numberWithInt:arc4random()%5+1], nil];
		[self.scenarios2 addObject:scenario];
		[scenario release];
	}
}
	
- (void) changeOrientationTo:(UIInterfaceOrientation) orientation
{
	[super changeOrientationTo:orientation];
	[self clearScreen];
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

- (void) clearScreen {
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
	if (self.noRun ==0){
		[self showPlayAgain];
	}else	{
		self.noRun--;
		[super startRound];

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
		
		NSArray* scenario = [self.scenarios objectAtIndex:self.currentRound];
		int totalNo = 0;
		for (int i=0; i<3; i++)	{
			[self.currentQueue addObject:[NSNumber numberWithInt:0]];
			int theNo = [[scenario objectAtIndex:i] intValue];
			totalNo += theNo;
			[self.targetQueue addObject:[NSNumber numberWithInt:theNo]];
			NSMutableArray* theArr = [[NSMutableArray alloc] initWithCapacity:5];
			for (int j=0; j<theNo; j++)	{
				Burger* aBurger = [[Burger alloc] initWithColor:i AndPos:j AndEmpty:YES AndOrientation:self.orientation];
				[self addSubview:aBurger];
				self.statTotalNum++;
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
		self.currentRound++;
		[self enableButtons];
		self.overheadTime = 0.9*totalNo*self.difficultFactor;
		[self setTimer:0.5+totalNo*self.difficultFactor];
	}
	  }

}
	

- (void) success
{
	[self.theTimer invalidate];
	self.score += (int)([self calScore]/10.0);
	NSLog(@"score is %d", self.score);
	[self disableButtons];
	[sharedSoundEffectsManager playYeahSound];
	NSLog(@"success");
	
	// do not show the big OK in VS mode
	if (!self.gkMatch&&!self.gkSession)	{
		self.OKView.frame = SingleOKRect;
		self.myOKView.frame = SingleOKTimeRectP;
		self.myOKView.font = [UIFont systemFontOfSize:30];
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

- (void) fail
{
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
		else {
			[self.gkSession sendDataToAllPeers:[self.gamePacket toNSData] withDataMode:GKSendDataReliable error:&error];

		}

	}
	
	[self.theTimer invalidate];
	[self disableButtons];
	[sharedSoundEffectsManager playFailSound];
	NSLog(@"fail");
	
	// do not show the big cross in VS mode
	if (!self.gkMatch&&!self.gkSession)	{
		float timeUsed = -(float)[self.roundStartTime timeIntervalSinceNow];
		self.statTotalSum += timeUsed;
		[self addSubview:self.crossView];	
		[self.crossView setFrame:CGRectMake(self.crossView.frame.origin.x-1, self.crossView.frame.origin.y, self.crossView.frame.size.width, self.crossView.frame.size.height)];
		[UIView beginAnimations:@"fail_end" context:nil];
		[UIView setAnimationDuration:0.6];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector: @selector(animationDidStop:finished:context:)];	
		[self.crossView setFrame:CGRectMake(self.crossView.frame.origin.x+1, self.crossView.frame.origin.y, self.crossView.frame.size.width, self.crossView.frame.size.height)];
		[self bringSubviewToFront:self.crossView];
		[UIView commitAnimations];
	}
	else {
		[self showRoundVSResult];
//		[NSObject cancelPreviousPerformRequestsWithTarget:self];
//		[self performSelector:@selector(startRound) withObject:nil afterDelay:1];
	}

}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	if (([animationID isEqualToString:@"success_end"]) || ([animationID isEqualToString:@"fail_end"])){
		[self.crossView removeFromSuperview];
		[self.OKView removeFromSuperview];
		[self.myOKView removeFromSuperview];
		
		if (self.gameType == multi_players_level_select){
			;
		}else if (!_toQuit){
			if ([animationID isEqualToString:@"fail_end"] && (self.difficultiesLevel == kWorldClass))	{
				self.noRun = 0;
				[self showPlayAgain];
			}
			else	{
				if (self.gkMatch||self.gkSession)	{
					[self showRoundVSResult];
				}
				else
					[self startRound];
			}
		}
		
	}
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
	Burger* aBurger = [[Burger alloc]initWithColor:kRed AndPos:[theNo intValue] AndEmpty:NO AndOrientation:self.orientation];
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
	Burger* aBurger = [[Burger alloc]initWithColor:kBlue AndPos:[theNo intValue] AndEmpty:NO AndOrientation:self.orientation];
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
	Burger* aBurger = [[Burger alloc]initWithColor:kGreen AndPos:[theNo intValue] AndEmpty:NO AndOrientation:self.orientation];
	[self addSubview:aBurger];
	[aBurger show];
	[[self.currentQueueBurger objectAtIndex:kGreen] addObject:aBurger];
	[self.currentQueue replaceObjectAtIndex:kGreen withObject:newNo];
	[aBurger release];
	[self checkSuccess];
}

// overwrite setScore for VS mode to not send /update time bar
- (void) setScore:(int) score
{
	if (!self.gkMatch&&!self.gkSession)
		[super setScore:score];
}

-(NSString*) getStat
{
	return [NSString stringWithFormat:NSLocalizedString(@"每點心用:%1.2fs", nil), (float)(self.statTotalSum/self.statTotalNum)];
}

-(UIImage*) getStatPic
{
	UIImageView* img = [[[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"burger" ofType:@"png"]]] autorelease];
	img.frame = CGRectMake(20,20,40,40);
	return img;
}

@end
