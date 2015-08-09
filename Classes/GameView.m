//
//  GameView.m
//  bishibashi
//
//  Created by Eric on 13/03/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GameView.h"
#import "TitleMenuViewController.h"


@implementation GameView
@synthesize statTotalNum = _statTotalNum;
@synthesize statTotalSum = _statTotalSum;

@synthesize submitPanel = _submitPanel;
@synthesize replayPanel = _replayPanel;

@synthesize whiteScreen = _whiteScreen;
@synthesize films = _films;

@synthesize gkMatch = _gkMatch;
@synthesize gkSession = _gkSession;
@synthesize gamePacket = _gamePacket;
@synthesize vsMsg = _vsMsg;
@synthesize vsAiView = _vsAiView;

@synthesize thePinPopUp = _thePinPopUP;
@synthesize bannerServed = _bannerServed;
@synthesize iAdBannerView = _iAdBannerView;

@synthesize lifes = _lifes;
@synthesize game = _game;
@synthesize myOKView = _myOKView;
@synthesize opponentOKView = _opponentOKView;
@synthesize OKView = _OKView;
@synthesize crossView = _crossView;
@synthesize backgroundView = _backgroundView;

@synthesize scenarios = _scenarios;
@synthesize scenarios2 = _scenarios2;
@synthesize gameFrame = _gameFrame;
@synthesize scoreView = _scoreView;
@synthesize scoreLabel = _scoreLabel;
@synthesize opponentTimeBar = _opponentTimeBar;
@synthesize timeBar = _timeBar;
@synthesize myPhoto = _myPhoto;
@synthesize opponentPhoto = _opponentPhoto;
@synthesize opponentTimeUsed = _opponentTimeUsed;
@synthesize myTimeUsed = _myTimeUsed;

@synthesize socialPanel = _socialPanel;
@synthesize timePie = _timePie;
@synthesize blueBut = _blueBut;
@synthesize greenBut = _greenBut;
@synthesize redBut = _redBut;
@synthesize replayImg = _replayImg;
@synthesize submitImg = _submitImg;
@synthesize pinImg = _pinImg;

@synthesize infoBut = _infoBut;
@synthesize exitBut = _exitBut;
@synthesize soundBut = _soundBut;
@synthesize socialBut = _socialBut;
@synthesize videoBut = _videoBut;
@synthesize globeBut = _globeBut;
@synthesize submitScoreBut = _submitScoreBut;
@synthesize readScoreBut = _readScoreBut;
@synthesize gcBut = _gcBut;
@synthesize replayBut = _replayBut;
@synthesize homeBut = _homeBut;

@synthesize owner = _owner;
@synthesize noRun = _noRun;
@synthesize roundTime = _roundTime;
@synthesize overheadTime = _overheadTime;
@synthesize remainedTime = _remainedTime;
@synthesize roundStartTime = _roundStartTime;

@synthesize theTimer = _theTimer;
@synthesize score = _score;
@synthesize difficultiesLevel = _difficultiesLevel;
@synthesize difficultFactor = _difficultFactor;

@synthesize orientation = _orientation;
@synthesize remoteView = _remoteView;
@synthesize isRemoteView = _isRemoteView;


@synthesize countDownThreeLabel = _countDownThreeLabel;
@synthesize countDownTwoLabel = _countDownTwoLabel;
@synthesize countDownOneLabel = _countDownOneLabel;
@synthesize gameStartLabel = _gameStartLabel;

@synthesize youWinImage = _youWinImage;

@synthesize navigationController;


@synthesize gameType =_gameType;
@synthesize roundResult =_roundResult;


@synthesize scoreFrame = _scroeFrame;

@synthesize waitingScreenUp = _waitingScreenUp;
@synthesize waitingScreenDown = _waitingScreenDown;

@synthesize submitAi = _submitAi;
@synthesize VSModeIsRoundBased = _VSModeIsRoundBased;

static const CGRect iAdBannerP = {{0, 345}, {320, 50}};
static const CGRect iAdBannerL = {{0, 0}, {480, 32}};


static const CGRect redButRectP = {{20, 400}, {80, 80}};
static const CGRect greenButRectP = {{120, 400}, {80, 80}};
static const CGRect blueButRectP = {{220, 400}, {80, 80}};


static const CGRect socialButRectP = {{250, 20}, {25,25}};
static const CGRect soundButRectP = {{280, 20}, {25,25}};
static const CGRect infoButRectP = {{15, 20}, {25,25}};
static const CGRect exitButRectP = {{25, 20}, {25,25}};
static const CGRect globeButRectP = {{220, 20}, {25,25}};
static const CGRect videoButRectP = {{190, 20}, {25,25}};


static const CGRect redButRectL = {{20, 240}, {80, 80}};
static const CGRect greenButRectL = {{120, 240}, {80, 80}};
static const CGRect blueButRectL = {{220, 240}, {80, 80}};

static const CGRect SingleOKRect = {{100, 210}, {120, 140}};
static const CGRect SingleOKTimeRectP = {{100, 170}, {120, 40}};

static const CGRect OKRectP = {{100, 210}, {120, 140}};
static const CGRect CrossRectP = {{100, 210}, {120, 140}};

static const CGRect myOKRectP = {{20, 80}, {120, 35}};
static const CGRect opponentOKRectP = {{180, 80}, {120, 35}};

static const CGRect myPhotoRect = {{15, 45}, {30, 30}};
static const CGRect opponentPhotoRect = {{275, 45}, {30, 30}};

static const CGRect singleTimeBarRectP = {{50, 45}, {210, 18}};
static const CGRect opponentTimeBarRectP = {{170, 45}, {105, 18}};
static const CGRect timeBarRectP = {{50, 45}, {105, 18}};
static const CGRect timePieRectP = {{150, 20}, {25, 25}};

static const CGRect socialPanelRectP = {{15, 46}, {291, 31}};
static const CGRect scoreFrameRectP = {{220, 40}, {20, 15}};

static const CGRect submitPanelRect = {{15,400}, {291,80}};
static const CGRect replayPanelRect = {{15,400}, {291,80}};

static const CGRect whiteScreenRect = {{15,80}, {292,310}};

static const CGRect vsMsgRect = {{20,280}, {280,30}};
static const CGRect vsAiViewRect = {{250,0}, {30,30}};

static const CGRect youWinRect = {{70, 275}, {180, 65}};

static const CGRect waitingScreenUpRect = {{0, 0}, {320, 205}};
static const CGRect waitingScreenDownRect = {{0,205}, {320,385}};

static const CGRect PinPopUpRect = {{20,300}, {150, 43}};
- (GameCenterManager*) gameCenterManagerInstance
{
	return [GameCenterManager sharedInstance];
}

- (id) initWithFrame:(CGRect)frameRect AndOwner:(id)owner AndGame:(Game) game AndGameType:(currrentGameType) gameType AndLevel:(GameLevel) level;
{
    self = [super initWithFrame:frameRect];
	_toQuit = NO;
	_VSModeIsRoundBased = YES; // default is YES, set to NO in some Specific classes
	self.gameType = gameType;
	self.game = game;
	self.difficultiesLevel = level;
	self.owner = owner;
	self.orientation = UIInterfaceOrientationPortrait;
	[self initBackground];
	[self initFilms];
	[self setGameFrame];
	[self initButtons];
	[self initImages];
	[self initVSResult];
	[self showPlayAgain];
	[self disableButtons];
	
	self.scoreFrame = scoreFrameRectP;
	self.isRemoteView = NO;
	sharedSoundEffectsManager = [MediaManager sharedInstance];	
	
#ifdef LITE_VERSION
	if ([[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)])	{
	if (self.gameType == one_player_level_select && NSClassFromString(@"ADBannerView")!=nil)	{		
		if (self.orientation == UIInterfaceOrientationPortrait || self.orientation == UIInterfaceOrientationPortraitUpsideDown)	{
			ADBannerView *adView = [[ADBannerView alloc] initWithFrame:iAdBannerP];
			adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifier320x50;
			adView.requiredContentSizeIdentifiers = [NSSet setWithObjects: ADBannerContentSizeIdentifier320x50, ADBannerContentSizeIdentifier480x32,nil];
			[self addSubview:adView];
			self.iAdBannerView = adView;
			adView.delegate = self;
			adView.frame = CGRectOffset(adView.frame, 320, 0);
			self.bannerServed = NO;
			[adView release];
		}
		else if (self.orientation == UIInterfaceOrientationLandscapeLeft || self.orientation == UIInterfaceOrientationLandscapeRight)	{
			ADBannerView *adView = [[ADBannerView alloc] initWithFrame:iAdBannerL];
			adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifier480x32;
			adView.requiredContentSizeIdentifiers = [NSSet setWithObjects: ADBannerContentSizeIdentifier320x50, ADBannerContentSizeIdentifier480x32,nil];
			[self addSubview:adView];
			self.iAdBannerView = adView;
			adView.delegate = self;
			adView.frame = CGRectOffset(adView.frame, 320, 0);
			self.bannerServed = NO;
			[adView release];
		}		
	}
	}
	else{
		NSLog(@"iAd Fail");
		self.bannerServed = NO;
		self.iAdBannerView = [AdMobView requestAdWithDelegate:self];
		self.iAdBannerView.frame = iAdBannerP;
		[self addSubview:self.iAdBannerView];
		self.iAdBannerView.frame = CGRectOffset(self.iAdBannerView.frame, 320, 0);
		NSLog(@"x is %f", self.iAdBannerView.frame.origin.x);
		
	}
#endif
	
    return self;
}


-(void) switchToCreditView
{
	
	CreditsViewController *creditsViewController = [[CreditsViewController alloc]initWithGameType:self.game];
	creditsViewController.isFromTransition = NO;
	creditsViewController.owner = self.owner;
	UIWindow* window = [[self.owner view] superview];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:window cache:YES];
	[window addSubview:creditsViewController.view];
	[[self.owner view] removeFromSuperview];
	[self.owner setView:creditsViewController.view];
	//	self.isShowingGameView = YES;
	[creditsViewController.view release];
	[UIView commitAnimations];
}


- (int) calScore
{
	float factor;
	switch (_difficultiesLevel)	{
		case (kEasy):
			factor = 0.4;
			break;
		case (kNormal):
			factor = 0.6;
			break;
		case (kHard):
			factor = 0.8;
			break;
		case (kWorldClass):
			factor = 1.0;
			break;
	}
	if (self.roundTime <= 0)
		return 0;
	if (self.remainedTime > self.roundTime-self.overheadTime)
		return (int)(100 * factor);
//	NSLog(@"remained Time %f roundTime %f score %d", self.remainedTime, self.roundTime ,  (int) ((100 * self.remainedTime) / (self.roundTime - self.overheadTime)));
	NSLog(@"calScore %f", ((factor*100 * self.remainedTime) / (self.roundTime - self.overheadTime)));
	NSLog(@"calScore%d", (int)((factor*100 * self.remainedTime) / (self.roundTime - self.overheadTime)));
	
	return (int) ((factor*100 * self.remainedTime) / (self.roundTime - self.overheadTime));
}

- (void) startRound	{
	self.roundStartTime = [NSDate date];
	self.myTimeUsed = 0.0;
	self.opponentTimeUsed = 0.0;
	[self enableButtons];
}

- (void) setTimer:(float)duration
{
	NSLog(@"setTimer");
	if (self.orientation==10)
		return;
	
	self.roundTime = duration;
	self.remainedTime = duration;
	if (duration<0)	{
		self.timePie = nil;
		self.theTimer = nil;
	}
	else	{
		if (self.theTimer)	{
			[self.theTimer invalidate];
			self.theTimer = nil;
		}
		if (self.timePie)	{
			NSLog(@"removeing timepie with count %d", [self.timePie retainCount]);
			[self.timePie removeFromSuperview];
			self.timePie = nil;
		}
		
		PieChartView* timePie;
		timePie = [[PieChartView alloc] initWithFrame:timePieRectP AndMaxVal:duration];
		self.timePie = timePie;
		[timePie release];
		[self addSubview:timePie];
		NSLog(@"after init, timepie count is %d", [self.timePie retainCount]);
		self.theTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(updateTimeBar:) userInfo:nil repeats:YES];
	}
}

- (void) setDifficultiesLevel:(GameLevel)level 
{
	_difficultiesLevel=level;
	self.difficultFactor = [[[[[Constants sharedInstance] gameTimerArray] objectAtIndex:self.game] objectAtIndex:_difficultiesLevel] floatValue];
	self.scoreView.level = level;
}

- (void) updateTimeBar:(NSTimer*)theTimer
{
	self.remainedTime = self.roundTime + 	[self.roundStartTime timeIntervalSinceNow];
	self.timePie.curVal = self.roundTime - self.remainedTime;
	if (self.remainedTime<=0)	{
//		self.theTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateTimeBar:) userInfo:nil repeats:NO];
//	}	
//	else {
		if( [self respondsToSelector:@selector(failGame)] ) {
			[self failGame];
		}
		else if( [self respondsToSelector:@selector(fail)] ) {
			[self fail];
		}
		[theTimer invalidate];
	}
}

- (void) setScore:(int) score
{
	if (score<0)
		score = 0;
	int diff = score-_score;
	_score = score;
	[self.timeBar setCurrentValue:self.score];
	ScoreBox* sb = [[ScoreBox alloc] initWithScore:diff AndView:self AndFrame:self.scoreFrame];
	[sb release];

	if (self.gkMatch || self.gkSession)	{
		self.gamePacket.packetType = kGKPacketTypeScoreUpdated;
		self.gamePacket.score = _score;
		NSError* error;
		if (self.gkMatch)
			[self.gkMatch sendDataToAllPlayers:[self.gamePacket toNSData] withDataMode:GKSendDataUnreliable error:&error];
		else
			[self.gkSession sendDataToAllPeers:[self.gamePacket toNSData] withDataMode:GKSendDataUnreliable error:&error];
	}
}

