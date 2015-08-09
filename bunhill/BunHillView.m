//
//  JumingGirlView.m
//  bishibashi
//
//  Created by Eric on 14/03/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BunHillView.h"


@implementation BunHillView
@synthesize theClimbingMan = _theClimbingMan;
@synthesize theClimbingManFlipped = _theClimbingManFlipped;
@synthesize duration = _duration;
@synthesize seq = _seq;
@synthesize queues = _queues;

static const CGRect backgroundRectP = {{20, 55}, {280, 360}};
static const CGRect backgroundRectL = {{20, 20}, {280, 220}};
static const CGRect backgroundRectR = {{30, 20}, {100, 240}};


- (void) dealloc	{
	NSLog(@"dealloc BunHillView");
	self.theClimbingMan = nil;
	self.theClimbingManFlipped = nil;
	self.queues = nil;
	[super dealloc];
}


- (void) fail
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(opponentCollectBun) object:nil];
	[NSObject cancelPreviousPerformRequestsWithTarget:self.theClimbingManFlipped selector:@selector(moveLeft) object:nil];
	[NSObject cancelPreviousPerformRequestsWithTarget:self.theClimbingManFlipped selector:@selector(moveRight) object:nil];
	[self showPlayAgain];
}


- (void) initScenarios:(NSArray*)scenarios
{
	[super initScenarios:scenarios];
	if (!scenarios)
	{
		/* scenario is an array of noRun NSNumber for random number 0-80 */
		for (int i=0; i<self.noRun; i++)	{
			NSNumber* scenario = [NSNumber numberWithInt:arc4random()%80];
			[self.scenarios addObject:scenario];
		}
	}
	if (self.remoteView)
		[self.remoteView initScenarios:self.scenarios];
}

- (void) startGame
{
	_VSModeIsRoundBased = NO;
	[super startGame];
	if ((self.gameType != multi_players_arcade)&& (self.gameType != multi_players_level_select)){	
		if ((!self.isRemoteView) ){
			[self initScenarios:nil];
		}
	}
	self.duration = self.difficultFactor;
	self.statTotalSum = self.difficultFactor;
	if (self.theTimer){
		[self.theTimer invalidate];
	}
	[self setTimer:self.duration];
	[super startRound];

	[self initObjects];	
	if (self.remoteView)
		[self.remoteView startGame];

	if (self.difficultiesLevel == kWorldClass)
		[self showBunForWorldClass];

}

- (void) prepareToStartGameWithNewScenario:(BOOL)newScenario
{
	[self.theClimbingMan resetPos];
	[self.theClimbingManFlipped resetPos];
	self.seq = 0;
	self.noRun = 120;
	[super prepareToStartGameWithNewScenario:newScenario];
}

- (void) changeOrientationTo:(UIInterfaceOrientation) orientation
{
	[super changeOrientationTo:orientation];
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

- (void) showPlayAgain
{
	[super showPlayAgain];
}

- (void) hidePlayAgain
{
	[super hidePlayAgain];
}

-(void) initBackground
{
	
	[self setBackgroundColor:[UIColor blackColor]];	
	UIImage* tmpImage = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"bunhillbackground" ofType:@"png"]];
	UIImageView* tmpView = [[UIImageView alloc] initWithImage:tmpImage];
	[tmpView setFrame:backgroundRectP];
	self.backgroundView = tmpView;
	[self addSubview:tmpView];
	[tmpView release];
	
}


