//
//  3in1View.m
//  bishibashi
//
//  Created by Eric on 08/03/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "3in1View.h"
#import "Constants.h"


@implementation the3in1View
@synthesize curSeq = _curSeq;
@synthesize integratedType = _integratedType;
@synthesize seq = _seq;
@synthesize rMachine = _rMachine;
@synthesize bMachine = _bMachine;
@synthesize gMachine = _gMachine;

@synthesize rButton = _rButton;
@synthesize gButton = _gButton;
@synthesize bButton = _bButton;

@synthesize currentRound = _currentRound;
@synthesize positions = _positions;
@synthesize stations = _stations;
@synthesize theRoute = _theRoute;


static const CGRect backgroundRectP = {{15, 40}, {290, 340}};
static const CGRect backgroundRectL = {{20, 15}, {280, 210}};
static const CGRect backgroundRectR = {{10, 30}, {140, 210}};

static const CGRect SingleOKRect = {{100, 200}, {120, 140}};
static const CGRect SingleOKTimeRectP = {{100, 160}, {120, 30}};



- (void) dealloc	{
	self.theRoute = nil;
	self.seq = nil;
	self.rMachine = nil;
	self.bMachine = nil;
	self.gMachine = nil;
	
	self.bButton = nil;
	self.rButton = nil;
	self.gButton = nil;

	[super dealloc];
}

