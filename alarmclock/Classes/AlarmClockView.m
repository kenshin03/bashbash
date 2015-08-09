//
//  AlarmClockView.m
//  bishibashi
//
//  Created by Eric on 14/03/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AlarmClockView.h"
#import "Constants.h"

@implementation AlarmClockView
@synthesize speed = _speed;
@synthesize startTime = _startTime;
@synthesize shortArrow = _shortArrow;
@synthesize longArrow = _longArrow;
@synthesize currentRound = _currentRound;
@synthesize clockView = _clockView;
@synthesize zoomView = _zoomView;

static const CGRect backgroundRectP = {{10, 25}, {300, 370}};
static const CGRect backgroundRectL = {{10, 14}, {300, 250}};
static const CGRect backgroundRectR = {{5, 14}, {150, 250}};

static const CGRect backgroundZoomRectP = {{135.5,150}, {55,65}};
static const CGRect backgroundZoomRectL = {{122,82}, {55,65}};
static const CGRect backgroundZoomRectR = {{61, 82}, {30, 40}};

static const CGRect clockRectP = {{150.7, 169.3}, {25, 25}};
static const CGRect clockRectL = {{120, 140}, {16,16}};
static const CGRect clockRectR = {{0, 22}, {16,16}};

static const CGRect OKRectP = {{20, 270}, {140, 110}};
static const CGRect OKRectL = {{20, 170}, {140, 70}};
static const CGRect OKRectR = {{10, 170}, {70, 70}};

static const CGRect SingleOKRect = {{100, 200}, {120, 140}};
static const CGRect SingleOKTimeRectP = {{100, 160}, {120, 30}};


- (void) dealloc	{
	NSLog(@"dealloc AlarmClockView");
	[sharedSoundEffectsManager stopAlarmClockTickingSound];
	self.zoomView = nil;
	self.startTime = nil;
	self.longArrow = nil;
	self.shortArrow = nil;
	self.clockView = nil;
	[super dealloc];
}

-(void) initBackground
{
	UIImage* tmpImage = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"tst3" ofType:@"png"]];
	UIImageView* tmpView = [[UIImageView alloc] initWithImage:tmpImage];
	tmpView.frame = backgroundRectP;
	self.backgroundView = tmpView;
	[self addSubview:self.backgroundView];
	[tmpView release];
	
	tmpImage = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"tst3zoom" ofType:@"png"]];
	tmpView = [[UIImageView alloc] initWithImage:tmpImage];
	tmpView.frame = backgroundZoomRectP;
	self.zoomView = tmpView;
	[self addSubview:self.zoomView];
	[tmpView release];
	
	tmpImage = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"clock" ofType:@"png"]];
	tmpView = [[UIImageView alloc] initWithImage:tmpImage];
	tmpView.frame = clockRectP;
	self.clockView = tmpView;
	[self addSubview:self.clockView];
	[tmpView release];

	[self setBackgroundColor:[UIColor blackColor]];
	self.scoreFrame = CGRectMake(220, 50, 20, 20);

}

- (void) changeOrientationTo:(UIInterfaceOrientation) orientation
{
	[super changeOrientationTo:orientation];
	switch (orientation)	{
		case (UIInterfaceOrientationPortrait):
		case (UIInterfaceOrientationPortraitUpsideDown):
			self.backgroundView.frame = backgroundRectP;
			self.clockView.frame = clockRectP;
			self.zoomView.frame = backgroundZoomRectP;
			self.OKView.frame = OKRectP;
			break;
		case (UIInterfaceOrientationLandscapeLeft):
		case (UIInterfaceOrientationLandscapeRight):
			self.backgroundView.frame = backgroundRectL;
			self.clockView.frame = clockRectL;
			self.zoomView.frame = backgroundZoomRectL;
			self.OKView.frame = OKRectL;
			break;
		case (10):
			self.backgroundView.frame = backgroundRectR;
			self.clockView.frame = clockRectR;
			self.zoomView.frame = backgroundZoomRectR;
			self.OKView.frame = OKRectR;
			break;
	}
	
}

- (void) initImages
{
	[super initImages];
	
	/*
	UIImageView* tmpView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"notmoving" ofType:@"png"]]];
	self.OKView = tmpView;
	[self.OKView setFrame:OKRectP];
	[tmpView release];
	 */
}

- (void) initScenarios:(NSArray*)scenarios
{
	[super initScenarios:scenarios];
	if (!scenarios)
	{
		self.noRun = 12;
		/* scenario is an array of 1 NSNumber(integer) of consecutively diminishing numbers */
		for (int i=self.noRun; 0<i; i--)	{
			[self.scenarios addObject:[NSNumber numberWithInt:(12-i)]];
		}
		// for master level
		if (self.difficultiesLevel == kWorldClass)	{
			/* scenario is an array of 1 NSNumber(integer) of consecutively diminishing numbers */
			for (int i=self.noRun; 0<i; i--)	{
				[self.scenarios2 addObject:[NSNumber numberWithInt:(12-i)]];
			}
		}
	}
	if (self.remoteView){
		[self.remoteView initScenarios:self.scenarios];
	}
}