- (void) setGameFrame
{
		if (!self.gameFrame)	{
			NSString* gameFrame = [LocalStorageManager objectForKey:GAMEFRAME];
			if (gameFrame)	{
//				UIImageView* theView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"frame_%@2.png",gameFrame]]];
				UIImageView* theView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"frame_black.png"]];
				self.gameFrame = theView;
				[self addSubview:self.gameFrame];
				[theView release];
			}
		}
}


- (void) dealloc	{
	NSLog(@"dealloc GameView");
	self.scoreView.theGameRecord.delegate=nil;
	self.submitAi = nil;
	self.vsMsg = nil;
	self.vsAiView = nil;
	self.gcBut = nil;
	self.replayBut = nil;
	self.homeBut = nil;
	self.readScoreBut = nil;
	self.submitScoreBut = nil;
	
	self.submitPanel = nil;
	self.replayPanel = nil;
	self.whiteScreen = nil;
	self.films = nil;
	
	self.submitImg = nil;
	self.replayImg = nil;
	self.pinImg  = nil;
	
	self.myPhoto = nil;
	self.opponentPhoto = nil;
	
	self.gamePacket = nil;
	self.thePinPopUp = nil;
	if ([[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)])
		[self.iAdBannerView setDelegate:nil];
	self.iAdBannerView = nil;
	self.scenarios = nil;
	self.scenarios2 = nil;
	self.gameFrame = nil;
	self.scoreView = nil;
	self.timeBar = nil;
	self.opponentTimeBar = nil;
	self.scoreLabel = nil;
	self.socialPanel = nil;
	self.timePie = nil;
	self.blueBut = nil;
	self.redBut = nil;
	self.greenBut = nil;
	if (self.theTimer)
		[self.theTimer invalidate];
	self.theTimer = nil;
	
	self.myOKView = nil;
	self.opponentOKView = nil;
	self.OKView = nil;
	self.crossView = nil;
	self.backgroundView = nil;
	
	self.roundStartTime = nil;
	self.infoBut = nil;
	self.exitBut = nil;
	self.soundBut = nil;
	self.socialBut = nil;
	self.videoBut = nil;
	self.globeBut = nil;
	
	self.waitingScreenUp = nil;
	self.waitingScreenDown = nil;
	
	self.whiteScreen = nil;
	self.films = nil;
	self.youWinImage = nil;
	[super dealloc];
}

- (void) showVsMsg:(NSString*)msg
{
	if (self.youWinImage)	{
		[self.youWinImage removeFromSuperview];
		self.youWinImage = nil;
	}
	self.vsMsg.text = msg;
	[self bringSubviewToFront:self.vsMsg];
	[self.vsMsg setHidden:NO];
}

- (void) hideVsMsg
{
	[self.vsMsg setHidden:YES];
}


-(void) startGame
{
	self.statTotalSum=0;
	self.statTotalNum=0;
	if (self.gkMatch){
		NSLog(@"set opponent and want be NO");
	}
	self.score = 0;
	[self enableButtons];
	
	NSLog(@"startGame, self.game is %i", self.game);
	[[self.owner sharedSoundEffectsManager] startPlayingBGM:self.game];	
}

-(void) initVSResult
{
	
	VSResult* tmpView = [[VSResult alloc] initWithFrame:myOKRectP];
	self.myOKView = tmpView;
	[tmpView release];	
	tmpView = [[VSResult alloc] initWithFrame:opponentOKRectP];
	self.opponentOKView = tmpView;
	[tmpView release];	
	
	
	UILabel*	vsMsg = [[UILabel alloc] initWithFrame:vsMsgRect];
	self.vsMsg = vsMsg;
	self.vsMsg.textColor = [UIColor whiteColor];
	self.vsMsg.font = [UIFont boldSystemFontOfSize:24];
	self.vsMsg.textAlignment = UITextAlignmentCenter;
	self.vsMsg.backgroundColor = [UIColor grayColor];
	self.vsMsg.alpha=0.8;
	[vsMsg release];
	[self.vsMsg setHidden:YES];
	[self addSubview:self.vsMsg];
	UIActivityIndicatorView*	vsAiView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	self.vsAiView = vsAiView;
	self.vsAiView.frame = vsAiViewRect;
	[self.vsAiView startAnimating];
	[vsAiView release];
	[self.vsMsg addSubview:self.vsAiView];
}

-(void) initImages
{
	UIImageView* tmpView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cross.png"]];
	self.crossView = tmpView;
	[self.crossView setFrame:OKRectP];
	[tmpView release];
	
	tmpView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"OK.png"]];
	self.OKView = tmpView;
	[self.OKView setFrame:OKRectP];
	[tmpView release];
	
	UIView* waitingScreenUp = [[UIView alloc] initWithFrame:waitingScreenUpRect];
	self.waitingScreenUp = waitingScreenUp;
	[waitingScreenUp release];
	self.waitingScreenUp.backgroundColor = [UIColor grayColor];
	self.waitingScreenUp.alpha = 0.6;

	UIView* waitingScreenDown = [[UIView alloc] initWithFrame:waitingScreenDownRect];
	self.waitingScreenDown = waitingScreenDown;
	[waitingScreenDown release];
	self.waitingScreenDown.backgroundColor = [UIColor grayColor];
	self.waitingScreenDown.alpha = 0.6;
}

-(void) initFilms{
	UIView* whiteScreen = [[UIView alloc] initWithFrame:whiteScreenRect];
	self.whiteScreen = whiteScreen;
	[whiteScreen release];
	self.whiteScreen.backgroundColor = [UIColor grayColor];
	self.whiteScreen.alpha = 0.7;

//	NSArray* colors = [NSArray arrayWithObjects:@"blue", @"green", @"grey", @"lightblue", @"lightgreen", @"orange", @"pink", @"purpleblue", @"purple", @"purplered", @"red", @"yellow", nil];
	NSArray* colors = [NSArray arrayWithObjects:@"blue", @"green", @"grey", @"lightblue", @"lightgreen", @"orange", @"pink", @"purpleblue", @"purple", nil];

	self.films = [NSMutableArray arrayWithCapacity:9];
	int i=0;
	for (NSString* color in colors)	{
		PolaroidFilm* film = [[PolaroidFilm alloc] initWithColor:color AndText:nil AndTitle:nil];
		film.frame = CGRectMake(23+95*(i%3), 80+100*(i/3), 80,94);
		[self.films addObject:film];
		[film release];
		i++;
	}
}	

-(void) initBackground
{
	self.backgroundColor = [UIColor blackColor];	
}

- (void) initScenarios:(NSArray*) scenarios;
{
	if (!self.scenarios)	{
	NSLog(@"initScenarios with %@", scenarios);
	if (scenarios)	{
		NSMutableArray* tmp = [[NSMutableArray alloc] initWithArray:scenarios copyItems:YES];
		self.scenarios = tmp;
		[tmp release];
	}
	else {
		NSMutableArray* tmp = [[NSMutableArray alloc] initWithCapacity:self.noRun];
		self.scenarios = tmp;
		[tmp release];		
		
		/* for Master Level */
		if (self.difficultiesLevel==kWorldClass)	{
			tmp = [[NSMutableArray alloc] initWithCapacity:self.noRun];
			self.scenarios2 = tmp;
			[tmp release];		
		}			
												
	}
	}
}

-(void) initButtons
{
	
	UIImageView* panel = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"expandbox" ofType:@"png"]]];
	self.submitPanel = panel;
	[self.submitPanel setUserInteractionEnabled:YES];
	[panel release];
	self.submitPanel.frame = submitPanelRect;
	[self addSubview:self.submitPanel];
	if ([[Constants sharedInstance] gameCenterEnabled]) {
		self.gcBut = [UIButton buttonWithType:UIButtonTypeCustom];
		[self.gcBut setImage:[UIImage imageNamed:@"gamecenter_icon.png"] forState:UIControlStateNormal];
		self.gcBut.frame = CGRectMake(230, 20, 40,40);
		[self.submitPanel addSubview:self.gcBut];
		[self.gcBut addTarget:self action:@selector(gcIconClicked) forControlEvents:UIControlEventTouchUpInside];
		[self.gcBut addTarget:self action:@selector(gcButTapped) forControlEvents:UIControlEventTouchDown|UIControlEventTouchDragEnter];
		[self.gcBut addTarget:self action:@selector(gcButUnTapped) forControlEvents:UIControlEventTouchDragOutside|UIControlEventTouchDragExit|UIControlEventTouchUpOutside|UIControlEventTouchUpInside];
	}
	self.submitScoreBut = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.submitScoreBut setBackgroundImage:[UIImage imageNamed:@"submit.png"] forState:UIControlStateNormal];
	[self.submitScoreBut addTarget:self action:@selector(submitScoreButClicked) forControlEvents:UIControlEventTouchUpInside];
	[self.submitScoreBut addTarget:self action:@selector(submitScoreButTapped) forControlEvents:UIControlEventTouchDown|UIControlEventTouchDragEnter];
	[self.submitScoreBut addTarget:self action:@selector(submitScoreButUnTapped) forControlEvents:UIControlEventTouchDragOutside|UIControlEventTouchDragExit|UIControlEventTouchUpOutside|UIControlEventTouchUpInside];
	self.submitScoreBut.frame = CGRectMake(130, 20, 30,30);
	[self.submitPanel addSubview:self.submitScoreBut];
	
	self.readScoreBut = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.readScoreBut setBackgroundImage:[UIImage imageNamed:@"leaderboard.png"] forState:UIControlStateNormal];
	[self.readScoreBut addTarget:self action:@selector(readScoreButClicked) forControlEvents:UIControlEventTouchUpInside];
	[self.readScoreBut addTarget:self action:@selector(readScoreButTapped) forControlEvents:UIControlEventTouchDown|UIControlEventTouchDragEnter];
	[self.readScoreBut addTarget:self action:@selector(readScoreButUnTapped) forControlEvents:UIControlEventTouchDragOutside|UIControlEventTouchDragExit|UIControlEventTouchUpOutside|UIControlEventTouchUpInside];
	self.readScoreBut.frame = CGRectMake(30, 20, 30,30);
	[self.submitPanel addSubview:self.readScoreBut];
	[self.submitPanel setHidden:YES];
	
	panel = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"expandbox" ofType:@"png"]]];
	self.replayPanel = panel;
	[self.replayPanel setUserInteractionEnabled:YES];
	[panel release];
	self.replayPanel.frame = replayPanelRect;
	[self addSubview:self.replayPanel];
	self.replayBut = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.replayBut setBackgroundImage:[UIImage imageNamed:@"replay.png"] forState:UIControlStateNormal];
	[self.replayBut addTarget:self action:@selector(playAgainButClicked) forControlEvents:UIControlEventTouchUpInside];
	[self.replayBut addTarget:self action:@selector(replayButTapped) forControlEvents:UIControlEventTouchDown|UIControlEventTouchDragEnter];
	[self.replayBut addTarget:self action:@selector(replayButUnTapped) forControlEvents:UIControlEventTouchDragOutside|UIControlEventTouchDragExit|UIControlEventTouchUpOutside|UIControlEventTouchUpInside];
	self.replayBut.frame = CGRectMake(200, 20, 30,30);
	[self.replayPanel addSubview:self.replayBut];
	
	self.homeBut = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.homeBut setBackgroundImage:[UIImage imageNamed:@"home.png"] forState:UIControlStateNormal];
	[self.homeBut addTarget:self action:@selector(leaveGame) forControlEvents:UIControlEventTouchUpInside];
	[self.homeBut addTarget:self action:@selector(homeButTapped) forControlEvents:UIControlEventTouchDown|UIControlEventTouchDragEnter];
	[self.homeBut addTarget:self action:@selector(homeButUnTapped) forControlEvents:UIControlEventTouchDragOutside|UIControlEventTouchDragExit|UIControlEventTouchUpOutside|UIControlEventTouchUpInside];
	[self.homeBut setUserInteractionEnabled:YES];
	self.homeBut.frame = CGRectMake(50, 20, 30,30);
	[self.replayPanel addSubview:self.homeBut];
	[self.replayPanel setHidden:YES];
	
	self.blueBut = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.blueBut setBackgroundImage:[UIImage imageNamed:@"bluebutton.png"] forState:UIControlStateNormal];
	[self.blueBut setBackgroundImage:[UIImage imageNamed:@"bluebutton_pressed.png"] forState:UIControlStateHighlighted];
	[self.blueBut setFrame:blueButRectP];

	self.greenBut = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.greenBut setBackgroundImage:[UIImage imageNamed:@"greenbutton.png"] forState:UIControlStateNormal];
	[self.greenBut setBackgroundImage:[UIImage imageNamed:@"greenbutton_pressed.png"] forState:UIControlStateHighlighted];
	[self.greenBut setFrame:greenButRectP];
	
	self.redBut = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.redBut setBackgroundImage:[UIImage imageNamed:@"redbutton.png"] forState:UIControlStateNormal];
	[self.redBut setBackgroundImage:[UIImage imageNamed:@"redbutton_pressed.png"] forState:UIControlStateHighlighted];
	[self.redBut setFrame:redButRectP];
	
	[self.blueBut addTarget:self action:@selector(blueButClicked) forControlEvents:UIControlEventTouchDown];
	[self.greenBut addTarget:self action:@selector(greenButClicked) forControlEvents:UIControlEventTouchDown];
	[self.redBut addTarget:self action:@selector(redButClicked) forControlEvents:UIControlEventTouchDown];
	[self addSubview:self.blueBut];
	[self addSubview:self.redBut];
	[self addSubview:self.greenBut];
	
	
	/* either have social panel (single mode) or score bar with oppponentes (vs mode) */
	if (self.gkMatch || self.gkSession)	{
		OCProgress *timeBar = [[OCProgress alloc] initWithFrame:timeBarRectP ForMyself:YES AsSingleMode:NO];
		timeBar.maxValue=100.0;
		self.timeBar = timeBar;
		[timeBar release];
		[self addSubview:self.timeBar];
		
		timeBar = [[OCProgress alloc] initWithFrame:opponentTimeBarRectP ForMyself:NO AsSingleMode:NO];
		timeBar.maxValue=100.0;
		self.opponentTimeBar = timeBar;
		[timeBar release];
		[self addSubview:self.opponentTimeBar];
		
		WebImageView* myPhoto = [[WebImageView alloc] initWithFrame:myPhotoRect AndImageUrl:nil];
		self.myPhoto = myPhoto;
		[myPhoto release];
		[self addSubview:self.myPhoto];
		
		WebImageView* opponentPhoto = [[WebImageView alloc] initWithFrame:opponentPhotoRect AndImageUrl:nil];
		self.opponentPhoto = opponentPhoto;
		[opponentPhoto release];
		[self addSubview:self.opponentPhoto];
		
		if ([[[FBDataSource sharedInstance] fbSession] isConnected])	{
			[[GameCenterManager sharedInstance] setImageUrl:[LocalStorageManager objectForKey:FACEBOOK_IMAGE_URL]];
			[self.myPhoto initImageUrl:[LocalStorageManager objectForKey:FACEBOOK_IMAGE_URL]];
			self.gamePacket.packetType = kGKPacketTypeImageUrl;
			self.gamePacket.name = [LocalStorageManager objectForKey:FACEBOOK_IMAGE_URL];
			NSError* error;
			if (self.gkMatch)
				[self.gkMatch sendDataToAllPlayers:[self.gamePacket toNSData] withDataMode:GKMatchSendDataReliable error:&error];					
			else
				[self.gkSession sendDataToAllPeers:[self.gamePacket toNSData] withDataMode:GKMatchSendDataReliable error:&error];					
		}

		// set and send country
		[[GameCenterManager sharedInstance] setMyCountry:[LocalStorageManager objectForKey:COUNTRY]];
		self.gamePacket.packetType = kGKPacketTypeCountry;
		self.gamePacket.name = [LocalStorageManager objectForKey:COUNTRY];
		NSError* error;
		if (self.gkMatch)
			[self.gkMatch sendDataToAllPlayers:[self.gamePacket toNSData] withDataMode:GKMatchSendDataReliable error:&error];					
		else
			[self.gkSession sendDataToAllPeers:[self.gamePacket toNSData] withDataMode:GKMatchSendDataReliable error:&error];					
		
	}
	else{
		
		OCProgress *timeBar = [[OCProgress alloc] initWithFrame:singleTimeBarRectP ForMyself:YES AsSingleMode:YES];
		timeBar.maxValue=100.0;
		timeBar.name = [LocalStorageManager objectForKey:USER_NAME];
		self.timeBar = timeBar;
		[timeBar release];
		[self addSubview:self.timeBar];
		
		WebImageView* myPhoto = [[WebImageView alloc] initWithFrame:myPhotoRect AndImageUrl:nil];
		self.myPhoto = myPhoto;
		[myPhoto release];
		[self addSubview:self.myPhoto];

		if ([[[FBDataSource sharedInstance] fbSession] isConnected])	{
			[[GameCenterManager sharedInstance] setImageUrl:[LocalStorageManager objectForKey:FACEBOOK_IMAGE_URL]];
			[self.myPhoto initImageUrl:[LocalStorageManager objectForKey:FACEBOOK_IMAGE_URL]];
		}
		
	}
	
	SocialPanel *socialPanel = [[SocialPanel sharedInstance] initWithFrame:socialPanelRectP WithMsgBoard:nil AndOwner:self.owner];
	self.socialPanel = socialPanel;
	[socialPanel release];

	UILabel* tmp = [[UILabel alloc] initWithFrame:CGRectMake(24,17,56,18)];
	tmp.backgroundColor = [UIColor clearColor];
	tmp.text = NSLocalizedString(@"分數:",nil);
	tmp.textColor = [UIColor whiteColor];
	tmp.font = [UIFont systemFontOfSize:16];
	self.scoreLabel = tmp;
	//[self addSubview:tmp];
	[tmp release];
	
	self.infoBut = [UIButton buttonWithType:UIButtonTypeCustom];
	self.infoBut.frame = infoButRectP;
	[self.infoBut setImage:[UIImage imageNamed:@"info.png"] forState:UIControlStateNormal];
	[self addSubview:self.infoBut];