- (void) prepareToStartGameWithNewScenario:(BOOL)newScenario
{
	// to make the initial start round startable
	self.myTimeUsed = 0.0;
	self.opponentTimeUsed = 0.0;
	
	self.noRun = 10;
	self.currentRound = 0;
	self.overheadTime = 0.8;
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

- (void) startGame
{
	[super startGame];
	// set time bar max value in VS mode
	if (self.gkMatch || self.gkSession)	{
		self.timeBar.maxValue=10;
		self.opponentTimeBar.maxValue=10;
		self.timeBar.currentValue = 0;
		self.opponentTimeBar.currentValue = 0;
		
		// set VS mode as normal 
		self.difficultiesLevel = kNormal;
	}
	if (!self.theRoute)	{
		Route* theRoute = [[Route alloc] initWithOrientation:self.orientation 
									AndStationNames:[NSArray arrayWithObjects:@"test1", @"test2", @"test3",@"test4", nil] 
									AndColors:[NSArray arrayWithObjects:[NSNumber numberWithInt:0], [NSNumber numberWithInt:1], [NSNumber numberWithInt:2], nil]];
		self.theRoute = theRoute;
		[theRoute release];
		[self addSubview:self.theRoute];
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
		[self.scenarios removeAllObjects];
		self.noRun = 10;
		/* scenario is NSNumber of random number 0-5 */
		for (int i=0; i<self.noRun; i++)	{
			NSNumber* scenario = [NSNumber numberWithInt:arc4random()%6];
			[self.scenarios addObject:scenario];
		}
		
		// For Master Level
		if (self.difficultiesLevel == kWorldClass)	{
			[self.scenarios2 removeAllObjects];
			for (int i=0; i<self.noRun; i++)	{
				NSNumber* scenario = [NSNumber numberWithInt:arc4random()%6];
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
		for (int i=0; i<self.noRun; i++)	{
			NSNumber* scenario = [NSNumber numberWithInt:arc4random()%6];
			[self.scenarios2 addObject:scenario];
		}
	}
}

-(void) initBackground
{
	[self setBackgroundColor:[UIColor blackColor]];	
	
	UIImage* tmpImage = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"mtrroute" ofType:@"png"]];
	UIImageView* tmpView = [[UIImageView alloc] initWithImage:tmpImage];
	[tmpView setFrame:backgroundRectP];
	[self addSubview:tmpView];
	self.backgroundView = tmpView;
	[tmpView release];
	self.scoreFrame = CGRectMake(220, 40, 20, 20);
}



- (void) changeOrientationTo:(UIInterfaceOrientation) orientation
{
	[super changeOrientationTo:orientation];
	switch (orientation)    {
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
	[self.rMachine changeOrientationTo:orientation];
	[self.bMachine changeOrientationTo:orientation];
	[self.gMachine changeOrientationTo:orientation];
	
	switch (self.orientation)	{
		case (UIInterfaceOrientationPortrait):
		case (UIInterfaceOrientationPortraitUpsideDown):
		{
			CGPoint positions[] = {
				CGPointMake(270,50),CGPointMake(270,100),CGPointMake(120,100),CGPointMake(100,140),
				CGPointMake(20,70),CGPointMake(150,110),CGPointMake(140,240),CGPointMake(250,240),
				CGPointMake(220,110),CGPointMake(150,70),CGPointMake(150,100),CGPointMake(140,240),
				CGPointMake(250,240),CGPointMake(140,240),CGPointMake(150,110),CGPointMake(20,70),
				CGPointMake(160,180),CGPointMake(150,110),CGPointMake(150,70),CGPointMake(220,110),
				CGPointMake(160,180),CGPointMake(140,240),CGPointMake(270,100),CGPointMake(270,50)};
			self.positions = malloc(sizeof(CGPoint)*24);
			memcpy(self.positions, positions, sizeof(CGPoint)*24);
		}
			break;
		case (UIInterfaceOrientationLandscapeLeft):
		case (UIInterfaceOrientationLandscapeRight):
		{
			float ratio = 260.0/400.0;
			CGPoint positions[] = {
				CGPointMake(270,30*ratio),CGPointMake(270,80*ratio),CGPointMake(120,80*ratio),CGPointMake(100,120*ratio),
				CGPointMake(20,50*ratio),CGPointMake(150,90*ratio),CGPointMake(140,220*ratio),CGPointMake(250,220*ratio),
				CGPointMake(220,90*ratio),CGPointMake(150,50*ratio),CGPointMake(150,80*ratio),CGPointMake(140,220*ratio),
				CGPointMake(250,220*ratio),CGPointMake(140,220*ratio),CGPointMake(150,90*ratio),CGPointMake(20,50*ratio),
				CGPointMake(160,160*ratio),CGPointMake(150,90*ratio),CGPointMake(150,50*ratio),CGPointMake(220,90*ratio),
				CGPointMake(160,160*ratio),CGPointMake(140,220*ratio),CGPointMake(270,80*ratio),CGPointMake(270,30*ratio)};
			self.positions = malloc(sizeof(CGPoint)*24);
			memcpy(self.positions, positions, sizeof(CGPoint)*24);
		}
			break;		
	}
}

- (void) initObjects {

	self.stations = [NSArray  arrayWithObjects:
			/* RGY */			 NSLocalizedString(@"沙田",nil), NSLocalizedString(@"九龍塘",nil), NSLocalizedString(@"荔景",nil), NSLocalizedString(@"青衣",nil), 
			/* RYG */			 NSLocalizedString(@"荃灣西",nil), NSLocalizedString(@"南昌",nil), NSLocalizedString(@"香港",nil), NSLocalizedString(@"銅鑼灣",nil),
			/* GRY */			 NSLocalizedString(@"深水埗",nil), NSLocalizedString(@"美孚",nil), NSLocalizedString(@"南昌",nil), NSLocalizedString(@"香港",nil),
			/* GYR */			 NSLocalizedString(@"銅鑼灣",nil), NSLocalizedString(@"香港",nil), NSLocalizedString(@"南昌",nil), NSLocalizedString(@"荃灣西",nil),
			/* YRG */			 NSLocalizedString(@"九龍",nil), NSLocalizedString(@"南昌",nil), NSLocalizedString(@"美孚",nil), NSLocalizedString(@"深水埗",nil),
			/* YGR */			 NSLocalizedString(@"九龍",nil), NSLocalizedString(@"香港",nil), NSLocalizedString(@"九龍塘",nil), NSLocalizedString(@"沙田",nil),nil];

	switch (self.orientation)	{
		case (UIInterfaceOrientationPortrait):
		case (UIInterfaceOrientationPortraitUpsideDown):
		{
			CGPoint positions[] = {
				CGPointMake(270,50),CGPointMake(270,100),CGPointMake(120,100),CGPointMake(100,140),
				CGPointMake(20,70),CGPointMake(150,110),CGPointMake(140,240),CGPointMake(250,240),
				CGPointMake(220,110),CGPointMake(150,70),CGPointMake(150,100),CGPointMake(140,240),
				CGPointMake(250,240),CGPointMake(140,240),CGPointMake(150,110),CGPointMake(20,70),
				CGPointMake(160,180),CGPointMake(150,110),CGPointMake(150,70),CGPointMake(220,110),
				CGPointMake(160,180),CGPointMake(140,240),CGPointMake(270,100),CGPointMake(270,50)};
			self.positions = malloc(sizeof(CGPoint)*24);
			memcpy(self.positions, positions, sizeof(CGPoint)*24);
		}
			break;
		case (UIInterfaceOrientationLandscapeLeft):
		case (UIInterfaceOrientationLandscapeRight):
		{
			float ratio = 260.0/400.0;
			CGPoint positions[] = {
				CGPointMake(270,30*ratio),CGPointMake(270,80*ratio),CGPointMake(120,80*ratio),CGPointMake(100,120*ratio),
				CGPointMake(20,50*ratio),CGPointMake(150,90*ratio),CGPointMake(140,220*ratio),CGPointMake(250,220*ratio),
				CGPointMake(220,90*ratio),CGPointMake(150,50*ratio),CGPointMake(150,80*ratio),CGPointMake(140,220*ratio),
				CGPointMake(250,220*ratio),CGPointMake(140,220*ratio),CGPointMake(150,90*ratio),CGPointMake(20,50*ratio),
				CGPointMake(160,160*ratio),CGPointMake(150,90*ratio),CGPointMake(150,50*ratio),CGPointMake(220,90*ratio),
				CGPointMake(160,160*ratio),CGPointMake(140,220*ratio),CGPointMake(270,80*ratio),CGPointMake(270,30*ratio)};
			self.positions = malloc(sizeof(CGPoint)*24);
			memcpy(self.positions, positions, sizeof(CGPoint)*24);
		}
			break;
	}
			
	
	if (!self.rMachine)	{
		Machine* rMachine = [[Machine alloc] initWithOwner:self AndColor:kRed AndOrientation:self.orientation];
		self.rMachine = rMachine;
		[self addSubview:self.rMachine];
		[rMachine release];
	/*	
		UILabel* rLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		self.rButton = rLabel;
		[rLabel release];
		self.rButton.backgroundColor = [UIColor redColor];
		self.rButton.textColor = [UIColor whiteColor];
		self.rButton.font = [UIFont boldSystemFontOfSize:16];
		self.rButton.text = @"東鐵綫 西鐵綫";
		self.rButton.textAlignment = UITextAlignmentCenter;
	 */
	}
	if (!self.gMachine)	{
		Machine* gMachine = [[Machine alloc] initWithOwner:self AndColor:kGreen AndOrientation:self.orientation];
		self.gMachine = gMachine;
		[self addSubview:self.gMachine];
		[gMachine release];
		/*
		UILabel* rLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		self.gButton = rLabel;
		[rLabel release];
		self.gButton.backgroundColor = [UIColor greenColor];
		self.gButton.textColor = [UIColor whiteColor];
		self.gButton.font = [UIFont boldSystemFontOfSize:16];
		self.gButton.text = @"觀塘綫 荃灣綫";
		self.gButton.textAlignment = UITextAlignmentCenter;
		 */
	}
	
	
	if (!self.bMachine)	{
		Machine* bMachine = [[Machine alloc] initWithOwner:self AndColor:kBlue AndOrientation:self.orientation];
		self.bMachine = bMachine;
		[self addSubview:self.bMachine];
		[bMachine release];
		/*
		UILabel* rLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		self.bButton = rLabel;
		[rLabel release];
		self.bButton.backgroundColor = [UIColor orangeColor];
		self.bButton.textColor = [UIColor whiteColor];
		self.bButton.font = [UIFont boldSystemFontOfSize:16];
		self.bButton.text = @"東涌綫";
		self.bButton.textAlignment = UITextAlignmentCenter;
		 */
	}
	
	[self enableButtons];
	
}
- (void) startRound	{
	@synchronized(self)	{
  NSLog(@"no run is %d", self.noRun);
	if (self.difficultiesLevel == kWorldClass)
	{
		if (self.noRun==0)	{
			self.noRun=10;
			[self switchScenario];
		}
	}
	if (self.noRun==0){
		[self.theTimer invalidate];
		[self showPlayAgain];
	}
	else {
		[super startRound];
		[self setTimer:self.difficultFactor];
		self.noRun--;
		NSMutableArray* theSeq = [[NSMutableArray alloc] initWithCapacity:3];
		self.seq = theSeq;
		[theSeq release];
		[self initObjects];
		self.curSeq = 0;
		self.integratedType = [[self.scenarios objectAtIndex:self.currentRound] intValue];
		self.currentRound++;
		NSArray* colors;
		NSArray* stationNames;
		NSRange myRange = {self.integratedType*4, 4};
		switch (self.integratedType)	{
			case (0):
				[self.seq addObject:self.rMachine];
				self.rMachine.pos = 0;
				[self.seq addObject:self.gMachine];
				self.gMachine.pos = 1;
				[self.seq addObject:self.bMachine];
				self.bMachine.pos = 2;
				colors = [NSArray arrayWithObjects:[NSNumber numberWithInt:kRed], [NSNumber numberWithInt:kGreen], [NSNumber numberWithInt:kBlue], nil];	
				stationNames = [self.stations subarrayWithRange:myRange];
				CGRect a = {self.positions[self.integratedType*4],self.rMachine.frame.size};
				CGRect b = {self.positions[self.integratedType*4+1],self.gMachine.frame.size};
				CGRect c = {self.positions[self.integratedType*4+2],self.bMachine.frame.size};
				CGRect ab = {self.positions[self.integratedType*4+1],self.rMachine.frame.size};
				CGRect bc = {self.positions[self.integratedType*4+2],self.gMachine.frame.size};
				CGRect cd = {self.positions[self.integratedType*4+3],self.bMachine.frame.size};
				self.rMachine.frame = a;
				self.gMachine.frame = b;
				self.bMachine.frame = c;
				self.rMachine.finalPos = ab;
				self.gMachine.finalPos = bc;
				self.bMachine.finalPos = cd;
				break;
			case (1):
				[self.seq addObject:self.rMachine];
				self.rMachine.pos = 0;
				[self.seq addObject:self.bMachine];
				self.bMachine.pos = 1;
				[self.seq addObject:self.gMachine];
				self.gMachine.pos = 2;
				colors = [NSArray arrayWithObjects:[NSNumber numberWithInt:kRed], [NSNumber numberWithInt:kBlue], [NSNumber numberWithInt:kGreen], nil];
				stationNames = [self.stations subarrayWithRange:myRange];
				CGRect a2 = {self.positions[self.integratedType*4],self.rMachine.frame.size};
				CGRect b2 = {self.positions[self.integratedType*4+1],self.bMachine.frame.size};
				CGRect c2 = {self.positions[self.integratedType*4+2],self.gMachine.frame.size};
				CGRect ab2 = {self.positions[self.integratedType*4+1],self.rMachine.frame.size};
				CGRect bc2 = {self.positions[self.integratedType*4+2],self.bMachine.frame.size};
				CGRect cd2 = {self.positions[self.integratedType*4+3],self.gMachine.frame.size};
				self.rMachine.frame = a2;
				self.bMachine.frame = b2;
				self.gMachine.frame = c2;
				self.rMachine.finalPos = ab2;
				self.bMachine.finalPos = bc2;
				self.gMachine.finalPos = cd2;
				break;
			case (2):
				[self.seq addObject:self.gMachine];
				self.gMachine.pos = 0;
				[self.seq addObject:self.rMachine];
				self.rMachine.pos = 1;
				[self.seq addObject:self.bMachine];
				self.bMachine.pos = 2;
				colors = [NSArray arrayWithObjects:[NSNumber numberWithInt:kGreen], [NSNumber numberWithInt:kRed], [NSNumber numberWithInt:kBlue], nil];
				stationNames = [self.stations subarrayWithRange:myRange];
				CGRect a3 = {self.positions[self.integratedType*4],self.gMachine.frame.size};
				CGRect b3 = {self.positions[self.integratedType*4+1],self.rMachine.frame.size};
				CGRect c3 = {self.positions[self.integratedType*4+2],self.bMachine.frame.size};
				CGRect ab3 = {self.positions[self.integratedType*4+1],self.gMachine.frame.size};
				CGRect bc3 = {self.positions[self.integratedType*4+2],self.rMachine.frame.size};
				CGRect cd3 = {self.positions[self.integratedType*4+3],self.bMachine.frame.size};
				self.gMachine.frame = a3;
				self.rMachine.frame = b3;
				self.bMachine.frame = c3;
				self.gMachine.finalPos = ab3;
				self.rMachine.finalPos = bc3;
				self.bMachine.finalPos = cd3;
				break;
			case (3):
				[self.seq addObject:self.gMachine];
				self.gMachine.pos = 0;
				[self.seq addObject:self.bMachine];
				self.bMachine.pos = 1;
				[self.seq addObject:self.rMachine];
				self.rMachine.pos = 2;
				colors = [NSArray arrayWithObjects:[NSNumber numberWithInt:kGreen], [NSNumber numberWithInt:kBlue], [NSNumber numberWithInt:kRed], nil];
				stationNames = [self.stations subarrayWithRange:myRange];
				CGRect a4 = {self.positions[self.integratedType*4],self.gMachine.frame.size};
				CGRect b4 = {self.positions[self.integratedType*4+1],self.bMachine.frame.size};
				CGRect c4 = {self.positions[self.integratedType*4+2],self.rMachine.frame.size};
				CGRect ab4 = {self.positions[self.integratedType*4+1],self.gMachine.frame.size};
				CGRect bc4 = {self.positions[self.integratedType*4+2],self.bMachine.frame.size};
				CGRect cd4 = {self.positions[self.integratedType*4+3],self.rMachine.frame.size};
				self.gMachine.frame = a4;
				self.bMachine.frame = b4;
				self.rMachine.frame = c4;
				self.gMachine.finalPos = ab4;
				self.bMachine.finalPos = bc4;
				self.rMachine.finalPos = cd4;
				break;
			case (4):
				[self.seq addObject:self.bMachine];
				self.bMachine.pos = 0;
				[self.seq addObject:self.rMachine];
				self.rMachine.pos = 1;
				[self.seq addObject:self.gMachine];
				self.gMachine.pos = 2;
				colors = [NSArray arrayWithObjects:[NSNumber numberWithInt:kBlue], [NSNumber numberWithInt:kRed], [NSNumber numberWithInt:kGreen], nil];
				stationNames = [self.stations subarrayWithRange:myRange];
				CGRect a5 = {self.positions[self.integratedType*4],self.bMachine.frame.size};
				CGRect b5 = {self.positions[self.integratedType*4+1],self.rMachine.frame.size};
				CGRect c5 = {self.positions[self.integratedType*4+2],self.gMachine.frame.size};
				CGRect ab5 = {self.positions[self.integratedType*4+1],self.bMachine.frame.size};
				CGRect bc5 = {self.positions[self.integratedType*4+2],self.rMachine.frame.size};
				CGRect cd5 = {self.positions[self.integratedType*4+3],self.gMachine.frame.size};
				self.bMachine.frame = a5;
				self.rMachine.frame = b5;
				self.gMachine.frame = c5;
				self.bMachine.finalPos = ab5;
				self.rMachine.finalPos = bc5;
				self.gMachine.finalPos = cd5;
				break;
			case (5):
				[self.seq addObject:self.bMachine];
				self.bMachine.pos = 0;
				[self.seq addObject:self.gMachine];
				self.gMachine.pos = 1;
				[self.seq addObject:self.rMachine];
				self.rMachine.pos = 2;
				colors = [NSArray arrayWithObjects:[NSNumber numberWithInt:kBlue], [NSNumber numberWithInt:kGreen], [NSNumber numberWithInt:kRed], nil];
				stationNames = [self.stations subarrayWithRange:myRange];
				CGRect a6 = {self.positions[self.integratedType*4],self.bMachine.frame.size};
				CGRect b6 = {self.positions[self.integratedType*4+1],self.gMachine.frame.size};
				CGRect c6 = {self.positions[self.integratedType*4+2],self.rMachine.frame.size};
				CGRect ab6 = {self.positions[self.integratedType*4+1],self.bMachine.frame.size};
				CGRect bc6 = {self.positions[self.integratedType*4+2],self.gMachine.frame.size};
				CGRect cd6 = {self.positions[self.integratedType*4+3],self.rMachine.frame.size};
				self.bMachine.frame = a6;
				self.gMachine.frame = b6;
				self.rMachine.frame = c6;
				self.bMachine.finalPos = ab6;
				self.gMachine.finalPos = bc6;
				self.rMachine.finalPos = cd6;
				break;
		}
		[self.theRoute updateWithOrientation:self.orientation 
									AndStationNames:stationNames 
									AndColors:colors];

		[self.rMachine show];
		[self.gMachine show];
		[self.bMachine show];
		self.rButton.frame = CGRectMake(200, self.rMachine.frame.origin.y+30, 100,40);
		[self addSubview:self.rButton];
		self.gButton.frame = CGRectMake(200, self.gMachine.frame.origin.y+30, 100,40);
		[self addSubview:self.gButton];
		self.bButton.frame = CGRectMake(200, self.bMachine.frame.origin.y+30, 100,40);
		[self addSubview:self.bButton];
	}
		
  }
	
}	

- (void) fail	{
	/* send time spent to opponent */
	if (self.gkMatch || self.gkSession)	{
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
	
	if ([self.theTimer isValid])	{
		[self.theTimer invalidate];
		[sharedSoundEffectsManager playFailSound];
		[self disableButtons];
		
		// do not show the big cross in VS mode 
		if (!self.gkMatch && !self.gkSession)	{
			[self addSubview:self.crossView];
			[self.crossView setFrame:CGRectMake(self.crossView.frame.origin.x-1, self.crossView.frame.origin.y, self.crossView.frame.size.width, self.crossView.frame.size.height)];
			[UIView beginAnimations:@"failend" context:nil];
			[UIView setAnimationDuration:0.6];
			[UIView setAnimationDelegate:self]; 
			[UIView setAnimationDidStopSelector: @selector(animationDidStop:finished:context:)];	
			for (Machine* machine in self.seq)	{
		//		[machine setHidden:YES];
				;
			}
			[self.crossView setFrame:CGRectMake(self.crossView.frame.origin.x+1, self.crossView.frame.origin.y, self.crossView.frame.size.width, self.crossView.frame.size.height)];
			[UIView commitAnimations];
		}
		else {
			[self showRoundVSResult];
			[NSObject cancelPreviousPerformRequestsWithTarget:self];
	//		[self performSelector:@selector(startRound) withObject:nil afterDelay:1];
		}

	}
}

- (void) success {
	[sharedSoundEffectsManager playYeahSound];
	// do not show the big OK in VS mode
	if (!self.gkMatch&&!self.gkSession)	{
		self.OKView.frame = SingleOKRect;
		self.myOKView.frame = SingleOKTimeRectP;
		self.myOKView.font = [UIFont systemFontOfSize:30];
		float timeUsed = -(float)[self.roundStartTime timeIntervalSinceNow];
		self.statTotalSum += timeUsed;
		NSLog(@"success, statTotalSum is %f", self.statTotalSum);
		self.statTotalNum+=3;
		NSLog(@"statTotalNum is %d", self.statTotalNum);
		[self.myOKView setTime:timeUsed];
		[self addSubview:self.OKView];
		[self addSubview:self.myOKView];
	}
	
	[UIView beginAnimations:@"end" context:nil];
	[UIView setAnimationDuration:0.6];
	[UIView setAnimationDelegate:self]; 
	[UIView setAnimationDidStopSelector: @selector(animationDidStop:finished:context:)];	
	for (Machine* machine in self.seq)	{
//		[machine setHidden:YES];
		;
	}
	/*
	switch (self.orientation)	{
		case (UIInterfaceOrientationPortrait):
		case (UIInterfaceOrientationPortraitUpsideDown):
			[[self.machineImgs objectAtIndex:self.integratedType] setFrame:backgroundRectP];
			break;
		case (UIInterfaceOrientationLandscapeLeft):
		case (UIInterfaceOrientationLandscapeRight):
			[[self.machineImgs objectAtIndex:self.integratedType] setFrame:backgroundRectL];
			break;
		case (10):
			[[self.machineImgs objectAtIndex:self.integratedType] setFrame:backgroundRectR];
			break;
	}
	 */
	if (!self.gkMatch&&!self.gkSession)	{
		self.myOKView.frame = CGRectOffset(self.myOKView.frame, 0.1, 0);
		self.OKView.frame = CGRectOffset(self.OKView.frame, 0.1, 0);
	}
	[UIView commitAnimations];
}
   
- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	int contextid = [((NSNumber*)context) intValue];
		if ([animationID isEqualToString:@"end"] || [animationID isEqualToString:@"failend"])	{
			// do not show (and hide) the big cross in VS mode 
			if (!self.gkMatch && !self.gkSession)	{
				[self.crossView removeFromSuperview];
				[self.OKView removeFromSuperview];
				[self.myOKView removeFromSuperview];
			}
			
			if (self.gameType == multi_players_level_select){
				;
			}else if (!_toQuit){
				if ([animationID isEqualToString:@"failend"] && (self.difficultiesLevel == kWorldClass))	{
					self.noRun = 0;
					[self.theTimer invalidate];
					[self showPlayAgain];
				}
				else	{
					if (self.gkMatch || self.gkSession)	{
						;
					}
					else
						[self startRound];
				}
			}
		}
		else if ([animationID isEqualToString:@"integrate1"]){
			[sharedSoundEffectsManager playIntegrateSound];
			if (contextid==2)
				[self success];
		}
		else if ([animationID isEqualToString:@"fail"] && contextid==2 && [finished boolValue]==YES)	{
			[self fail];
		}

}



- (void) redButClicked
{
	[super redButClicked];
	Machine* machine = [self.seq objectAtIndex:self.curSeq];
	if (machine.color == kRed)	{
		self.curSeq ++;
		if (machine.pos == 2)	{
			/* send time spent to opponent */
			if (self.gkMatch || self.gkSession)	{
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
			[self.theTimer invalidate];
			self.score += (int)([self calScore]/10.0);
			[self disableButtons];
			
		}
		[self bringSubviewToFront:machine];
		[machine toIntegrate];
		[self.theRoute show:self.curSeq-1];
		
	}
	else{
		[self fail];
	}
}

- (void) blueButClicked
{
	[super blueButClicked];
	Machine* machine = [self.seq objectAtIndex:self.curSeq];
	if (machine.color == kBlue)	{
		self.curSeq ++;
		if (machine.pos == 2)	{
			/* send time spent to opponent */
			if (self.gkMatch || self.gkSession)	{
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
			[self.theTimer invalidate];
			self.score += (int)([self calScore]/10.0);
			[self disableButtons];
		}
		[self bringSubviewToFront:machine];
		[machine toIntegrate];
		[self.theRoute show:self.curSeq-1];
	}
	else{
		[self fail];
	}
}

- (void) greenButClicked
{
	[super greenButClicked];
	Machine* machine = [self.seq objectAtIndex:self.curSeq];
	if (machine.color == kGreen)	{
		self.curSeq ++;
		if (machine.pos == 2)	{
			/* send time spent to opponent */
			if (self.gkMatch || self.gkSession)	{
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
			[self.theTimer invalidate];
			self.score += (int)([self calScore]/10.0);
			[self disableButtons];
		}
		[self bringSubviewToFront:machine];
		[machine toIntegrate];
		[self.theRoute show:self.curSeq-1];
	}
	else{
		[self fail];
	}
}

// overwrite setScore for VS mode to not send /update time bar
- (void) setScore:(int) score
{
	if (!self.gkMatch && !self.gkSession)
		[super setScore:score];
}

-(NSString*) getStat
{
	return [NSString stringWithFormat:NSLocalizedString(@"每轉車用:%1.2fs", nil), (float)(self.statTotalSum/self.statTotalNum)];
}

-(UIImage*) getStatPic
{
	UIImageView* img = [[[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"mtr" ofType:@"png"]]] autorelease];
	img.frame = CGRectMake(20,20,40,40);
	return img;
}

@end
