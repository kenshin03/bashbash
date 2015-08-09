//
//  MainVC.m
//  bishibashi
//
//  Created by Eric on 26/03/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GameViewController.h"
#import "TransitionView.h"
#import "MediaManager.h"


@implementation GameViewController
@synthesize gkMatch = _gkMatch;
@synthesize gkSession = _gkSession;
@synthesize theGame = _theGame;
@synthesize mustLandscape = _mustLandscape;
@synthesize theMainView = _theMainView;
@synthesize theRemoteView = _theRemoteView;
@synthesize gameViews = _gameViews;
@synthesize lockedOrientation = _lockedOrientation;
@synthesize navigationController = _navigationController;
@synthesize gameType =_gameType;
@synthesize difficultiesLevel = _difficultiesLevel;
@synthesize isShowingGameView = _isShowingGameView;
@synthesize session = _session;
@synthesize peerID = _peerID;
@synthesize gamestate = _gamestate;
@synthesize gameFrame = _gameFrame;
@synthesize gameScreenFrame = _gameScreenFrame;
@synthesize totalScore = _totalScore;
@synthesize lifes = _lifes;
@synthesize transitionView = _transitionView;
@synthesize sharedSoundEffectsManager = _sharedSoundEffectsManager;

@synthesize imageUrl = _imageUrl;
@synthesize opponentImageUrl = _opponentImageUrl;
@synthesize alias = _alias;
@synthesize opponentAlias = _opponentAlias;
@synthesize opponentCountry = _opponentCountry;
@synthesize myCountry = _myCountry;

@synthesize versusTransitionView = _versusTransitionView;
@synthesize isLite = _isLite;
@synthesize roundNo = _roundNo;
@synthesize numRoundWin = _numRoundWin;
@synthesize numRoundLose = _numRoundLose;
@synthesize opponentNumMatches = _opponentNumMatches;
@synthesize opponentNumWins = _opponentNumWins;
@synthesize myNumMatches = _myNumMatches;
@synthesize myNumWins = _myNumWins;

#pragma mark -
#pragma mark Session Related Methods
- (void)session:(GKSession *)theSession didFailWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error Connecting!", @"Error Connecting!") 
                                                    message:NSLocalizedString(@"Unable to establish the connection.",@"Unable to establish the connection.") 
                                                   delegate:self 
                                          cancelButtonTitle:NSLocalizedString(@"Network Error", @"Network Error")
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
    theSession.available;
    [theSession disconnectFromAllPeers];
    theSession.delegate = nil;
    [theSession setDataReceiveHandler:nil withContext:nil];
    self.session = nil;
	
}

- (void)session:(GKSession *)theSession peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)inState {
    
	NSLog(@"peer connected session didChangeState called!!!");
    if (inState == GKPeerStateDisconnected) {
        self.gamestate = kGameStateInterrupted;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Peer Disconnected!", @"Peer Disconnected!") 
                                                        message:NSLocalizedString(@"Your opponent has disconnected, or the connection has been lost",@"Your opponent has disconnected, or the connection has been lost") 
                                                       delegate:self 
                                              cancelButtonTitle:NSLocalizedString(@"Ok", @"Ok")
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        theSession.available;
        [theSession disconnectFromAllPeers];
        theSession.delegate = nil;
        [theSession setDataReceiveHandler:nil withContext:nil];
        self.session = nil;
    }else if (inState ==  GKPeerStateConnected){
		// invoke method to start the game
	}
}


- (id) init {
	self = [super init];
	[self.navigationController setNavigationBarHidden:YES animated:NO];
	
	self.gameViews = [[[NSMutableArray alloc] initWithCapacity:12]autorelease];
	[self.gameViews addObject:[EatbeansView class]];
	[self.gameViews addObject:[the3in1View class]];
	[self.gameViews addObject:[BurgersetView class]];
	[self.gameViews addObject:[UFOView class]];
	[self.gameViews addObject:[AlarmClockView class]];
	[self.gameViews addObject:[JumpingGirlView class]];
	[self.gameViews addObject:[BurgerseqView class]];
	[self.gameViews addObject:[the3BoView class]];
	[self.gameViews addObject:[SmallnumberView class]];
	[self.gameViews addObject:[BignumberView class]];
	[self.gameViews addObject:[DancingView class]];
	[self.gameViews addObject:[BunHillView class]];
//	[self.gameViews addObject:[HeartnHandView class]];
	[self.gameViews addObject:[QuickPencilView class]];
	self.isShowingGameView = NO;
	self.lifes = 3;
	
	[[Constants sharedInstance] clearAttributeScores];
	self.sharedSoundEffectsManager = [MediaManager sharedInstance];
	return self;
}