- (void) switchScenario
{
	self.scenarios = self.scenarios2;
	for (int i=self.noRun; 0<i; i--)	{
		[self.scenarios addObject:[NSNumber numberWithInt:(12-i)]];
	}
}	

- (void) startRound{
	@synchronized(self)	{
	// for master level
	if (self.difficultiesLevel == kWorldClass)
	{
		if (self.noRun==0)	{
			self.noRun=12;
			[self switchScenario];
		}
	}
	
	if (self.noRun==0){
		[sharedSoundEffectsManager stopAlarmClockTickingSound];
		[self restartGameAnimation];
		[self showPlayAgain];
	}
	else{
		[super startRound];
		[self enableButtons];
		if (self.speed >0.1)
			self.speed *= 0.95;
		else if (self.speed >0.08)
			self.speed *= 0.98;
		if (!self.shortArrow)		{
			Arrow* shortArrow = [[Arrow alloc]initWithOwner:self ForLong:NO AndAngle:([[self.scenarios objectAtIndex:self.currentRound]intValue])*30.0 AndSpeed:self.speed AndOrientation:self.orientation];
			self.shortArrow = shortArrow;
			[shortArrow release];
			[self addSubview:self.shortArrow];
		}
		else	{
			[self.shortArrow setAngle:([[self.scenarios objectAtIndex:self.currentRound]intValue])*30.0	AndSpeed:self.speed];
		}
		if (!self.longArrow)	{
			Arrow* longArrow = [[Arrow alloc]initWithOwner:self ForLong:YES  AndAngle:0.0 AndSpeed:self.speed AndOrientation:self.orientation];
			self.longArrow = longArrow;
			[longArrow release];
			[self addSubview:self.longArrow];
		}
		else	{
			[self.longArrow setAngle:0.0 AndSpeed:self.speed];			
		}
		[self enableButtons];	
		
		self.startTime = [NSDate date]; 
		self.theTimer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
		[sharedSoundEffectsManager playAlarmClockTickingSound];

		self.currentRound++;
		self.statTotalNum++;
		self.noRun--;
	}
	}
	
}


- (void) timerFireMethod:(NSTimer*)theTimer
{
	NSDate* now = [NSDate date];
	NSTimeInterval timeDiff = [now timeIntervalSinceDate:self.startTime];
	if (timeDiff > self.speed*3.5)	{
		[self fail];
	}
		
	[self.shortArrow showTime];
	[self.longArrow showTime];
}

- (void) startGame
{
	[super startGame];
	self.noRun = 12;
	self.currentRound = 0;
	
	if ((self.gameType != multi_players_arcade)|| (self.gameType != multi_players_level_select)){	
		if ((!self.isRemoteView)){
			[self initScenarios:nil];
		}
	}
	
	// set to Normal for VS mode
	if (self.gkSession || self.gkMatch)	{
		self.difficultiesLevel = kNormal;
	}
	
	self.speed = self.difficultFactor;
	[self beforeGameAnimation];

	
}

-(void) beforeGameAnimation{
	[self disableButtons];
	self.backgroundView.transform = CGAffineTransformIdentity;
	self.clockView.transform = CGAffineTransformIdentity;
	self.zoomView.transform = CGAffineTransformIdentity;
	self.backgroundView.frame = backgroundRectP;
	self.clockView.frame = clockRectP;
	self.zoomView.frame = backgroundZoomRectP;
	[UIView beginAnimations:@"zoom in frame" context:nil];
	[UIView setAnimationDuration: 1.2];
	CGAffineTransform backgroundTransform = CGAffineTransformMakeScale(6, 6);
	CGAffineTransform zoomTransform = CGAffineTransformMakeScale(6, 6);
	backgroundTransform = CGAffineTransformTranslate(backgroundTransform, 1, 26.2);
	zoomTransform = CGAffineTransformTranslate(zoomTransform, 3.5, 1);
	self.backgroundView.transform = backgroundTransform;
	self.zoomView.transform = zoomTransform;
	CGAffineTransform clockTransform = CGAffineTransformMakeScale(6.2, 6.2);
	clockTransform = CGAffineTransformTranslate(clockTransform, 4,1);
	
	self.clockView.transform = clockTransform;
	[UIView setAnimationDelegate:self];
	[UIView commitAnimations];
	
	[self performSelector:@selector(startRound) withObject:nil afterDelay:1.2];

	
}

-(void) restartGameAnimation{
	[self.shortArrow removeFromSuperview];
	[self.longArrow removeFromSuperview];
	self.shortArrow = nil;
	self.longArrow = nil;
	[UIView beginAnimations:@"zoom out frame" context:nil];
	[UIView setAnimationDuration: 0.1];
	self.backgroundView.frame = backgroundRectP;
	self.zoomView.frame = backgroundZoomRectP;
	self.clockView.frame = clockRectP;
	[UIView setAnimationDelegate:self];
	[UIView commitAnimations];
	
}