- (void) initObjects {
	if (self.queues)	{
		for (NSMutableArray* queue in self.queues)	{
			for (Bun* aBun in queue)	{
				[aBun removeFromSuperview];
			}
		}
		self.queues = nil;
	}

	self.queues = [NSArray arrayWithObjects:[NSMutableArray arrayWithCapacity:10],
				   [NSMutableArray arrayWithCapacity:10],
				   [NSMutableArray arrayWithCapacity:10],
				   [NSMutableArray arrayWithCapacity:10],
				   [NSMutableArray arrayWithCapacity:10],
				   [NSMutableArray arrayWithCapacity:10],
				   [NSMutableArray arrayWithCapacity:10],
				   nil];

	for (int i=0; i<20; i++)	{
		int randNo = [[self.scenarios objectAtIndex:self.seq] intValue];
		self.seq++;
		if (randNo<60)	{
			int no2 = randNo%10;
			int no1 = (randNo-no2)/10;
			if (no1==0|| (no1==1&&no2<9) || (no1==2&&no2<7) || (no1==3&&no2<5) || (no1==4&&no2<3) || (no1==5&&no2<2))	{
				Bun* aBun = [[Bun alloc] initWithOwner:self andOrientation:self.orientation AndPos:no1 AndCol:[[self.queues objectAtIndex:no1] count]  AndSpecial:(no2==0) AndDifficultLevel:self.difficultiesLevel];
				[[self.queues objectAtIndex:no1] addObject:aBun];
				[aBun show];
				[self addSubview:aBun];
				[aBun release];
			}
		}
	}
	
	if (!self.theClimbingMan)	{
		ClimbingMan* theClimbingMan = [[ClimbingMan alloc] initWithOrientation:self.orientation];
		self.theClimbingMan = theClimbingMan;
		[theClimbingMan release];
		[self addSubview:self.theClimbingMan];
	}
	
	if (self.difficultiesLevel != kEasy && !self.theClimbingManFlipped)	{
		ClimbingMan* theClimbingManFlipped = [[ClimbingMan alloc] initWithOrientation:self.orientation];
		self.theClimbingManFlipped = theClimbingManFlipped;
		[theClimbingManFlipped release];
		[self.theClimbingManFlipped setComputer];
		[self addSubview:self.theClimbingManFlipped];
	}
	
	
	[self enableButtons];
	
}

- (void) setGkMatch:(GKMatch*) match
{
	[super setGkMatch:match];
	if (!self.theClimbingManFlipped)	{
		ClimbingMan* theClimbingManFlipped = [[ClimbingMan alloc] initWithOrientation:self.orientation];
		self.theClimbingManFlipped = theClimbingManFlipped;
		[theClimbingManFlipped release];
		[self.theClimbingManFlipped setComputer];
		[self addSubview:self.theClimbingManFlipped];
	}
}


- (void) updateTimeBar:(NSTimer*)theTimer
{
	if (self.difficultiesLevel!=kWorldClass)	{
		int randNo = [[self.scenarios objectAtIndex:self.seq] intValue];
		// do not control the opponent if VS match
		if (!self.gkMatch&&!self.gkSession)	{
			if (self.difficultiesLevel==kNormal)	{
				if (randNo<25)
					[self.theClimbingManFlipped moveRight];
				else if (randNo<50)
					[self.theClimbingManFlipped moveLeft];
				else if ([[self.queues objectAtIndex:self.theClimbingManFlipped.pos]count]>0)	{
					[self.theClimbingManFlipped moveArm];
					[self collectBun:self.theClimbingManFlipped.pos FromUser:NO];
				}	
			}
			else if (self.difficultiesLevel==kHard)	{
				if (randNo<25)
					[self.theClimbingManFlipped moveRight];
				else if (randNo<40)
					[self.theClimbingManFlipped moveLeft];
				else if ([[self.queues objectAtIndex:self.theClimbingManFlipped.pos]count]>0)		{
					[self.theClimbingManFlipped moveArm];
					[self collectBun:self.theClimbingManFlipped.pos FromUser:NO];
				}	
			}
		}
		
		self.seq++;
		if (randNo<60)	{
			int no2 = randNo%10;
			int no1 = (randNo-no2)/10;
			if (no1==0|| (no1==1&&no2<9) || (no1==2&&no2<7) || (no1==3&&no2<5) || (no1==4&&no2<3) || (no1==5&&no2<1))	{
				Bun* aBun = [[Bun alloc] initWithOwner:self andOrientation:self.orientation AndPos:no1 AndCol:[[self.queues objectAtIndex:no1] count] AndSpecial:(no2==0) AndDifficultLevel:self.difficultiesLevel];
				[[self.queues objectAtIndex:no1] addObject:aBun];
				[aBun show];
				[self addSubview:aBun];
				[aBun release];
			}
		}
		[super updateTimeBar:theTimer];
	}
}