- (void) setOpponentNumMatches:(NSInteger)numMatches AndOpponentNumWins:(NSInteger)numWins
{
	_opponentNumWins = numWins;
	_opponentNumMatches = numMatches;
	[self.versusTransitionView setOpponentNumMatches:numMatches AndOpponentNumWins:numWins];
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	self.mustLandscape = NO;
//	self.lockedOrientation = NO;
//	only portrait mode for lite version
	self.lockedOrientation = YES;
	self.totalScore = 0;
	self.roundNo = 1;
	self.numRoundWin = 0;
	self.numRoundLose = 0;
	if (self.gkMatch || self.gkSession)	{
		if (self.theGame == karcade)	{
			self.theGame = (Game)[[Constants sharedInstance] firstGameForMode:kVSArcade];
			self.gameType = multi_players_arcade;
			self.isLite = NO;
		}
			
		
		VersusTransitionView* versusTransitionView = [[VersusTransitionView alloc]initWithFrame:CGRectMake(0, 0, 320, 480) WithAlias:self.alias WithImageUrl:self.imageUrl WithOpponentAlias:self.opponentAlias WithOpponentImageUrl:self.opponentImageUrl 
																					WithNumRoundWin:self.numRoundWin WithNumRoundLose:self.numRoundLose
																					WithMyNumMatches:self.myNumMatches WithMyNumWins:self.myNumWins
																					WithOpponentNumMatches:self.opponentNumMatches WithOpponentNumWins:self.opponentNumWins

													  ];
		self.versusTransitionView = versusTransitionView;
		[versusTransitionView release];
		self.versusTransitionView.peerPlayerName = self.opponentAlias;
		self.versusTransitionView.peerFacebookImageURL = self.opponentImageUrl;
		[self.versusTransitionView setPeerCountry:self.opponentCountry];
		[self.versusTransitionView setServerCountry:self.myCountry];
		
		self.versusTransitionView.versusTransitionViewDelegate = self;
		self.view = self.versusTransitionView;
		
		self.versusTransitionView.theGame = self.theGame;
		self.versusTransitionView.roundNo = self.roundNo;
		[self.versusTransitionView showView];
		MediaManager *sharedSoundEffectsManager = [MediaManager sharedInstance];
		[sharedSoundEffectsManager playVersusTransitionBGM];
		[self.navigationController setNavigationBarHidden:YES animated:NO];
	}
	
	else {
	
		// in future, make level number and game id separate
		TransitionView* transitionView = [[TransitionView alloc] init];
		transitionView.levelNumber = self.roundNo;
		transitionView.currentGame = self.theGame;
		transitionView.delegate = self;
		self.transitionView = transitionView;
		[transitionView release];
		self.view = self.transitionView;
		if ((self.gameType != multi_players_arcade) && (self.gameType != multi_players_level_select)){
			[self.transitionView showTransitionInGameTitle];
		}
	}

}

-(void) setOpponentImageUrl:(NSString *)imageUrl
{
	_opponentImageUrl = imageUrl;
	[_opponentImageUrl retain];
	if (self.versusTransitionView)
		self.versusTransitionView.peerFacebookImageURL = imageUrl;
}

-(void) setOpponentAlias:(NSString *)alias
{
	_opponentAlias = alias;
	[_opponentAlias retain];
	if (self.versusTransitionView)
		self.versusTransitionView.peerPlayerName = alias;
}

-(void) setOpponentCountry:(NSString *)country
{
	_opponentCountry = country;
	[_opponentCountry retain];
	if (self.versusTransitionView)
		[self.versusTransitionView setPeerCountry:country];
}

