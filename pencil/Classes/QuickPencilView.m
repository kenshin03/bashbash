//
//  QuickPencilView.m
//  bishibashi
//
//  Created by Eric on 14/03/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "QuickPencilView.h"


@implementation QuickPencilView

@synthesize localPencilHoldingHand = _localPencilHoldingHand;
@synthesize opponentPencilHoldingHand = _opponentPencilHoldingHand;
@synthesize localPencilLead = _localPencilLead;
@synthesize opponentPencilLead = _opponentPencilLead;
@synthesize hits = _hits;
@synthesize opponentHits = _opponentHits;
@synthesize opponentScore = _opponentScore;
@synthesize duration = _duration;

static const CGRect backgroundRectP = {{15, 80}, {290, 330}};


- (void) dealloc	{
	self.localPencilHoldingHand = nil;
	self.opponentPencilHoldingHand = nil;
	self.localPencilLead = nil;
	self.opponentPencilLead = nil;
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
	self.hits = 0;
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
	
	[self enableButtons];
	[self.redBut setEnabled:NO];
	[self.blueBut setEnabled:NO];
	

}

- (void) prepareToStartGameWithNewScenario:(BOOL)newScenario
{
	[self initObjects];	
	[super prepareToStartGameWithNewScenario:newScenario];
}

- (void) setGkMatch:(GKMatch*) match
{
	[super setGkMatch:match];
	
	QuickPencilOpponent* localOpponentPencilHoldingHand = [[QuickPencilOpponent alloc] initWithOwner:self isMyself:YES];
	self.opponentPencilHoldingHand = localOpponentPencilHoldingHand;
	[localOpponentPencilHoldingHand release];
	
	UIImageView* localOpponentPencilLeadView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"pencil_lead" ofType:@"png"]]];
	localOpponentPencilLeadView.frame = CGRectMake(28, 150, 95, 97);
	self.opponentPencilLead = localOpponentPencilLeadView;
	[self.opponentPencilLead setAlpha:0.1];
	[localOpponentPencilLeadView release];
	[self insertSubview:self.opponentPencilLead belowSubview:self.localPencilLead];
	[self insertSubview:self.opponentPencilHoldingHand belowSubview:self.localPencilHoldingHand];
	
}

- (void) setGkSession:(GKSession*) session
{
	[super setGkSession:session];
	
	QuickPencilOpponent* localOpponentPencilHoldingHand = [[QuickPencilOpponent alloc] initWithOwner:self isMyself:YES];
	self.opponentPencilHoldingHand = localOpponentPencilHoldingHand;
	[localOpponentPencilHoldingHand release];
	
	UIImageView* localOpponentPencilLeadView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"pencil_lead" ofType:@"png"]]];
	localOpponentPencilLeadView.frame = CGRectMake(28, 150, 95, 97);
	self.opponentPencilLead = localOpponentPencilLeadView;
	[self.opponentPencilLead setAlpha:0.1];
	[localOpponentPencilLeadView release];
	[self insertSubview:self.opponentPencilLead belowSubview:self.localPencilLead];
	[self insertSubview:self.opponentPencilHoldingHand belowSubview:self.localPencilHoldingHand];
	
}

- (void) hidePlayAgain
{
	[super hidePlayAgain];
}

-(void) initBackground
{
	[self setBackgroundColor:[UIColor blackColor]];		
	UIImage* tmpImage = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"pencil_background" ofType:@"png"]];
	UIImageView* tmpView = [[UIImageView alloc] initWithImage:tmpImage];
	[tmpView setFrame:CGRectMake(0, 0, 291, 373)];
	self.backgroundView = tmpView;
	[self addSubview:self.backgroundView];
	[self sendSubviewToBack:self.backgroundView];
	[tmpView release];
	
}


- (void) initObjects {
	if (self.localPencilHoldingHand){
		[self.localPencilHoldingHand removeFromSuperview];
	}
	if (self.localPencilLead){
		[self.localPencilLead removeFromSuperview];
	}
	QuickPencil* localPencilHoldingHand = [[QuickPencil alloc] initWithOwner:self isMyself:YES];
	self.localPencilHoldingHand = localPencilHoldingHand;
	[localPencilHoldingHand release];
	
	UIImageView* localPencilLeadView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"pencil_lead" ofType:@"png"]]];
	localPencilLeadView.frame = CGRectMake(98, 150, 95, 97);
	self.localPencilLead = localPencilLeadView;
	[localPencilLeadView release];
	
	[self addSubview:self.localPencilLead];
	[self addSubview:self.localPencilHoldingHand];
	
	[self disableButtons];
	
}



-(void)moveOutOpponentPencilLead{
	[UIView beginAnimations:@"move out opponent pencil lead" context:nil];
	[UIView setAnimationDuration:0.2]; 
	[UIView setAnimationDelegate:self];
	CGRect frame = self.opponentPencilLead.frame;
	frame.origin = CGPointMake(self.opponentPencilLead.frame.origin.x-8, self.opponentPencilLead.frame.origin.y+8);
	
	self.opponentPencilLead.frame = frame;
	[UIView commitAnimations];		
}

