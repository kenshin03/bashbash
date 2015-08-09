//
//  HeartnHandView.m
//  bishibashi
//
//  Created by Eric on 25/03/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "HeartnHandView.h"
@implementation HeartnHandView
@synthesize me = _me;
@synthesize opponent = _opponent;
@synthesize myHand = _myHand;
@synthesize myHeart = _myHeart;
@synthesize opponentHand = _opponentHand;
@synthesize opponentHeart = _opponentHeart;
@synthesize sampleHands = _sampleHands;
@synthesize myHandShown = _myHandShown;
@synthesize currentRound = _currentRound;

static const CGRect backgroundRectP = {{10, 70}, {300, 310}};
static const CGRect backgroundRectL = {{10, 30}, {300, 210}};
static const CGRect backgroundRectR = {{15, 40}, {0, 0}};

static const CGRect sampleHand1Rect = {{25, 290}, {80, 80}};
static const CGRect sampleHand2Rect = {{140, 250}, {20, 20}};
static const CGRect sampleHand3Rect = {{240, 250}, {20, 20}};

static const CGRect myHeartRect = {{130, 200}, {60, 60}};
static const CGRect myHandRect = {{-10, 130}, {80, 80}};
static const CGRect opponentHandRect = {{280, 130}, {80, 80}};

-(void) initBackground
{
	[super initBackground];
/*	
	UIImage* tmpImage = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"mahjongtable" ofType:@"png"]];
	UIImageView* tmpView = [[UIImageView alloc] initWithImage:tmpImage];
	self.backgroundView = tmpView;
	[tmpView release];
	[self.backgroundView setFrame:backgroundRectP];
	[self addSubview:self.backgroundView];
 */
}

- (void) dealloc	{
//	[sharedSoundEffectsManager stopMahjongNoiseSound];
	self.me = nil;
	self.opponent = nil;
	self.myHand = nil;
	self.myHeart = nil;
	self.opponentHand = nil;
	self.opponentHeart = nil;
	
	self.sampleHands = nil;
	[super dealloc];
}


