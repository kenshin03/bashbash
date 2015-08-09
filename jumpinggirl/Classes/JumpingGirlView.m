//
//  JumingGirlView.m
//  bishibashi
//
//  Created by Eric on 14/03/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "JumpingGirlView.h"


@implementation JumpingGirlView
@synthesize theGirl = _theGirl;
@synthesize opponentGirl = _opponentGirl;
@synthesize hits = _hits;
@synthesize seq = _seq;
@synthesize opponentSeq = _opponentSeq;
@synthesize duration = _duration;

static const CGRect backgroundRectP = {{15, 80}, {290, 330}};


- (void) dealloc	{
	self.theGirl = nil;
	self.opponentGirl = nil;
	self.theTimer = nil;

	[super dealloc];
}

-(void) initButtons
{
	[super initButtons];
}

- (void) fail
{
	[self showPlayAgain];

}

- (void) startGame
{
	_VSModeIsRoundBased = NO;
	[super startGame];
	self.opponentSeq = 1;
	self.seq = 1;
	self.hits = 0;
	self.statTotalSum=self.difficultFactor;
	if ((self.gameType != multi_players_arcade)&& (self.gameType != multi_players_level_select)){	
		if ((!self.isRemoteView) ){
			[self initScenarios:nil];
		}
	}
	self.duration = self.difficultFactor;
	if (self.theTimer){
		[self.theTimer invalidate];
	}
	if (self.difficultiesLevel != kWorldClass)
		[self setTimer:self.duration];
	else	{
		[self setTimer:1.5];
		self.remainedTime=1;
		[self.roundStartTime init]; 
	}
	[super startRound];

	[self initObjects];	
	if (self.gkMatch)
		self.gkMatch = self.gkMatch;
	else if (self.gkSession)
		self.gkSession = self.gkSession;

}

- (void) prepareToStartGameWithNewScenario:(BOOL)newScenario
{
	[self initObjects];	
	[super prepareToStartGameWithNewScenario:newScenario];
}

- (void) setGkMatch:(GKMatch*) match
{
	[super setGkMatch:match];
	if (self.opponentGirl)
		[self.opponentGirl removeFromSuperview];
	JumpingGirl* opponentGirl = [[JumpingGirl alloc] initWithOwner:self AndOrientation:self.orientation AndIsMyself:NO];
	self.opponentGirl = opponentGirl;
	[opponentGirl release];
	self.opponentGirl.color = kRed;
	[self addSubview:self.opponentGirl];
	[self bringSubviewToFront:self.theGirl];
}

- (void) setGkSession:(GKSession*) session
{
	[super setGkSession:session];
	if (self.opponentGirl)
		[self.opponentGirl removeFromSuperview];
	JumpingGirl* opponentGirl = [[JumpingGirl alloc] initWithOwner:self AndOrientation:self.orientation AndIsMyself:NO];
	self.opponentGirl = opponentGirl;
	[opponentGirl release];
	self.opponentGirl.color = kRed;
	[self addSubview:self.opponentGirl];
	[self bringSubviewToFront:self.theGirl];
}

/*
- (void) showPlayAgain{
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
	
	[super showPlayAgain];
}
*/
- (void) hidePlayAgain
{
	[super hidePlayAgain];
}

-(void) initBackground
{
	
	[self setBackgroundColor:[UIColor blackColor]];	
	UIImage* tmpImage = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"jumpinggirlbackground" ofType:@"png"]];
	UIImageView* tmpView = [[UIImageView alloc] initWithImage:tmpImage];
	[tmpView setFrame:backgroundRectP];
	self.backgroundView = tmpView;
	[self addSubview:tmpView];
	[tmpView release];
	
}


- (void) initObjects {
	if (self.theGirl)
		[self.theGirl removeFromSuperview];
	JumpingGirl* theGirl = [[JumpingGirl alloc] initWithOwner:self AndOrientation:self.orientation AndIsMyself:YES];
	self.theGirl = theGirl;
	[theGirl release];
	self.theGirl.color = kRed;
	[self addSubview:self.theGirl];
	[self enableButtons];
}


- (void) redButClicked
{
	[super redButClicked];
	if (self.seq==4)	{
		[sharedSoundEffectsManager playDripSound];
		[self.theGirl jumpToLeft];
		self.seq = 1;
		self.hits++;
		self.statTotalNum++;
		self.scoreFrame = CGRectMake(60, 80, 0, 0);
		self.score =  self.hits;
		if (self.difficultiesLevel == kWorldClass)	{
			self.remainedTime -= 0.16;
		}
	}
	else if (self.difficultiesLevel==kWorldClass)
		[self fail];
}

- (void) blueButClicked
{
	[super blueButClicked];
	if (self.seq==2)	{
		[sharedSoundEffectsManager playDripSound];
		[self.theGirl jumpToRight];
		self.seq = 3;
		self.hits++;
		self.statTotalNum++;
		self.scoreFrame = CGRectMake(260, 80, 0, 0);
		self.score =  self.hits;
		if (self.difficultiesLevel == kWorldClass)	{
			self.remainedTime -= 0.16;
		}
	}
	else if (self.difficultiesLevel==kWorldClass)
		[self fail];
}

- (void) greenButClicked
{
	[super greenButClicked];
	if (self.seq==1)	{
		[sharedSoundEffectsManager playDripSound];
		[self.theGirl jumpToRight];
		self.seq=2;
		self.hits++;
		self.statTotalNum++;
		self.scoreFrame = CGRectMake(160, 80, 0, 0);
		self.score =  self.hits;
		if (self.difficultiesLevel == kWorldClass)	{
			self.remainedTime -= 0.16;
		}
	}
	else if (self.seq==3)	{
		[sharedSoundEffectsManager playDripSound];
		[self.theGirl jumpToLeft];
		self.seq=4;
		self.hits++;
		self.statTotalNum++;
		self.scoreFrame = CGRectMake(160, 80, 0, 0);
		self.score =  self.hits;
		if (self.difficultiesLevel == kWorldClass)	{
			self.remainedTime -= 0.16;
		}
	}
	else if (self.difficultiesLevel==kWorldClass)
		[self fail];
}

- (void) redButClickedOpponent
{
	if (self.opponentSeq==4)	{
//		[sharedSoundEffectsManager playDripSound];
		[self.opponentGirl jumpToLeft];
		self.opponentSeq = 1;
	}
}

- (void) blueButClickedOpponent
{
	if (self.opponentSeq==2)	{
//		[sharedSoundEffectsManager playDripSound];
		[self.opponentGirl jumpToRight];
		self.opponentSeq = 3;
	}
}

- (void) greenButClickedOpponent
{
	if (self.opponentSeq==1)	{
//		[sharedSoundEffectsManager playDripSound];
		[self.opponentGirl jumpToRight];
		self.opponentSeq=2;
	}
	else if (self.opponentSeq==3)	{
//		[sharedSoundEffectsManager playDripSound];
		[self.opponentGirl jumpToLeft];
		self.opponentSeq=4;
	}
}

- (void) updateTimeBar:(NSTimer*)theTimer
{
	if (self.difficultiesLevel == kWorldClass)	{
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
	}
}

-(NSString*) getStat
{
	return [NSString stringWithFormat:NSLocalizedString(@"每跳用:%1.2fs", nil), (float)(self.statTotalSum/self.statTotalNum)];
}

-(UIImage*) getStatPic
{
	UIImageView* img = [[[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"torightgirl" ofType:@"png"]]] autorelease];
	img.frame = CGRectMake(20,20,40,40);
	return img;
}
@end