-(void)dropOpponentPencilLead{
	[sharedSoundEffectsManager playPencilLeadFallSound];
	[UIView beginAnimations:@"drop opponent pencil lead" context:nil];
	[UIView setAnimationDuration:0.1]; 
	[UIView setAnimationDelegate:self];
	CGRect frame = self.opponentPencilLead.frame;
	frame.origin = CGPointMake(self.opponentPencilLead.frame.origin.x, self.opponentPencilLead.frame.origin.y+100);
	self.opponentPencilLead.alpha = 0;
	self.opponentPencilLead.frame = frame;
	[UIView commitAnimations];
	
}


-(void)moveOutPencilLead{
	[UIView beginAnimations:@"move out pencil lead" context:nil];
	[UIView setAnimationDuration:0.2]; 
	[UIView setAnimationDelegate:self];
	CGRect frame = self.localPencilLead.frame;
	frame.origin = CGPointMake(self.localPencilLead.frame.origin.x-8, self.localPencilLead.frame.origin.y+8);
	
	self.localPencilLead.frame = frame;
	[UIView commitAnimations];		
}

-(void)dropPencilLead{
	[sharedSoundEffectsManager playPencilLeadFallSound];
	[UIView beginAnimations:@"drop pencil lead" context:nil];
	[UIView setAnimationDuration:0.04]; 
	[UIView setAnimationDelegate:self];
	CGRect frame = self.localPencilLead.frame;
	frame.origin = CGPointMake(self.localPencilLead.frame.origin.x, self.localPencilLead.frame.origin.y+100);
	self.localPencilLead.alpha = 0;
	self.localPencilLead.frame = frame;
	[UIView commitAnimations];
	
}


- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	if ([animationID isEqualToString:@"drop pencil lead"])	{
		// reset
		[self.localPencilLead removeFromSuperview];
		self.localPencilLead.frame = CGRectMake(98, 150, 95, 97);
		[self addSubview:self.localPencilLead];
		[self insertSubview:self.localPencilLead belowSubview:self.localPencilHoldingHand];
		self.localPencilLead.alpha = 1;
	}else if ([animationID isEqualToString:@"drop opponent pencil lead"]){
		// reset
		[self.opponentPencilLead removeFromSuperview];
		self.opponentPencilLead.frame = CGRectMake(28, 150, 95, 97);
		[self addSubview:self.opponentPencilLead];
		[self insertSubview:self.opponentPencilLead belowSubview:self.opponentPencilHoldingHand];
		self.opponentPencilLead.alpha = 1;
	}
}		

- (void) gameButClicked
{
	self.hits++;
	
	if (self.difficultiesLevel == kEasy){
			[self.localPencilHoldingHand buttonClicked];
			[self moveOutPencilLead];
			self.score = self.score + 1;
	}else if (self.difficultiesLevel == kNormal){
			[self.localPencilHoldingHand buttonClicked];
			[self moveOutPencilLead];
			self.score = self.score + 1;
	}else if (self.difficultiesLevel == kHard){
		if ((self.hits%2 == 0) && (self.hits != 0)){
			[self.localPencilHoldingHand buttonClicked];
			[self moveOutPencilLead];
			self.score = self.score + 1;
		}
	}else if (self.difficultiesLevel == kMaster){
		if ((self.hits%3 == 0) && (self.hits != 0)){
			[self.localPencilHoldingHand buttonClicked];
			[self moveOutPencilLead];
			self.score = self.score + 1;
		}
	}

	if ((self.score%10 == 0) && (self.score != 0) && (self.score != 1)){
		NSLog(@"self.score %i", self.score);
		self.scoreFrame = CGRectMake(60, 80, 0, 0);
		[self dropPencilLead];
	}
	
	
}


- (void) greenButClicked
{
	[super greenButClicked];
	[sharedSoundEffectsManager playPencilPressSound];
	
	[self gameButClicked];
}

- (void) greenButClickedOpponent
{
	NSLog(@"greenButClickedOpponent");
	self.opponentHits++;
	
	if (self.difficultiesLevel == kEasy){
		[self.opponentPencilHoldingHand buttonClicked];
		[self moveOutOpponentPencilLead];
	}else if (self.difficultiesLevel == kNormal){
		[self.opponentPencilHoldingHand buttonClicked];
		[self moveOutOpponentPencilLead];
	}else if (self.difficultiesLevel == kHard){
		if ((self.opponentHits%2 == 0) && (self.opponentHits != 0)){
			[self.opponentPencilHoldingHand buttonClicked];
			[self moveOutOpponentPencilLead];
		}
	}else if (self.difficultiesLevel == kMaster){
		if ((self.opponentHits%3 == 0) && (self.opponentHits != 0)){
			[self.opponentPencilHoldingHand buttonClicked];
			[self moveOutOpponentPencilLead];
		}
	}
	
	if ((self.opponentScore%10 == 0) && (self.opponentScore != 0) && (self.opponentScore != 1)){
		[self dropOpponentPencilLead];
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
	return nil;
}

-(UIImage*) getStatPic
{
	return [NSArray array];
}
@end