-(void) setMyCountry:(NSString *)country
{
	NSLog(@"set country in GameViewController is %@", country);
	_myCountry = country;
	[_myCountry retain];
	if (self.versusTransitionView)
		[self.versusTransitionView setServerCountry:country];
}

-(void) finishedTransitionIn1:(UIView*)backgroundView{
	[UIView beginAnimations:@"zoom in frame" context:nil];
	[UIView setAnimationDuration: 0.8];
	self.gameFrame.frame = CGRectMake(0,0,340,500);
	self.gameScreenFrame.frame = CGRectMake(20,20,300,350);
	//		self.gameFrame.transform = CGAffineTransformMakeScale(10.0, 10.0);
	backgroundView.transform = CGAffineTransformMakeScale(4.3, 4.3);
	[UIView setAnimationDelegate:self];
	[UIView commitAnimations];
	[backgroundView release];
	
	[self.sharedSoundEffectsManager playJetFlyBySound];
	
	[self performSelector:@selector(finishedTransitionIn2) withObject:nil afterDelay:0.7];
	
}
-(void) finishedTransitionIn{
	/*
	NSString* gameFrame = [LocalStorageManager objectForKey:GAMEFRAME];
	if (gameFrame)	{
		UIImageView* theView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"frame_%@.png",gameFrame]]];
		UIImageView* theView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"framescreen.png"]];
		theView.frame = CGRectMake(125, 179, 71, 105);
		theView2.frame = CGRectMake(132, 185, 57, 70);
		self.gameFrame = theView;
		self.gameScreenFrame = theView2;
		[theView release];
		[theView2 release];
	
		UIView* blackView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,320,480)];
		blackView.backgroundColor = [UIColor blackColor];
		UIImageView* backgroundView;
		if ([gameFrame isEqualToString:@"white"])
			backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tvgamecenter.png"]];			
		else
			backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"oldtvshop.png"]];
		backgroundView.frame = CGRectMake(0,0,320,480);
		self.view = blackView;
		[blackView release];
		[self.view addSubview:backgroundView];
		[self.view addSubview:self.gameScreenFrame];
		[self.view addSubview:self.gameFrame];
		 
		[self performSelector:@selector(finishedTransitionIn1:) withObject:backgroundView afterDelay:1.4];
	}
	else
	 */
		[self finishedTransitionIn2];
}

-(void) hideTransitionView{
	[self finishedTransitionIn2];
}

-(void) finishedTransitionIn2{
	if(self.gameFrame)	{
		[self.gameFrame removeFromSuperview];
		self.gameFrame = nil;
		[self.gameScreenFrame removeFromSuperview];
		self.gameScreenFrame = nil;
	}
	
//	if (self.gameType != multi_players_level_select){
		
		/* GC head to head already set theMainView from GameCenterManager */
		if (!self.theMainView)	{
			GameView* g1View = [[[self.gameViews objectAtIndex:self.theGame] alloc]initWithFrame:CGRectMake(0,0,320,480) AndOwner:self AndGame:self.theGame AndGameType:self.gameType AndLevel:self.difficultiesLevel];			g1View.lifes = self.lifes;
			
			self.view = g1View;
			self.theMainView = g1View;
			if (self.gkMatch || self.gkSession)	{
				if (self.gkMatch)
					g1View.gkMatch = self.gkMatch;
				else
					g1View.gkSession = self.gkSession;
				[g1View setVSScoreBar];
				[g1View showVsMsg:NSLocalizedString(@"等待對手連線中", nil)];
				g1View.scoreView.type = kScoreViewType_beforeGameMultiplay;
			}
			[g1View release];
		}
		else
			self.view = self.theMainView;
//	}
	
//	if (self.gameType == multi_players_arcade){
		// sync scenarios first before removing transition view
		//		[self sendDecideHostPacket];
//	}else{
		[self.theMainView playAgainButClicked]; 
		self.isShowingGameView = YES;
		[self.transitionView removeFromSuperview];
		NSLog(@"count is %d", [self.transitionView retainCount]); 
		self.transitionView = nil;
		
//	}
	
	
}