//	[self.infoBut setHidden:YES];
	[self.infoBut addTarget:self action:@selector(switchToCreditView) forControlEvents:UIControlEventTouchUpInside];
	[self.infoBut addTarget:self action:@selector(infoButTapped) forControlEvents:UIControlEventTouchDown|UIControlEventTouchDragEnter];
	[self.infoBut addTarget:self action:@selector(infoButUnTapped) forControlEvents:UIControlEventTouchDragOutside|UIControlEventTouchDragExit|UIControlEventTouchUpOutside|UIControlEventTouchUpInside];

	self.exitBut = [UIButton buttonWithType:UIButtonTypeCustom];
	self.exitBut.frame = exitButRectP;
	self.exitBut.backgroundColor = [UIColor clearColor];
	[self.exitBut setImage:[UIImage imageNamed:@"exit.png"] forState:UIControlStateNormal];
	[self addSubview:self.exitBut];
	[self.exitBut addTarget:self action:@selector(exitButClicked) forControlEvents:UIControlEventTouchUpInside];
	[self.exitBut addTarget:self action:@selector(exitButTapped) forControlEvents:UIControlEventTouchDown|UIControlEventTouchDragEnter];
	[self.exitBut addTarget:self action:@selector(exitButUnTapped) forControlEvents:UIControlEventTouchDragOutside|UIControlEventTouchDragExit|UIControlEventTouchUpOutside|UIControlEventTouchUpInside];

	self.socialBut = [UIButton buttonWithType:UIButtonTypeCustom];
	self.socialBut.frame = socialButRectP;
	self.socialBut.backgroundColor = [UIColor clearColor];
	[self.socialBut setImage:[UIImage imageNamed:@"social.png"] forState:UIControlStateNormal];
	[self addSubview:self.socialBut];
	[self.socialBut addTarget:self action:@selector(socialButClicked) forControlEvents:UIControlEventTouchUpInside];
	[self.socialBut addTarget:self action:@selector(socialButTapped) forControlEvents:UIControlEventTouchDown|UIControlEventTouchDragEnter];
	[self.socialBut addTarget:self action:@selector(socialButUnTapped) forControlEvents:UIControlEventTouchDragOutside|UIControlEventTouchDragExit|UIControlEventTouchUpOutside|UIControlEventTouchUpInside];
	[self.socialBut setEnabled:NO];

	self.globeBut = [UIButton buttonWithType:UIButtonTypeCustom];
	self.globeBut.frame = globeButRectP;
	self.globeBut.backgroundColor = [UIColor clearColor];
	[self.globeBut setImage:[UIImage imageNamed:@"globe.png"] forState:UIControlStateNormal];
	[self addSubview:self.globeBut];
	[self.globeBut addTarget:self action:@selector(globeButClicked) forControlEvents:UIControlEventTouchUpInside];
	[self.globeBut addTarget:self action:@selector(globeButTapped) forControlEvents:UIControlEventTouchDown|UIControlEventTouchDragEnter];
	[self.globeBut addTarget:self action:@selector(globeButUnTapped) forControlEvents:UIControlEventTouchDragOutside|UIControlEventTouchDragExit|UIControlEventTouchUpOutside|UIControlEventTouchUpInside];
	[self.globeBut setEnabled:NO];

	self.videoBut = [UIButton buttonWithType:UIButtonTypeCustom];
	self.videoBut.frame = videoButRectP;
	self.videoBut.backgroundColor = [UIColor clearColor];
	[self.videoBut setImage:[UIImage imageNamed:@"video.png"] forState:UIControlStateNormal];
	[self addSubview:self.videoBut];
	[self.videoBut addTarget:self action:@selector(videoButClicked) forControlEvents:UIControlEventTouchUpInside];
	[self.videoBut addTarget:self action:@selector(videoButTapped) forControlEvents:UIControlEventTouchDown|UIControlEventTouchDragEnter];
	[self.videoBut addTarget:self action:@selector(videoButUnTapped) forControlEvents:UIControlEventTouchDragOutside|UIControlEventTouchDragExit|UIControlEventTouchUpOutside|UIControlEventTouchUpInside];
	[self.videoBut setEnabled:NO];
	
	
	self.soundBut = [UIButton buttonWithType:UIButtonTypeCustom];
	self.soundBut.frame = soundButRectP;		
	self.soundBut.backgroundColor = [UIColor clearColor];
	if (![LocalStorageManager boolForKey:SOUNDOFF]){
		[self.soundBut setImage:[UIImage imageNamed:@"soundon.png"] forState:UIControlStateNormal];
	}else{
		[self.soundBut setImage:[UIImage imageNamed:@"soundoff.png"] forState:UIControlStateNormal];
	}
	[self addSubview:self.soundBut];
	[self.soundBut addTarget:self action:@selector(soundButClicked) forControlEvents:UIControlEventTouchUpInside];
	[self.soundBut addTarget:self action:@selector(soundButTapped) forControlEvents:UIControlEventTouchDown|UIControlEventTouchDragEnter];
	[self.soundBut addTarget:self action:@selector(soundButUnTapped) forControlEvents:UIControlEventTouchDragOutside|UIControlEventTouchDragExit|UIControlEventTouchUpOutside|UIControlEventTouchUpInside];
	
}

- (void) readScoreButClicked
{
	GameRecordMenuViewController*  theView = [[GameRecordMenuViewController alloc] init];
	if (self.gameType == one_player_arcade)
		theView.section = -2;
	else
		theView.section = self.game;
	
	[[self.owner navigationController] setNavigationBarHidden:NO animated:NO];
	[[self.owner navigationController] pushViewController:theView animated:YES];
	[theView release];
}

- (void) submitScoreButClicked
{
	CGRect screenRect = [[UIScreen mainScreen] bounds];
	UIGraphicsBeginImageContext(screenRect.size);
	
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	[[UIColor blackColor] set];
	CGContextFillRect(ctx, screenRect);
	
	[self.layer renderInContext:ctx];
	
	UIImage *image1 = UIGraphicsGetImageFromCurrentImageContext();
	NSData * imageData = UIImageJPEGRepresentation(image1, 0.1);
	NSString* imageStr = [NSString base64StringFromData:imageData length:[imageData length]];
	
	self.scoreView.theGameRecord.imageStr = imageStr;
	UIGraphicsEndImageContext();
	CFUUIDRef   uuid; 
    
	uuid = CFUUIDCreate(NULL); 
	self.scoreView.theGameRecord.uuid    = (NSString *) CFUUIDCreateString(NULL, uuid); 
	CFRelease(uuid); 
	
	self.scoreView.theGameRecord.delegate = self;
	[self.scoreView.theGameRecord submitGameRecord];	
	UIActivityIndicatorView* aiView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	self.submitAi = aiView;
	[aiView release];
	self.submitAi.frame = self.submitScoreBut.frame;
	[self.submitAi startAnimating];
	[self.submitPanel addSubview:self.submitAi];
	[self.submitScoreBut setHidden:YES];
	
}

-(void) finishedSubmitting
{
	[self.submitAi removeFromSuperview];
	self.submitAi = nil;
}

-(void) exitButTapped
{
	self.exitBut.transform = CGAffineTransformMakeScale(2.0, 2.0);
	[self socialButUnTapped];
	[self soundButUnTapped];
	[self infoButUnTapped];
	[self videoButUnTapped];
	[self globeButUnTapped];
}

-(void) exitButUnTapped
{
		self.exitBut.transform = CGAffineTransformMakeScale(1.0,1.0);		
}

-(void) socialButTapped
{
	self.socialBut.transform = CGAffineTransformMakeScale(2.0, 2.0);		
	[self soundButUnTapped];
	[self exitButUnTapped];
	[self infoButUnTapped];
	[self videoButUnTapped];
	[self globeButUnTapped];
}

-(void) socialButUnTapped
{
		self.socialBut.transform = CGAffineTransformMakeScale(1.0,1.0);		
}

-(void) globeButTapped
{
	self.globeBut.transform = CGAffineTransformMakeScale(2.0, 2.0);		
	[self soundButUnTapped];
	[self exitButUnTapped];
	[self infoButUnTapped];
	[self videoButUnTapped];
	[self socialButUnTapped];
}

-(void) globeButUnTapped
{
	self.globeBut.transform = CGAffineTransformMakeScale(1.0,1.0);		
}

-(void) videoButTapped
{
	self.videoBut.transform = CGAffineTransformMakeScale(2.0, 2.0);		
	[self soundButUnTapped];
	[self exitButUnTapped];
	[self infoButUnTapped];
	[self globeButUnTapped];
	[self socialButUnTapped];
}

-(void) videoButUnTapped
{
	self.videoBut.transform = CGAffineTransformMakeScale(1.0,1.0);		
}

-(void) soundButTapped
{
	self.soundBut.transform = CGAffineTransformMakeScale(2.0, 2.0);		
	[self socialButUnTapped];
	[self exitButUnTapped];
	[self infoButUnTapped];
	[self videoButUnTapped];
	[self globeButUnTapped];
}

-(void) soundButUnTapped
{
		self.soundBut.transform = CGAffineTransformMakeScale(1.0, 1.0);		
}

-(void) infoButTapped
{
	self.infoBut.transform = CGAffineTransformMakeScale(2.0, 2.0);		
	[self soundButUnTapped];
	[self socialButUnTapped];
	[self exitButUnTapped];
	[self videoButUnTapped];
	[self globeButUnTapped];
}

-(void) infoButUnTapped
{
	[UIView animateWithDuration:0.1 animations:^{
		self.infoBut.transform = CGAffineTransformMakeScale(1.0,1.0);		
	}];
}

-(void) gcButTapped
{
	self.gcBut.transform = CGAffineTransformMakeScale(2.0, 2.0);	
}

-(void) gcButUnTapped
{
	self.gcBut.transform = CGAffineTransformMakeScale(1.0, 1.0);	
}

-(void) readScoreButTapped
{
	self.readScoreBut.transform = CGAffineTransformMakeScale(2.0, 2.0);	
}

-(void) readScoreButUnTapped
{
	self.readScoreBut.transform = CGAffineTransformMakeScale(1.0, 1.0);	
}