-(void) showBunForWorldClass
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(opponentCollectBun) object:nil];
	[NSObject cancelPreviousPerformRequestsWithTarget:self.theClimbingManFlipped selector:@selector(moveLeft) object:nil];
	[NSObject cancelPreviousPerformRequestsWithTarget:self.theClimbingManFlipped selector:@selector(moveRight) object:nil];
	if (self.queues)	{
		for (NSMutableArray* queue in self.queues)	{
			for (Bun* aBun in queue)	{
				[aBun removeFromSuperview];
			}
			[queue removeAllObjects];
		}
	}

	
	int randNo = arc4random()%6;
	for (int i=0; i<6; i++)	{
		Bun* aBun = [[Bun alloc] initWithOwner:self andOrientation:self.orientation AndPos:i AndCol:0 AndSpecial:(i!=randNo) AndDifficultLevel:self.difficultiesLevel];
		if (i!=randNo)
			aBun.image = [UIImage imageNamed:@"bomb.png"];
		[[self.queues objectAtIndex:i] addObject:aBun];
		[aBun show];
		[self addSubview:aBun];
		[aBun release];
	}	
	
	int offset = randNo - self.theClimbingManFlipped.pos;
	if (offset>0)	{
		for (int i=0; i<offset; i++)	{
			[self.theClimbingManFlipped performSelector:@selector(moveRight) withObject:nil afterDelay:i*0.6];
		}
	}
	else if (offset <0)	{
		offset = -offset;
		for (int i=0; i<offset; i++)	{
			[self.theClimbingManFlipped performSelector:@selector(moveLeft) withObject:nil afterDelay:i*0.6];
		}		
	}
	[self performSelector:@selector(opponentCollectBun) withObject:nil afterDelay:offset+0.7];
	
}

-(void) opponentCollectBun 
{
	[self fail];
	[self.theClimbingManFlipped moveArm];
	[self collectBun:self.theClimbingManFlipped.pos FromUser:NO];
}	

- (void) collectBun:(int) pos FromUser:(BOOL)fromUser
{
	self.scoreFrame = CGRectOffset(self.theClimbingMan.frame, -5, -5);

	if ([[self.queues objectAtIndex:pos]count]>0)	{
		Bun* aBun =[[self.queues objectAtIndex:pos] objectAtIndex:0];
		if (fromUser)	{
			[[MediaManager sharedInstance] playMouthPopSound];
			self.score += aBun.score;
			self.statTotalNum++;
		}
		[aBun collectedFromUser:fromUser];
		[[self.queues objectAtIndex:pos]removeObjectAtIndex:0];
		for (Bun* aBun in [self.queues objectAtIndex:pos])	{
			aBun.column --;
			[aBun show];
		}
	}
}
		
- (void) redButClicked
{
	[super redButClicked];
	[self.theClimbingMan moveLeft];
}

- (void) blueButClicked
{
	[super blueButClicked];
	[self.theClimbingMan moveRight];	
}

- (void) greenButClicked
{
	[super greenButClicked];
	[self.theClimbingMan moveArm];
	if (self.difficultiesLevel!=kWorldClass)
		[self collectBun:self.theClimbingMan.pos FromUser:YES];
	else
	{
		Bun* aBun = [[self.queues objectAtIndex:self.theClimbingMan.pos] objectAtIndex:0];
		[self collectBun:self.theClimbingMan.pos FromUser:YES];
		if (!aBun.isSpecial)	{
			[self showBunForWorldClass];
		}
		else
			[self fail];
	}
}

- (void) redButClickedOpponent
{
	[self.theClimbingManFlipped moveLeft];
}

- (void) blueButClickedOpponent
{
	[self.theClimbingManFlipped moveRight];	
}

- (void) greenButClickedOpponent
{
	[self.theClimbingManFlipped moveArm];
	[self collectBun:self.theClimbingManFlipped.pos FromUser:NO];
}


-(NSString*) getStat
{
	return [NSString stringWithFormat:NSLocalizedString(@"每包用:%1.2fs", nil), (float)(self.statTotalSum/self.statTotalNum)];
}

-(UIImage*) getStatPic
{
	UIImageView* img = [[[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"bun" ofType:@"png"]]] autorelease];
	img.frame = CGRectMake(20,20,40,40);
	return img;
}
@end