-(void) showTransitionOut{
//	self.totalScore += self.theMainView.score;
	self.lifes = self.theMainView.lifes;
	NSLog(@"showTO, lifes is %d", self.lifes);
	self.theMainView = nil;
	[self finishedTransitionOut];
	/*
	self.isShowingGameView = NO;
	transitionView.levelNumber = self.theGame;
	transitionView.currentGame = self.theGame;
	transitionView.levelScore = self.totalScore;
	transitionView.delegate = self;
	self.view = transitionView;
	NSLog(@"showTransitionOut isShowingGameView %i", self.isShowingGameView);
	
	// todo: show game score or game over page
	[transitionView showTransitionOut];
	*/
}


-(void) finishedTransitionOut{

//	if (self.theGame < [[Constants sharedInstance] noAvailableGames]-1){
	[self switchToNext:self.theGame];

//	}else{
		// todo: need to do some clean up first?
//		[self.navigationController popViewControllerAnimated:YES];
//	}
}


- (void) switchToNext:(id)original isPeerHosted:(BOOL)isPeerHosted
{
	
	[self.sharedSoundEffectsManager playSlamMetalSound];
	[self.sharedSoundEffectsManager playWarpSound];
	[self.sharedSoundEffectsManager stopPlayingBGM:self.theGame];
	
	if (self.gameType == one_player_level_select)	{
		self.theGame = (Game)[[Constants sharedInstance] nextGame:self.theGame ForMode:kArcade];
		[UIView beginAnimations:@"flipToNext" context:nil];
		[UIView setAnimationDuration:0.7];
		GameView* g1View = [[[self.gameViews objectAtIndex:self.theGame] alloc]initWithFrame:CGRectMake(0,0,320,480) AndOwner:self AndGame:self.theGame AndGameType:self.gameType AndLevel:self.difficultiesLevel];
		g1View.lifes = self.lifes;
		self.view=g1View;
		self.isShowingGameView = YES;
		[g1View release];
		[UIView commitAnimations];
	}
	
	else	{
		self.roundNo++;
		if (self.gkMatch || self.gkSession)	{
			if (self.isLite)
				self.theGame = (Game)[[Constants sharedInstance] nextGame:self.theGame ForMode:kVSArcadeLite];			
			else
				self.theGame = (Game)[[Constants sharedInstance] nextGame:self.theGame ForMode:kVSArcade];

			VersusTransitionView* versusTransitionView = [[VersusTransitionView alloc]initWithFrame:CGRectMake(0, 0, 320, 480) WithAlias:self.alias WithImageUrl:self.imageUrl WithOpponentAlias:self.opponentAlias WithOpponentImageUrl:self.opponentImageUrl 
																					 
																					WithNumRoundWin:self.numRoundWin WithNumRoundLose:self.numRoundLose
																					WithMyNumMatches:self.myNumMatches WithMyNumWins:self.myNumWins
																					WithOpponentNumMatches:self.opponentNumMatches WithOpponentNumWins:self.opponentNumWins];
			self.versusTransitionView = versusTransitionView;
			[versusTransitionView release];
			self.versusTransitionView.peerPlayerName = self.opponentAlias;
			self.versusTransitionView.peerFacebookImageURL = self.opponentImageUrl;
			[self.versusTransitionView setPeerCountry:self.opponentCountry];
			[self.versusTransitionView setServerCountry:self.myCountry];
			
			self.versusTransitionView.versusTransitionViewDelegate = self;
			self.view = self.versusTransitionView;
			
			self.versusTransitionView.theGame = self.theGame;
			self.versusTransitionView.roundNo = self.roundNo;
			[self.versusTransitionView showView];
			MediaManager *sharedSoundEffectsManager = [MediaManager sharedInstance];
			[sharedSoundEffectsManager playVersusTransitionBGM];
		}
		
		else {
			if (self.isLite)
				self.theGame = (Game)[[Constants sharedInstance] nextGame:self.theGame ForMode:kArcadeLite];			
			else
				self.theGame = (Game)[[Constants sharedInstance] nextGame:self.theGame ForMode:kArcade];
			
			TransitionView* transitionView = [[TransitionView alloc] init];
			transitionView.levelNumber = self.roundNo;
			transitionView.currentGame = self.theGame;
			transitionView.delegate = self;
			self.view = transitionView;
			self.transitionView = transitionView;
			[self.transitionView showTransitionInGameTitle];
			[transitionView release];
		}
	}
}