-(void) submitScoreButTapped
{
	self.submitScoreBut.transform = CGAffineTransformMakeScale(2.0, 2.0);	
}

-(void) submitScoreButUnTapped
{
	self.submitScoreBut.transform = CGAffineTransformMakeScale(1.0, 1.0);	
}

-(void) replayButTapped
{
	self.replayBut.transform = CGAffineTransformMakeScale(2.0, 2.0);	
}

-(void) replayButUnTapped
{
	self.replayBut.transform = CGAffineTransformMakeScale(1.0, 1.0);	
}

-(void) homeButTapped
{
	self.homeBut.transform = CGAffineTransformMakeScale(2.0, 2.0);	
}

-(void) homeButUnTapped
{
	self.homeBut.transform = CGAffineTransformMakeScale(1.0, 1.0);	
}




- (void)gcIconClicked{
	NSString* prefix = @"bashbash.";
#ifdef LITE_VERSION
	prefix = @"bashbashlite.";
#endif
	
	if ([[Constants sharedInstance] gameCenterEnabled]) {
		GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
		leaderboardController.timeScope = GKLeaderboardTimeScopeAllTime;		
		leaderboardController.category = [NSString stringWithFormat:@"%@freeselect.%@", prefix,[[[Constants sharedInstance] gameLeaderboardsArray] objectAtIndex:self.game]];			
		
		if (leaderboardController != nil)
		{
			leaderboardController.leaderboardDelegate = self;
			[self.owner presentModalViewController: leaderboardController animated: YES];
		}
		[leaderboardController release];
	}
	
}

-(float) getLevel
{
	/*
	if (self.difficultiesLevel < 0.5){
		return 2.0;
	}else{
		return 1.0/self.difficultiesLevel;
	}
	 */
 }

-(void) showRoundVSResult
{
	@synchronized(self)	{
		float myTimeUsed = self.myTimeUsed;
		float opponentTimeUsed = self.opponentTimeUsed;
		BOOL VSResultDismissed=NO;
	NSLog(@"showRoundVSResult mytime is %f, opponentTime is %f", myTimeUsed, opponentTimeUsed);

		
	//to Show myOKView
	if (self.myTimeUsed!=0.0 && ![self.myOKView isDescendantOfView:self])	{
		if (opponentTimeUsed!=0.0 && myTimeUsed!=0.0)	{
			VSResultDismissed = YES;
			NSLog(@"show myOkView, set VSResultDismissed to YES");
		}
		NSLog(@"show myOkView");
		[self.myOKView setTime:self.myTimeUsed];
		[self addSubview:self.myOKView];
		[self addSubview:self.waitingScreenUp];
		[self addSubview:self.waitingScreenDown];
		[UIView animateWithDuration:0.2
						 animations:^{ 
							 self.waitingScreenUp.frame = CGRectOffset (waitingScreenUpRect, 0, -125);
							 self.waitingScreenDown.frame = CGRectOffset(waitingScreenDownRect, 0, 125);
						 }
						 completion:^(BOOL finished){
							 @synchronized(self)	{
							 if (opponentTimeUsed!=0.0 && myTimeUsed!=0.0)	{
								 [self dismissRoundVSResult];
							 }
							 }
						 }];
		
	}
	
	//to Show opponentOKView
	if (self.opponentTimeUsed!=0.0 && ![self.opponentOKView isDescendantOfView:self])	{
		NSLog(@"show opponentOkView");
		[self.opponentOKView setTime:self.opponentTimeUsed];
		[self addSubview:self.opponentOKView];
	}
		if (VSResultDismissed)
			NSLog(@"VSResultDismissed is YES");
		else
			NSLog(@"VSResultDismissed is NO");
		
	if (opponentTimeUsed!=0.0 && myTimeUsed!=0.0 && !VSResultDismissed)	{
		[self dismissRoundVSResult];
		VSResultDismissed = YES;
		NSLog(@"after dismiss set VSResultDismissed to YES");
		
	}
		
		// re-initialize opponentTimeUsed for round start
		if (myTimeUsed!=0.0 && opponentTimeUsed!=0.0)	{
			if ((opponentTimeUsed<0) && (myTimeUsed<0))	{
				NSLog(@"both lose");
				[self addSubview:self.crossView];
			}				
			else if (self.opponentTimeUsed<0)	{
				NSLog(@"i win as opponent failed");
				self.timeBar.currentValue +=1;
				_score = self.timeBar.currentValue;
				[self addSubview:self.OKView];
				[self.myOKView setWin];
			}
			else if (myTimeUsed<0)	{
				NSLog(@"opponent win as i failed");
				self.opponentTimeBar.currentValue +=1;
				[self.opponentOKView setWin];
				[self addSubview:self.crossView];
			}
			else if (myTimeUsed < opponentTimeUsed)	{
				NSLog(@"I win for faster");
				self.timeBar.currentValue +=1;
				_score = self.timeBar.currentValue;
				[self.myOKView setWin];				
				[self addSubview:self.OKView];
			}
			else if (opponentTimeUsed < myTimeUsed)	{
				NSLog(@"opponent win for faster");
				self.opponentTimeBar.currentValue +=1;
				[self.opponentOKView setWin];				
				[self addSubview:self.crossView];
			}
			
			NSLog(@"resetting myTime and opponentTime");
			self.opponentTimeUsed=0.0;
			self.myTimeUsed=0.0;
		}
		
		
	}
}

- (void) dismissRoundVSResult
{
	@synchronized(self)	{
	[UIView animateWithDuration:0.2 delay:1.0 options:nil 
					 animations:^{ 
						 self.waitingScreenUp.frame = waitingScreenUpRect;
						 self.waitingScreenDown.frame = waitingScreenDownRect;
					 }
					 completion:^(BOOL finished){ 	
						 @synchronized(self)	{
//						 self.opponentOKView.backgroundColor = [UIColor clearColor];
//						 self.myOKView.backgroundColor = [UIColor clearColor];
//						 [self.myOKView dismiss];
//						 [self.opponentOKView dismiss];
						 [self.myOKView removeFromSuperview];
						 [self.opponentOKView removeFromSuperview];
						 [self.OKView removeFromSuperview];
						 [self.crossView removeFromSuperview];
						 
						 [self.waitingScreenUp removeFromSuperview];
						 [self.waitingScreenDown removeFromSuperview];
						 NSLog(@"finished dismiss, start new round");
						 [self startRound];
						 }
					 }];
						 
	}	
}


- (void) setVSScoreBar
{
	if (self.gkMatch || self.gkSession)	{

		if (self.timeBar)	{
			[self.timeBar removeFromSuperview];
			self.timeBar = nil;
		}
		OCProgress *timeBar = [[OCProgress alloc] initWithFrame:timeBarRectP ForMyself:YES AsSingleMode:NO];
		timeBar.maxValue=100.0;
		timeBar.name = [[GameCenterManager sharedInstance] alias];
		self.timeBar = timeBar;
		[timeBar release];
		[self addSubview:self.timeBar];
		
		timeBar = [[OCProgress alloc] initWithFrame:opponentTimeBarRectP ForMyself:NO AsSingleMode:NO];
		timeBar.maxValue=100.0;
		timeBar.name = [[GameCenterManager sharedInstance] opponentAlias];
		self.opponentTimeBar = timeBar;
		[timeBar release];
		[self.opponentTimeBar setProgressColor:[UIColor orangeColor]];		
		[self addSubview:self.opponentTimeBar];
		
		WebImageView* myPhoto = [[WebImageView alloc] initWithFrame:myPhotoRect AndImageUrl:nil];
		self.myPhoto = myPhoto;
		[myPhoto release];
		[self addSubview:self.myPhoto];
		
		WebImageView* opponentPhoto = [[WebImageView alloc] initWithFrame:opponentPhotoRect AndImageUrl:nil];
		self.opponentPhoto = opponentPhoto;
		[opponentPhoto release];
		[self addSubview:self.opponentPhoto];
		
		if ([[[FBDataSource sharedInstance] fbSession] isConnected])	{
			[[GameCenterManager sharedInstance] setImageUrl:[LocalStorageManager objectForKey:FACEBOOK_IMAGE_URL]];
			[self.myPhoto initImageUrl:[LocalStorageManager objectForKey:FACEBOOK_IMAGE_URL]];
//			self.gamePacket.packetType = kGKPacketTypeImageUrl;
//			self.gamePacket.name = [LocalStorageManager objectForKey:FACEBOOK_IMAGE_URL];
//			NSError* error;
//			if (self.gkMatch)
//				[self.gkMatch sendDataToAllPlayers:[self.gamePacket toNSData] withDataMode:GKMatchSendDataReliable error:&error];					
//			else
//				[self.gkSession sendDataToAllPeers:[self.gamePacket toNSData] withDataMode:GKMatchSendDataReliable error:&error];					
		}
/*		
		//set and send country
		[[GameCenterManager sharedInstance] setMyCountry:[[LocalStorageManager objectForKey:COUNTRY]lowercaseString]];
		self.gamePacket.packetType = kGKPacketTypeCountry;
		self.gamePacket.name = [[LocalStorageManager objectForKey:COUNTRY]lowercaseString];
		NSError* error;
		if (self.gkMatch)
			[self.gkMatch sendDataToAllPlayers:[self.gamePacket toNSData] withDataMode:GKMatchSendDataReliable error:&error];					
		else
			[self.gkSession sendDataToAllPeers:[self.gamePacket toNSData] withDataMode:GKMatchSendDataReliable error:&error];					
 */
	}
}

- (void) hidePlayAgain
{
	[self.socialBut setEnabled:NO];
	[self.videoBut setEnabled:NO];
	[self.globeBut setEnabled:NO];
	[self.socialPanel disableButtons];

	[self.owner setLockedOrientation:YES];
	[self enableButtons];

}

-(void) setButtonsAfterFinish{
	if ([self.owner gameType]==one_player_arcade)	
		if ([self.owner isLite])	
			[[Constants sharedInstance] regenerateGamesForMode:kArcadeLite FromMode:kArcade];
		
	[self.socialBut setEnabled:YES];
	[self.globeBut setEnabled:YES];
	[self.videoBut setEnabled:YES];
	if (![self.socialPanel isDescendantOfView:self])	{
		[self addSubview:self.socialPanel];
		[self.socialPanel enableButtons];
	}

	UIImageView* tmpView;
	if (!self.replayImg)	{
		tmpView= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"replay.png"]];
		tmpView.frame = CGRectMake(29, 24, 25,25);
		self.replayImg = tmpView;
		[self.blueBut addSubview:tmpView];
		[tmpView release];
	}
	else
		[self.replayImg setHidden:NO];
		
	if (!self.submitImg)	{
		tmpView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"submit.png"]];
		tmpView.frame = CGRectMake(29, 24, 25,25);
		self.submitImg = tmpView;
		[self.greenBut addSubview:tmpView];
		[tmpView release];
	}
	else
		[self.submitImg setHidden:NO];

	if (!self.pinImg)	{		
		tmpView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pin.png"]];
		tmpView.frame = CGRectMake(29, 24, 25,25);
		self.pinImg = tmpView;
		[self.redBut addSubview:tmpView];
		[tmpView release];
	}
	else
		[self.pinImg setHidden:NO];

	[self.blueBut removeTarget:self action:@selector(blueButClicked) forControlEvents:UIControlEventTouchDown];
	[self.greenBut removeTarget:self action:@selector(greenButClicked) forControlEvents:UIControlEventTouchDown];
	[self.redBut removeTarget:self action:@selector(redButClicked) forControlEvents:UIControlEventTouchDown];
	
	[self.blueBut addTarget:self action:@selector(toggleReplayPanel) forControlEvents:UIControlEventTouchDown];
	[self.greenBut addTarget:self action:@selector(toggleSubmitPanel) forControlEvents:UIControlEventTouchDown];
	[self.redBut addTarget:self action:@selector(pinClicked) forControlEvents:UIControlEventTouchDown];
	
	
	[self enableButtons];
}

-(void) setButtonsAfterFinishForVSMode{
	// post VS result to Game Center Leaderboard
	[self postUpdateToGameCenter];
	/* re generate lite sequece */
	// do not allow replay for VS arcade modes
	if ([self.owner gameType]==multi_players_arcade)	{
		if ([self.owner isLite])	
			[[Constants sharedInstance] regenerateGamesForMode:kVSArcadeLite FromMode:kVSArcade];
			[self.replayBut setHidden:YES];
	}
	
	UIImageView* tmpView;
	if (!self.replayImg)	{
		tmpView= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"replay.png"]];
		tmpView.frame = CGRectMake(29, 24, 25,25);
		self.replayImg = tmpView;
		[self.blueBut addSubview:tmpView];
		[tmpView release];
	}
	else
		[self.replayImg setHidden:NO];
	
	[self.blueBut removeTarget:self action:@selector(blueButClicked) forControlEvents:UIControlEventTouchDown];
	[self.greenBut removeTarget:self action:@selector(greenButClicked) forControlEvents:UIControlEventTouchDown];
	[self.redBut removeTarget:self action:@selector(redButClicked) forControlEvents:UIControlEventTouchDown];
	
	[self.blueBut addTarget:self action:@selector(toggleReplayPanel) forControlEvents:UIControlEventTouchDown];
	[self.greenBut addTarget:self action:@selector(toggleSubmitPanel) forControlEvents:UIControlEventTouchDown];
	[self.redBut addTarget:self action:@selector(pinClicked) forControlEvents:UIControlEventTouchDown];

	[self.blueBut setEnabled:YES];
}