- (void) initScenarios:(NSArray*)scenarios
{
	[super initScenarios:scenarios];
	if (!scenarios)
	{
		self.noRun = 10;
		/* scenario is an array of 3 NSNumber(integer) of random number 0-4 */
		for (int i=0; i<self.noRun; i++)	{
			/*
			NSNumber* number1 = [NSNumber numberWithInt:arc4random()%5];
			NSNumber* number2 = [NSNumber numberWithInt:arc4random()%5];
			while ([number2 intValue] == [number1 intValue])
				number2 = [NSNumber numberWithInt:arc4random()%5];
			NSNumber* number3 = [NSNumber numberWithInt:arc4random()%5];
			while (([number3 intValue] == [number1 intValue]) || ([number3 intValue] == [number2 intValue]))
				number3 = [NSNumber numberWithInt:arc4random()%5];
			*/
			NSNumber* number1 = [NSNumber numberWithInt:arc4random()%5];
			NSNumber* number2 = [NSNumber numberWithInt:arc4random()%5];
			NSNumber* number3 = [NSNumber numberWithInt:arc4random()%5];
			NSLog(@"%d %d %d", [number1 intValue], [number2 intValue], [number3 intValue]);
			while ([number3 intValue] == [number2 intValue] && [number2 intValue] == [number1 intValue])	{
				NSLog(@"in while loop");
				number1 = [NSNumber numberWithInt:arc4random()%5];
				number2 = [NSNumber numberWithInt:arc4random()%5];
				number3 = [NSNumber numberWithInt:arc4random()%5];
				NSLog(@"%d %d %d", [number1 intValue], [number2 intValue], [number3 intValue]);
			}				
			NSArray* scenario = [[NSArray alloc] initWithObjects:number1, number2, number3, nil];
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
	[self clearSampleHands];
	self.sampleHands = [NSMutableArray arrayWithCapacity:3];
	self.noRun = 10;
	self.overheadTime=1.5;
	self.currentRound=0;
	
	if ((self.gameType != multi_players_arcade)&& (self.gameType != multi_players_level_select)){	
		if ((!self.isRemoteView) ){
			[self initScenarios:nil];
		}
	}
	
	[self startRound];	
	
	if (self.remoteView)
		[self.remoteView startGame];
}

- (void) initImages {
	[super initImages];
/*	
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
*/	
	Heart* myHeart = [[Heart alloc] initWithFrame:myHeartRect];
	self.myHeart = myHeart;
	[myHeart release];

	Hand* myHand = [[Hand alloc] initWithFrame:myHandRect];
	self.myHand = myHand;
	[self.myHand setRotateAngle:90];
	[myHand release];

	Hand* opponentHand = [[Hand alloc] initWithFrame:opponentHandRect];
	self.opponentHand = opponentHand;
	[self.opponentHand setRotateAngle:-90];
	self.opponentHand.isOpponent = YES;
	[opponentHand release];
	
	Heart* opponentHeart = [[Heart alloc] initWithFrame:myHeartRect];
	self.opponentHeart = opponentHeart;
	[opponentHeart release];
	
}

- (void) clearSampleHands
{
	if (self.sampleHands)	{
		for (Hand* hand in self.sampleHands)	{
			[hand removeFromSuperview];
		}
		[self.sampleHands removeAllObjects];
	}
}	

-(void) showSampleHands
{
	for (Hand* hand in self.sampleHands)	{
		[self addSubview:hand];
	}

	if (self.difficultiesLevel == kNormal)	{
		for (Hand* hand in self.sampleHands)	{
			[hand performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1.5];
		}
		for (Hand* hand in self.sampleHands)	{
			[self performSelector:@selector(addSubview:) withObject:hand afterDelay:2.5];
		}
	}		
	
	else if (self.difficultiesLevel == kHard)	{
		for (Hand* hand in self.sampleHands)	{
			[hand performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1];
		}
	}

	else if (self.difficultiesLevel == kWorldClass)	{
		for (Hand* hand in self.sampleHands)	{
			[hand performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.75];
		}
	}
}
	
- (void) opponentStartRound{
	self.myHandShown = NO;
	[self.myHand hide];
	[self.myHeart removeFromSuperview];
	self.opponentHand.val = arc4random()%5;
	self.opponentHeart.val = arc4random()%5;
	while (self.opponentHand.val == self.opponentHeart.val)
		self.opponentHeart.val = arc4random()%5;

	[self addSubview:self.opponentHeart];
	[self addSubview:self.opponentHand];
	[self.opponentHand show];
	[self.opponentHand performSelector:@selector(hide) withObject:nil afterDelay:0.8];
	[self.opponentHeart performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.8];
	
	[self performSelector:@selector(startRound) withObject:nil afterDelay:1];
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
	//	[sharedSoundEffectsManager stopMahjongNoiseSound];
		[self showPlayAgain];
	}
	else {
		[super startRound];
		[self clearSampleHands];
		self.myHandShown = NO;

		NSArray* Scenario = [self.scenarios objectAtIndex:self.currentRound];
		for (int i=0; i<3; i++)	{
			Hand* hand = [[Hand alloc] initWithFrame:sampleHand1Rect];
			hand.frame = CGRectOffset(hand.frame, 100*i, 0);
			hand.val = [[Scenario objectAtIndex:i] intValue];
			[self.sampleHands addObject:hand];
			[hand release];
		}
		[self showSampleHands];
		self.myHeart.val = [[Scenario objectAtIndex:arc4random()%3] intValue];
		[self performSelector:@selector(addSubview:) withObject:self.myHeart afterDelay:1];
		self.currentRound++;

		[self setTimer:self.difficultFactor];
		
//		[sharedSoundEffectsManager playMahjongNoiseSound];
		
	}
}	

- (void) fail	{
	if (!self.myHandShown)	{
		self.myHand.val = self.myHeart.val;
		[self addSubview:self.myHand];
		self.myHandShown = YES;
		[self.myHand show];
	}
//	[sharedSoundEffectsManager playFailSound];
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	[self disableButtons];
	[self addSubview:self.crossView];	
	[self.crossView setFrame:CGRectMake(self.crossView.frame.origin.x-1, self.crossView.frame.origin.y, self.crossView.frame.size.width, self.crossView.frame.size.height)];
	[UIView beginAnimations:@"fail_end" context:nil];
	[UIView setAnimationDuration:0.6];
	[UIView setAnimationDelegate:self]; 
	[UIView setAnimationDidStopSelector: @selector(animationDidStop:finished:context:)];	
	[self.crossView setFrame:CGRectMake(self.crossView.frame.origin.x+1, self.crossView.frame.origin.y, self.crossView.frame.size.width, self.crossView.frame.size.height)];
	[UIView commitAnimations];
}

- (void) success	{
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	self.score += (float)([self calScore]/10.0);
//	[sharedSoundEffectsManager playYeahSound];
	[self disableButtons];
	[self addSubview:self.OKView];	
	[self.OKView setFrame:CGRectMake(self.OKView.frame.origin.x-1, self.OKView.frame.origin.y, self.OKView.frame.size.width, self.OKView.frame.size.height)];
	[UIView beginAnimations:@"success_end" context:nil];
	[UIView setAnimationDuration:0.6];
	[UIView setAnimationDelegate:self]; 
	[UIView setAnimationDidStopSelector: @selector(animationDidStop:finished:context:)];	
	[self.OKView setFrame:CGRectMake(self.OKView.frame.origin.x+1, self.OKView.frame.origin.y, self.OKView.frame.size.width, self.OKView.frame.size.height)];
	[UIView commitAnimations];
}


- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	int contextid = [((NSNumber*)context) intValue];
	if ([animationID isEqualToString:@"success_end"] || [animationID isEqualToString:@"fail_end"])	{
		[self.crossView removeFromSuperview];
		[self.OKView removeFromSuperview];
		[self enableButtons];
		self.noRun--;
		
		if (self.gameType == multi_players_level_select){
			;
		}
		
		else if (! _toQuit){
			if ((self.difficultiesLevel == kWorldClass) && [animationID isEqualToString:@"fail_end"])	{
				[sharedSoundEffectsManager stopMahjongNoiseSound];
				[self showPlayAgain];
			}
			else
				[self opponentStartRound];
		}
		
	}
}


- (void) redButClicked
{
	[self.theTimer invalidate];
	[super redButClicked];
	self.myHand.val = [[self.sampleHands objectAtIndex:0] val];
	[self addSubview:self.myHand];
	self.myHandShown = YES;
	[self.myHand show];
	if (self.myHand.val != self.myHeart.val)
		[self success];
	else
		[self fail];
}

- (void) blueButClicked
{
	[self.theTimer invalidate];
	[super blueButClicked];
	self.myHand.val = [[self.sampleHands objectAtIndex:2] val];
	[self addSubview:self.myHand];
	self.myHandShown = YES;
	[self.myHand show];

	if (self.myHand.val != self.myHeart.val)
		[self success];
	else
		[self fail];
}

- (void) greenButClicked
{
	[self.theTimer invalidate];
	[super greenButClicked];
	self.myHand.val = [[self.sampleHands objectAtIndex:1] val];
	[self addSubview:self.myHand];
	self.myHandShown = YES;

	[self.myHand show];
	if (self.myHand.val != self.myHeart.val)
		[self success];
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
 

@end