-(void) checkSuccess
{
	NSDate* now = [NSDate date];
	NSTimeInterval timeDiff = [now timeIntervalSinceDate:self.startTime];
	if (timeDiff > self.speed*2.5 && timeDiff < self.speed*3.5)	{
		float score = fabs(0.5 - fabs(timeDiff - self.speed*3.0)/self.speed)/0.5 * 100;
		self.score += (int)(score/12);
		[self success:fabs(timeDiff - self.speed*3.0)];
	}
	else {
		[self fail];
	}
}


- (void) success:(float)value
{	
	[self disableButtons];
	[sharedSoundEffectsManager playYeahSound];
	
	// do not show the big OK in VS mode
	if (!self.gkMatch && !self.gkSession)	{
		self.OKView.frame = SingleOKRect;
		self.myOKView.frame = SingleOKTimeRectP;
		self.myOKView.font = [UIFont systemFontOfSize:30];
		self.statTotalSum += value;
		[self.myOKView setTime:value];
		[self addSubview:self.myOKView];
		[self addSubview:self.OKView];
		[UIView beginAnimations:@"success_end" context:nil];
		[UIView setAnimationDuration:1];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector: @selector(animationDidStop:finished:context:)];	
		self.OKView.frame = CGRectOffset(self.OKView.frame, 0.1, 0);
		self.myOKView.frame = CGRectOffset(self.myOKView.frame, 0.1,0);
		[UIView commitAnimations];
	}
	else {
		self.gamePacket.packetType = kGKPacketTypeTimeUsed;
		self.gamePacket.timeUsed = value;
		self.myTimeUsed=self.gamePacket.timeUsed;
		NSLog(@"gamePacket.timeUsed is %f", self.gamePacket.timeUsed);
		NSError* error;
		if (self.gkMatch)
			[self.gkMatch sendDataToAllPlayers:[self.gamePacket toNSData] withDataMode:GKSendDataReliable error:&error];				
		else {
			[self.gkSession sendDataToAllPeers:[self.gamePacket toNSData] withDataMode:GKSendDataReliable error:&error];				
		}

		[self showRoundVSResult];
	}

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
	
	[self.theTimer invalidate];
	[sharedSoundEffectsManager pauseAlarmClockTickingSound];
	[self disableButtons];
	[sharedSoundEffectsManager playFailSound];
	
	// do not show the big cross in VS mode
	if (!self.gkMatch&&!self.gkSession)	{
		float timeUsed = -(float)[self.roundStartTime timeIntervalSinceNow];
		self.statTotalSum += timeUsed;
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
	else{
		[self showRoundVSResult];
	}
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	if ([animationID isEqualToString:@"success_end"] || [animationID isEqualToString:@"fail_end"])	{
		[self.crossView removeFromSuperview];
		[self.OKView removeFromSuperview];
		[self.myOKView removeFromSuperview];
		
		if (self.gameType == multi_players_level_select){
			;
		}else if (!_toQuit){
			if ([animationID isEqualToString:@"fail_end"] && (self.difficultiesLevel == kWorldClass))	{
				self.noRun = 0;
				[sharedSoundEffectsManager stopAlarmClockTickingSound];
				
				if (((self.gameType == multi_players_arcade)||(self.gameType == multi_players_level_select))&&(self.isRemoteView == NO)){
					/*
					 [self sendPeerCompletedGameToPeer];
					 //			[self sendGoToNextGameToPeer];
					 //			[self anotherButClicked];
					 */
				}else{
					[self restartGameAnimation];
					[self showPlayAgain];
				}
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
	else if ([animationID isEqualToString:@"fail"] && [context boolValue] && [finished boolValue])	{
		[self fail];
	}
	
}

- (void) redButClicked
{
	[sharedSoundEffectsManager pauseAlarmClockTickingSound];
	[self.theTimer invalidate];
	[self checkSuccess];
}

- (void) blueButClicked
{
	[sharedSoundEffectsManager pauseAlarmClockTickingSound];
	[self.theTimer invalidate];
	[self checkSuccess];

}

- (void) greenButClicked
{
	[sharedSoundEffectsManager pauseAlarmClockTickingSound];
	[self.theTimer invalidate];
	[self checkSuccess];

}

// overwrite setScore for VS mode to not send /update time bar
- (void) setScore:(int) score
{
	if (!self.gkMatch && !self.gkSession)
		[super setScore:score];
}

-(NSString*) getStat
{
	return [NSString stringWithFormat:NSLocalizedString(@"準確度:%1.2fs", nil), (float)(self.statTotalSum/self.statTotalNum)];
}

-(UIImage*) getStatPic
{
	UIImageView* img = [[[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"clock" ofType:@"png"]]] autorelease];
	img.frame = CGRectMake(20,20,40,40);
	return img;
}
@end