-(void)unsetButtonsAfterFinish{
	[self.replayImg setHidden:YES];
	[self.submitImg setHidden:YES];
	[self.pinImg setHidden:YES];

	[self.blueBut removeTarget:self action:@selector(toggleReplayPanel) forControlEvents:UIControlEventTouchDown];
	[self.greenBut removeTarget:self action:@selector(toggleSubmitPanel) forControlEvents:UIControlEventTouchDown];
	[self.redBut removeTarget:self action:@selector(pinClicked) forControlEvents:UIControlEventTouchDown];
	
	[self.blueBut addTarget:self action:@selector(blueButClicked) forControlEvents:UIControlEventTouchDown];
	[self.greenBut addTarget:self action:@selector(greenButClicked) forControlEvents:UIControlEventTouchDown];
	[self.redBut addTarget:self action:@selector(redButClicked) forControlEvents:UIControlEventTouchDown];	
	
	[self.submitScoreBut setHidden:NO];

}

-(void) finishGame
{
	GameMode mode;
	if ([self.owner gameType]==multi_players_arcade)	{
		if ([self.owner isLite])	{
			mode = kVSArcadeLite;
		}
		else
			mode = kVSArcade;
	}
	else if ([self.owner gameType]==one_player_arcade)	{
		if ([self.owner isLite])	{
			mode = kArcadeLite;
		}
		else
			mode = kArcade;
	}
	

	if ([self.owner gameType]==one_player_level_select)
		[self.scoreView saveScore];
	else if ([self.owner gameType]==one_player_arcade && ![self.owner isLite] && self.game==[[Constants sharedInstance] lastGameForMode:kArcade])
		[self.scoreView saveScore];
	else if ([self.owner gameType]==one_player_arcade && [self.owner isLite] && self.game==[[Constants sharedInstance] lastGameForMode:kArcadeLite])
		[self.scoreView saveScore];
	
	if ([self.owner gameType]==one_player_arcade)	{
		[[Constants sharedInstance] updateAttributeScore:self.score ForGame:self.game];
		[[Constants sharedInstance] logAttributeScores];
	}
	
	NSLog(@"lifes is %d", self.lifes);
	// level_select do nothing
	if ([self.owner gameType]==one_player_level_select || [self.owner gameType]==multi_players_level_select)
		;
	// one_player_arcade fail
	else if ([self.owner gameType]==one_player_arcade && self.lifes==0)	{
		[self performSelector:@selector(switchToResult:) withObject:[NSArray arrayWithObjects:[NSNumber numberWithBool:NO],[NSNumber numberWithInt:[[Constants sharedInstance] noAvailableGames][mode]],nil] afterDelay:3];
	}
	// not final game
	else if (self.game!=[[Constants sharedInstance]lastGameForMode:mode]) {
		[[GameCenterManager sharedInstance] setScenarios:nil];
		[self performSelector:@selector(showTransitionOut) withObject:nil afterDelay:5];
	}
	else if ([self.owner gameType]==one_player_arcade)	{
		[self performSelector:@selector(switchToResult:) withObject:[NSArray arrayWithObjects:[NSNumber numberWithBool:YES],[NSNumber numberWithInt:[[Constants sharedInstance] noAvailableGames][mode]],nil] afterDelay:3];
	}
}	

- (void) switchToResult:(NSArray*)args
{
	if ([self.owner isLite])	
		[[Constants sharedInstance] regenerateGamesForMode:kVSArcadeLite FromMode:kVSArcade];
	
	PentagonChartViewController* resultView = [[PentagonChartViewController alloc]initWithScore:[self.owner totalScore] AndScores:[[Constants sharedInstance] attributeScoresArray] AndNumGame:[[args objectAtIndex:1] intValue] AndGameView:self AndPass:[[args objectAtIndex:0] boolValue]];
	[[self.owner navigationController] pushViewController:resultView animated:YES];	
	[resultView release];
}	
	
	
-(void) toggleSubmitPanel
{
	if ([self.submitPanel isHidden])	{
		[self.submitPanel setHidden:NO];
		[self bringSubviewToFront:self.submitPanel];
		[self bringSubviewToFront:self.gameFrame];
		[self bringSubviewToFront:self.blueBut];
		[self bringSubviewToFront:self.greenBut];
		[self bringSubviewToFront:self.redBut];
		[UIView animateWithDuration:0.5 animations:^{
			self.submitPanel.frame = CGRectOffset(self.submitPanel.frame, 0, -70);
		}];
	}
	else {
		[UIView animateWithDuration:1 animations:^{
			self.submitPanel.frame = CGRectOffset(self.submitPanel.frame, 0, 70);
		}
		completion:^(BOOL finished){
			[self.submitPanel setHidden:YES];				 
		}];
	}

	
}

-(void) toggleReplayPanel
{
	if ([self.replayPanel isHidden])	{
		[self.replayPanel setHidden:NO];
		[self sendSubviewToBack:self.replayPanel];
		[self bringSubviewToFront:self.replayPanel];
		[self bringSubviewToFront:self.gameFrame];
		[self bringSubviewToFront:self.blueBut];
		[self bringSubviewToFront:self.greenBut];
		[self bringSubviewToFront:self.redBut];
		[UIView animateWithDuration:0.5 animations:^{
			self.replayPanel.frame = CGRectOffset(self.replayPanel.frame, 0, -70);
		}];
	}
	else {
		[UIView animateWithDuration:1 animations:^{
			self.replayPanel.frame = CGRectOffset(self.replayPanel.frame, 0, 70);
		}
		completion:^(BOOL finished){
			[self.replayPanel setHidden:YES];				 
		}];		
	}
}

-(void) videoButClicked
{
	[self.owner setTitle:NSLocalizedString(@"遊戲",nil)];
	VideoTableViewController* theConfigView = [[VideoTableViewController alloc]initWithPage:self.game];
	[[self.owner navigationController] pushViewController:theConfigView animated:YES];	
	[theConfigView release];	
}

-(void) globeButClicked
{
	[self.owner setTitle:NSLocalizedString(@"遊戲",nil)];
	AroundTheWorldViewController* theConfigView = [[AroundTheWorldViewController alloc]initWithGame:self.game];
	[[self.owner navigationController] pushViewController:theConfigView animated:YES];	
	[theConfigView release];
	
}
-(void) pinClicked
{
	StampCollectionViewController* theConfigView = [[StampCollectionViewController alloc]init];
	[[self.owner navigationController] pushViewController:theConfigView animated:YES];	
	[theConfigView release];
}

- (void) prepareFilms:(UIImageView*)stamp
{
	[self addSubview:self.whiteScreen];
	[self.scoreView setHidden:YES];
	
	if (self.gameType == one_player_arcade)	{
		NSLog(@"score is %d", self.score);
		NSLog(@"total score is %d", [((GameViewController*)self.owner) totalScore]);
		[((GameViewController*)self.owner) setTotalScore:self.score+[((GameViewController*)self.owner) totalScore]];
		[[self.films objectAtIndex:0] setTitle:[NSString stringWithFormat:@"%@/%@", NSLocalizedString(@"總分",nil), NSLocalizedString(@"分數",nil)]];
		NSLog(@"total score is %d", [((GameViewController*)self.owner) totalScore]);
		[[self.films objectAtIndex:0] setText:[NSString stringWithFormat:@"%d/\n%d", self.score, [((GameViewController*)self.owner) totalScore]]];
		[[self.films objectAtIndex:0] setFontSize:24];													 
	}
	else if (self.gameType == one_player_level_select)	{
		[[self.films objectAtIndex:0] setTitle:NSLocalizedString(@"分數",nil)];
		[[self.films objectAtIndex:0] setText:[NSString stringWithFormat:@"%d", self.score]];				
		[[self.films objectAtIndex:0] setFontSize:32];													 
	}
	
	[[self.films objectAtIndex:1] setTitle:NSLocalizedString(@"遊戲",nil)];
	[[self.films objectAtIndex:1] setText:[[[Constants sharedInstance] getGameNamesDictionary] objectForKey:[NSNumber numberWithInt:self.game]]];
	
	[[self.films objectAtIndex:2] setTitle:[NSString stringWithFormat:@"%@/%@", NSLocalizedString(@"難度",nil), NSLocalizedString(@"等級", nil)]];
	
	NSString* rankStr;
	if (self.score>=80)
		rankStr = @"S";
	else if (self.score >=70)
		rankStr = @"A";
	else if (self.score >=60)
		rankStr = @"B";
	else if (self.score >=50)
		rankStr = @"C";
	else if (self.score >=40)
		rankStr = @"D";
	else if (self.score >=30)
		rankStr = @"E";
	else
		rankStr = @"F";
	
	
	switch (self.difficultiesLevel)	{
		case (kEasy):
			[[self.films objectAtIndex:2] setText:[NSString stringWithFormat:@"%@/\n%@", NSLocalizedString(@"好易",nil), rankStr]];
			break;
		case (kNormal):
			[[self.films objectAtIndex:2] setText:[NSString stringWithFormat:@"%@/\n%@", NSLocalizedString(@"正常",nil), rankStr]];
			break;
		case (kHard):
			[[self.films objectAtIndex:2] setText:[NSString stringWithFormat:@"%@/\n%@", NSLocalizedString(@"難爆",nil), rankStr]];
			break;
		case (kWorldClass):
			[[self.films objectAtIndex:2] setText:[NSString stringWithFormat:@"%@/\n%@", NSLocalizedString(@"大師",nil), rankStr]];
			break;
	}
	
	[[self.films objectAtIndex:4] setTitle:[LocalStorageManager objectForKey:USER_NAME]];
	WebImageView* profileImage;
	if ([LocalStorageManager objectForKey:FACEBOOK_IMAGE_URL])
		profileImage = [[WebImageView alloc] initWithFrame:CGRectMake(11, 11, 55,55) AndImageUrl:[LocalStorageManager objectForKey:FACEBOOK_IMAGE_URL]];
	else
		profileImage = [[WebImageView alloc] initWithFrame:CGRectMake(11, 11, 55,55) AndImageUrl:[NSString stringWithFormat:@"%@%@", HOSTURL, ANONYMOUSPHOTOURL]];

	[[self.films objectAtIndex:4] setImages:[NSArray arrayWithObject:profileImage]];
	[profileImage release];										 
	
	/* Arcade Mode */
	if (self.gameType == one_player_arcade)	{
		[[self.films objectAtIndex:3] setTitle:NSLocalizedString(@"生命",nil)];
		NSMutableArray* images = [NSMutableArray arrayWithCapacity:3];
		for (int i=0; i<self.lifes; i++)	{
			NSString* lifeiconfilename = [LocalStorageManager stringForKey:LIFEICON];
			UIView* lifeicon;
			if (lifeiconfilename == nil)	{   
				lifeicon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"heartwithline.png"]];
				lifeicon.frame = CGRectMake(15+20*i,30, 20,20);
			}
			else if ([lifeiconfilename isEqualToString:LIFEICON])					{
				lifeicon = [[Baby alloc] initWithFrame:CGRectMake(14+22*i,87, 50,50) AndColor:(i%3) AndOrientation:11];			
			}
			else {
				lifeicon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:lifeiconfilename]];
				lifeicon.frame = CGRectMake(15+20*i,30, 20,20);
			}
			
			[images addObject:lifeicon];
			[lifeicon release];
		}
		if (self.gameType == one_player_arcade)	{		
			int passScore = [[[[[Constants sharedInstance] gamePassingScoreArray] objectAtIndex:self.game] objectAtIndex:_difficultiesLevel] intValue];
			if (self.score < passScore)	{
				self.lifes--;
				UIImageView* liveImage = [images lastObject];
				[UIView animateWithDuration:0.3 delay:0.5 options:nil animations:^{
					liveImage.frame=CGRectMake(liveImage.frame.origin.x,liveImage.frame.origin.y+120, liveImage.frame.size.width*2, liveImage.frame.size.height*2);
				} completion:^(BOOL finished){
					[UIView animateWithDuration:0.3 animations:^{
						liveImage.frame=CGRectMake(liveImage.frame.origin.x,liveImage.frame.origin.y-50, liveImage.frame.size.width*2, liveImage.frame.size.height*2);
					} completion:^(BOOL finished){
						[UIView animateWithDuration:0.3 animations:^{
							liveImage.frame=CGRectMake(liveImage.frame.origin.x,liveImage.frame.origin.y+50, liveImage.frame.size.width*2, liveImage.frame.size.height*2);
						} completion:^(BOOL finished){
							[liveImage removeFromSuperview];
						}];
					}];
				}];
			}
		}
		
		[[self.films objectAtIndex:3] setImages:images];
		
		if ([self getStat])	{
			[[self.films objectAtIndex:5] setImages:[NSArray arrayWithObject:[self getStatPic]]];
			[[self.films objectAtIndex:5] setTitle:[self getStat]];
		}
	}
	
	/* Game Select Mode */
	else {
		if ([self getStat])	{
			[[self.films objectAtIndex:3] setImages:[NSArray arrayWithObject:[self getStatPic]]];
			[[self.films objectAtIndex:3] setTitle:[self getStat]];
		}
	}
	
	if (stamp)	{
		stamp.frame = CGRectOffset(stamp.frame, 9, 9);
		[[self.films objectAtIndex:5] setTitle:NSLocalizedString(@"拍拍郵票",nil)];
		[[self.films objectAtIndex:5] setImages:[NSArray arrayWithObject:stamp]];
	}
	
	
	for (PolaroidFilm* film in self.films)	{
		if (film.titleLbl.text!=nil)	{
			CGRect tempFrame = film.frame;
			//				float theDelay = (arc4random()%4)*0.1;
			float theDelay = 0;
			float theDuration = (arc4random()%10)*0.1;
			//				float theDuration = 0.1;
			float x = 10+arc4random()%120;
			float y = 30+arc4random()%200;
			film.frame = CGRectMake(x,y,280,320);				
			[self addSubview:film];
			[UIView animateWithDuration:theDuration delay:theDelay options:nil animations:^{
				film.frame = tempFrame;
				film.transform = CGAffineTransformMakeRotation(radians((float)(arc4random()%40-20.0)));
				
			} completion:^(BOOL finished)
			 {
				 if (finished && self.gameType == one_player_level_select)
					 [self setButtonsAfterFinish];

			 }];
		}
	}
	if ([self.owner gameType]==one_player_level_select)	
		[self toggleSubmitPanel];

	
}