- (void) switchToNext:(id) original
{
	[self switchToNext:original isPeerHosted:NO];
	
}

- (void) switchToPrevious:(id)original isPeerHosted:(BOOL)isPeerHosted
{
	if (self.theGame !=0){
		self.theGame--;
	}else{ 
		self.theGame = [[Constants sharedInstance] noGames]-1;
	}
	
	if (self.gameType == one_player_level_select)	{
		[UIView beginAnimations:@"flipToNext" context:nil];
		[UIView setAnimationDuration:0.7];
		GameView* g1View = [[[self.gameViews objectAtIndex:self.theGame] alloc]initWithFrame:CGRectMake(0,0,320,480) AndOwner:self AndGame:self.theGame AndGameType:self.gameType AndLevel:self.difficultiesLevel];
		g1View.lifes = self.lifes;
		self.view=g1View;
		[g1View release];
		[UIView commitAnimations];
	}
	
	else	{
		self.roundNo++;
		if (self.gkMatch || self.gkSession)	{
			VersusTransitionView* versusTransitionView = [[VersusTransitionView alloc]initWithFrame:CGRectMake(0, 0, 320, 480) WithAlias:self.alias AndImageUrl:self.imageUrl AndOpponentAlias:self.opponentAlias AndOpponentImageUrl:self.opponentImageUrl AndNumRoundWin:self.numRoundWin AndNumRoundLose:self.numRoundLose];
			self.versusTransitionView = versusTransitionView;
			[versusTransitionView release];
			self.versusTransitionView.peerPlayerName = self.opponentAlias;
			self.versusTransitionView.peerFacebookImageURL = self.opponentImageUrl;
			[self.versusTransitionView setPeerCountry:self.opponentCountry];
			[self.versusTransitionView setServerCountry:self.myCountry];
			
			self.versusTransitionView.versusTransitionViewDelegate = self;
			self.view = self.versusTransitionView;
			
			self.versusTransitionView.theGame = self.theGame;
			self.versusTransitionView.roundNo = self.roundNo;
			[self.versusTransitionView showView];
			MediaManager *sharedSoundEffectsManager = [MediaManager sharedInstance];
			[sharedSoundEffectsManager playVersusTransitionBGM];
		}
		
		else {
			
			TransitionView* transitionView = [[TransitionView alloc] init];
			transitionView.levelNumber = self.roundNo;
			transitionView.currentGame = self.theGame;
			transitionView.delegate = self;
			self.view = transitionView;
			[transitionView showTransitionInGameTitle];
			self.transitionView = transitionView;
			[transitionView release];
		}
	}
}

- (void) switchToPrevious:(id) original
{
	[self switchToPrevious:original isPeerHosted:NO];
	
}

- (void)viewWillDisappear:(BOOL)animated {
	[self.sharedSoundEffectsManager playTitleScreenBGM];
}



- (void) viewWillAppear:(BOOL)animated{
	
    [self.navigationController setNavigationBarHidden:YES animated:NO];
	[self.sharedSoundEffectsManager stopTitleScreenBGM];
}




// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	
	NSLog(@"shouldAutorotateToInterfaceOrientation isShowingGameView %i", self.isShowingGameView);
	
//	return YES; // test
    // Return YES for supported orientations
	if (self.lockedOrientation){
		return NO;
	}
	if (!self.mustLandscape){
		return YES;
	}else{
		return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
	}
}



- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}


- (void)dealloc {
	NSLog(@"dealloc GameViewController");
	self.view = nil;
	self.transitionView = nil;
	self.gameFrame = nil;
	self.gameScreenFrame = nil;
	self.theMainView = nil;
	self.theRemoteView = nil;
	self.gameViews = nil;
	self.versusTransitionView=nil;
	self.alias = nil;
	self.opponentAlias = nil;
	self.imageUrl = nil;
	self.opponentImageUrl = nil;
	self.opponentCountry = nil;
	self.myCountry = nil;
    [super dealloc];
}
			  
@end