- (void) prepareVSFilms
{
	[self addSubview:self.whiteScreen];
	[self.scoreView setHidden:YES];
	[self hideVsMsg];
	
	[[self.films objectAtIndex:1] setTitle:NSLocalizedString(@"遊戲",nil)];
	[[self.films objectAtIndex:1] setText:[[[Constants sharedInstance] getGameNamesDictionary] objectForKey:[NSNumber numberWithInt:self.game]]];
	
	
	if ([[self opponentTimeBar] currentValue] >[[self timeBar ]currentValue])	{
		[[self.films objectAtIndex:4] setTitle:[NSString stringWithFormat:@"%@%@",[[GameCenterManager sharedInstance] opponentAlias],NSLocalizedString(@"勝出", nil)]];
		WebImageView* profileImage;
		if ([[GameCenterManager sharedInstance] opponentImageUrl])
			profileImage = [[WebImageView alloc] initWithFrame:CGRectMake(11, 11, 55,55) AndImageUrl:[[GameCenterManager sharedInstance] opponentImageUrl]];
		else
			profileImage = [[WebImageView alloc] initWithFrame:CGRectMake(11, 11, 55,55) AndImageUrl:[NSString stringWithFormat:@"%@%@", HOSTURL, ANONYMOUSPHOTOURL]];		
		[[self.films objectAtIndex:4] setImages:[NSArray arrayWithObject:profileImage]];
		[profileImage release];	
		[self.owner setNumRoundLose:[self.owner numRoundLose]+1];
		UIImageView* youWinImage = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"youlose" ofType:@"png"]]];
		youWinImage.frame = youWinRect;
		self.youWinImage = youWinImage;
		[youWinImage release];
		[self addSubview:self.youWinImage];
	}
	else if ([[self opponentTimeBar] currentValue] <[[self timeBar] currentValue])	{
		[[self.films objectAtIndex:4] setTitle:[NSString stringWithFormat:@"%@%@",[LocalStorageManager objectForKey:USER_NAME],NSLocalizedString(@"勝出", nil)]];
		WebImageView* profileImage;
		if ([LocalStorageManager objectForKey:FACEBOOK_IMAGE_URL])
			profileImage = [[WebImageView alloc] initWithFrame:CGRectMake(11, 11, 55,55) AndImageUrl:[LocalStorageManager objectForKey:FACEBOOK_IMAGE_URL]];
		else
			profileImage = [[WebImageView alloc] initWithFrame:CGRectMake(11, 11, 55,55) AndImageUrl:[NSString stringWithFormat:@"%@%@", HOSTURL, ANONYMOUSPHOTOURL]];
		[[self.films objectAtIndex:4] setImages:[NSArray arrayWithObject:profileImage]];
		[profileImage release];										 
		[self.owner setNumRoundWin:[self.owner numRoundWin]+1];
		UIImageView* youWinImage = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"youwin" ofType:@"png"]]];
		youWinImage.frame = youWinRect;
		self.youWinImage = youWinImage;
		[youWinImage release];
		[self addSubview:self.youWinImage];
	}
	
	else	{
		NSLog(@"same score, decide win based on time used ");
		if ([self myTimeUsed]<[self opponentTimeUsed]){
			[[self.films objectAtIndex:4] setTitle:[NSString stringWithFormat:@"%@%@",[LocalStorageManager objectForKey:USER_NAME],NSLocalizedString(@"勝出", nil)]];
			WebImageView* profileImage;
			if ([LocalStorageManager objectForKey:FACEBOOK_IMAGE_URL])
				profileImage = [[WebImageView alloc] initWithFrame:CGRectMake(11, 11, 55,55) AndImageUrl:[LocalStorageManager objectForKey:FACEBOOK_IMAGE_URL]];
			else
				profileImage = [[WebImageView alloc] initWithFrame:CGRectMake(11, 11, 55,55) AndImageUrl:[NSString stringWithFormat:@"%@%@", HOSTURL, ANONYMOUSPHOTOURL]];			[[self.films objectAtIndex:4] setImages:[NSArray arrayWithObject:profileImage]];
			[profileImage release];										 
			[self.owner setNumRoundWin:[self.owner numRoundWin]+1];
			UIImageView* youWinImage = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"youwin" ofType:@"png"]]];
			youWinImage.frame = youWinRect;
			self.youWinImage = youWinImage;
			[youWinImage release];
			[self addSubview:self.youWinImage];
			NSLog(@"my time used is %f, opponent tim eused is %f, i win", [self myTimeUsed], [self opponentTimeUsed]);
		}
		else if ([self myTimeUsed]>[self opponentTimeUsed])	{
			[[self.films objectAtIndex:4] setTitle:[NSString stringWithFormat:@"%@%@",[[GameCenterManager sharedInstance] opponentAlias],NSLocalizedString(@"勝出", nil)]];
			WebImageView* profileImage;
			if ([[GameCenterManager sharedInstance] opponentImageUrl])
				profileImage = [[WebImageView alloc] initWithFrame:CGRectMake(11, 11, 55,55) AndImageUrl:[[GameCenterManager sharedInstance] opponentImageUrl]];
			else
				profileImage = [[WebImageView alloc] initWithFrame:CGRectMake(11, 11, 55,55) AndImageUrl:[NSString stringWithFormat:@"%@%@", HOSTURL, ANONYMOUSPHOTOURL]];
			[[self.films objectAtIndex:4] setImages:[NSArray arrayWithObject:profileImage]];
			[profileImage release];	
			[self.owner setNumRoundLose:[self.owner numRoundLose]+1];
			UIImageView* youWinImage = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"youlose" ofType:@"png"]]];
			youWinImage.frame = youWinRect;
			self.youWinImage = youWinImage;
			[youWinImage release];
			[self addSubview:self.youWinImage];
			NSLog(@"my time used is %f, opponent tim eused is %f, i lose", [self myTimeUsed], [self opponentTimeUsed]);

		}
	 
		else	{
			[[self.films objectAtIndex:4] setTitle:NSLocalizedString(@"打成平手", nil)];
//			WebImageView* profileImage = [[WebImageView alloc] initWithFrame:CGRectMake(11, 11, 55,55) AndImageUrl:[[GameCenterManager sharedInstance] opponentImageUrl]];
//			[[self.films objectAtIndex:4] setImages:[NSArray arrayWithObject:profileImage]];
//			[profileImage release];										 
		}
	}

//	if (self.gameType == multi_players_arcade)	{
		[[self.films objectAtIndex:3] setTitle:[NSString stringWithFormat:@"%@", NSLocalizedString(@" 你勝出回數",nil)]];
		[[self.films objectAtIndex:3] setText:[NSString stringWithFormat:@"%d", [self.owner numRoundWin]]];
		[[self.films objectAtIndex:3] setFontSize:48];													 
		
		[[self.films objectAtIndex:5] setTitle:[NSString stringWithFormat:@"%@", NSLocalizedString(@"對方勝出回數",nil)]];
		[[self.films objectAtIndex:5] setText:[NSString stringWithFormat:@"%d", [self.owner numRoundLose]]];
		[[self.films objectAtIndex:5] setFontSize:48];													 
//	}
	
	
	for (PolaroidFilm* film in self.films)	{
		if (film.titleLbl.text!=nil)	{
			CGRect tempFrame = film.frame;
			//				float theDelay = (arc4random()%4)*0.1;
			float theDelay = 0;
			float theDuration = (arc4random()%10)*0.1;
			//				float theDuration = 0.1;
			float x = 10+arc4random()%120;
			float y = 30+arc4random()%200;
			film.frame = CGRectMake(x,y,280,320);				
			[self addSubview:film];
			[UIView animateWithDuration:theDuration delay:theDelay options:nil animations:^{
				film.frame = tempFrame;
				film.transform = CGAffineTransformMakeRotation(radians((float)(arc4random()%40-20.0)));
				
			} completion:^(BOOL finished)
				{
					
					if  (finished){
						if (self.gameType == multi_players_level_select) 	{
							[self setButtonsAfterFinishForVSMode];
						}
						else if (self.gameType==multi_players_arcade && [self.owner isLite] && self.game == [[Constants sharedInstance]lastGameForMode:kVSArcadeLite])
						{
							[self setButtonsAfterFinishForVSMode];
						}
						else if (self.gameType==multi_players_arcade && ![self.owner isLite] && self.game == [[Constants sharedInstance]lastGameForMode:kVSArcade])
						{
							[self setButtonsAfterFinishForVSMode];

						}
					}
					}];
		}
	}
	
	// VS Game Select
	if (self.gameType == multi_players_level_select) 	{
		[LocalStorageManager setInteger:[LocalStorageManager integerForKey:VSNUMFREESELECTGAMES]+1 forKey:VSNUMFREESELECTGAMES];
		if ([self.owner numRoundWin] > [self.owner numRoundLose])	{
			[LocalStorageManager setInteger:[LocalStorageManager integerForKey:VSNUMFREESELECTWINS]+1 forKey:VSNUMFREESELECTWINS];
			[LocalStorageManager setInteger:[LocalStorageManager integerForKey:VSNUMWINS]+1 forKey:VSNUMWINS];
		}
		else	{
			[LocalStorageManager setInteger:[LocalStorageManager integerForKey:VSNUMFREESELECTLOSES]+1 forKey:VSNUMFREESELECTLOSES];
			[LocalStorageManager setInteger:[LocalStorageManager integerForKey:VSNUMLOSES]+1 forKey:VSNUMLOSES];
		}
		[self toggleReplayPanel];
	}
	// VS Arcade Lite
	else if (self.gameType==multi_players_arcade && [self.owner isLite] && self.game == [[Constants sharedInstance]lastGameForMode:kVSArcadeLite])
	{
		[LocalStorageManager setInteger:[LocalStorageManager integerForKey:VSNUMARCADELITEGAMES]+1 forKey:VSNUMARCADELITEGAMES];
		if ([self.owner numRoundWin] > [self.owner numRoundLose]){
			[LocalStorageManager setInteger:[LocalStorageManager integerForKey:VSNUMARCADELITEWINS]+1 forKey:VSNUMARCADELITEWINS];
			[LocalStorageManager setInteger:[LocalStorageManager integerForKey:VSNUMWINS]+1 forKey:VSNUMWINS];
		}
		else	{
			[LocalStorageManager setInteger:[LocalStorageManager integerForKey:VSNUMARCADELITELOSES]+1 forKey:VSNUMARCADELITELOSES];
			[LocalStorageManager setInteger:[LocalStorageManager integerForKey:VSNUMLOSES]+1 forKey:VSNUMLOSES];
		}
		[self toggleReplayPanel];
	}
	// VS Arcade
	else if (self.gameType==multi_players_arcade && ![self.owner isLite] && self.game == [[Constants sharedInstance]lastGameForMode:kVSArcade])
	{
		[LocalStorageManager setInteger:[LocalStorageManager integerForKey:VSNUMARCADEGAMES]+1 forKey:VSNUMARCADEGAMES];
		if ([self.owner numRoundWin] > [self.owner numRoundLose])	{
			[LocalStorageManager setInteger:[LocalStorageManager integerForKey:VSNUMARCADEWINS]+1 forKey:VSNUMARCADEWINS];
			[LocalStorageManager setInteger:[LocalStorageManager integerForKey:VSNUMWINS]+1 forKey:VSNUMWINS];
		}else	{
			[LocalStorageManager setInteger:[LocalStorageManager integerForKey:VSNUMARCADELOSES]+1 forKey:VSNUMARCADELOSES];
			[LocalStorageManager setInteger:[LocalStorageManager integerForKey:VSNUMLOSES]+1 forKey:VSNUMLOSES];
		}
		[self toggleReplayPanel];
	}
}

- (void) postUpdateToGameCenter
{
	NSLog(@"postUpdateToGameCenter");
	GKScore *scoreReporter = nil;
	NSString* gameCategoryString = nil;
		gameCategoryString = kGamekitVSLeaderboardCategory;
#ifdef LITE_VERSION
		gameCategoryString = kGamekitVSLeaderboardLiteCategory;
#endif
		
	scoreReporter = [[[GKScore alloc] initWithCategory:gameCategoryString] autorelease];
	scoreReporter.value = [LocalStorageManager integerForKey:VSNUMWINS];
	[scoreReporter reportScoreWithCompletionHandler: ^(NSError *error) 
	 {
		 if (error != nil)
		 {
			 NSLog(@"error submitting score to server: %@", [error localizedDescription]);
		 }		 
	 }];
	
	
}

- (void) showPlayAgain{
	[self disableButtons];
#ifdef LITE_VERSION
	[self showBannerView];
#endif	
	
	
	[self.timePie setHidden:YES];
	if (self.theTimer)	{
		[self.theTimer invalidate];
		self.theTimer = nil;
	}
	if (self.orientation!=10)	{
		if (!self.scoreView)	{
			ScoreView* scoreView;
			if (self.gameType == one_player_arcade || self.gameType == multi_players_arcade || self.gameType == none)	{
				scoreView = [[ScoreView alloc] initWithOrientation:self.orientation AndScore:self.score AndLives:self.lifes AndType:kScoreViewType_beforeGame];			
				int passScore = [[[[[Constants sharedInstance] gamePassingScoreArray] objectAtIndex:self.game] objectAtIndex:_difficultiesLevel] intValue];
				[scoreView setScore:passScore];
				[scoreView setLevel:self.difficultiesLevel];
			}
			else
				scoreView = [[ScoreView alloc] initWithOrientation:self.orientation AndScore:self.score AndLives:self.lifes AndGame:(Game)([self.owner theGame]) AndGameLevel:self.difficultiesLevel AndType:kScoreViewType_beforeGame];
			self.scoreView = scoreView;
			[scoreView release];
			
			self.scoreView.owner = self.owner;
			self.scoreView.gameView = self;
			self.scoreView.currentGameType = self.gameType;

		}
		else		{
			if (self.gameType == one_player_arcade || self.gameType == multi_players_arcade || self.gameType == none)	{
				self.scoreView.type = kScoreViewType_afterGameArcade;
				[self.scoreView setTotalScore:[((GameViewController*)self.owner) totalScore] + self.score];
			}
			else
				self.scoreView.type = kScoreViewType_afterGameNonArcade;
			
			if (self.gameType != one_player_level_select)	{		
				int passScore = [[[[[Constants sharedInstance] gamePassingScoreArray] objectAtIndex:self.game] objectAtIndex:_difficultiesLevel] intValue];
				if (self.score > passScore)	{
					self.scoreView.isPass = YES;
					[sharedSoundEffectsManager playGoodTakeSound];
					[[self.owner sharedSoundEffectsManager] playSlamMetalSound];
					[[self.owner sharedSoundEffectsManager] playWarpSound];
					[[self.owner sharedSoundEffectsManager] playClapSound];
				}
				else	{
					self.scoreView.isPass = NO;
					[sharedSoundEffectsManager playCutSound];
					[[self.owner sharedSoundEffectsManager] playSlamMetalSound];
					[[self.owner sharedSoundEffectsManager] playWarpSound];
				}
				
			}
			else {
				[sharedSoundEffectsManager playGoodTakeSound];
				[[self.owner sharedSoundEffectsManager] playSlamMetalSound];
				[[self.owner sharedSoundEffectsManager] playWarpSound];
			}
			[self.scoreView setScore:self.score];

			
			// ---- for VS mode ---------
			if (self.gkMatch || self.gkSession)	{
			  @synchronized([GameCenterManager sharedInstance])	{
				[[GameCenterManager sharedInstance] setTheGameState:kGKGameStateEnded];
				if (!_VSModeIsRoundBased)	{
					self.myTimeUsed = -(float)[self.roundStartTime timeIntervalSinceNow];
					self.gamePacket.packetType = kGKPacketTypeEndWithScore;
					self.gamePacket.score = self.score;
					NSError* error;
					if (self.gkMatch)
						[self.gkMatch sendDataToAllPlayers:[self.gamePacket toNSData] withDataMode:GKMatchSendDataReliable error:&error];		
					else
						[self.gkSession sendDataToAllPeers:[self.gamePacket toNSData] withDataMode:GKMatchSendDataReliable error:&error];		
				}
				
				else {
					self.gamePacket.packetType = kGKPacketTypeEndWithTimeUsed;
					self.gamePacket.timeUsed = -(float)[self.roundStartTime timeIntervalSinceNow];
					self.myTimeUsed = self.gamePacket.timeUsed;
					NSLog(@"gamePacket.timeUsed is %f", self.gamePacket.timeUsed);
					NSError* error;
					if (self.gkMatch)
						[self.gkMatch sendDataToAllPlayers:[self.gamePacket toNSData] withDataMode:GKSendDataReliable error:&error];
					else
						[self.gkSession sendDataToAllPeers:[self.gamePacket toNSData] withDataMode:GKSendDataReliable error:&error];
				}
				
				self.scoreView.type = kScoreViewType_afterGameMultiplayNonArcade;
				if ([self.owner gameType]==multi_players_arcade)
					self.scoreView.type = kScoreViewType_afterGameMultiplayArcade;

				[self showVsMsg:NSLocalizedString(@"等待對手完成", nil)];
//				[self.scoreView show];
				  [self finishGame];
				if ([[GameCenterManager sharedInstance] theOpponentGameState] == kGKGameStateEnded)	{
	//				[self.scoreView showVSResult];
					NSLog(@"show play again  prepareVSFilms");
					[self prepareVSFilms];
				}
			  }
			}
			// end ---- for VS mode ---------
			else	{
//				[self.scoreView show]; 
				UIImageView* stamp = nil;
				//if (self.scoreView.type == kScoreViewType_afterGameNonArcade)	{
				if (self.gameType == one_player_level_select)	{
					
					NSArray* scores = [[[Constants sharedInstance] gamePinScoreArray] objectAtIndex:self.game];
					Pin* thePin =nil;
					NSMutableArray* pins = [NSMutableArray arrayWithArray:[LocalStorageManager customObjectForKey:PIN]];
					/* get master score */
					if (self.score >= [[scores objectAtIndex:1] intValue])	{
						// prepare stamp for the film
						stamp = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[[Constants sharedInstance] gamePinsArray] objectAtIndex:self.game]]];
						
						thePin = [[Pin alloc] initWithGame:self.game AndPinLevel:kMaster];

						/* no need to add / submit if there is already master pin collected */
						if ([pins indexOfObject:thePin]!=NSNotFound)	{
							[thePin release];
							thePin = nil;
						}
						else{
							Pin* theBeginnerPin = [[Pin alloc] initWithGame:self.game AndPinLevel:kIntermediate];
							/* add beginner pin together */
							if ([pins indexOfObject:theBeginnerPin]==NSNotFound)	{
								[pins addObject:theBeginnerPin];
								[theBeginnerPin release];
								/* submit beginner achievement */
								if ([[Constants sharedInstance] gameCenterEnabled])	{
									NSLog(@"submitting beginner pin ");
									NSString* achievementId = [NSString stringWithFormat:@"%@%@Beginner", [[Constants sharedInstance] appVersionPrefix], [[[Constants sharedInstance] gameAchievementsArray] objectAtIndex:self.game]];
									GKAchievement* myAchievement = [[[GKAchievement alloc] initWithIdentifier:achievementId] autorelease];
									myAchievement.percentComplete = 100;
									[myAchievement reportAchievementWithCompletionHandler:^(NSError *error)	{NSLog(@"finished submitting");}];
								}
							}
							
							/* submit master achievement */
							if ([[Constants sharedInstance] gameCenterEnabled])	{
								NSLog(@"submitting master pin ");
								NSString* achievementId = [NSString stringWithFormat:@"%@%@Master", [[Constants sharedInstance] appVersionPrefix], [[[Constants sharedInstance] gameAchievementsArray] objectAtIndex:self.game]];
								GKAchievement* myAchievement = [[[GKAchievement alloc] initWithIdentifier:achievementId] autorelease];
								myAchievement.percentComplete = 100;
								[myAchievement reportAchievementWithCompletionHandler:^(NSError *error)	{NSLog(@"finished submitting");}];
							}
						}
					}
					/* get beginner score */
					else if (self.score >= [[scores objectAtIndex:0] intValue])	{
						// prepare stamp for film
						stamp = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[[Constants sharedInstance] gameGreyPinsArray] objectAtIndex:self.game]]];
						
						thePin = [[Pin alloc] initWithGame:self.game AndPinLevel:kIntermediate];
						Pin* theMasterPin = [[Pin alloc] initWithGame:self.game AndPinLevel:kMaster];
						
						/* no need to add / submit if there is already master / beginner pin collected */
						if (([pins indexOfObject:thePin]!=NSNotFound) || ([pins indexOfObject:theMasterPin]!=NSNotFound))	{
							
							[thePin release];
							thePin = nil;
						}
						else {

							if ([[Constants sharedInstance] gameCenterEnabled])	{
								NSLog(@"submitting beginner pin ");
								NSString* achievementId = [NSString stringWithFormat:@"%@%@Beginner", [[Constants sharedInstance] appVersionPrefix], [[[Constants sharedInstance] gameAchievementsArray]objectAtIndex:self.game]];
								GKAchievement* myAchievement = [[[GKAchievement alloc] initWithIdentifier:achievementId] autorelease];
								myAchievement.percentComplete = 100;
								[myAchievement reportAchievementWithCompletionHandler:^(NSError *error)	{NSLog(@"finished submitting");
								}];
							}
						}				
						[theMasterPin release];
					}
					if (thePin)	{
						[pins addObject:thePin];
						[LocalStorageManager setCustomObject:pins forKey:PIN];
						PinPopUp* thePopup = [[PinPopUp alloc] initWithFrame:PinPopUpRect AndPin:thePin];
						[self addSubview:thePopup];
						[thePopup show];
						[thePin release];
						self.thePinPopUp = thePopup;
						[thePopup release];
					}
				} // end level select
				
				[self prepareFilms:stamp];
				if (stamp)
					[stamp release];
				
				if (self.thePinPopUp)
					[self bringSubviewToFront:self.thePinPopUp];
				[self finishGame];

			} // end single mode
		} // end not at start
	}
}

- (void) redButClicked
{
	if (self.gkMatch || self.gkSession)	{
		self.gamePacket.packetType = kGKPacketTypeButtonClicked;
		self.gamePacket.butState = kRed;
		NSError* error;
		if (self.gkMatch)
			[self.gkMatch sendDataToAllPlayers:[self.gamePacket toNSData] withDataMode:GKMatchSendDataUnreliable error:&error];
		else 
			[self.gkSession sendDataToAllPeers:[self.gamePacket toNSData] withDataMode:GKMatchSendDataUnreliable error:&error];
	}		
}

- (void) blueButClicked
{
	if (self.gkMatch || self.gkSession)	{
		self.gamePacket.packetType = kGKPacketTypeButtonClicked;
		self.gamePacket.butState = kBlue;
		NSError* error;
		if (self.gkMatch)
			[self.gkMatch sendDataToAllPlayers:[self.gamePacket toNSData] withDataMode:GKMatchSendDataUnreliable error:&error];
		else
			[self.gkSession sendDataToAllPeers:[self.gamePacket toNSData] withDataMode:GKMatchSendDataUnreliable error:&error];
	}		
}

- (void) greenButClicked
{
	if (self.gkMatch || self.gkSession)	{
		self.gamePacket.packetType = kGKPacketTypeButtonClicked;
		self.gamePacket.butState = kGreen;
		NSError* error;
		if (self.gkMatch)	
			[self.gkMatch sendDataToAllPlayers:[self.gamePacket toNSData] withDataMode:GKMatchSendDataUnreliable error:&error];
		else
			[self.gkSession sendDataToAllPeers:[self.gamePacket toNSData] withDataMode:GKMatchSendDataUnreliable error:&error];
	}		
}

- (void) disableButtons{	
	[self.greenBut setEnabled:NO];
	[self.blueBut setEnabled:NO];
	[self.redBut setEnabled:NO];
}

- (void) enableButtons{	
	[self.greenBut setEnabled:YES];
	[self.blueBut setEnabled:YES];
	[self.redBut setEnabled:YES];
}

- (void) prepareToStartGameWithNewScenario:(BOOL)newScenario
{
	[self.infoBut setHidden:YES];
	[self bringSubviewToFront:self.scoreView];
	if (newScenario)	{
		self.scenarios = nil;
		[self initScenarios:nil];
	}
	else if ([[GameCenterManager sharedInstance] scenarios])	{
		NSLog(@"copy sceanrio from game center manger rcv Packet");
		self.scenarios = [[GameCenterManager sharedInstance] scenarios];
	}
}

- (void) playAgainButClickedFromScoreView
{	
	if ([[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)])
		[self.iAdBannerView setEnabled:NO];
	if (self.gameType == one_player_level_select) {
		[self playAgainButClicked];
	}else if (self.gameType == multi_players_level_select){
		
		// regenerate scenarios, then send to peer
		self.scenarios = nil;
		[self initScenarios:nil];
		[self sendScenariosUpdatePlayAgainToPeer:self.scenarios];
		
		// can start without waiting for peer reply?
		[self.owner playAgainButClickedStartGameOnBothViews];
		
	}
	else if (self.gameType == one_player_arcade)	{
		
	}
}

- (void) playAgainButClicked
{
	if (self.youWinImage)	{
		[self.youWinImage removeFromSuperview];
		self.youWinImage = nil;
	}
		
	if (![self.replayPanel isHidden])
		[self toggleReplayPanel];
	if (![self.submitPanel isHidden])
		[self toggleSubmitPanel];

	[self.whiteScreen removeFromSuperview];
	[self unsetButtonsAfterFinish];
	for (UIImageView* film in self.films){
		film.transform = CGAffineTransformMakeRotation(0);
		[film removeFromSuperview];
	}
	
	if ((self.gkMatch || self.gkSession) && [[GameCenterManager sharedInstance] theGameState]==kGKGameStateEnded)	{
		[self showVsMsg:NSLocalizedString(@"等待對方回應中...", nil)];
	}
		 
	[self hidePlayAgain];
	[self disableButtons];
	
	[self.thePinPopUp dismiss];
//	if (!self.gkMatch || ([[GameCenterManager sharedInstance] wantReplay] && [[GameCenterManager sharedInstance] opponentWantReplay])) {
		NSLog(@"intial start or both wanna replay, go head to start");

	// if not host and replay, DO NOT re-generate scanrios, use the sceanrio sent from host in GameStart Message
	if ((self.gkMatch || self.gkSession) && ![[GameCenterManager sharedInstance] isHost])	
		[self prepareToStartGameWithNewScenario:NO];
	else
		[self prepareToStartGameWithNewScenario:YES];
	[self prepareToStartShowingCountDownMessage];
//	}
	
}

- (void) bePrepareToStartShowingCountDownMessage
{
	self.gamePacket.packetType = kGKPacketTypeAckStart;
	NSError* error;
	if (self.gkMatch)	
		[self.gkMatch sendDataToAllPlayers:[self.gamePacket toNSData] withDataMode:GKMatchSendDataReliable error:&error];
	else
		[self.gkSession sendDataToAllPeers:[self.gamePacket toNSData] withDataMode:GKMatchSendDataReliable error:&error];
	[self startShowingCountDownMessage];	
}


- (void) prepareToStartShowingCountDownMessage
{
	if (self.gkMatch || self.gkSession)	{
		if ([[GameCenterManager sharedInstance] theGameState]==kGKGameStateEnded)
			[self.scoreView mePlayAgain];
		
		[[GameCenterManager sharedInstance] setTheGameState:kGKGameStateReadyToStart];
		if ([[GameCenterManager sharedInstance] isHost])	{
			// scenarios may have been generated in prepareToStartGameWithNewScenario
			if (!self.scenarios)
				[self initScenarios:nil];
			self.gamePacket.packetType = kGKPacketTypeStart;
			self.gamePacket.scenarios = self.scenarios;
			NSError* error;
			if (self.gkMatch)
				[self.gkMatch sendDataToAllPlayers:[self.gamePacket toNSData] withDataMode:GKMatchSendDataReliable error:&error];
			else
				[self.gkSession sendDataToAllPeers:[self.gamePacket toNSData] withDataMode:GKMatchSendDataReliable error:&error];
		}
		else{
			if ([[GameCenterManager sharedInstance] theOpponentGameState] == kGKGameStateReadyToStart)
				[self bePrepareToStartShowingCountDownMessage];
		}
	}		
	else {
		[self startShowingCountDownMessage];
	}

}

- (void) startShowingCountDownMessage
{
	[self hideVsMsg];
	[sharedSoundEffectsManager playCountDownThreeSound];
	
	UILabel* tmpLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 400)];
	tmpLabel.textAlignment = UITextAlignmentCenter;
	[tmpLabel setFont:[UIFont systemFontOfSize:260]];
	[tmpLabel setText:@"3"];
	tmpLabel.textColor = [UIColor whiteColor];
	tmpLabel.backgroundColor = [UIColor clearColor];
	tmpLabel.shadowColor = [UIColor blackColor];
	tmpLabel.shadowOffset = CGSizeMake(3, 3);
	self.countDownThreeLabel = tmpLabel;
	[self addSubview:self.countDownThreeLabel];
	
	[UIView beginAnimations:@"zoom in three" context:nil];
	[UIView setAnimationDuration: 0.8];
	self.countDownThreeLabel.transform = CGAffineTransformMakeScale(0.2, 0.2);
	self.countDownThreeLabel.alpha = 0;
	[UIView setAnimationDelegate:self];
	[UIView commitAnimations];
	
	[self performSelector:@selector(showCountDownTwoMessage) withObject:nil afterDelay:0.8];
	
	
	[tmpLabel release];
	//	[self startGame];
#ifdef LITE_VERSION	
	[self hideBannerView];
#endif
	
}

- (void) showTransitionOut{
	[self.owner showTransitionOut];
}

- (void) showHostLostRoundMessage
{
	
	UILabel* tmpLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 400)];
	tmpLabel.textAlignment = UITextAlignmentCenter;
	[tmpLabel setFont:[UIFont systemFontOfSize:260]];
	[tmpLabel setText:@"You lost!"];
	tmpLabel.textColor = [UIColor whiteColor];
	tmpLabel.backgroundColor = [UIColor clearColor];
	tmpLabel.shadowColor = [UIColor blackColor];
	tmpLabel.shadowOffset = CGSizeMake(3, 3);
	self.countDownTwoLabel = tmpLabel;
	[self addSubview:self.countDownTwoLabel];
	
	[UIView beginAnimations:@"zoom in two" context:nil];
	[UIView setAnimationDuration: 0.8];
	self.countDownTwoLabel.transform = CGAffineTransformMakeScale(0.2, 0.2);
	self.countDownTwoLabel.alpha = 0;
	[UIView commitAnimations];
	
	[tmpLabel release];
	[self.countDownTwoLabel removeFromSuperview];
}

- (void) showHostWonRoundMessage
{
	
	UILabel* tmpLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 400)];
	tmpLabel.textAlignment = UITextAlignmentCenter;
	[tmpLabel setFont:[UIFont systemFontOfSize:260]];
	[tmpLabel setText:@"You won!"];
	tmpLabel.textColor = [UIColor whiteColor];
	tmpLabel.backgroundColor = [UIColor clearColor];
	tmpLabel.shadowColor = [UIColor blackColor];
	tmpLabel.shadowOffset = CGSizeMake(3, 3);
	self.countDownTwoLabel = tmpLabel;
	[self addSubview:self.countDownTwoLabel];
	
	[UIView beginAnimations:@"zoom in two" context:nil];
	[UIView setAnimationDuration: 0.8];
	self.countDownTwoLabel.transform = CGAffineTransformMakeScale(0.2, 0.2);
	self.countDownTwoLabel.alpha = 0;
	[UIView commitAnimations];
	
	[tmpLabel release];
	[self.countDownTwoLabel removeFromSuperview];
}



- (void) showCountDownTwoMessage
{
	[sharedSoundEffectsManager playCountDownTwoSound];
	
	UILabel* tmpLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 400)];
	tmpLabel.textAlignment = UITextAlignmentCenter;
	[tmpLabel setFont:[UIFont systemFontOfSize:260]];
	[tmpLabel setText:@"2"];
	tmpLabel.textColor = [UIColor whiteColor];
	tmpLabel.backgroundColor = [UIColor clearColor];
	tmpLabel.shadowColor = [UIColor blackColor];
	tmpLabel.shadowOffset = CGSizeMake(3, 3);
	self.countDownTwoLabel = tmpLabel;
	[self addSubview:self.countDownTwoLabel];
	
	[UIView beginAnimations:@"zoom in two" context:nil];
	[UIView setAnimationDuration: 0.8];
	self.countDownTwoLabel.transform = CGAffineTransformMakeScale(0.2, 0.2);
	self.countDownTwoLabel.alpha = 0;
	[UIView commitAnimations];
	
	[self performSelector:@selector(showCountDownOneMessage) withObject:nil afterDelay:0.8];
	[tmpLabel release];
}

- (void) showCountDownOneMessage
{
	[sharedSoundEffectsManager playCountDownOneSound];
	
	UILabel* tmpLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 400)];
	tmpLabel.textAlignment = UITextAlignmentCenter;
	[tmpLabel setFont:[UIFont systemFontOfSize:260]];
	[tmpLabel setText:@"1"];
	tmpLabel.textColor = [UIColor whiteColor];
	tmpLabel.backgroundColor = [UIColor clearColor];
	tmpLabel.shadowColor = [UIColor blackColor];
	tmpLabel.shadowOffset = CGSizeMake(3, 3);
	self.countDownOneLabel = tmpLabel;
	[self addSubview:self.countDownOneLabel];
	
	[UIView beginAnimations:@"zoom in one" context:nil];
	[UIView setAnimationDuration: 0.8];
	self.countDownOneLabel.transform = CGAffineTransformMakeScale(0.2, 0.2);
	self.countDownOneLabel.alpha = 0;
	[UIView commitAnimations];
	
	[self performSelector:@selector(showGameStartMessage) withObject:nil afterDelay:0.8];
	[tmpLabel release];
}

- (void) showGameStartMessage{
	
	[sharedSoundEffectsManager playActionSound];
	
	UILabel* tmpLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 320)];
	tmpLabel.textAlignment = UITextAlignmentCenter;
	[tmpLabel setFont:[UIFont systemFontOfSize:80]];
	[tmpLabel setText:@"Action!"];
	tmpLabel.textColor = [UIColor whiteColor];
	tmpLabel.backgroundColor = [UIColor clearColor];
	tmpLabel.shadowColor = [UIColor blackColor];
	tmpLabel.shadowOffset = CGSizeMake(3, 3);
	self.gameStartLabel = tmpLabel;
	[self addSubview:self.gameStartLabel];
	
	if (self.scoreView)
		[self.scoreView dismiss];
	
	[UIView beginAnimations:@"zoom in one" context:nil];
	[UIView setAnimationDuration: 1.6];
	self.gameStartLabel.transform = CGAffineTransformMakeScale(0.2, 0.2);
	self.gameStartLabel.alpha = 0;
	[UIView commitAnimations];
	[self performSelector:@selector(startGame) withObject:nil afterDelay:1.2];
	[tmpLabel release];	
}


- (void)soundButClicked{
	 	if (![LocalStorageManager boolForKey:SOUNDOFF]){
		 		// turn sound off
			[LocalStorageManager setBool:YES forKey:SOUNDOFF];
		 		[self.soundBut setImage:[UIImage imageNamed:@"soundoff.png"] forState:UIControlStateNormal];
		 		[[self.owner sharedSoundEffectsManager] stopPlayingBGM:self.game];
		 	}else{
			 		// turn sound on
			 		[LocalStorageManager setBool:NO forKey:SOUNDOFF];
			 		[self.soundBut setImage:[UIImage imageNamed:@"soundon.png"] forState:UIControlStateNormal];
			 		[[self.owner sharedSoundEffectsManager] startPlayingBGM:self.game];
		 	}
	 	
}


-(void) socialButClicked
{
	if ([self.socialPanel isDescendantOfView:self])	{
		[self.socialPanel disableButtons];
	}
	else	{
		[self addSubview:self.socialPanel];
		[self.socialPanel enableButtons];
	}
}

- (void) exitButClicked
{
	// open an alert with just an OK button
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"離開遊戲",nil) 
													message:NSLocalizedString(@"確定離開遊戲？",nil)
												   delegate:self cancelButtonTitle:nil otherButtonTitles: NSLocalizedString(@"確定",nil),NSLocalizedString(@"取消",nil),nil];
	[alert show];	
	[alert release];
}

-(void) leaveGame
{
	_toQuit = YES;
	if (self.theTimer)	{
		NSLog(@"invalidate timer");
		[self.theTimer invalidate];
	}
	self.theTimer = nil;
	[[self.owner sharedSoundEffectsManager] stopPlayingBGM:self.game];
	
	[NSObject cancelPreviousPerformRequestsWithTarget:self];	
	
	/* for VS mode, set them to nil to 'disable' game center manager */
	if ([[GameCenterManager sharedInstance] theMatch])
		[[[GameCenterManager sharedInstance] theMatch] disconnect];
	if ([[GameCenterManager sharedInstance] theSession])
		[[[GameCenterManager sharedInstance] theSession] disconnectFromAllPeers];
	[[GameCenterManager sharedInstance] setTheMatch:nil];
	[[GameCenterManager sharedInstance] setTheSession:nil];

	[[self.owner navigationController] popViewControllerAnimated:YES];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	[sharedSoundEffectsManager playUFOFlyPassSound];
	if (buttonIndex == 0)
	{
		[self leaveGame];
	}
}


- (void) reConfig
{
}


#pragma mark Data Send/Receive Methods



- (void)didReceiveMemoryWarning {
	// dont release the view
    //[super didReceiveMemoryWarning];
    
}

-(void) showBannerView
{
  if (self.bannerServed)		{
	[self bringSubviewToFront:self.iAdBannerView];
	[UIView beginAnimations:@"animateAdBannerOn" context:NULL];
	[UIView setAnimationDuration:0.3];
	// assumes the banner view is offset 120 pixels so that it is not visible.
	self.iAdBannerView.frame = CGRectOffset(self.iAdBannerView.frame, -320, 0);
	[UIView commitAnimations];
  }	
}

- (void) hideBannerView
{
  if (self.bannerServed)	{
	[UIView beginAnimations:@"animateAdBannerOn" context:NULL];
	[UIView setAnimationDuration:0.3];
	// assumes the banner view is offset 120 pixels so that it is not visible.
	self.iAdBannerView.frame = CGRectOffset(self.iAdBannerView.frame, 320, 0);
	[UIView commitAnimations];	
	
	NSLog(@"hideBannerView removeFromSuperview");
  }
}

- (void) setGkMatch:(id)gkMatch
{
	_gkMatch = gkMatch;
	if (!self.gamePacket)	{
		GKPacket* gamePacket = [[GKPacket alloc] init];
		self.gamePacket = gamePacket;
		[gamePacket release];
	}
	if (_gkSession)	{
		[_gkSession release];
		_gkSession = nil;
	}
}	

- (void) setGkSession:(id)gkSession
{
	_gkSession = gkSession;
	if (!self.gamePacket)	{
		GKPacket* gamePacket = [[GKPacket alloc] init];
		self.gamePacket = gamePacket;
		[gamePacket release];
	}
	if (_gkMatch)	{
		[_gkMatch release];
		_gkMatch = nil;
	}
}	

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
    [self.owner dismissModalViewControllerAnimated:YES];
}

#ifdef LITE_VERSION
#pragma mark -
#pragma mark ADBannerViewDelegate
- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
	if (!willLeave)
		return YES;
	else {
		UIDevice* device = [UIDevice currentDevice];
		if ([device respondsToSelector:@selector(isMultitaskingSupported)]){
			return YES;
		}
		else
			return NO;
	}
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
	NSLog(@"iAd did load");
	self.bannerServed = YES;
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
	NSLog(@"iAd Fail");
	self.bannerServed = NO;
	CGRect theFrame = self.iAdBannerView.frame;
	[self.iAdBannerView removeFromSuperview];
	self.iAdBannerView = [AdMobView requestAdWithDelegate:self];
	self.iAdBannerView.frame = theFrame;
	[self addSubview:self.iAdBannerView];
	NSLog(@"x is %f", self.iAdBannerView.frame.origin.x);
}
#endif


#pragma mark -
#pragma mark AdMobDelegate methods

- (NSString *)publisherIdForAd:(AdMobView *)adView {
	return @"a14c999e3ad241c"; // this should be prefilled; if not, get it from www.admob.com
}

- (UIViewController *)currentViewControllerForAd:(AdMobView *)adView {
	return self.owner;
}

- (UIColor *)adBackgroundColorForAd:(AdMobView *)adView {
	return [UIColor colorWithRed:1 green:0.569 blue:0.098 alpha:1]; // this should be prefilled; if not, provide a UIColor
}

- (UIColor *)primaryTextColorForAd:(AdMobView *)adView {
	return [UIColor colorWithRed:1 green:1 blue:1 alpha:1]; // this should be prefilled; if not, provide a UIColor
}

- (UIColor *)secondaryTextColorForAd:(AdMobView *)adView {
	return [UIColor colorWithRed:1 green:1 blue:1 alpha:1]; // this should be prefilled; if not, provide a UIColor
}

- (BOOL)useTestAd{
	return [Constants showTestAdmobAds];
}

- (BOOL)refreshAd:(NSTimer*)timer{
	[self requestFreshAd];
}



// Sent when an ad request loaded an ad; this is a good opportunity to attach
// the ad view to the hierachy.
- (void)didReceiveAd:(AdMobView *)adView {
	NSLog(@"receive admob ad");
	self.bannerServed = YES;
}

// Sent when an ad request failed to load an ad
- (void)didFailToReceiveAd:(AdMobView *)adView {
	NSLog(@"fail admob ad");
	self.bannerServed = NO;
}


@end
